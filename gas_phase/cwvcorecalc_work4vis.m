function [tau_aero_woH2O tau_aero_woH2Ofit cwvopt940 cwvopt940_800 QA avg_U1] = cwvcorecalc(starsun,modc0,vislampc0,nirlampc0,model_atmosphere,cross_sections)
% this function recieves averaged spectra (starsun)
% and calculates cwv amounts 
% this is linear procedure based on convolved gas cross sections
% here water vapor are deduced using modified Langley and 940 nm
% band water vapor values before visible region gas retrieval
% averaging of spectra every 3 seconds 
% in retrieved values (when using baseline of 0.88-1.00 micron)
% tau_h2oa - water vapor optical depth derived from Tw transmittance
% tau_h2ob - water vapor optical depth derived from CWV
% avg_U1   - retrieved CWV
% h2o4sub  - derived quantity to be used in AOD CWV subtraction
% tau_aero_woH2O:    water subtracted aerosol optical depth (measured OD)
% tau_aero_woH2Ofit: water subtracted aerosol optical depth (fitted OD)
% cwvopt940: best fit CWV from optimization procedure (940 nm band)
% cwvopt940_800: avg best fit CWV from optimization procedure (940+800 nm band)
% QA: quality assurance number: 
% 0-best fit; both 800 and 940 nm have small difference (<0.05)&small resi
% 1-good; 800 and 940 have std>0.05 but with small residual values
% 2- one of the bands has high residual
% 3- both bands have high residual (probably clouds/noisy measurement)
%----------------------------------------------------------------------
% MS: Mar 11 2013, added altitude dependent calculation of CWV
% MS: May 8 2013, modified to be an inner function
% MS: Aug 17 2013 - assigned NaN's to idxuse==0 to be same length as
% starsun, and to be used within gasretrieveo3no2cwv
% MS: Nov, 19, 2013 - added h2o4sub by using fmincon-still in progress
% MS: Jan 17 2014; modified to run separately from o3/no2 cwvcorecalc
% instead of h2ocorecalc used formerly with idxuse
%----------------------------------------------------------------------
 showfigure = 0;
 Loschmidt=2.686763e19;                   % molec/cm3*atm
%----------------------------------------------------------------------
%% lamp calibratio
% lamp calibration spectra
wvis = starsun.w(1:1044);
wnir = starsun.w(1045:end);
%
% find wavelength range for vis/nir water vapor bands
 nm_0685 = interp1(wvis,[1:length(wvis)],0.690,  'nearest');
 nm_0750 = interp1(wvis,[1:length(wvis)],0.7490,  'nearest');
 nm_0780 = interp1(wvis,[1:length(wvis)],0.781,  'nearest');
 nm_0870 = interp1(wvis,[1:length(wvis)],0.869,  'nearest');
 nm_0880 = interp1(wvis,[1:length(wvis)],0.8823, 'nearest');
 nm_0990 = interp1(wvis,[1:length(wvis)],0.9940, 'nearest');
 nm_1060 = interp1(wnir,[1:length(wnir)],1.060,  'nearest');
 nm_1240 = interp1(wnir,[1:length(wnir)],1.240,  'nearest');
 nm_1300 = interp1(wnir,[1:length(wnir)],1.300,  'nearest');
 nm_1540 = interp1(wnir,[1:length(wnir)],1.540,  'nearest');
 
 wln_vis1 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880)); 
 wln_vis2 = find(wvis<=wvis(nm_0870)&wvis>=wvis(nm_0780)); 
 wln_vis3 = find(wvis<=wvis(nm_0750)&wvis>=wvis(nm_0685)); 
 wln_nir1 = find(wnir<=wnir(nm_1240)&wnir>=wnir(nm_1060)); 
 wln_nir2 = find(wnir<=wnir(nm_1540)&wnir>=wnir(nm_1300)); 
 
 % initialize subtracted OD spectra
 wvOD    = zeros(length(starsun.t),length(starsun.w));
 wvODfit = zeros(length(starsun.t),length(starsun.w));
% add for loop over 3 wavelength range
for wrange=[1,4,5];
    switch wrange
    case 1 
    % 940 nm analysis
        lab  = 'cwv940';
        lab2 = 'U940';
        labresi = 'resi940';
        wln  = wln_vis1;
%       wln_ind2 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880));
%       cwv_ind1 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880));
%       Tw_wln   = find(wvis(wln_ind2)<=0.9945&wvis(wln_ind2)>=0.8823);
        ind = [77:103];% 0.94-0.96
        
    case 2 
    %800 nm analysis
       
        lab  ='cwv800';
        lab2 ='U800';
        labresi = 'resi800';
        wln  = wln_vis2;
        ind = [26:103];%0.80-0.845 nm
        
    case 3 
    %700 nm analysis
        lab  = 'cwv700';
        lab2 = 'U700';
        labresi = 'resi700';
        wln  = wln_vis3;
        ind=[32:58];%0.715-0.735 nm
%     case 4 
%     %1100 nm analysis
%         lab  = 'cwv1100';
%         lab2 = 'U1100';
%         labresi = 'resi1100';
%         wln  = wln_nir1;
%         ind=[32:58];%0.715-0.735 nm
%     case 5 
%     %1400 nm analysis
%         lab  = 'cwv1400';
%         lab2 = 'U1400';
%         labresi = 'resi1400';
%         wln  = wln_nir2;
%         ind=[32:58];%0.715-0.735 nm
end % switch

