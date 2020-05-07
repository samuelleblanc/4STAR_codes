function [fname_mat, fname_csv] = gen_grasp_out(s)
% filename = gen_grasp_out(s)

% Produce output file(s) tailored as input for GRASP
% Accepts a 4STAR "s" struct as input which should have been processed
% through starsky_2 

% Connor, v0.1, 2020/05/02, Beta-version before iteration with Oleg & David Fuertes
%               Considering producing row-ordered (each named variable of
%               N-length on separate row), column-ordered but with a header
%               of elements before the time series columns, and a mat file
%               with equivalent content
if ~isavar('s')
    s = load(getfullname('*STAR*sky*.mat','starsky','Select a starsky mat file:'));
    if isfield(s,'s'); s= s.s; 
    elseif isfield(s,'star'); s = s.star; 
    end
end
v_str = '0.1';
version_set(v_str);
% Critical elements: time, lat, lon, alt, wavelength, dW, SFA,
% TOD, ROD, AGOD, RAD, TOA
sun_ = s.Str==1&s.Zn==0; 
sun_ii = find(sun_);
sky_ = s.good_sky;  
if size(sky_,2)~=1 
    sky_ = any(sky_,2); 
end 
sky_ii = find(sky_);
good_ = sun_ | sky_; 
good_ii = find(good_);
wl_ = s.wl_; wl_ii = s.wl_ii;
WL = s.w(s.wl_);
meanTime = meannonan(s.t(good_)); d_str =  datestr(meanTime, 'yyyy-mm-dd HH:MM:SS UT');
meanLat = meannonan(s.Lat(good_)); meanLon = meannonan(s.Lon(good_)); meanAlt = meannonan(s.Alt(good_&s.Alt>0));
meanSZA = meannonan(s.sza(good_)); meanSAZ = meannonan(s.sunaz(good_)); meanSEL = meannonan(s.sunel(good_)); 
mean_am_ray = mean(s.m_ray(good_));
mean_am_aero = mean(s.m_aero(good_));
soldst_au = mean(sqrt(1./s.f(good_)));
sfc_alb = s.sfc_alb;
sfc_alb(isnan(sfc_alb)) = interp1(s.w(~isnan(sfc_alb)), sfc_alb(~isnan(sfc_alb)), s.w(isnan(sfc_alb)), 'nearest','extrap');
campaign = 'ORACLES2016';
if isfield(s.toggle,'sky_rad_scale')
    rad_scale = s.toggle.sky_rad_scale;
    rad_scale=repmat(rad_scale,size(s.skyrad,1),1);
else
    rad_scale = 1;
end
if length(unique(rad_scale))==1 
    rad_scale = rad_scale(1); 
end
if isfield(s,'rad')
    skyrad = rad_scale .* s.rad(sky_,wl_);
elseif isfield(s,'skyrad')
    skyrad = rad_scale .* s.skyrad(sky_,wl_);
end    
clear inp
% Reproduce elements of gen_sky_inp_4STAR that may be of use for GRASP...
inp.header(1,1) = {['% NSTAR GRASP Input File v',v_str, ' created ',datestr(now,'yyyy-mm-dd HH:MM:SS UT'), ' by ',get_starauthor]};
inp.header(end+1,1) = {sprintf('%% Instrument="%s", Campaign="%s"',s.instrumentname, campaign)};
inp.header(end+1,1) = {['% Date_Time="',d_str, '", ', sprintf('Lat_deg_N=%2.3f, Lon_deg_E=%2.3f, Flight_Alt_m_MSL=%d', meanLat, meanLon, meanAlt)]};
inp.header(end+1,1) = {sprintf('%% Solar geometry: SZA=%2.1f, SAZ=%2.1f, SEL=%2.1f, airmass_Rayleigh=%1.2f, airmass_aerosol=%1.2f, sol_dist_AU=%1.3f',...
    [meanSZA, meanSAZ, meanSEL, mean_am_ray, mean_am_aero, soldst_au])};
N_wl = sum(s.wl_);N_obs = sum(good_); N_sun_obs = sum(sun_); N_sky_obs = sum(sky_); alb_src = 'SSFR'; 
inp.header(end+1,1) = {sprintf('%% Config details: N_wavelengths=%d,N_obs=%d, N_sun_obs=%d, N_sky_obs=%d, albedo_source=%s',[N_wl, N_obs, N_sun_obs, N_sky_obs,alb_src])};

inp.static_data(1,1) = {['wavelength(N_wavelengths)[nm]=[',sprintf('%3.1f',1000.*s.w(s.wl_ii(1))),sprintf(', %3.1f',1000.*s.w(s.wl_ii(2:end))),']']};
% Add spectrometer FWHM
% Add uncertainty estimate for AOD, for skyrad
%
inp.static_data(end+1,1) = {['flight_level_albedo(N_wavelengths)[unitless]=[',sprintf('%1.2f',sfc_alb(s.wl_ii(1))),sprintf(', %1.2f',sfc_alb(s.wl_ii(2:end))),']']};
% Add variability in SFFR albedo over sky scan
% Add uncertainty in SSFR albedo over sky scan
% Add support for MODIS sfc_alb or BDRF
    guey_ESR = gueymard_ESR;
    g_ESR = interp1(guey_ESR(:,1), guey_ESR(:,3), 1000.*s.w(s.wl_ii),'pchip','extrap');
   % Substitute alternative to Gueymard? E.g., Coddington ESR?
inp.static_data(end+1,1) = {['TOA_irradiance_Gueymard(N_wavelengths)[W/m2/nm]=[',sprintf('%1.2f',g_ESR(1)),sprintf(', %1.2f',g_ESR(2:end)),']']};

