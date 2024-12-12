function [cwv] = cwvcorecalc(s,modc0,model_atmosphere)
%% function routine
%  [cwv] = cwvcorecalc(s,modc0,model_atmosphere)
%% Details of the function:
% NAME:
%   cwvcorecalc
%
% PURPOSE:
%   retrieves water vapor using best fit/avg estimation
%   using the 940 nm band absorption region using two methods:
%   m1: coef based, average over 940-960 nm region (AATS haritage)
%   m2: best fit procedure over the 940 nm band + 2nd order polynomial
%   both methods use altitude dependent cross-sections
%
%
% CALLING SEQUENCE:
%  function [cwv] = cwvcorecalc(starsun,modc0,model_atmosphere)
%
% INPUT:
%  - starsun: starsun struct from starwarapper
%  - modc0  : modified c0 over the 940 nm band (from starmodc0.m) combined
%    with vislampc0/nirlampc0: (from starc0mod.m)
%  - model_atmosphere: needed to decide which coef set to use
%
%
% OUTPUT:
%  - cwv.cwv940m1: cwv amount using avg 940-960 nm values (old method)
%  - cwv.cwv940m2: cwv amount using best fit over 940 nm band (new method)
%  - cwv.cwv940m1std: std of avrage over 940-960 nm band
%  - cwv.cwv940m2resi: residual of best fit procedure
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.
%
% NEEDED FILES:
%  - yyyymmdd_VIS_C0_modified_Langley*.DAT file forward by starwrapper
%
% EXAMPLE:
%  - [cwv] = cwvcorecalc(starsun,modc0,2);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, NASA Ames, Aug 7th, 2014
% MS: 2014-11-14: corrected bug of using m_aero_avg/m_H2O_avg instead of
%                 m_aero/m_H2O, and performed calculations over slant path with
%                 post-division of airmass factor
% MS: 2014-11-17:-replaced all _avg values with original ones
%                -added water vapor subtraction from OD spectra
% MS: 2015-10-20: added QA plots for various structures; commented out
%                 subtracted water vapor from
%                 line 607: used starsun.tau_aero_tot (O2-O2 NIR
%                 subtracted) with water vapor subtraction
% MS: 2016-01-10  fixed some bugs related to cwv retrieval for model atm=1
% MS: 2016-02-23: re-editing changes that were made after MLO and deleted
% MS: 2016-09-02: tweaked to account for erroneous altitudes
% MS: 2016-11-02: fixing bug in calculating cwv.tau_OD_wvsubtract
% SL: 2017-04-07: fix calculation of cwv.tau_OD_wvsubtract to be set to 0 when NaN or inf
% MS: 2018-04-11: fixed bug of cwv2sub calculated from subtracting s.tau_aero
%                 instead of tau_aero calculated from the polynomial fit (slant)
%                 also corrected bug to save tau_aero_cwvsub into cwv struct instead of s
% MS: 2018-04-16: changed calculation for tau_aero_cwvsub (line 408)
% CJF: 2020-04-24: Added comments, and forced run only for suns=find(s.Str==1 & s.Zn==0)
% -----------------------------------------------------------------------------------------
showfigure = 0;
Loschmidt=2.686763e19;                   % molec/cm3*atm
cwvoptfit = true;

%----------------------------------------------------------------------
%% lamp calibration
% lamp calibration spectra
wvis = s.w(1:1044);
wnir = s.w(1045:end);
%
% find wavelength range for 940 nm water vapor bands
nm_0880 = interp1(wvis,[1:length(wvis)],0.8823, 'nearest');
nm_0990 = interp1(wvis,[1:length(wvis)],0.9940, 'nearest');

% end of o3 region
nm_0675 = interp1(wvis,[1:length(wvis)],0.6823,  'nearest');%0.675

wln_vis1 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880));

% initialize subtracted OD spectra
wvOD    = zeros(length(s.t),length(s.w));
wvODfit = zeros(length(s.t),length(s.w));

% calculate OD spectra:
qqvis = length(wvis);
qqnir = length(wnir);
pp    = length(s.t);
qq    = length(s.w);
sundist   = repmat(s.f(1),length(s.t),length(s.w));
calibc0   = repmat(s.c0,length(s.t),1);
spc       = s.rate./calibc0./sundist; % This is the slant-path line of sight atmospheric transmittance
Tslant    = spc.*exp((s.tau_ray).*repmat(s.m_ray,1,length(s.w))); % Removes effect of Rayleigh
tau_ODslant = -log(Tslant); % Slant-path OD
%rateall    = real(starsun.rate./repmat(starsun.f,1,qq)./tr(starsun.m_ray, starsun.tau_ray)); % rate adjusted for the Rayleigh component
%tau_OD     = real(-log(rateall./repmat(starsun.c0,pp,1)));%./repmat(starsun.m_aero,1,qq));   % total slant optical depth (Rayeigh subtracted)