%
qqvis = length(wvis);
qqnir = length(wnir);
pp    = length(starsun.t);
%
caliblampvis = repmat(vislampc0(:,2)',length(starsun.tavg),1);
caliblampnir = repmat(nirlampc0(:,2)',length(starsun.tavg),1);
sundistvis   = repmat(starsun.f(1),length(starsun.UTavg),length(wvis));
sundistnir   = repmat(starsun.f(1),length(starsun.UTavg),length(wnir));
spc_vis_lamp = starsun.spc_avg(:,1:1044)./caliblampvis./sundistvis;
spc_nir_lamp = starsun.spc_avg(:,1045:end)./caliblampnir./sundistnir;
vislampTw=spc_vis_lamp.*exp((starsun.tau_ray_avg(:,1:1044)).*repmat(starsun.m_ray_avg,1,length(wvis)));
tau_visOD = -log(vislampTw)./repmat(starsun.m_aero,1,qqvis);
nirlampTw=spc_nir_lamp.*exp((starsun.tau_ray_avg(:,1045:end)).*repmat(starsun.m_ray_avg,1,length(wnir)));
tau_nirOD = -log(nirlampTw);


vis.ratelamp=starsun.rate(:,1:1044)./repmat(starsun.f,1,qqvis)./tr(starsun.m_ray, starsun.tau_ray(:,1:1044));
vis.ODlamp  =-log(vis.ratelamp./repmat(vislampc0(:,2)',pp,1))./repmat(starsun.m_aero,1,qqvis);


% plot spectra
figure;plot(wvis,vis.ODlamp(end-500,:),'-b');
hold on;plot(wvis,starsun.tau_a_avg(end-500,1:1044),'--r');
%hold on;plot(wvis,-log(spc_vis_lamp(2252,:)),'--c');
legend('lampOD','tau-aero');xlabel('wavelength');ylabel('vertical OD');
%
%%
%% baseline subtraction
 
% calculate linear baseline for only the water vapor band region
% calculate polynomial baseline
order2=1;  % order of baseline polynomial fit
poly3=zeros(length(wvis(wln)),length(starsun.UTavg));  % calculated polynomial
poly3_c=zeros(length(starsun.UTavg),(order2)+1);            % polynomial coefficients
order_in2=1;
thresh_in2=0.01;
lampcalib =1;
% deduce baseline
for i=1:length(starsun.UTavg)
% function (fn) can be: 'sh','ah','stq','atq'
% for gui use (visualization) write:
% [poly2_,poly2_c_,iter,order,thresh,fn]=backcor(wvis(wln_ind),starsun.tau_aero(goodTime(i),wln_ind));
    if lampcalib==1
        % perform baseline on vertical total OD (rayleigh excluded)
        [poly3_,poly3_c_,iter,order_lin,thresh,fn] = backcor(wvis(wln),tau_visOD(i,wln),order_in2,thresh_in2,'atq');% backcor(wavelength,signal,order,threshold,function);
        poly3(:,i)=poly3_;        % calculated polynomials
        poly3_c(i,:)=poly3_c_';   % polynomial coefficients

        % plot AOD baseline interpolation and real AOD values
%                 figure(1111)
%                 plot(wvis(wln_ind2),tau_visOD(i,wln_ind2),'.b','markersize',8);hold on;
%                 plot(wvis(wln_ind2),poly3_,'-r','linewidth',2);hold off;
%                 legend('AOD','AOD baseline');title(num2str(starsun.UTavg(i)));
%                 pause(0.01);  
    else
        [poly3_,poly3_c_,iter,order_lin,thresh,fn] = backcor(wvis(wln),starsun.tau_a_avg(i,wln),order_in2,thresh_in2,'atq');% backcor(wavelength,signal,order,threshold,function);
        poly3(:,i)=poly3_;        % calculated polynomials
        poly3_c(i,:)=poly3_c_';   % polynomial coefficients

        % plot AOD baseline interpolation and real AOD values
%                 figure(1111)
%                 plot(wvis(wln_ind2),starsun.tau_a_avg(i,wln_ind2),'.b','markersize',8);hold on;
%                 plot(wvis(wln_ind2),poly3_,'-r','linewidth',2);hold off;
%                 legend('AOD','AOD baseline');title(num2str(starsun.UTavg(i)));
%                 pause(0.01);   
    end

end
 
 % assign spectrum, baseline and subtracted spectrum
 tau_aero=real(poly3);
 
 if lampcalib==1
     baseline = (tau_aero)';%this is vertical
     spectrum = tau_visOD(:,wln);
     spectrum_sub = (spectrum-baseline);%./repmat(starsun.m_aero,1,qqvis);
 else
     baseline = (tau_aero)';
     spectrum = starsun.tau_a_avg(:,wln);
     spectrum_sub = spectrum-baseline;
 end
 %spectrum_aod = spectrum-spectrum_sub;
%% end of baseline subtraction 
%  figure;
%  ax(1)=subplot(311); plot(wvis(wln_ind2),spectrum);hold on;
%                      plot(wvis(wln_ind2),baseline,'-b');hold off;
%                      set(gca,'YScale','log');
%                      ylabel('optical depth');title(datestr(starsun.t(1),'yyyy-mm-dd'));
%  ax(2)=subplot(312); plot(wvis(wln_ind2),spectrum_sub);
%                      legend('baseline corrected spectra');
% %  ax(3)=subplot(313); plot(wvis(wln_ind2),spectrum_aod);
% %                      set(gca,'YScale','log');
%  xlabel('wavelength [\mum]');ylabel('optical depth');legend('aod spectra');
%  linkaxes(ax,'x');
 
 % 
 sundist2  = repmat(starsun.f(1),length(starsun.UTavg),length(wvis(wln)));
 calibuse2 = repmat(modc0(wln)',length(starsun.tavg),1);
 
 %
 % calculate new spectra (general transmittance using mod_vo)
 % modified Langley
 spc_avg_new = starsun.spc_avg(:,wln)./calibuse2./sundist2;
 
 %
 % calculate transmittance minus aerosol and Rayligh
 % define water vapor regions
 %cwv_ind1=find(wvis<=0.98&wvis>=0.92);
 %cwv_ind1=find(wvis<=0.9945&wvis>=0.8823);
 %cwv_ind1=find(wvis<=0.750&wvis>=0.690);
 %cwv_ind1=find(wvis<=0.870&wvis>=0.780);
 % calculate for all but use only index regions for retrieval
 % slant transmittance
 if lampcalib==1
     Tw=spc_vis_lamp(:,wln).*exp(tau_aero'.*(repmat(starsun.m_aero_avg,1,length(wvis(wln))))+...
    (starsun.tau_ray_avg(:,wln)).*repmat(starsun.m_ray_avg,1,length(wvis(wln))));    % disregarding O3 in those wavelengths (above 800 nm)
 else
     Tw=spc_avg_new.*exp(tau_aero'.*(repmat(starsun.m_aero_avg,1,length(wvis(wln))))+...
    (starsun.tau_ray_avg(:,wln)).*repmat(starsun.m_ray_avg,1,length(wvis(wln))));    % disregarding O3 in those wavelengths (above 800 nm)
 end
 
 % Tw wavelength index
 %Tw_wln = find(wvis(wln_ind2)<=0.98&wvis(wln_ind2)>=0.92);
 %Tw_wln = find(wvis(wln_ind2)<=0.9945&wvis(wln_ind2)>=0.8823);
 %Tw_wln = find(wvis(wln_ind2)<=0.750&wvis(wln_ind2)>=0.690);
 %Tw_wln = find(wvis(wln_ind2)<=0.870&wvis(wln_ind2)>=0.780);
 %
 % calculate slant path wv OD
%  slantpTw = -log(Tw(:,Tw_wln));
%  tau_h2o_  = real(nanmean(slantpTw(:,26:52),2));%average over 940-960 nm, this is slant tau
 %tau_h2oSD= real(nanstd(slantpTw(:,26:52),[],2));%average over 940-960 nm, this is slant tau
 
 % 
 %
 % upload a and b parameters (from LBLRTM - new spec FWHM)
 if model_atmosphere==1||model_atmosphere==2 %!!! check if xs should be related to calibration or measurement location 
     xs_ = 'H2O_cross_section_FWHM_new_spec_all_range_Tropical3400m.mat';
     xs  = load(fullfile(starpaths, xs_));
 else
     xs_ = 'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter6850m.mat';
     xs  = load(fullfile(starpaths, xs_));
 end
 %
 % interpolate H2O parameters to whole wln grid
 % this is not used here; altitude interpolated is used
 H2Oa = interp1(xs.wavelen(1:1044),xs.cs_sort(1:1044,1),(wvis)*1000,'nearest','extrap');
 H2Ob = interp1(xs.wavelen(1:1044),xs.cs_sort(1:1044,2),(wvis)*1000,'nearest','extrap');
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
 
 if model_atmosphere==1
      H2O_conv=1244.12; %converts cm-atm in pr cm or g/cm2.  the conversion factor has units of [cm^3/g]. 
      
      U1=(1./repmat(starsun.m_H2O_avg,1,length(wln))).*(((1./(-repmat(H2Oa((wln))',1,length(starsun.UTavg)))))'.*...
         (log(Tw(:,wln)))).^((1./(repmat(H2Ob((wln))',1,length(starsun.UTavg))))'); 
      Ufinal  = U1/H2O_conv;
      avg_U1 = mean(Ufinal(:,ind),2);%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
 elseif model_atmosphere==3 % TCAP winter
     % load altitude dependent coef.
     alt0    = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter0m.mat'));
     alt1000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter1000m.mat'));
     alt2000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter2000m.mat'));
     alt3000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter3000m.mat'));
     alt4000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter4000m.mat'));
     alt5000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter5000m.mat'));
     alt6000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwin6000m.mat'));
     alt7000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter7000m.mat'));
     
      zkm_LBLRTM_calcs=[0:7];
      afit_H2O=[alt0.cs_sort(1:1044,1) alt1000.cs_sort(1:1044,1) alt2000.cs_sort(1:1044,1) alt3000.cs_sort(1:1044,1) alt4000.cs_sort(1:1044,1) alt5000.cs_sort(1:1044,1) alt6000.cs_sort(1:1044,1) alt7000.cs_sort(1:1044,1)];
      bfit_H2O=[alt0.cs_sort(1:1044,2) alt1000.cs_sort(1:1044,2) alt2000.cs_sort(1:1044,2) alt3000.cs_sort(1:1044,2) alt4000.cs_sort(1:1044,2) alt5000.cs_sort(1:1044,2) alt6000.cs_sort(1:1044,2) alt7000.cs_sort(1:1044,2)];
      cfit_H2O=ones(length(xs.wavelen(1:1044)),length(zkm_LBLRTM_calcs));

      for j=1:length(starsun.UTavg)
          kk=find(starsun.Altavg(j)/1000>=zkm_LBLRTM_calcs);
          if starsun.Altavg(j)/1000<0 kk=1; end  %handles alts slightly less than zero
          kz=kk(end);
          CWV1=(-log(Tw(j,:)./(cfit_H2O(wln,kz))')./(afit_H2O(wln,kz))').^(1./(bfit_H2O(wln,kz))')./starsun.m_H2O_avg(j);
          CWV2=(-log(Tw(j,:)./(cfit_H2O(wln,kz+1))')./(afit_H2O(wln,kz+1))').^(1./(bfit_H2O(wln,kz+1))')./starsun.m_H2O_avg(j);
          CWVint_atmcm = CWV1 + (starsun.Altavg(j)/1000-zkm_LBLRTM_calcs(kz))*(CWV2-CWV1)/(zkm_LBLRTM_calcs(kz+1)-zkm_LBLRTM_calcs(kz));
          Ucalc(j,:)=CWVint_atmcm;      
      end
      %Uold=U;
      U=Ucalc;

      H2O_conv=1244.12; %converts cm-atm in pr cm or g/cm2.  the conversion factor has units of [cm^3/g]. 
      Ufinal  = U/H2O_conv;
    %   U1=(1./repmat(starsun.m_H2O_avg((goodTime))',1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.UTavg((goodTime)))))))'.*...
    %       (log(Tw(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.UTavg((goodTime))))))');
    %  U1_lamp=(1./repmat(starsun.m_H2O_avg((goodTime))',1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.UTavg((goodTime)))))))'.*...
    %      (log(Tw_lamp(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.UTavg((goodTime))))))');
     % average U1 over wavelength
     avg_U1 = mean(Ufinal(:,ind),2);%(1:78=920-980)%26-52=940-960 26-40=940-950 nm; last:26:52
    %  avg_U1 = avg_U1_;
    %  avg_U1((isnan(avg_U1_)==1))=0;
    %  avg_U1 = real(avg_U1);
    %   U1_conv    =U1/H2O_conv;
    %   U1_convavg =mean(U1_conv(:,26:52),2) 
    %  U1_lamp_conv=U1_lamp/H2O_conv;
    
 elseif model_atmosphere==2 % SEAC4RS
     % load altitude dependent coef.
     alt0    = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum0m.mat'));
     alt1000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum1000m.mat'));
     alt2000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum2000m.mat'));
     alt3000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum3000m.mat'));
     alt4000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum4000m.mat'));
     alt5000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum5000m.mat'));
     alt6000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum6000m.mat'));
     alt7000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer7000m.mat'));
     alt8000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer8000m.mat'));
     alt9000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer9000m.mat'));
     alt10000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer10000m.mat'));
     alt11000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer11000m.mat'));
     alt12000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer12000m.mat'));
     alt13000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer13000m.mat'));
     alt14000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer14000m.mat'));



      zkm_LBLRTM_calcs=[0:14];
      afit_H2O=[alt0.cs_sort(1:1044,1) alt1000.cs_sort(1:1044,1) alt2000.cs_sort(1:1044,1) alt3000.cs_sort(1:1044,1) alt4000.cs_sort(1:1044,1) alt5000.cs_sort(1:1044,1) alt6000.cs_sort(1:1044,1) alt7000.cs_sort(1:1044,1) alt8000.cs_sort(1:1044,1) alt9000.cs_sort(1:1044,1)...
                alt10000.cs_sort(1:1044,1) alt11000.cs_sort(1:1044,1) alt12000.cs_sort(1:1044,1) alt13000.cs_sort(1:1044,1) alt14000.cs_sort(1:1044,1)];
      bfit_H2O=[alt0.cs_sort(1:1044,2) alt1000.cs_sort(1:1044,2) alt2000.cs_sort(1:1044,2) alt3000.cs_sort(1:1044,2) alt4000.cs_sort(1:1044,2) alt5000.cs_sort(1:1044,2) alt6000.cs_sort(1:1044,2) alt7000.cs_sort(1:1044,2) alt8000.cs_sort(1:1044,2) alt9000.cs_sort(1:1044,2)...
                alt10000.cs_sort(1:1044,2) alt11000.cs_sort(1:1044,2) alt12000.cs_sort(1:1044,2) alt13000.cs_sort(1:1044,2) alt14000.cs_sort(1:1044,2)];
      cfit_H2O=ones(length(xs.wavelen(1:1044)),length(zkm_LBLRTM_calcs));
      
      afit_allH2O=[alt0.cs_sort(1:1556,1) alt1000.cs_sort(1:1556,1) alt2000.cs_sort(1:1556,1) alt3000.cs_sort(1:1556,1) alt4000.cs_sort(1:1556,1) alt5000.cs_sort(1:1556,1) alt6000.cs_sort(1:1556,1) alt7000.cs_sort(1:1556,1) alt8000.cs_sort(1:1556,1) alt9000.cs_sort(1:1556,1)...
                alt10000.cs_sort(1:1556,1) alt11000.cs_sort(1:1556,1) alt12000.cs_sort(1:1556,1) alt13000.cs_sort(1:1556,1) alt14000.cs_sort(1:1556,1)];
      bfit_allH2O=[alt0.cs_sort(1:1556,2) alt1000.cs_sort(1:1556,2) alt2000.cs_sort(1:1556,2) alt3000.cs_sort(1:1556,2) alt4000.cs_sort(1:1556,2) alt5000.cs_sort(1:1556,2) alt6000.cs_sort(1:1556,2) alt7000.cs_sort(1:1556,2) alt8000.cs_sort(1:1556,2) alt9000.cs_sort(1:1556,2)...
                alt10000.cs_sort(1:1556,2) alt11000.cs_sort(1:1556,2) alt12000.cs_sort(1:1556,2) alt13000.cs_sort(1:1556,2) alt14000.cs_sort(1:1556,2)];
      
      
      Ucalc    = NaN(length(starsun.UTavg),length(wln));
      colTw    = NaN(length(starsun.UTavg),length(starsun.w));
      %tau_h2oa = NaN(length(starsun.UTavg),length(starsun.w));
      
      for j=1:length(starsun.UTavg)
          if ~isNaN(starsun.Altavg(j))
              kk=find(starsun.Altavg(j)/1000>=zkm_LBLRTM_calcs);
              if starsun.Altavg(j)/1000<=0 kk=1; end            %handles alts slightly less than zero
              kz=kk(end);
              CWV1=(-log(Tw(j,:)./(cfit_H2O(wln,kz))')./(afit_H2O(wln,kz))').^(1./(bfit_H2O(wln,kz))')./starsun.m_H2O_avg(j);
              CWV2=(-log(Tw(j,:)./(cfit_H2O(wln,kz+1))')./(afit_H2O(wln,kz+1))').^(1./(bfit_H2O(wln,kz+1))')./starsun.m_H2O_avg(j);
              CWVint_atmcm = CWV1 + (starsun.Altavg(j)/1000-zkm_LBLRTM_calcs(kz))*(CWV2-CWV1)/(zkm_LBLRTM_calcs(kz+1)-zkm_LBLRTM_calcs(kz));
              Ucalc(j,:)    =CWVint_atmcm; 
              colTw(j,:)    =exp(- afit_allH2O(:,kz).*(nanmean(CWVint_atmcm(26:52))).^bfit_allH2O(:,kz));
              %tau_h2oa(j,:) = real(-log(colTw(j,:)));
          else
              Ucalc(j,:)   =zeros(1,length(wln)); 
              colTw(j,:)   =zeros(1,length(starsun.w));
              %tau_h2oa(j,:)=zeros(1,length(starsun.w));
              
          end
      end
      %Uold=U;
      U=Ucalc;

      H2O_conv=1244.12; %converts cm-atm into pr cm or g/cm2.  the conversion factor has units of [atm*cm^3/g]. 
      Ufinal  = U/H2O_conv;
     %   U1=(1./repmat(starsun.m_H2O_avg((goodTime))',1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.UTavg((goodTime)))))))'.*...
     %       (log(Tw(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.UTavg((goodTime))))))');
    
     % average U1 over wavelength
     avg_U1 = abs(real(nanmean(Ufinal(:,ind),2)));%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
     std_U1 = abs(real((nanstd(Ufinal(:,ind),[],2)))); 
%      avg_U1(avg_U1==0)     = NaN;
%      std_U1(avg_U1==0)     = NaN;
     
    
    % filter noisy points (this was original version; before Jan 17 2014)
      
    % avg_U1(idxuse==0)     = NaN;
    % std_U1(idxuse==0)     = NaN;
    % now; apply starflag (badaod & unspecified clouds)
    avg_U1(starsun.flags.bad_aod==1&starsun.flags.unspecified_clouds==1) = NaN;
    std_U1(starsun.flags.bad_aod==1&starsun.flags.unspecified_clouds==1) = NaN;
    
    starsun.Altavg(starsun.Altavg<0)=0;
 end
 
 %% plots
 %-------
 if showfigure==1
     % plot Tw
     figure (1); plot(wvis(wln),Tw);legend('Tw by modified Langley');

     % plot cwv with wavelength
     figure (2);plot(wvis(wln),Ufinal);      axis([0.92 0.98 0 (max(avg_U1))]);legend('cwv by Modified Langley');
     
     % plot avg_cwv
     figure (3);plot(starsun.UTavg,avg_U1,'ob','markerfacecolor','b','markersize',10);xlabel('UT','fontsize',12,'fontweight','bold');ylabel('CWV [g/cm2]','fontsize',12,'fontweight','bold');
     set(gca,'fontsize',12,'fontweight','bold');axis([min(starsun.UTavg) max(starsun.UTavg) 0 max(avg_U1)]);

     % with Lat/Lon
     figure(4);scatter3(starsun.Latavg(avg_U1<=3&avg_U1>=0),starsun.Lonavg(avg_U1<=3&avg_U1>=0),avg_U1(avg_U1<=3&avg_U1>=0),10,avg_U1(avg_U1<=3&avg_U1>=0),'filled');xlabel('Latitude','fontsize',12,'fontweight','bold');ylabel('Longitude','fontsize',12,'fontweight','bold');
     set(gca,'fontsize',12,'fontweight','bold');axis([min(starsun.Latavg) max(starsun.Latavg) min(starsun.Lonavg) max(starsun.Lonavg) 0 3]);
     cb=colorbar; set(cb,'fontsize',12,'fontweight','bold');title('CWV [g/cm^{2}]','fontsize',12','fontweight','bold');
     % with Lat/Alt-bound by low CWV values
     figure(5);scatter3(starsun.Latavg(avg_U1<=0.5&avg_U1>=0),starsun.Altavg(avg_U1<=0.5&avg_U1>=0),avg_U1(avg_U1<=0.5&avg_U1>=0),10,avg_U1(avg_U1<=0.5&avg_U1>=0),'filled');
     xlabel('Latitude','fontsize',12,'fontweight','bold');ylabel('Altitude [m]','fontsize',12,'fontweight','bold');
     set(gca,'fontsize',12,'fontweight','bold');axis([min(starsun.Latavg) max(starsun.Latavg) min(starsun.Altavg) max(starsun.Altavg) 0 1]);
     cb=colorbar; set(cb,'fontsize',12,'fontweight','bold');title('CWV [g/cm^{2}]','fontsize',12','fontweight','bold');

     % plot average 0.92-0.96 (1:52)
     %  figure;errorbar(starsun.UTavg((goodTime)),mean(Ufinal(:,26:52),2),std(Ufinal(:,26:52),[],2),'d','color',[0 0.8 0.2],'MarkerSize',6);hold on;
     %         plot(starsun.UTavg((goodTime)),starsun.Altavg((goodTime))/1000,'-','color',[0.5 0.5 0.5],'LineWidth',2);
     figure(44);
     [AX,H1,H2] = plotyy(starsun.UTavg,avg_U1,starsun.UTavg,starsun.Altavg);
     set(get(AX(1),'Ylabel'),'String','Columnar Water vapor [g cm^{-2}]','FontSize',16,'color',[0 0.8 0.2]) 
     set(get(AX(2),'Ylabel'),'String','Altitude [meters]','FontSize',16,'color',[0.5 0.5 0.5]) 
     set(H1,'LineStyle','d','MarkerFaceColor',[0 0.8 0.2],'MarkerSize',6)
     set(H2,'LineStyle','-','color',[0.5 0.5 0.5],'LineWidth',3)
     set(AX,'FontSize',16); xlabel('Time [UT]','FontSize',16);

 
 end
 % fill-values for SEAC4RS
 %  avg_U1(avg_U1==0)     = -99999;
 %  avg_U1(isNaN(avg_U1)) = -99999;
 
 % calculate tau_h2o
 % tau_h2ob = real((avg_U1*H2O_conv)*(cross_sections.h2o*Loschmidt));

 
 % overall std
 relstd_cwv      = (std(Ufinal(:,ind),[],2)./mean(Ufinal(:,ind),2))*100;
 relstdmean = real(nanmean(relstd_cwv));
 relstdstd  = real(nanstd (relstd_cwv));
 
 % calculate water vapor OD for subtraction from AOD spectrum
 % this is under development MS Jan 2014
 %------------------------------------------------------------
 %% load water vapor cross-sections
 % HITRAN convolved with 4STAR (we might want to create LUT for various alt)
%     vis.nm = load('visLambda.txt');
%     nir.nm = load('nirLambda.txt');
%     watervis = importdata('C:\Users\msegalro\PostDoc\Ames\DOAS\H2OconTest\xs\H2O_1013mbar273K_vis.xs');
%     water.visnm     = watervis.data(:,1);
%     water.visXs     = watervis.data(:,2);
%     water.visInterp = interp1(water.visnm, water.visXs, vis.nm,'pchip','extrap');
%     waternir = importdata('C:\Users\msegalro\PostDoc\Ames\DOAS\H2OconTest\xs\H2O_1013mbar273K_nir.xs');
%     water.nirnm     = waternir.data(:,1);
%     water.nirXs     = waternir.data(:,2);
%     water.nirInterp = interp1(water.nirnm, water.nirXs, nir.nm,'pchip','extrap');
%     % plot cross sections
%     figure;plot(vis.nm,water.visInterp,'-b');hold on;plot(nir.nm,water.nirInterp,'-r');hold on;
%     hold on;
%     % plot conv water vapor and sample spectrum
%     waterOD = -log(Tw); % after Rayleigh and aerosol subtraction
%     x = repmat(starsun.m_H2O_avg,1,length(wln)).*(U);
%     acoef = repmat((afit_H2O(wln,1))',length(starsun.t),1);
%     bcoef = repmat((bfit_H2O(wln,1))',length(starsun.t),1);
%     %Twcalc  =  exp(-afit_H2O(:,1).*(x0).^bfit_H2O(:,1));
%     Twcalc  =  exp(-acoef.*(x).^bcoef);
%     waterODcalc = -log(Twcalc);
%     % waterODcalc = acoef.*(x).^bcoef;
%     % plot calcuated versus measured
%     figure;
%     plot(wvis(wln),waterOD    (end,:),'-b');hold on;   % measured
%     plot(wvis(wln),waterODcalc(end,:),'--r');hold on;   % calculated from coef
%     xlabel('wavelength');ylabel('water vapor OD');legend('measured','calculated from coef');
%     %
%     figure;plot(vis.nm,1e21*water.visInterp,'-b');hold on;plot(nir.nm,5e20*water.nirInterp,'-r');hold on;
%     plot(1000*wvis(wln),waterOD(end-10,:)/20,'--c');
%     plot(1000*starsun.w,starsun.tau_aero(end-10,:)/20,'--g');
%     legend('water vapor cross section vis','water vapor cross section nir','waterOD-modLAngley','waterOD-tauaero');
%     % plot sample ground spectrum
%     hold off;
%     axis([300 1700 0 0.15]);xlabel('wavelength [nm]');legend('water vapor conv vis (scaled)','water vapor conv nir (scaled)','4star ground spectrum');
%% fmincon conversion

% loop over all meas 
% modified Langley spectra
waterOD = -log(Tw); % after Rayleigh and aerosol subtraction
% calculate water vapor OD
visTw=spc_vis_lamp(:,wln).*exp(tau_aero'.*(repmat(starsun.m_aero_avg,1,length(wvis(wln))))+...
    (starsun.tau_ray_avg(:,wln)).*repmat(starsun.m_ray_avg,1,length(wvis(wln))));
viswvOD = -log(visTw);
% compare c0 with lamp Tw
figure;
plot(wvis(wln),waterOD(end,:),'-b');hold on;
plot(wvis(wln),viswvOD(end,:),'--r');
xlabel('wavelength');ylabel('water vapor OD');
legend('wv OD with modified c0','wv OD with lamp c0');

swv_opt=[];
wv_residual = [];

for i = 1:length(starsun.t)
    
       % choose right altitude coef
        if ~isNaN(starsun.Altavg(i))
              kk=find(starsun.Altavg(i)/1000>=zkm_LBLRTM_calcs);
              if starsun.Altavg(i)/1000<=0 kk=1; end            %handles alts slightly less than zero
              kz=kk(end);
              
        else 
             kz=1; 
        end
       
       %
       x0 = real(nanmean(U(i,:)));
       if lampcalib==1
            y = spectrum_sub(i,:);%viswvOD(i,:);%waterOD(i,:);viswvOD
       else
            y = spectrum_sub(i,:);%waterOD(i,:);
       end
       meas = [wvis(wln)' y'];
       ac = real(afit_H2O(wln,kz)); ac(isNaN(ac)) = 0; ac(ac<0) = 0; ac(isinf(ac)) = 0;
       bc = real(bfit_H2O(wln,kz)); bc(isNaN(bc)) = 0; bc(bc<0) = 0; bc(isinf(bc)) = 0;
       PAR = [ac bc];
       % Set Options
       options = optimset('TolFun',1e-12);%optimset('MaxIter', 400);
       
       % bounds
       lb = 0;
       ub = 10000;%max(max(real(U)));
       
       if x0>=ub
           x0 = ub;
       elseif x0<0
           x0 = lb;
       end
       
       %ynan = isNaN(y); realy = isreal(y);
       % check spectrum validity for conversion
       ypos = logical(y>=0);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15
            [U_,fval,exitflag,output]  = fmincon('H2Oresi',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            if isNaN(U_) || ~isreal(U_) || U_<0
                U_ = NaN;
                swv_opt = [swv_opt; U_];
                wv_residual = [wv_residual;NaN];
            else
                swv_opt = [swv_opt; real(U_)];
                wv_residual = [wv_residual;real(fval)];
                cwv_opt_ = (real(U_)/H2O_conv);%/starsun.m_H2O_avg(i); 
                cwv_opt_round = round(cwv_opt_*100)/100;
               %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
               % plot fitted figure
               yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_)).^bfit_H2O(wln,kz));
               yopt  = -log(yopt_);
               % assign fitted spectrum
               wvODfit(i,wln) = yopt;
               figure(444);
               plot(wvis(wln),y,'-b');hold on;
               plot(wvis(wln),yopt,'--r');hold off;
               xlabel('wavelength','fontsize',12);ylabel('total slant water vapor OD','fontsize',12);
               legend('measured','calculated (opt)');
               title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Altavg(i)) 'm' ' CWV= ' num2str(cwv_opt_round)]);
               ymax = yopt + 0.2;
               axis([min(wvis(wln)) max(wvis(wln)) 0 max(ymax)]);
               pause(0.0001);
            end
       else
            U_ = NaN;
            swv_opt = [swv_opt; U_];
            wv_residual = [wv_residual;NaN];
       end
       
end
   cwv_opt = (swv_opt/H2O_conv);%./starsun.m_H2O_avg;  
    
    % save in each wavelength range retrieval
    cwv.(lab)     = cwv_opt;
    cwv.(lab2)    = avg_U1;
    cwv.(labresi) = wv_residual;
    wvOD(:,wln)     = spectrum_sub;
end % end for loop over 3 wavelength range cases

[cwv.QA cwv.watervapor940 cwv.watervapor940_800] = watervaporQA(cwv);
QA     = cwv.QA;
cwvopt940     = cwv.watervapor940;
cwvopt940_800 = cwv.watervapor940_800;
% create water subtracted tau_aero
caliblamp = repmat([vislampc0(:,2)' nirlampc0(:,2)'],length(starsun.tavg),1);
sundist   = repmat(starsun.f(1),length(starsun.UTavg),length(starsun.w));
spc_lamp = starsun.spc_avg./caliblamp./sundist;

lampTw=spc_lamp.*exp((starsun.tau_ray_avg).*repmat(starsun.m_ray_avg,1,length(starsun.w)));
tau_OD = -log(lampTw)./repmat(starsun.m_aero,1,length(starsun.w));
% subtraction with measured OD
tau_aero_woH2O = tau_OD - wvOD;
% subtraction with fitted OD
tau_aero_woH2Ofit = tau_OD - wvODfit;
% plot two subtraction methods:
figure;
ax(1)=subplot(211);
plot(starsun.w,tau_OD(end,:),'-r');hold on;plot(starsun.w,tau_aero_woH2O(end,:),'--b');
ylabel('OD');legend('total OD (Rayleigh subtracted)','aerosol OD (Rayleigh and water OD subtracted)');
ax(2)=subplot(212);
plot(starsun.w,tau_OD(end,:),'-r');hold on;plot(starsun.w,tau_aero_woH2Ofit(end,:),'--b');
xlabel('wavelength');
ylabel('OD');legend('total OD (Rayleigh subtracted)','aerosol OD (Rayleigh and water OD fit subtracted)');
linkaxes(ax,'x');
%% end fmincon
%--------------------------------------------------------------------------
%--------------------------
 % save cwv into file
 % save .mat file
 % load c0mod_unc
 % uncertainty due to T coef with Alt = 2.5%
 % c0mod_unc = load(fullfile(starpaths, 'C:\MatlabCodes\data\c0mod_20120722_unc.mat')); 
 %
 cwv.UT      = starsun.UTavg;                               
 cwv.t       = starsun.tavg;                                    
 cwv.Alt     = starsun.Altavg;   
 cwv.Pst     = starsun.Presavg;   
 cwv.Lat     = starsun.Latavg;                                  
 cwv.Lon     = starsun.Lonavg;                                  
 cwv.cwv     = avg_U1;                                         cwv.cwv(isNaN(cwv.cwv))=-99999;cwv.cwv(cwv.cwv<=0)=-99999;% this is for archiving; not sure if here or at ict routine
 cwv.std     = std_U1;                                         cwv.std(isNaN(cwv.std))=-99999;cwv.std(cwv.std<=0)=-99999;
 % cwv.unc_    = mean(c0mod_unc.c0mod_unc(cwv_ind1(26:52)));
 cwv.unc     = sqrt((((0.025)*cwv.cwv).^2+cwv.std.^2)/2);      cwv.unc(isNaN(cwv.unc))=-99999;cwv.unc(cwv.unc<=0)=-99999;
 cwv.note    = 'cwv retrieved by both Modified Langley, and lamp-Langley combined calibration using coef and opt methods, 3s avg. spectra CWV altitude dependent';
 cwv.date    = datestr(starsun.t(1),'yyyymmdd');
 cwv_matfile = strcat(fullfile([starpaths, cwv.date,'_4starCWV','.mat']));
 v = 0;
 while exist(fullfile([starpaths, cwv.date,'_4starCWV','.v',num2str(v),'.mat']),'file')
     v = v + 1;
 end
 save(cwv_matfile,'-struct','cwv');
 copyfile(cwv_matfile, fullfile([starpaths, cwv.date,'_4starCWV','.v',num2str(v),'.mat']));
 
 % save .txt file
%  cwv = mean(Ufinal(:,26:52),2);               % avg 940-960 nm
%  %cwv_lamp = mean(U1_lamp_conv(:,26:52),2);   % avg 940-960 nm
%  data_date = datestr(starsun.t(1),'yyyy-mm-dd');
%  cwv_file=strcat(data_date,'_4starCWVavgcor','.dat');
%  %write vis data
%  fid = fopen(cwv_file, 'wt');
%  fprintf(fid,'%s ','4STAR Columnar water vapor [g/cm^2]');
%  fprintf(fid,'\n');
%  fprintf(fid,'%s ','Flight Date:  ', data_date);
%  fprintf(fid,'\n');
%  fprintf(fid,'%s %6.4f ','total Relative std (modified Langly method) [%] = ',relstdmean);
%  fprintf(fid,'\n');
%  fprintf(fid,'%s %6.4f ','total Relative std (lamp adjusted Langly method) [%] = ',relstdmean_lamp);
%  fprintf(fid,'\n');
%  fprintf(fid,'%s %s %s %s %s ','Time [UT] ','CWV1 [g/cm^2] ', 'std error1 [%] ','CWV2 [g/cm^2] ', 'std error2 [%] ');
%  fprintf(fid,'\n');
%  for i=1:length((goodTime))
%  fprintf(fid,'%6.4f %6.4f %6.4f %6.4f %6.4f ',starsun.UTavg((goodTime(i))),cwv(i),relstd_cwv(i),cwv_lamp(i),relstd_cwv_lamp(i));
%  fprintf(fid,'\n');
%  end
%  fclose(fid)
 %---------------------------------------------------------------------
 return;