% inp.static_data(end+1,1) = {'pitch, roll, heading, Quad, pitch_del, roll_del, head_del, quad_del, pitch_std, roll_std, head_std, QD_std'}
% rec_type: type of spectra reported 
% rec_type=1: Tr_LOS, atmospheric transmittance, line of sight to sun
% rec_type=2: TOD_LOS, total observed OD, line of sight to sun = -ln(Tr_LOS)
% rec_type=3: ROD, Rayleigh molecular OD, vertical above Alt
% rec_type=4: AOD, aerosol OD subtract all gasses, vertical above Alt (=TOD-ROD-GOD_retrieved)
% rec_type=5: AOD_fit, 3rd order polynomial fit of AOD subtract-all over gas-free wavelengths
% rec_type=6: GOD_obs, gaseous OD inferred as TOD - ROD - AOD_fit 
% rec_type>6: reserved for reporting specific gas ODs and cross-sections
% rec_type=-1: RAD, sky radiance [W/m2/nm/sr] (= s.skyrad./1000)
% rec_type=-2: NRAD, normalized sky radiance [1/sr] (=pi*RAD/TOA)
nrad = pi.*skyrad./(ones(size(sky_ii))*g_ESR);

Tr_LOS = s.rate(sun_,s.wl_).*(soldst_au.^2)./s.c0(s.wl_);
TOD_LOS =real(log(Tr_LOS));
ROD = s.tau_ray(sun_,s.wl_);
AOD = s.tau_aero_subtract_all(sun_,s.wl_);
for ss = length(sun_ii):-1:1
    PP_(ss,:) = polyfit(log(WL), real(log(AOD(ss,:))),3);
    AOD_fit(ss,:) = exp(polyval(PP_(ss,:),log(WL)));
end
GOD_obs = s.tau_tot_vert(sun_ii,s.wl_) -ROD - AOD_fit;


V = datevec(s.t(good_));
% YYYY, MM, DD, hh, mm, ss.mmm, d_str, lat, lon, alt, sza, sel, saz, oza, oel, oaz, SA
%  s_type, airmass_X, spectra(wavelength)

inp.spectra(1,1) = {'YYYYMMDD HH:MM:SS UTC, YYYY, MM, DD, hh, mm, ss.mmm, Lat_degN, Lon_degE, Flight_Alt_m, SZA_deg, SEL_deg, SAZ_deg, obs_ZA_deg, obs_El_deg, obs_Az_deg, Scat_Ang_Deg, rec_type, spectra(wavelength)'};
for ss = 1:length(good_ii)
    ti = good_ii(ss);
    stub = sprintf('%s, %d, %d, %d, %d, %d , %2.3f, %2.4f, %3.4f, %2.1f, %2.1f, %2.1f, %2.1f, %2.1f, %2.1f, %2.1f, %2.1f, ',...
        datestr(s.t(ti),'yyyy-mm-dd HH:MM:SS.fff UT'),V(ss,:), s.Lat(ti), s.Lon(ti), s.Alt(ti),...
        s.sza(ti), s.sunel(ti), s.sunaz(ti),s.sza(ti), s.sunel(ti), s.sunaz(ti),s.SA(ti));
    if any(sun_ii==ti) % Then it is a sun spectra, so report various direct beam products
        for rec_type = 1:6
            in = find(sun_ii==ti);
            if rec_type==1
                spec = Tr_LOS(in,:);
            elseif rec_type==2
                spec = TOD_LOS(in,:);
            elseif rec_type==3
                spec = ROD(in,:);
            elseif rec_type==4
                spec = AOD(in,:);
            elseif rec_type==5
                spec = AOD_fit(in,:);
            elseif rec_type==6
                spec = GOD_obs(in,:);
            elseif rec_type>6
                spec = NaN(size(WL));
                warning('rec_type > 6 reserved for reporting gas species OD and cross sections.  Not yet supported.');
            end
            inp.spectra(end+1,1) = {[stub, sprintf('%d',rec_type), sprintf(', %2.3g',spec)]};
        end
        
    elseif any(sky_ii==ti) %Then it is a sky scan so report
        for rec_type = -1:-1:-2
            in = find(sky_ii==ti);
            if rec_type==-1
                spec = skyrad(in,:);
            elseif rec_type == -2
                spec = nrad(in,:);
            end
            inp.spectra(end+1,1) = {[stub, sprintf('%d',rec_type), sprintf(', %2.3g',spec)]};
        end               
    end
end

   if isfield(s.toggle,'sky_tag')&&~isempty(s.toggle.sky_tag)
        tag_str = s.toggle.sky_tag; tag_str = tag_str{:};
        if ~isempty(tag_str) tag_str = strrep(['.',tag_str, '.'],'..','.'); tag_str = strrep(tag_str,'..','.');end
    else tag_str = '';
   end
    grout = '.grout.'; % Output mat file for GRASP
    
    fname = strrep([getnamedpath('starsky'),  s.fstem,grout,tag_str,'.mat'],'..','.'); 
    v = 1;
    while isafile(fname)
        v = v+1;
        fname = strrep([getnamedpath('starsky'),  s.fstem,grout,tag_str,'.v',num2str(v),'.mat'],'..','.'); 
    end
    save(fname,'inp','-mat', '-v7.3');
    fname_mat = fname;
    fname = strrep(fname, '.mat','.csv'); 
    while isafile(fname)
        v = v+1;
        fname = strrep([getnamedpath('starsky'),  s.fstem,grout,tag_str,'.v',num2str(v),'.csv'],'..','.'); 
    end
    gid = fopen(fname,'w+');
    fprintf(gid,'%s \n',inp.header{:});
    fprintf(gid,'%s \n',inp.static_data{:});
    fprintf(gid,'%s \n',inp.spectra{:});
    fclose(gid);
    fname_csv = fname;
%     edit(fname)
    
return