% QA plot of tau_ODslant vs.s.tau_tot_slant
%     wi = [1084,1109,1213,1439,1503];
%     le = {'1020 nm';'1064 nm';'1236 nm';'1559 nm';'1640 nm'};
%     figure;
%     for ll=1:length(wi)
%         subplot(length(wi),1,ll);
%         plot(starsun.UTHh,tau_ODslant(:,wi(ll))-...
%              starsun.tau_tot_slant(:,wi(ll)),'ok');hold on;
%          if ll==3
%          xlabel('time [UTC]');
%          ylabel('\Delta (tau-aero OD slant (cwv routine) - tau-aero-slant (starwrapper))');
%          end
%         legend(le{ll,:});
%         axis([min(starsun.UTHh) max(starsun.UTHh) -0.05 0.05]);
%         plot(starsun.UTHh,zeros(length(starsun.UTHh),1),'-m');hold off;
%     end


%     figure;
%
%         plot(starsun.w,tau_ODslant([9850],:),'-k');hold on;
%         plot(starsun.w,starsun.tau_tot_slant([9850],:),':k');hold on;
%         legend('tau-aero OD slant','tau-tot-slant');
%         xlabel('wavelength');
%


%
%% apply modified calib to rate

calibmodc0   = repmat(modc0',length(s.t),1);

% calculate rate using modc0
% spc_modc0old    = starsun.spc_avg./calibmodc0./sundist;
spc_modc0       = s.rate./calibmodc0./sundist;
%

% slant transmittance corrected for Rayleigh
modc0Tw=spc_modc0.*exp((s.tau_ray).*repmat(s.m_ray,1,length(s.w)));
% tau_OD modc0
tau_ODmodc0slant = -log(modc0Tw);
% tau_ODmodc0 = tau_ODmodc0slant./repmat(s.m_aero,1,length(s.w));

%
% initialize wv array for subtraction
% cwv.tau_aero_cwvsub = zeros(pp,qq);   % this is for cwv m1 retrieval
cwv.tau_OD_wvsubtract   = zeros(pp,qq);   % this is for cwv fit retreival (m2)
%

%%

%-------------------------------------
% loop over retrieval regions (==1 at current version)
for wrange=[1];
    switch wrange
        case 1
            % 940 nm analysis
            lab1  = 'cwv940m1';
            lab2  = 'cwv940m2';
            labstd1 = 'cwv940m1std';
            labstd2 = 'cwv940m2resi';
            wln  = wln_vis1;
            ind = [77:103];% 0.94-0.96
    end % switch
    
    %
    %%
    %% baseline subtraction
    % begin of method 1
    %==================
    % baseline is calculated to get an estimation of the aerosol amount at the 940 nm band for Tw conversion
    % calculate linear baseline for only the water vapor band region
    % calculate polynomial baseline
    order2=1;  % order of baseline polynomial fit
    poly3=zeros(length(s.w(wln)),length(s.t));  % calculated polynomial
    poly3_c=zeros(length(s.t),(order2)+1);            % polynomial coefficients
    order_in2=1;
    thresh_in2=0.01;
    % deduce baseline
    
    % for i=1:length(s.t)
    suns = find(s.Str==1&s.Zn==0)';
    for i=suns
        % function (fn) can be: 'sh','ah','stq','atq'
        % for gui use (visualization) write:
        % [poly2_,poly2_c_,iter,order,thresh,fn]=backcor(wvis(wln_ind),starsun.tau_aero(goodTime(i),wln_ind));
        % spectrum calculated by modc0 calibration (vertical OD)
        [poly3_,poly3_c_,iter,order_lin,thresh,fn] = backcor(s.w(wln),tau_ODmodc0slant(i,wln),order_in2,thresh_in2,'atq');% backcor(wavelength,signal,order,threshold,function);
        poly3(:,i)=poly3_;        % calculated polynomials
        poly3_c(i,:)=poly3_c_';   % polynomial coefficients
        
        % plot AOD baseline interpolation and real AOD values
        %                 figure(1111)
        %                 plot(starsun.w(wln),tau_ODmodc0(i,wln),'.b','markersize',8);hold on;
        %                 plot(starsun.w(wln),poly3_,'-r','linewidth',2);hold off;
        %                 legend('AOD','AOD baseline');title(num2str(starsun.t(i)));
        %                 pause(0.01);
        
    end
    
    % assign spectrum, baseline and subtracted spectrum
    tau_aero=real(poly3);  % this is slant path aerosol OD
    
    baseline = (tau_aero)';% this is slant
    spectrum = tau_ODmodc0slant(:,wln); %Non-Rayleigh slant OD
    spectrum_sub = spectrum-baseline;%
    %% end of baseline subtraction
    
    
    % these transmittances are used for AATS method CWV derivation
    %      Tw=spc_modc0(:,wln).*exp(tau_aero'.*(repmat(starsun.m_aero,1,length(starsun.w(wln))))+...
    %     (starsun.tau_ray(:,wln)).*repmat(starsun.m_ray,1,length(starsun.w(wln))));    % disregarding O3 in those wavelengths (above 800 nm)
    % tau_aero is slant path here
    Tw=spc_modc0(:,wln).*exp(tau_aero'+...
        (s.tau_ray(:,wln)).*repmat(s.m_ray,1,length(s.w(wln))));    % disregarding O3 in those wavelengths (above 800 nm)
    
    %
    % upload a and b parameters (from LBLRTM - new spec FWHM)
    if model_atmosphere==1||model_atmosphere==2 %!!! check if xs should be related to calibration or measurement location
        xs_ = 'H2O_cross_section_FWHM_new_spec_all_range_Tropical3400m.mat';
        %      xs = load(xs_); %xs  = load(which( xs_));
    else
        xs_ = 'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter6850m.mat';
        %      xs  = load(xs_); %xs = load(which( xs_));
    end
    xs = load(xs_);
    %
    % interpolate H2O parameters to whole wln grid
    % this is not used here; altitude interpolated is used
    H2Oa = interp1(xs.wavelen,xs.cs_sort(:,1),(s.w)*1000,'nearest','extrap');
    H2Ob = interp1(xs.wavelen,xs.cs_sort(:,2),(s.w)*1000,'nearest','extrap');
    % transform H2Oa nan to zero
    H2Oa(isnan(H2Oa)==1)=0;
    % transform H2Oa inf to zero
    H2Oa(isinf(H2Oa)==1)=0;
    % transform H2Oa negative to zero
    H2Oa(H2Oa<0)=0;
    % transform H2Ob to zero if H2Oa is zero
    H2Ob(H2Oa==0)=0;
    %---------------------------------------
    % calculate water vapor
    %---------------------------------------
    
    if model_atmosphere==1 %MLO
        H2O_conv=1244.12; %converts cm-atm in pr cm or g/cm2.  the conversion factor has units of [cm^3/g].
        
        U1=(1./repmat(s.m_H2O,1,length(wln))).*(((1./(-repmat(H2Oa((wln))',1,length(s.t)))))'.*...
            (log(Tw))).^((1./(repmat(H2Ob((wln))',1,length(s.t))))');
        Ufinal  = U1/H2O_conv;
        avg_U1 = mean(Ufinal(:,ind),2);%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
        std_U1 = nanstd(Ufinal(:,ind),[],2);%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
        % add cross section parameters to be used in best fit retrieval
        afit_H2O = H2Oa';
        bfit_H2O = H2Ob';
        cfit_H2O=ones(length(xs.wavelen),1);
    elseif model_atmosphere==3 % TCAP winter/ARISE
        % load altitude dependent coef.
        alt0    = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter0m.mat'));
        alt1000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter1000m.mat'));
        alt2000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter2000m.mat'));
        alt3000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter3000m.mat'));
        alt4000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter4000m.mat'));
        alt5000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter5000m.mat'));
        alt6000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwin6000m.mat'));
        alt7000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter7000m.mat'));
        alt8000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter7000m.mat'));
        alt9000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatWinter7000m.mat'));
        
        zkm_LBLRTM_calcs=[0:9];
        afit_H2O=[alt0.cs_sort(:,1) alt1000.cs_sort(:,1) alt2000.cs_sort(:,1) alt3000.cs_sort(:,1) alt4000.cs_sort(:,1) alt5000.cs_sort(:,1) alt6000.cs_sort(:,1) alt7000.cs_sort(:,1) alt8000.cs_sort(:,1) alt9000.cs_sort(:,1)];
        bfit_H2O=[alt0.cs_sort(:,2) alt1000.cs_sort(:,2) alt2000.cs_sort(:,2) alt3000.cs_sort(:,2) alt4000.cs_sort(:,2) alt5000.cs_sort(:,2) alt6000.cs_sort(:,2) alt7000.cs_sort(:,2) alt8000.cs_sort(:,2) alt9000.cs_sort(:,2)];
        cfit_H2O=ones(length(xs.wavelen),length(zkm_LBLRTM_calcs));
        Ucalc = NaN(length(s.t), length(wln));
        for j=suns
            kk=find(s.Alt(j)/1000>=zkm_LBLRTM_calcs);
            if s.Alt(j)/1000<0 kk=1; end  %handles alts slightly less than zero
            kz=kk(end);
            CWV1=(-log(Tw(j,:)./(cfit_H2O(wln,kz))')./(afit_H2O(wln,kz))').^(1./(bfit_H2O(wln,kz))')./s.m_H2O(j);
            CWV2=(-log(Tw(j,:)./(cfit_H2O(wln,kz+1))')./(afit_H2O(wln,kz+1))').^(1./(bfit_H2O(wln,kz+1))')./s.m_H2O(j);
            CWVint_atmcm = CWV1 + (s.Alt(j)/1000-zkm_LBLRTM_calcs(kz))*(CWV2-CWV1)/(zkm_LBLRTM_calcs(kz+1)-zkm_LBLRTM_calcs(kz));
            Ucalc(j,:)=CWVint_atmcm;
        end
        %Uold=U;
        U=Ucalc;
        
        H2O_conv=1244.12; %converts cm-atm in pr cm or g/cm2.  the conversion factor has units of [cm^3/g].
        Ufinal  = U/H2O_conv;
        %   U1=(1./repmat(starsun.m_H2O_avg((goodTime))',1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.t((goodTime)))))))'.*...
        %       (log(Tw(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.t((goodTime))))))');
        %  U1_lamp=(1./repmat(starsun.m_H2O_avg((goodTime))',1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.t((goodTime)))))))'.*...
        %      (log(Tw_lamp(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.t((goodTime))))))');
        % average U1 over wavelength
        avg_U1 = mean(Ufinal(:,ind),2);%(1:78=920-980)%26-52=940-960 26-40=940-950 nm; last:26:52
        std_U1 = abs(real((nanstd(Ufinal(:,ind),[],2))));
        %  avg_U1 = avg_U1_;
        %  avg_U1((isnan(avg_U1_)==1))=0;
        %  avg_U1 = real(avg_U1);
        %   U1_conv    =U1/H2O_conv;
        %   U1_convavg =mean(U1_conv(:,26:52),2)
        %  U1_lamp_conv=U1_lamp/H2O_conv;
        
    elseif model_atmosphere==2 % SEAC4RS/TCAP summer
        % load altitude dependent coef.
        if exist('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum0m.mat','file')
            alt0    = load('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum0m.mat');
            alt1000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum1000m.mat');
            alt2000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum2000m.mat');
            alt3000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum3000m.mat');
            alt4000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum4000m.mat');
            alt5000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum5000m.mat');
            alt6000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum6000m.mat');
            alt7000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer7000m.mat');
            alt8000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer8000m.mat');
            alt9000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer9000m.mat');
            alt10000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer10000m.mat');
            alt11000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer11000m.mat');
            alt12000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer12000m.mat');
            alt13000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer13000m.mat');
            alt14000 = load('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer14000m.mat');
        else
            
            alt0    = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum0m.mat'));
            alt1000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum1000m.mat'));
            alt2000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum2000m.mat'));
            alt3000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum3000m.mat'));
            alt4000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum4000m.mat'));
            alt5000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum5000m.mat'));
            alt6000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatwsum6000m.mat'));
            alt7000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer7000m.mat'));
            alt8000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer8000m.mat'));
            alt9000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer9000m.mat'));
            alt10000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer10000m.mat'));
            alt11000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer11000m.mat'));
            alt12000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer12000m.mat'));
            alt13000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer13000m.mat'));
            alt14000 = load(which('H2O_cross_section_FWHM_new_spec_all_range_midLatSummer14000m.mat'));
        end
        
        
        zkm_LBLRTM_calcs=[0:14];
        afit_H2O=[alt0.cs_sort(:,1) alt1000.cs_sort(:,1) alt2000.cs_sort(:,1) alt3000.cs_sort(:,1) alt4000.cs_sort(:,1) alt5000.cs_sort(:,1) alt6000.cs_sort(:,1) alt7000.cs_sort(:,1) alt8000.cs_sort(:,1) alt9000.cs_sort(:,1)...
            alt10000.cs_sort(:,1) alt11000.cs_sort(:,1) alt12000.cs_sort(:,1) alt13000.cs_sort(:,1) alt14000.cs_sort(:,1)];
        bfit_H2O=[alt0.cs_sort(:,2) alt1000.cs_sort(:,2) alt2000.cs_sort(:,2) alt3000.cs_sort(:,2) alt4000.cs_sort(:,2) alt5000.cs_sort(:,2) alt6000.cs_sort(:,2) alt7000.cs_sort(:,2) alt8000.cs_sort(:,2) alt9000.cs_sort(:,2)...
            alt10000.cs_sort(:,2) alt11000.cs_sort(:,2) alt12000.cs_sort(:,2) alt13000.cs_sort(:,2) alt14000.cs_sort(:,2)];
        cfit_H2O=ones(length(xs.wavelen),length(zkm_LBLRTM_calcs));
        
        afit_allH2O=[alt0.cs_sort(1:1556,1) alt1000.cs_sort(1:1556,1) alt2000.cs_sort(1:1556,1) alt3000.cs_sort(1:1556,1) alt4000.cs_sort(1:1556,1) alt5000.cs_sort(1:1556,1) alt6000.cs_sort(1:1556,1) alt7000.cs_sort(1:1556,1) alt8000.cs_sort(1:1556,1) alt9000.cs_sort(1:1556,1)...
            alt10000.cs_sort(1:1556,1) alt11000.cs_sort(1:1556,1) alt12000.cs_sort(1:1556,1) alt13000.cs_sort(1:1556,1) alt14000.cs_sort(1:1556,1)];
        bfit_allH2O=[alt0.cs_sort(1:1556,2) alt1000.cs_sort(1:1556,2) alt2000.cs_sort(1:1556,2) alt3000.cs_sort(1:1556,2) alt4000.cs_sort(1:1556,2) alt5000.cs_sort(1:1556,2) alt6000.cs_sort(1:1556,2) alt7000.cs_sort(1:1556,2) alt8000.cs_sort(1:1556,2) alt9000.cs_sort(1:1556,2)...
            alt10000.cs_sort(1:1556,2) alt11000.cs_sort(1:1556,2) alt12000.cs_sort(1:1556,2) alt13000.cs_sort(1:1556,2) alt14000.cs_sort(1:1556,2)];
        
        Ucalc    = NaN(length(s.t),length(wln));
        colTw    = NaN(length(s.t),length(s.w));
        
        for j=suns
            if ~isNaN(s.Alt(j))
                kk=find(s.Alt(j)/1000>=zkm_LBLRTM_calcs);
                % tweak to account for erroneous altitudes
                if length(kk)>14 kk=kk(1):kk(14); end;
                if s.Alt(j)/1000<=0 kk=1; end            %handles alts slightly less than zero
                kz=kk(end);
                CWV1=((-log(Tw(j,:)./(cfit_H2O(wln,kz))')./(afit_H2O(wln,kz))').^(1./(bfit_H2O(wln,kz))'))./s.m_H2O(j);
                CWV2=(-log(Tw(j,:)./(cfit_H2O(wln,kz+1))')./(afit_H2O(wln,kz+1))').^(1./(bfit_H2O(wln,kz+1))')./s.m_H2O(j);
                CWVint_atmcm = CWV1 + (s.Alt(j)/1000-zkm_LBLRTM_calcs(kz))*(CWV2-CWV1)/(zkm_LBLRTM_calcs(kz+1)-zkm_LBLRTM_calcs(kz));
                Ucalc(j,:)    =CWVint_atmcm;
                colTw(j,:)    =exp(- afit_allH2O(:,kz).*(nanmean(CWVint_atmcm(26:52))).^bfit_allH2O(:,kz));
                %tau_h2oa(j,:) = real(-log(colTw(j,:)));
                
                % test Tw figure;
                %               figure(666)
                %               plot(wvis(wln),-log(Tw(j,:)),'.b');hold on;
                %               plot(wvis(wln),CWV1/H2O_conv, '-b');hold on;
                %               plot(wvis(wln),CWV2/H2O_conv,'--g');hold off;
                %               legend('CWVod','CWVkz1','CWVkz2');
                %               title([datestr(starsun.t(j),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Alt(j)) 'm' 'kz1 = ' num2str(kz) ' kz2 = ' num2str(kz+1)]);
                
                %%% end test figure
                
            else
                Ucalc(j,:)   =zeros(1,length(wln));
                colTw(j,:)   =zeros(1,length(s.w));
                %tau_h2oa(j,:)=zeros(1,length(starsun.w));
                
            end
        end
        %Uold=U;
        U=Ucalc;
        
        
        
        H2O_conv=1244.12; %converts cm-atm into pr cm or g/cm2.  the conversion factor has units of [atm*cm^3/g].
        Ufinal  = U/H2O_conv;
        %   U1=(1./repmat(starsun.m_H2O((goodTime))',1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.t((goodTime)))))))'.*...
        %       (log(Tw(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.t((goodTime))))))');
        
        % average U1 over wavelength
        avg_U1 = abs(real(nanmean(Ufinal(:,ind),2)));%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
        std_U1 = abs(real((nanstd(Ufinal(:,ind),[],2))));
        
        s.Alt(s.Alt<0)=0;
        
        %      Tslant
        % subtract cwv from tau_aero using m1
        if ~isavar('kz'), kz = 1; end 
        afit_H2Os1 = afit_H2O(:,kz); afit_H2Os1(isNaN(afit_H2Os1)) = 0; afit_H2Os1(afit_H2Os1<0) = 0; afit_H2Os1(isinf(afit_H2Os1)) = 0;
        bfit_H2Os1 = bfit_H2O(:,kz); bfit_H2Os1(isNaN(bfit_H2Os1)) = 0; bfit_H2Os1(bfit_H2Os1<0) = 0; bfit_H2Os1(isinf(bfit_H2Os1)) = 0;
        afit_H2Os1  = real(afit_H2Os1)'; bfit_H2Os1 = real(bfit_H2Os1)';
        
        
        cwv2sub   = -log(  exp(  -(ones([pp,1])*afit_H2Os1).*((avg_U1*ones([1,qq])*H2O_conv).^(ones([pp,1])*bfit_H2Os1))  )  );
        %      cwv.tau_aero_cwvsub = s.tau_tot_slant - wvamount;% this is a structure with o2-o2 NIR subtracted
        
        %      cwv2sub   =
        %      -log(exp(-afit_H2Os1.*(real(avg_U1(i)*H2O_conv)).^bfit_H2Os1)); % original
        
        
    end
    % assign method 1 variables to save:
    cwv.(lab1)    = avg_U1;
    cwv.(labstd1) = std_U1;
    cwv.wvODm1 = cwv2sub;
    % end of method 1
    %================
    
    %-----------------------------------
    %% plots
    %-------
    s.UTHh = serial2Hh(s.t);
    if showfigure==1
        % plot Tw
        figure (1); plot(wvis(wln),Tw);legend('Tw by modified Langley');
        
        % plot cwv with wavelength
        figure (2);plot(wvis(wln),Ufinal);      axis([0.92 0.98 0 (max(avg_U1))]);legend('cwv by Modified Langley');
        
        % plot avg_cwv
        figure (3);plot(s.UTHh,avg_U1,'ob','markerfacecolor','b','markersize',10);xlabel('UT','fontsize',12,'fontweight','bold');ylabel('CWV [g/cm2]','fontsize',12,'fontweight','bold');
        set(gca,'fontsize',12,'fontweight','bold');axis([min(s.UTHh) max(s.UTHh) 0 max(avg_U1)]);
        
        % with Lat/Lon
        figure(4);scatter3(s.Lat(avg_U1<=3&avg_U1>=0),s.Lon(avg_U1<=3&avg_U1>=0),avg_U1(avg_U1<=3&avg_U1>=0),10,avg_U1(avg_U1<=3&avg_U1>=0),'filled');xlabel('Latitude','fontsize',12,'fontweight','bold');ylabel('Longitude','fontsize',12,'fontweight','bold');
        set(gca,'fontsize',12,'fontweight','bold');axis([min(s.Lat) max(s.Lat) min(s.Lon) max(s.Lon) 0 3]);
        cb=colorbar; set(cb,'fontsize',12,'fontweight','bold');title('CWV [g/cm^{2}]','fontsize',12','fontweight','bold');
        % with Lat/Alt-bound by low CWV values
        figure(5);scatter3(s.Lat(avg_U1<=0.5&avg_U1>=0),s.Altavg(avg_U1<=0.5&avg_U1>=0),avg_U1(avg_U1<=0.5&avg_U1>=0),10,avg_U1(avg_U1<=0.5&avg_U1>=0),'filled');
        xlabel('Latitude','fontsize',12,'fontweight','bold');ylabel('Altitude [m]','fontsize',12,'fontweight','bold');
        set(gca,'fontsize',12,'fontweight','bold');axis([min(s.Lat) max(s.Lat) min(s.Alt) max(s.Alt) 0 1]);
        cb=colorbar; set(cb,'fontsize',12,'fontweight','bold');title('CWV [g/cm^{2}]','fontsize',12','fontweight','bold');
        
        % plot average 0.92-0.96 (1:52)
        %  figure;errorbar(starsun.UTHh((goodTime)),mean(Ufinal(:,26:52),2),std(Ufinal(:,26:52),[],2),'d','color',[0 0.8 0.2],'MarkerSize',6);hold on;
        %         plot(starsun.UTHh((goodTime)),starsun.Altavg((goodTime))/1000,'-','color',[0.5 0.5 0.5],'LineWidth',2);
        figure(44);
        [AX,H1,H2] = plotyy(s.UTHh,avg_U1,s.UTHh,s.Alt);
        set(get(AX(1),'Ylabel'),'String','Columnar Water vapor [g cm^{-2}]','FontSize',16,'color',[0 0.8 0.2])
        set(get(AX(2),'Ylabel'),'String','Altitude [meters]','FontSize',16,'color',[0.5 0.5 0.5])
        set(H1,'LineStyle','d','MarkerFaceColor',[0 0.8 0.2],'MarkerSize',6)
        set(H2,'LineStyle','-','color',[0.5 0.5 0.5],'LineWidth',3)
        set(AX,'FontSize',16); xlabel('Time [UT]','FontSize',16);
        
        
    end

    %% fmincon conversion
    % begin of method 2
    %====================
    if cwvoptfit
        % declare sws_opt and ws_residual
        swv_opt = []; swv_opt=NaN(length(s.t),4);
        wv_residual = []; wv_residual= NaN(size(s.t));
        %if s.toggle.verbose
        %   options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','notify-detailed','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
        %else
        options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','off','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
        %end
        if s.toggle.verbose
            disp('Starting CWV retrieval loop...')
            upd = textprogressbar(length(s.t),'updatestep',50);
        end
 
        for i = suns
            % for i = 1:suns
            % choose right altitude coef
            if model_atmosphere~=1 % run for airborne campaigns only
                if ~isNaN(s.Alt(i))
                    kk=find(s.Alt(i)/1000>=zkm_LBLRTM_calcs);
                    if s.Alt(i)/1000<=0 kk=1; end            %handles alts slightly less than zero
                    kz=kk(end);
                    
                else
                    kz=1;
                end
            end
            % !!! can use co2/ch4/o2 xs altitude dependance similarly
            %
            %  x0 = [300 10000 10000 0.75 0.8 -2 -0.1]; % this is initial guess
            if wrange==3
                x0 = [5000 50000 0.75 0.8 -2];% last 3 are baseline poly coef
            elseif wrange==4
                x0 = [5000 100 0.75 0.8 -2];
            elseif wrange==5
                x0 = [5000 1000 1000 1000 0.75 0.8 -2];
            else
                x0 = [5000 0.75 0.8 -2];
            end
            %if lampcalib==1
            y = real((spectrum(i,:)));%this non-Rayliegh slant OD
            %        else
            %             y = (spectrum(i,:));%waterOD(i,:);
            %        end
            meas = [s.w(wln)' y'];
            Xdat = meas(:,1);
            if model_atmosphere==1
                ac = real(afit_H2O(wln)); ac(isNaN(ac)) = 0; ac(ac<0) = 0; ac(isinf(ac)) = 0;
                bc = real(bfit_H2O(wln)); bc(isNaN(bc)) = 0; bc(bc<0) = 0; bc(isinf(bc)) = 0;
                PAR  = [ac bc];
            else
                ac = real(afit_H2O(wln,kz)); ac(isNaN(ac)) = 0; ac(ac<0) = 0; ac(isinf(ac)) = 0;
                bc = real(bfit_H2O(wln,kz)); bc(isNaN(bc)) = 0; bc(bc<0) = 0; bc(isinf(bc)) = 0;
                PAR  = [ac bc];
            end
            
            % Set Options
            %        options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','notify-detailed','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
            
            % bounds
            if wrange==3
                lb = [0 0 -10 -10 -10];
                ub = [10000   10000 20 20 20];
                U_ = [NaN NaN NaN NaN NaN];
            elseif wrange==4
                lb = [0 0 -10 -10 -10];
                ub = [50000 10000 20 20 20];
                U_ = [NaN NaN NaN NaN NaN];
            elseif wrange==5
                lb = [0 0 0 0 -10 -10 -10];
                ub = [50000 10000 10000 10000 20 20 20];
                U_ = [NaN NaN NaN NaN NaN NaN];
            else
                lb = [0 -10 -10 -10];
                ub = [10000 20 20 20];%max(max(real(U)));
                U_ = [NaN NaN NaN NaN];
            end
            
            if x0(1)>=ub(1)
                x0(1) = ub(1)/2;
            elseif x0(1)<0
                x0(1) = lb(1);
            elseif isNaN(x0(1))
                x0(1) = lb(1);
            end
            
            %ynan = isNaN(y); realy = isreal(y);
            % check spectrum validity for conversion
            ypos = logical(y>=0);ylarge = logical(y>=5);
            if ~isNaN(y(1)) && isreal(y) && sum(ypos)>=(length(wln)-15) && sum(ylarge)<10 && sum(isinf(y))==0
                if wrange==3
                    [U_,fval,exitflag,output]  = fmincon('H2OO2resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR3);
                elseif wrange==4
                    ylarge = logical(y>=4);
                    if sum(ylarge)<10
                        [U_,fval,exitflag,output]  = fmincon('H2OCH4resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR4);
                    end
                elseif wrange==5
                    ylarge = logical(y>=4);
                    if sum(ylarge)<10
                        [U_,fval,exitflag,output]  = fmincon('H2OCH4CO2O4resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR5);
                    end
                else
                    ylarge = logical(y>=4);
                    if sum(ylarge)<10
                        [U_,fval,exitflag,output]  = fmincon('H2Oresi',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
                    end
                end
                if ~isNaN(U_(1)) & isreal(U_(1)) & U_(1)>=0 
                    swv_opt(i,:) = real(U_);
                    wv_residual(i) = real(fval);
                    cwv_opt_ = (real(U_(2))/H2O_conv)/s.m_H2O(i);
                    cwv_opt_round = round(cwv_opt_*1000)/1000;
                    %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
                    % plot fitted figure
                    if wrange==3
                        yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(o2coef(wln).*real(U_(2)))).*exp(-(real(U_(3)) + real(U_(4))*Xdat + real(U_(5))*Xdat.^2));
                        yopt  = real(-log(yopt_));
                        ysub  = real(-log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(o2coef(wln).*real(U_(2))))));
                    elseif wrange==4
                        yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2)))).*exp(-(real(U_(3)) + real(U_(4))*Xdat + real(U_(5))*Xdat.^2));
                        yopt  = real(-log(yopt_));
                        ysub  = real(-log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2))))));
                    elseif wrange==5
                        yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2)))).*exp(-(co2coef(wln).*real(U_(3)))).*exp(-(o4coef(wln).*real(U_(4))))...
                            .*exp(-(real(U_(5)) + real(U_(6))*Xdat + real(U_(7))*Xdat.^2));
                        yopt  = real(-log(yopt_));
                        ysub  = -log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2)))).*exp(-(co2coef(wln).*real(U_(3)))).*exp(-(o4coef(wln).*real(U_(4)))));
                    else
                        %yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(real(U_(2)) + real(U_(3))*Xdat + real(U_(4))*Xdat.^2));
                        %yopt  = (-log(yopt_));
                        %ysub  = real(-log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz))));
                        if model_atmosphere==1
                            yopt_ =  exp(-afit_H2O(wln).*(real(U_(1))).^bfit_H2O(wln)).*exp(-(real(U_(2)) + real(U_(3))*Xdat + real(U_(4))*Xdat.^2));
                            yopt  = (-log(yopt_));
                            ysub  = real(-log(exp(-afit_H2O(wln).*(real(U_(1))).^bfit_H2O(wln))));
                        else
                            yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(real(U_(2)) + real(U_(3))*Xdat + real(U_(4))*Xdat.^2));
                            yopt  = (-log(yopt_));
                            ysub  = real(-log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz))));
                        end
                    end
                    % assign fitted spectrum to subtract
                    %tau_aero_fitsubtract(i,wln) = ysub;
                    % wvODfit(i,wln) = real(yopt) + baseline(i,:)'; %(add subtracted baseline to retrieved fit)
                    %                          figure(4444);
                    %                          plot(starsun.w(wln),y,'-b');hold on;
                    %                          plot(starsun.w(wln),yopt,'--r');hold on;
                    %                          plot(starsun.w(wln),ysub,'-c');hold on;
                    %                          plot(starsun.w(wln),y'-ysub,'-k');hold off;
                    %                          xlabel('wavelength','fontsize',12);ylabel('total slant water vapor OD','fontsize',12);
                    %                          legend('measured','calculated (fit)','spectrum to subtract','subtracted spectrum');
                    %                          title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Alt(i)) 'm' ' CWV= ' num2str(cwv_opt_round)]);
                    %                          ymax = yopt + 0.2;
                    %                          if max(ymax)<0
                    %                              ymaxax=1;
                    %                          else
                    %                              ymaxax=max(ymax);
                    %                          end;
                    %                          axis([min(starsun.w(wln)) max(starsun.w(wln)) 0 ymaxax]);
                    %                          pause(0.0001);
                    
                end

            end
            % water vapor subtraction per altitude (based on 940 nm band)
            %------------------------------------------------------------
            if wrange==1
                % subtract water vapor for all but o3 region
                
                %afit_H2Os = afit_H2O(:,kz); afit_H2Os(isNaN(afit_H2Os)) = 0; afit_H2Os(afit_H2Os<0) = 0; afit_H2Os(isinf(afit_H2Os)) = 0;
                %bfit_H2Os = bfit_H2O(:,kz); bfit_H2Os(isNaN(bfit_H2Os)) = 0; bfit_H2Os(bfit_H2Os<0) = 0; bfit_H2Os(isinf(bfit_H2Os)) = 0;
                if model_atmosphere==1
                    afit_H2Os = afit_H2O'; afit_H2Os(isNaN(afit_H2Os)) = 0; afit_H2Os(afit_H2Os<0) = 0; afit_H2Os(isinf(afit_H2Os)) = 0;
                    bfit_H2Os = bfit_H2O'; bfit_H2Os(isNaN(bfit_H2Os)) = 0; bfit_H2Os(bfit_H2Os<0) = 0; bfit_H2Os(isinf(bfit_H2Os)) = 0;
                else
                    afit_H2Os = afit_H2O(:,kz); afit_H2Os(isNaN(afit_H2Os)) = 0; afit_H2Os(afit_H2Os<0) = 0; afit_H2Os(isinf(afit_H2Os)) = 0;
                    bfit_H2Os = bfit_H2O(:,kz); bfit_H2Os(isNaN(bfit_H2Os)) = 0; bfit_H2Os(bfit_H2Os<0) = 0; bfit_H2Os(isinf(bfit_H2Os)) = 0;
                end
                afit_H2Os(1:nm_0675) = 0;  bfit_H2Os(1:nm_0675) = 0;Tslant;
                afit_H2Os = afit_H2Os'; bfit_H2Os = bfit_H2Os';
                wvamount = -log(exp(-afit_H2Os.*(real(swv_opt(i,1))).^bfit_H2Os));
                %cwv.tau_OD_wvsubtract(i,:) = tau_ODslant(i,:)-wvamount';% this is slant becuse it is used by gases routine;need to divide by airmass in comparison
                wvamount(isNaN(wvamount)) = 0; wvamount(isinf(wvamount)) = 0; % added by SL, 2017-04-07, to ensure that tau_OD_wvsubtract is always real
                cwv.tau_OD_wvsubtract(i,:) = s.tau_tot_slant(i,:)-wvamount;% this is a structure with o2-o2 NIR subtracted
                wvOD(i,:) = real(wvamount);
            end
            
            % QA plot of tau_OD_wvsubtract vs.tau_ODslant
            %     wi = [1084,1109,1213,1439,1503];
            %     le = {'1020 nm';'1064 nm';'1236 nm';'1559 nm';'1640 nm'};
            %     figure;
            %     for ll=1:length(wi)
            %         subplot(length(wi),1,ll);
            %         plot(starsun.UTHh,tau_ODslant(:,wi(ll))-...
            %              cwv.tau_OD_wvsubtract(:,wi(ll)),'ok');hold on;
            %          if ll==3
            %          xlabel('time [UTC]');
            %          ylabel('\Delta (tau-aero slant - tau-aero-wvsubtract)');
            %          end
            %         legend(le{ll,:});
            %         axis([min(starsun.UTHh) max(starsun.UTHh) -0.0005 0.0005]);
            %         plot(starsun.UTHh,zeros(length(starsun.UTHh),1),'-m');hold off;
            %     end
            if s.toggle.verbose; upd(i); end;
        end % end of loop over all data points for wv retrieval
        cwv_opt = (swv_opt(:,1)/H2O_conv)./s.m_H2O;% retrieval is made on slant./starsun.m_H2O;  %conversion from slant path to vertical
        if wrange==4
            cwv.(lab3) = swv_opt(:,2)./s.m_ray; % this is [atm x cm]     !! check if needs to be divided with airmass
        elseif wrange==5
            cwv.(lab3) = swv_opt(:,2)./s.m_ray; % this is [atm x cm]     !! check if needs to be divided with airmass
            cwv.(lab4) = swv_opt(:,3)./s.m_ray; % this is [atm x cm]     !! check if needs to be divided with airmass
        end
        
        % save in each wavelength range retrieval
        cwv.(lab2)     = cwv_opt;
        cwv.(labstd2)  = sqrt(wv_residual/length(wln));
        cwv.wvOD = wvOD;
    end% end of optfit procedure
end % end for loop over all wavelength range cases
%
%---------------------------------------------------------------------
return;
