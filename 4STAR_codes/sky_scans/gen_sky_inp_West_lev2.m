function [inp,line_num] = gen_sky_inp_West_lev2(alm,rin,tot)
% inp = gen_sky_inp_4STAR_PPL
% % This function populates a structure subsequently used by
% "gen_aip_cimel_strings"  to create an input file for
% the Aeronet aip retrieval
% Patterned directly on gen_ppl_inp_cimel
% It differs from gen_sky_inp_4STAR_ALM not so much in the structure of the
% resulting input file but since AERONET ALM provides only the mean of the
% duplicated ALM angles passing acceptance criteria
% first_line: 112   31   1  -1  0  0  1   0  1  : KM KN KL IT ISZ IMSC IMSC1
% READ (*,*) KM,KN,KL,IT,ISZ,IMSC,IMSC1,ISTOP,IEL 	!! Read line 1
% KN number of measurements
% geom.WAVE = [0.4407 0.6764 0.8691 1.0194];
% 2018-02-05: Adding anet_level as pass-thru from star struct to inp to ".input" file.
% Here is where we attempt to screen out pixels or times when saturation
% was encountered.  We may need to consider accepted non-saturated pixels
% perhaps when relatively few other pixels were saturated.

if isafile('west.mat')
    load('west.mat')
else

if ~isavar('alm')
    alm=rd_anetalm_v3;
end
if ~isavar('rin')
    rin=rd_anet_rin_v3;
end
if ~isavar('tot')
    tot=rd_anetaod_v3;
end
%if ~isavar('aod')
%    aod=rd_anetaod_v3;
%end
end

% % Emily: Automated Section to get the indices that apply to the
% wavelengths we want (for alm file)
% %n=[1:(length(alm.time)-4)]';  % % Was throwing an error on line 45 so I
% changed this back to n=1 (also doesn't throw an error when n=[1:4])
n=7650;
dt=inf;
rin_t=interp1(rin.time,[1:length(rin.time)],alm.time(n),'nearest');
tot_t=interp1(tot.time,[1:length(tot.time)],alm.time(n),'nearest');
dt=max([abs(alm.time(n)-rin.time(rin_t)),abs(alm.time(n)-tot.time(tot_t))]);


for ij2=find(rin.If_Retrieval_is_L2_without_L2_0d4_AOD_440_threshold_==1)
    % %disp(ij2)
end

nseq=find(all(alm.Nominal_Wavelength_nm_(n+[0,2,3,4])==[1020,870,675,440]')); % % Emily/Connor: Look at this

while n<length(alm.time);
    while (n<(length(alm.time)-5)) && (~all(alm.Nominal_Wavelength_nm_(n+[0,2,3,4])==[1020,870,675,440]')|| (dt>0.05))
        n=n+1;
        rin_t=interp1(rin.time,[1:length(rin.time)],alm.time(n),'nearest');
        tot_t=interp1(tot.time,[1:length(tot.time)],alm.time(n),'nearest');
        if ~isnan(rin_t) && ~isnan(tot_t)
            dt=max([abs(alm.time(n)-rin.time(rin_t)),abs(alm.time(n)-tot.time(tot_t))]);
        else
            dt=-inf;
        end
    end
    
    if dt>=0
        % % Connor: Double check that we get all 4 indices from the n alm.

        % % Emily: Dictionary
        star.wl_ii=n+[0,2,3,4]; star.wl_ii = fliplr(star.wl_ii);
        star.Alt=mean(alm.Elevation_m_(star.wl_ii))./1000; % %Emily: Units in km now
        star.w=alm.Exact_Wavelength_um_(star.wl_ii)';
        star.TOD=fliplr([tot.AOD_1020nm_Total(tot_t),tot.AOD_870nm_Total(tot_t),tot.AOD_675nm_Total(tot_t),tot.AOD_440nm_Total(tot_t)]);
        % tod=star.TOD;
        % star.TOD=star.TOD.*tot.Optical_Air_Mass(tot_t);
        star.AOD= fliplr([tot.AOD_1020nm_AOD(tot_t),tot.AOD_870nm_AOD(tot_t),tot.AOD_675nm_AOD(tot_t),tot.AOD_440nm_AOD(tot_t)]);
        star.ray= fliplr([tot.AOD_1020nm_Rayleigh(tot_t),tot.AOD_870nm_Rayleigh(tot_t),tot.AOD_675nm_Rayleigh(tot_t),tot.AOD_440nm_Rayleigh(tot_t)]);
        star.AGOD= star.TOD-star.AOD-star.ray; % % Absorbing gas
        % % star.dOD= % % Connor: We talked about dOD but I haven't been able to find it in our files yet to address this change
        % % star (in the case of brdf and sfc_alb)
        agod=star.AGOD;
        star.sfc_alb= rin.Surface_Albedo(rin_t,:);% rin.lambda is already from short to long
        % % layer_alt
        star.ground_level=star.Alt;
        % % star.wind_speed (SHOULD NOT BE NEEDED SINCE WE ARE GROUND SITE NOT OCEAN)
        % % star.land_fraction (SHOULD NOT BE NEEDED)
        star.Lat= alm.Latitude_Degrees_(star.wl_ii);
        % % star.min_alb
        % % star.max_alb
        star.O3col=tot.Ozone_Dobson_(tot_t);
        star.PWV=tot.WV_cm__935nm_Total(tot_t); % % Compared to aod.Precipitable_Water_cm_ and they matched

{datestr(alm.time(n)), datestr(rin.time(rin_t)), datestr(tot.time(tot_t))}
        % % 4STAR

        % % star.sat_ij (SHOULD NOT BE NEEDED)
        % % sat_rad=alm.skyrad
        % % star.skymask (SHOULD NOT BE NEEDED)
        % % star.rad_scale (might be needed)
        % % good_sky (SHOULD NOT BE NEEDED)
        star.sunza=alm.Solar_Zenith_Angle_Degrees_(star.wl_ii);
        % % sunza=star.sunza; %emily
        star.sunel= 90-star.sunza;
        sunel=star.sunel;
        star.El_gnd=sunel; % % Emily: Since this file uses .alm and not .ppl this is the same as the solar elevation
        star.Az_gnd=alm.Az_deg;
        star.sunaz=0; % % Emily: Because using .alm (and .ppl would also assume you are looking at sun) would be relative to sun's position
        % % sunaz=star.sunaz; %emily
        % % star.isPPL

        skyrad = alm.skyrad(star.wl_ii,:)'; % %Connor: Double check whether or not we need to flip this
figure_(1); plot(star.Az_gnd, skyrad,'-'); logy; title({['AOD: ',sprintf('%1.2f, ',star.AOD)],['n=',num2str(n), ', SZA = ', num2str(mean(star.sunza))]})
xlabel('Azimuth Angle'); ylabel('radiance [um/cm2/sr/nm]'); legend('440 nm','676 nm','870 nm','1020 nm');
figure_(2); plot(abs(star.Az_gnd), skyrad,'-'); logy; title({['AOD: ',sprintf('%1.2f, ',star.AOD)],['n=',num2str(n), ', SZA = ', num2str(mean(star.sunza))]})
xlabel('Azimuth Angle'); ylabel('radiance [um/cm2/sr/nm]'); legend('440 nm','676 nm','870 nm','1020 nm');
        nanrad=isnan(skyrad);
        skyrad(any(nanrad,2),:)=[];
        star.Az_gnd(any(nanrad,2))=[];

        pos = star.Az_gnd>0;
        star.Az_gnd = star.Az_gnd(pos);
        skyrad = skyrad(pos,:);

        % Actually we should not be using Gueymard here.
        % We should be using the one Michal has used.  Coddington?
        guey_ESR = gueymard_ESR;  g_ESR = interp1(guey_ESR(:,1), 1000.*guey_ESR(:,3), 1000.*star.w,'pchip','extrap');
    % % ^ Emily: Interpolating first column (nm) to third column (W/m^2/micron) 
    % % ^^ Connor: Double check units nanometers -> Microns or vice versa
    
% % Connor: Consider Earth to Sun distance
    g_factor = pi./g_ESR*1000;
    skyrad = pi.*skyrad ./(repmat(g_ESR,size(skyrad,1),1)); inp.ESR = g_ESR; % % Emily: Goal is to remove dependence on units%
    % ^ Connor: Check Units (skyrad is µW/cm^2/sr/nm) g_ESR is W/m^2/nm
figure_(3); plot(star.Az_gnd, skyrad,'-'); logy; title({['AOD: ',sprintf('%1.2f, ',star.AOD)],['n=',num2str(n), ', SZA = ', num2str(mean(star.sunza))]});
xlabel('Azimuth Angle'); ylabel('normalized radiance'); legend('440 nm','676 nm','870 nm','1020 nm');
        nanrad=isnan(skyrad);
    % % Emily: Above tries to put skyrad and g_ESR into same dimensions
    % % Emily: The period in front of / does element by element division
    % rather than matrix division
    % % Emily: skyrad is wavelength by scattering angle dimensionality
    skyrad=skyrad.*10; % % Emily: Converting µW/cm^2/sr/nm to W/m^2/nm % Connor, trying to match magnitudes of afurioser by eye :-(
    


    geom.WAVE = star.w;
    
    inp.aod = star.AOD;
    % % if ~isfield(star,'brdf') % if the 4STAR code doesn't have brdf values, create and populate in line 120
        % % if isfield(star,'sfc_alb')
            flight_alb = interp1(star.w, star.sfc_alb, [0.470,0.555,0.659,0.858,1.24, 1.64, 2.13]', 'nearest','extrap');
        % % else
            % % [flight_alb, ~] = get_ssfr_flight_albedo(mean(star.t(good_sky(:,1))),[0.470,0.555,0.659,0.858,1.24, 1.64, 2.13]'); % % Connor: 4STAR specific inputs
        % % end
        
        star.brdf =[...
            [0.470,0.555,0.659,0.858,1.24, 1.64, 2.13]', flight_alb, zeros(size(flight_alb)), zeros(size(flight_alb))];
    % % end
    %         0.470000   0.067233    0.027191    0.010199
    %         0.555000   0.108960    0.060560    0.017044
    %         0.659000   0.141415    0.072841    0.023388
    %         0.858000   0.297822    0.187741    0.031740
    %         1.240000   0.388852    0.209102    0.030470
    %         1.640000   0.365508    0.195612    0.039094
    %         2.130000   0.278381    0.129836    0.046197];
    
    % 
    geom.HLYR = [star.Alt, 70]; % % Emily: Leaving 70 as top of atmosphere
    
    %Now convert 4STAR Az/El geometry (that permits El from horizon to horizon)
    %to AERONET geometry with El from 0 to 90 and Az adjusted by 180 when El is
    %on oppposite side of zenith from sun.
    % % Emily: Commenting the below lines because we are inputting an
    % AERONET File and the reasoning above
    % %over_top = star.El_gnd>90; % % Connor: I left this the same as I am not quite sure if this needs to be edited or for which input it would need to be edited
    % % star.El_gnd(over_top) = 180-star.El_gnd(over_top);
    % % star.Az_gnd(over_top) = mod(star.Az_gnd(over_top)+180,360);
    
    for w= length(geom.WAVE):-1:1
        % %geom.WAVE_(w).SA = [];% Not sure why this is an empty field
        in_meas = [star.TOD(w)];
        geom.WAVE_(w).albedo = fill_albedo(geom.WAVE(w),star.brdf);
        %     geom.WAVE_(w).UO3 = interp1(star.w, star.cross_sections.o3, geom.WAVE(w),'pchip','extrap');
        %     wi = interp1(star.w,[1:length(star.w)],geom.WAVE(w),'nearest');
        geom.WAVE_(w).UO3 = agod(w); %Not crosss section, ozone OD s.O3col  
        geom.WAVE_(w).DU = star.O3col; %dobson units for ozone (from tot file) 
        geom.WAVE_(w).PWV = star.PWV; %precipitable water vapor
        
        % Now we're gettting there!
        % We could screen the values for this wavelength here...
        %     geom.WAVE_(w).meas = [aod(w), sat_rad(:,w)'./1000];
        res = 1./150;
        layer_alt = star.Alt; % Units of km.
        % According to Sasha Sinyuk, hlyr should be ground level.  So setting
        % it to the aircraft altitude here may be wrong.
        % Sasha says: lyr basically specify the boundaries of atmospheric layer, so yes it is ground or sea level.
        % inp.geom.WAVE_(IW).HLYR(ITAU)
        geom.WAVE_(w).HLYR =  layer_alt; % in units of km
        layer_alts = layer_alt;
        %layer_alts = ((round(res.*(star.Alt(good_sky(:,w))-mean(star.Alt(good_sky(:,w)))))./res) ...
        %    + round(res.*mean(star.Alt(good_sky(:,w))))./res)/1000;
        % By stepping through length of layer_alt, with test against layer_alts we
        % can support multiple independent layers for each WL
        % for ly = 1:length(layer_alt)
        for ly = 1: length(layer_alt)
            % %good_lyr = good_sky(:,w);
            % %good_lyr(good_lyr) = layer_alts==layer_alts(ly);
            res = 0.1; des = 1./res;
            %sunel = 90- solar zenith angle
            % %sunel = unique(round(des.*(star.sunel(good_lyr)-mean(star.sunel(good_lyr))))./des)...
            % %    + round(des.*mean(star.sunel(good_lyr)))./des; % 0.2 degree resolution
            sunel = 90-alm.Solar_Zenith_Angle_Degrees_(star.wl_ii(w));
            sunza = 90-sunel;
            % %sunels =(round(des.*(star.sunel(good_lyr)-mean(star.sunel(good_lyr))))./des)...
            % %    + round(des.*mean(star.sunel(good_lyr)))./des;
            % %sunels = sunel;
            % %sunzas = 90-sunels;
            geom.WAVE_(w).HLYR_(ly).SZA = sunza;
            % Hypothetically, we can accept any arbitrary combination of
            % OZA and OAZ, with PPL: OZA(NOZA) and OAZ(1), ALM: OAZ(NOAZ)
            % and OZA(1) and anything in between, but our PPL and ALM
            % example files only show the pairing noted above, and there
            % may be details/inconsistencies with how meas and sza are
            % handled, so for now we'll support only these two cases.
            % So in essense, we require NOZA==1 (ALM) or NOAZ==1 (PPL).
            in_OZA = sunza;
            in_PHI = 0;
            
            for sz = 1: length(sunza)
                % %good_sza = good_lyr;
                % %good_sza(good_sza) = (sunzas ==sunzas(sz));
                
                %             OZAs = [90-star.El_true(good_sza)']';
                %%
                res = 0.1; des = 1./res;
                %             OEL =
                %             unique(round(des.*(star.El_true(good_sza)-mean(star.El_true(good_sza))))./des)...
                %             % % Connor: I can get observer elevation but
                %             I don't remember where that comes from
                %                 + round(des.*mean(star.El_true(good_sza)))./des; % 0.2 degree resolution
                % %OEL = unique(round(des.*(star.El_gnd-mean(star.El_gnd)))./des)... %observer elevation angle
                % %    + round(des.*mean(star.El_gnd))./des; % 0.2 degree resolution
                OEL=sunel;
                OZA = 90-OEL; %observer zenith angle % % Connor: Can I get observer zenith angle from solar zenith angle?
                %             OELs = (round(des.*(star.El_true(good_sza)-mean(star.El_true(good_sza))))./des)...
                %             + round(des.*mean(star.El_true(good_sza)))./des; % 0.2 degree resolution
                OELs = (round(des.*(star.El_gnd(w)-mean(star.El_gnd)))./des)...
                    + round(des.*mean(star.El_gnd))./des; % 0.2 degree resolution
                OZAs = 90-OELs;
                res = 0.1; des = 1./res;
                %             daz = abs(star.sunaz(good_sza) - star.Az_true(good_sza));
                daz = abs(star.sunaz - star.Az_gnd)';
                
                phis = (round(des.*daz)./des);
                if numel(OZAs)==1
                   OZAs = OZAs*ones(size(phis));
                end
                geom.WAVE_(w).HLYR_(ly).SZA_(sz).OZA = [in_OZA;OZAs]; in_OZA = [];
                %             geom.WAVE_(IW).HLYR_(ITAU).SZA_(ISZA).OZA
                geom.WAVE_(w).HLYR_(ly).SZA_(sz).PHI = [in_PHI; phis]; in_PHI = [];
                in_meas = [in_meas; skyrad(:,w)];
                geom.WAVE_(w).meas = [in_meas];
                in_meas = [];
                % [cts/ms / W/(m^2.sr.um)]
                %%
                %             for oz = 1:length(OZAs)
                %                 good_ozs = good_sza;
                %                 good_ozs(good_sza) = OZAs==OZAs(oz);
                %                 obs_za = OZAs(good_ozs(good_sza));
                %                 phi = phis(good_ozs(good_sza));
                % %                 geom.WAVE_(w).HLYR_(ly).SZA_(sz).PHI = [0 phis'];
                %
                %
                %             end
                %%
                %             try
                %            geom.WAVE_(w).SA = [geom.WAVE_(w).SA; scat_ang_degs(sunzas, star.sunaz(good_sza),  geom.WAVE_(w).HLYR_(ly).SZA_(sz).OZA(2:end),star.Az_gnd(good_sza))];
                %             catch
                %                 disp('mismatch in fields sent to scat_ang_degs')
                %             end
            end
        end
        %     try
        %     figure(48); semilogy(geom.WAVE_(w).SA, geom.WAVE_(w).meas(2:end),'o', star.SA(good_sky(:,w)),pi.*star.skyrad(good_sky(:,w),star.wl_ii(w))./inp.ESR(w),'x'); legend('star','inp.meas');
        % title(['normalized radiance: ', sprintf('%4.1f nm',1000.*geom.WAVE(w))]);
        %     catch
        %         disp('Skipping SA plot due to error in scat_ang mismatch')
        %     end
    end
    
    inp.KM=0;
    % inp.KNOISE = [1   29   57   85];
    for wi = length(geom.WAVE):-1:1
        inp.KM =inp.KM + numel(geom.WAVE_(wi).meas);
    end
    % KN retrieved parameters
    inp.NW = length(geom.WAVE);
    inp.NBIN = 22;
    inp.KN = 2*inp.NW + inp.NBIN + 1 ; %= 31
    % KL=0 - minimization of absolute errors
    % KL=1 - minimization of log
    inp.KL = 1;
    % IT=0 - refractive index is assumed
    % IT=-1 - refractive index is retrieved
    inp.IT = -1;
    % ISZ=0 initial guess for SD are read point by point
    % ISZ=1 - SD is assumed lognormal with the parameters from FILE="SDguess.dat"
    inp.ISZ = 0;
    % IMSC =0 -multiple scattering regime for signal
    % IMSC =1 -single scattering regime for signal
    inp.IMSC = 0;
    % IMSC1 =0 -multiple scattering regime for sim. matrix
    % IMSC1 =1 -single scattering regime for sim. matrix
    inp.IMSC1 = 1;
    %Fill last two elements: no description in the code...
    inp.ISTOP = 0;
    inp.IEL=1;
    
    % Second line: % 1 4 1 0 0 1 1 : NSD  NW  NLYR  NBRDF  NBRDF1
    % READ (*,*) NSD,NW,NLYR,NBRDF,NBRDF1,NSHAPE,IEND !! Read line 2
    % C*****************************************************
    % NSD - number of the retrieved aerosol component at each atmospheric layer
    inp.NSD = 1;
    
    % C***  WAVE(IW) - values of wavelengths
    % NW   - the number of wavelengths
    
    
    % NLYR - the number of the athmosperic layers redundant with NLYRS NTAU
    inp.NLYR = length(geom.WAVE_(1).HLYR); inp.NLYRS = inp.NLYR; inp.NTAU = inp.NLYR; % % Connor: Might not need since not layering
    
    % NBRDF- the number of the BRDF paremeters for each wavelength
    % NBRDF=0 when we use Lambertian approximation
    inp.NBRDF = 0;
    % C***  NBRDF1- the number of the BRDF paremeters independent of wavelenths
    inp.NBRDF1 = 0;
    
    % Fill last two, no description in code.
    inp.NSHAPE=1;
    inp.IEND=1;
    
    % 1 1 1 1                        INDSK
    inp.INDSK = ones(size(geom.WAVE));
    % 0 0 0 0                        INDSAT
    inp.INDSAT = 0.*inp.INDSK;
    % 1 1 1 1                        INDTAU
    inp.INDTAU = inp.INDSK;
    % 1 1 1 1                        INDORDER
    inp.INDORDER = inp.INDSK;
    
    % -1 22 22 0 -1  : IBIN, (NMIN(I),I=1,NSD)
    %       READ (*,*) IBIN, (NBIN(I),I=1,NSD)  !! Read line 8
    % C****************************************************
    % C***  IBIN - index determining the binning of SD:
    % C***         = -1 equal in logarithms
    % C***         =  1 equal in absolute scale
    % C***         =  0 read from the file
    inp.IBIN = -1;
    % C***  NBIN(NSD) - the number of the bins in
    % C***                 the size distributions
    
    
    
    % 0.05 15.0 0 (RMIN(ISD),RMAX(ISD),ISD=1,NSD)
    % READ(*,*) (RMIN(ISD),RMAX(ISD),IS(ISD),ISD=1,NSD)	!! Read line 9
    
    inp.RMIN = 0.05;
    inp.RMAX = 15;
    inp.ISD = 0;
    
    %       READ (*,*) !! Skip line 10
    %       READ (*,*) IM,NQ,IMTX,KI !! Read line 11
    % C***  Parameters for ITERQ.f (details in "iterqP" subr.)
    % C***  IM=1 - q-linear iterations
    % C***  IM=2 - matrix inversion
    % C***  NQ - key defining the prcedure for stopping
    % C***  q-iterations
    % C***  KI - defines the type of q-iterations (if IM=1)
    % C***  EPSP - for stoping p-iterations
    % C***  EPSQ and NQ see in "ITERQ"
    % C***  IMTX
    % C***  KI   - type of k-iterations
    % 3  17000 0 0 : IM,NQ,IMTX, KI
    inp.IM = 3;
    inp.NQ = 17000;
    inp.IMTX = 0;
    inp.KI = 0;
    
    % 15 0.0005 0.5 1.33 1.6 0.0005 0.5 IPSTOP, RSDMIN, RSDMAX,REALMIN,REALMAX,AIMAGMIN,AIMAGMAX
    %       READ(*,*) IPSTOP, RSDMIN,RSDMAX,REALMIN,REALMAX, ! line 13
    inp.IPSTOP = 15;
    inp.RSDMIN = 0.0005;
    inp.RSDMAX = 0.5;
    inp.REALMIN = 1.33;
    inp.REALMAX = 1.6;
    inp.AIMAGMIN = 0.0005;
    inp.AIMAGMAX = 0.5;
    
    % 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000. 0.001 1000.
    %       IF(NSHAPE.GT.0) THEN
    %        READ(*,*) (SHAPEMIN(I),SHAPEMAX(I),I=1,NSHAPE) ! Read line 14
    SHAPEMIN = 0.001; SHAPEMIN = repmat(SHAPEMIN,[19,1]);
    inp.SHAPEMIN=SHAPEMIN;
    SHAPEMAX = 1000; SHAPEMAX = repmat(SHAPEMAX,[19,1]);
    inp.SHAPEMAX=SHAPEMAX;
    %
    % SMOOTHNESS parameters:
    % 0 1e-4 0 0 0 0
    % 3  1.0e-3 1 1.0e-1 1 1.0e-4 IO(...), GSM(...) (SD,Real, Imag) (for each layer !!!)
    % 0 0
    % 0 0.00e-0
    % !! Not sure how to actually construct the information for the smoothing parameters
    % !! in terms of the dimensionality and order of the values.
    % !! So, just copying the values from the input files we have.
    inp.SMOOTHNESS_parameter = 'copy these verbatim';
    
    % 1.0e-3 1.0e-2 1.0e-3 5.0e-3 5.0e-0 1.0e-7 EPSP,EPST,EPSQ,DL,AREF,EPSD
    % C****************************************************
    %       READ (*,*) EPSP,EPST,EPSQ,DL,AREF,EPSD	!! Read line 20
    % C*****************************************************
    % C***  EPSP - for stopping p - iterations
    % C***  EPST - for stopping iterations in CHANGE
    % C***  EPSQ - for stopping q - iterations in ITERQ"
    % C***  DL   - for calc. derivatives, (see FMATRIX)
    % C*****************************************************
    inp.EPSP = 1.0e-3;
    inp.EPST = 1.0e-2;
    inp.EPSQ = 1.0e-3;
    inp.DL = 5.0e-3;
    inp.AREF = 5.0e-0;
    inp.EPSD = 1.0e-7;
    
    
    % Real and Imag index of refraction
    nreal = 1.5; nreal = repmat(nreal,[1,length(geom.WAVE)]);
    inp.nreal=nreal;
    nimag = 0.005; nimag = repmat(nimag,[1,length(geom.WAVE)]);
    inp.nimag=nimag;
    
    inp.sd_guess = (0.002791./5).*[1 repmat(5,[1,inp.NBIN-2]) 1];
    
    % C***  Accounting for different accuracy levels in the data
    % C***       AND   modelling   RANDOM NOISE           ***
    %       READ (*,*) INOISE	!! Read line 51
    %       READ (*,*) SGMS(1), INN(1), DNN(1) !! Read line 52
    % Maybe need help on the below...
    % C*******************************************************************
    % C*** INOISE  - the number of different noise sources              ***
    % C*** SGMS(I) - std of noise in i -th source                       ***
    % C*** INN(I)  - EQ.1.THEN error is absolute with                   ***
    % C***         - EQ.0 THEN error assumed relative
    % C*** DNN(I)  - variation of the noise of the I-th source
    % C*** IK(I)   - total number of measurements of i-th source        ***
    % C*** KNOISE(1,K)-specific numbers affected by i-th source        ***
    % C*** All the measurments which where not listed in  the INOISE-1 ***
    % C***  first INOISE-1 sources, they belong to last source of noise***
    % C*******************************************************************
    inp.INOISE = 2;
    % C*** SGMS(I) - std of noise in i -th source                       ***
    inp.SGMS = 0;
    % C*** INN(I)  - EQ.1.THEN error is absolute with                   ***
    % C***         - EQ.0 THEN error assumed relative
    inp.INN = 0;
    % C*** DNN(I)  - variation of the noise of the I-th source
    inp.DNN = 0.05;
    if length(inp.SGMS)<inp.INOISE
        inp.SGMS = [inp.SGMS(1) zeros([1,inp.INOISE-1])];
        inp.INN = [inp.INN(1) ones([1,inp.INOISE-1])];
        inp.DNN = [inp.DNN(1) repmat(0.0055,[1,inp.INOISE-1])];
        inp.IK = [0 , repmat(inp.NW,[1,inp.INOISE-1])];
        % C*** IK(I)   - total number of measurements of i-th source        ***
    end
    
    %  inp.KNOISE = [1   29   57   85]; Maybe need help here...
    ikn = 1;
    for iw = 1:inp.NW
        inp.KNOISE(iw) = ikn;
        ikn = ikn + length(geom.WAVE_(iw).meas);
    end
    
    % C*** Defining matrix inverse to  covariance ***
    % CD      WRITE(*,*) 'BEFORE IC,IACOV, DWW'
    %       READ (*,*) IC,IACOV,DWW
    % CD      WRITE(*,*) IC,IACOV,DWW,' IC,IACOV, DWW'
    % C***    IC  =0 then
    % C***           C is unit matrix (for logarithms)
    % C***           C is diagonal matrix with the ellements
    % C***                1/((F(j)*F(j)) (for non-logarithm case)
    % C***    IC  =1 then C is diagonal and defined
    % C*** with accounting for different levels of the errors in
    % C*** different measurements (according to Dubovik and King [2000]
    % C*** !!! the measurements assigned by INOISE=1 usually         !!!
    % C*** !!! correspond to the largest set of optical measurements !!!
    % C***    IC   <0 then C is read from cov.dat
    % C**************************************************************
    % C*** IACOV
    % C***       =0 - single inversion with unique COV matrix
    % C***       >0 - inversion is repeated with different COV matrix
    % 1 0 0.01  IC, IACOV,DWW
    inp.IC = 1;
    inp.IACOV = 0;
    inp.DWW = 0.01;
    
    %7 1 1 4 1 1 1  0.00 : NSTR NLYR NLYRS NW IGEOM IDF IDN DPF   - Almucantar
    inp.NSTR = 7;
    % inp.NLYRS = NLYR;
    inp.IGEOM = 1;
    inp.IDF = 1;
    inp.IDN = 1;
    inp.DPF = 0;
    
    inp.H_LYR = [star.ground_level, 70]; % geom.WAVE_(1).HLYR; % This is wrong.
    inp.H_NLYR = [star.ground_level 5]; %Hard coding a low layer and a high layer - higher than 4STAR altitude.
    %inp.H_NLYR = [star.ground_level 4+star.ground_level]; %Hard coding a low layer and a high layer - higher than 4STAR altitude.
    inp.W_NLYR = [1.0 1.0];
    inp.NS = [1000];
    inp.iatmos_1 = '6 0.0 3 0  1              : iatmos suhei';
    inp.iatmos_2 = '1.33739    1.33739    1.33739    1.33739  ';
    inp.iatmos_3 = '1.12E-09    1.12E-09    1.12E-09    1.12E-09 ';
    inp.iatmos_2 = repmat('1.33739    ',[1,length(geom.WAVE)]);
    inp.iatmos_3 = repmat('1.12E-09   ',[1,length(geom.WAVE)]);
    %! Need_windspeed_and_land_fraction
    % % if isfield(star,'wind_speed')
        % %inp.wind_speed = mean(star.wind_speed);
    % %else
        % %inp.wind_speed = 5.733;  %Need to improve this for airborne
    % %end
    % %if isfield(star,'land_fraction')
    % %    inp.land_fraction = mean(star.land_fraction);
    % %else
    % %    inp.land_fraction = 1;  %Need to improve this for airborne
    % %end
    if length(inp.H_LYR)==1
        inp.H_LYR = [inp.H_LYR, 70];
    end
    inp.Latitude = mean(star.Lat);
    
    %     if ~isfield(star,'brdf')
    %        geom.WAVE_(w).albedo = fill_albedo(geom.WAVE(w));
    %     else
    %        geom.WAVE_(w).albedo = fill_albedo(geom.WAVE(w),star.brdf);
    %     end
    
    modis_wave = [0.47 0.555 0.659 0.858  1.24 1.64 2.13];
    inp.whoknows = length(modis_wave);
    for m = 1:length(modis_wave)
        alb = fill_albedo(modis_wave(m),star.brdf);
        inp.mod_brdf(m) = {[modis_wave(m)   alb]};
    end
    % %if star.isPPL
    % %    sky_str = 'Principal_Plane';
    % %else
    sky_str = 'Almucantar';
    % %end
    % %inp.date_time_site_unit = [datestr(mean(star.t),'dd:mm:yyyy,HH:MM:SS,'),sky_str,',4STAR,01'];
    inp.date_time_site_unit = [];
    inp.geom = geom;
    inp.anet_level=1.5; inp.rad_scale=1; inp.dOD=0; inp.wind_speed=0; inp.land_fraction=1;% % Connor: Hard coded for the moment
    %[inp.anet_level inp.anet_tests] = anet_preproc_dl(inp);
%     [wl_, wl_ii,sky_wl,w_fit_ii] = get_last_wl(s);
    line_num = gen_aip_cimel_strings(inp);
    % %extras.sky_test = inp.sky_test;
    % %extras.tau_test = inp.tau_test;
    extras.rad_scale = inp.rad_scale;
    extras.dOD     = inp.dOD;
    % %extras.min_alb = star.min_alb(star.wl_ii);
    % %extras.max_alb = star.max_alb(star.wl_ii);
    % %suns_ii = find(star.Str==1&star.Zn==0); sun_ii = [];
    % %if ~isempty(suns_ii)
    % %    sun_ii = suns_ii(1);
    % %end
    % %extras.aod_meas = star.tau_aero_subtract_all(sun_ii,star.wl_ii);
    % %extras.aod_fit = star.aod_fit_pii(star.wl_ii);
    % %extras.aod_resid = extras.aod_meas - extras.aod_fit;
    % %extras.pixels_header = '% WL_fit_ii  nm   AOD_meas  AOD_fit  AOD_resid ';
    % %extras.pixels.WL_fit = star.w_ii_fit;
    % %extras.pixels.nm = 1000.*star.w(star.w_ii_fit);
    % %extras.pixels.AOD_meas = star.tau_aero_subtract_all(sun_ii,star.w_ii_fit);
    % %extras.pixels.AOD_fit = star.aod_fit_pii(star.w_ii_fit);
    % %extras.pixels.AOD_resid = extras.pixels.AOD_meas - extras.pixels.AOD_fit;

    line_num = add_aip_extra(line_num, extras);
    %   [~,fstem,ext] = fileparts(star.filename{1});
    % fstem = strrep(fstem, '_VIS','');
    % % from run_4STAR_AERONET_retrieval
    % pname = 'C:\z_4STAR\work_2aaa__\';
    % fname = ['4STAR_.input'];
    pname_inp = 'C:\z_4STAR\work_2aaa__\West_4STAR_Test_files/';
    %         if isfield(star,'filename')
    %             if iscell(star.filename)
    %                 [p,skytag,x] = fileparts(star.filename{1});
    %             else''
    %                 [p,skytag,x] = fileparts(star.filename);
    %             end
    %             skytag = strrep(skytag,'_VIS_','_');skytag = strrep(skytag,'_NIR_','_');
    %         end
    % %tag = [star.fstem, star.created_str,'.'];
    tag=[rin.site,'_',num2str(n)];% % Connor: Hard coded right now
    % %if size(good_sky_,2)>1; good_sky_ = all(good_sky_,2);end
    % %if size(star.good_sky,2)>1; star.good_sky = all(star.good_sky,2); end;
    % %if isavar('good_sky_')
        % %if isfield(star,'good_almA')&& isfield(star,'good_almB')&& all(good_sky_==star.good_almB)&& all(star.good_almA==star.good_almB)
            tag = strrep(tag,'..','.avg_');
        % %elseif isfield(star,'good_almA') && all(good_sky_==star.good_almA)
            % %tag = strrep(tag,'..','.almA_');
        % %elseif isfield(star,'good_almB') && all(good_sky_==star.good_almB)
            % %tag = strrep(tag,'..','.almB_');        
        % %elseif isfield(star,'good_ppl') && all(good_sky_==star.good_ppl)
            % %tag = strrep(tag,'..','.ppl_');
        % % end
        % %tag = [tag, sprintf('lv%2.0d',star.anet_level.*10)];
    % %end
    % %if isfield(star.toggle, 'sky_tag')&&~isempty(star.toggle.sky_tag)
        % %sky_tag = star.toggle.sky_tag; 
        % %if iscell(sky_tag) sky_tag = sky_tag{:};end
            
        % %tag = [tag, deblank(sky_tag)];
    % %end
    % fid = fopen([pname_tagged,fname_tagged],'w');
    fid = fopen([pname_inp,tag,'.input'],'w');
    for lin = 1:length(line_num)
        fprintf(fid,'%s \n',line_num{lin});
    end
    fclose(fid);
%%end

    end

    n=n+1

end

return
function line_num = add_aip_extra(line_num, extras)
ln = length(line_num)+1;
line_num(ln) = {' '};
ln = length(line_num)+1;
line_num(ln) = {'% Extras '};
ln = length(line_num)+1;
fields = fieldnames(extras);
for fld = 1:length(fields)
    field = fields{fld};
    if ~isstruct(extras.(field))&&isnumeric(extras.(field))
        line_num(ln) = {[fields{fld},' = ',sprintf('%2.4g ',extras.(field)(1:end))]};
        ln = ln +1;
    elseif ischar(extras.(field))
        line_num(ln) = {extras.(field)};
        ln = ln +1;
    elseif isstruct(extras.(field))
        pixels = extras.(field);
        block = [pixels.WL_fit; pixels.nm; pixels.AOD_meas; pixels.AOD_fit; pixels.AOD_resid];
        for b = 1:size(block,2)
            line_num(ln) = {sprintf('  %d  %2.2f  %1.4f  %1.4f  %1.3e ',block(:,b))};
            ln = ln + 1;
        end
    end
end
% output extras to ".input" file including aods, dAOD, input data level
% fit residuals for relevant WLs  


return
