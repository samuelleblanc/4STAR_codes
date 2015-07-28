function [tau_h2oa tau_h2ob avg_U1] = h2ocorecalc(starsun,modc0,model_atmosphere,idxuse,cross_sections)
% this function recieves averaged spectra (starsun)
% and calculates cwv amounts 
% this is linear procedure based on convolved gas cross sections
% here water vapor are deduced using modified Langley and 940 nm
% band water vapor values before visible region gas retrieval
% averaging of spectra every 3 seconds 
% in retrieved values (when using baseline of 0.88-1.00 micron)
%
%----------------------------------------------------------------
% On Mar 11 2013, Michal Segal
% added altitude dependent calculation of CWV
% 
% modified to be an inner function, Michal May 8 2013
% modified by Michal Aug 17 2013 - assigned NaN's to idxuse==0
% modified to be used within gasretrieveo3no2cwv
%----------------------------------------------------------------
 showfigure = 0;
 Loschmidt=2.686763e19;                   % molec/cm3*atm
 %% choose relevant analysis times
 
% calculate linear baseline for only the water vapor band region
% calculate polynomial baseline
wvis = starsun.w(1:1044);
wln_ind2 = find(wvis<=0.9945&wvis>=0.8823);                 % 0.90-0.99 or 0.88-1.00
order2=1;  % order of baseline polynomial fit
poly3=zeros(length(wvis(wln_ind2)),length(starsun.UTavg));  % calculated polynomial
poly3_c=zeros(length(starsun.UTavg),(order2)+1);            % polynomial coefficients
order_in2=1;
thresh_in2=0.01;
% deduce baseline
for i=1:length(starsun.UTavg)
% function (fn) can be: 'sh','ah','stq','atq'
% for gui use (visualization) write:
% [poly2_,poly2_c_,iter,order,thresh,fn]=backcor(wvis(wln_ind),starsun.tau_aero(goodTime(i),wln_ind));
[poly3_,poly3_c_,iter,order_lin,thresh,fn] = backcor(wvis(wln_ind2),starsun.tau_a_avg(i,wln_ind2),order_in2,thresh_in2,'atq');% backcor(wavelength,signal,order,threshold,function);
poly3(:,i)=poly3_;        % calculated polynomials
poly3_c(i,:)=poly3_c_';   % polynomial coefficients

% plot AOD baseline interpolation and real AOD values
%     figure(1111)
%     plot(wvis(wln_ind2),starsun.tau_a_avg(i,wln_ind2),'.b','markersize',8);hold on;
%     plot(wvis(wln_ind2),poly3_,'-r','linewidth',2);hold off;
%     legend('AOD','AOD baseline');title(num2str(starsun.UTavg(i)));
%     pause(0.01);
end
 
 % assign spectrum, baseline and subtracted spectrum
 tau_aero=real(poly3);
 
 baseline = (tau_aero)';
 spectrum = starsun.tau_a_avg(:,wln_ind2);
 spectrum_sub = spectrum-baseline;
 spectrum_aod = spectrum-spectrum_sub;
 
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
 sundist2  = repmat(starsun.f(1),length(starsun.UTavg),length(wvis(wln_ind2)));
 calibuse2 = repmat(modc0(wln_ind2)',length(starsun.tavg),1);
 
 %
 % calculate new spectra (general transmittance using mod_vo)
 % modified Langley
 spc_avg_new = starsun.spc_avg(:,wln_ind2)./calibuse2./sundist2;
 
 %
 % calculate transmittance minus aerosol and Rayligh
 % define water vapor regions
 cwv_ind1=find(wvis<=0.98&wvis>=0.92);
 % calculate for all but use only index regions for retrieval
 Tw=spc_avg_new.*exp(tau_aero'.*(repmat(starsun.m_aero_avg,1,length(wvis(wln_ind2))))+...
    (starsun.tau_ray_avg(:,wln_ind2)).*repmat(starsun.m_ray_avg,1,length(wvis(wln_ind2))));    % disregarding O3 in those wavelengths (above 800 nm)
 
 % Tw wavelength index
 Tw_wln = find(wvis(wln_ind2)<=0.98&wvis(wln_ind2)>=0.92);
 %
 % calculate slant path wv OD
 slantpTw = -log(Tw(:,Tw_wln));
 tau_h2o_  = real(nanmean(slantpTw(:,26:52),2));%average over 940-960 nm, this is slant tau
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
      
      U1=(1./repmat(starsun.m_H2O_avg,1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.UTavg)))))'.*...
         (log(Tw(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.UTavg))))'); 
      Ufinal  = U1/H2O_conv;
      avg_U1 = mean(Ufinal(:,26:52),2);%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
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
          CWV1=(-log(Tw(j,Tw_wln)./(cfit_H2O(cwv_ind1,kz))')./(afit_H2O(cwv_ind1,kz))').^(1./(bfit_H2O(cwv_ind1,kz))')./starsun.m_H2O_avg(j);
          CWV2=(-log(Tw(j,Tw_wln)./(cfit_H2O(cwv_ind1,kz+1))')./(afit_H2O(cwv_ind1,kz+1))').^(1./(bfit_H2O(cwv_ind1,kz+1))')./starsun.m_H2O_avg(j);
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
     avg_U1 = mean(Ufinal(:,26:52),2);%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
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
      
      
      Ucalc    = NaN(length(starsun.UTavg),length(cwv_ind1));
      colTw    = NaN(length(starsun.UTavg),length(starsun.w));
      tau_h2oa = NaN(length(starsun.UTavg),length(starsun.w));
      
      for j=1:length(starsun.UTavg)
          if ~isNaN(starsun.Altavg(j))
              kk=find(starsun.Altavg(j)/1000>=zkm_LBLRTM_calcs);
              if starsun.Altavg(j)/1000<=0 kk=1; end            %handles alts slightly less than zero
              kz=kk(end);
              CWV1=(-log(Tw(j,Tw_wln)./(cfit_H2O(cwv_ind1,kz))')./(afit_H2O(cwv_ind1,kz))').^(1./(bfit_H2O(cwv_ind1,kz))')./starsun.m_H2O_avg(j);
              CWV2=(-log(Tw(j,Tw_wln)./(cfit_H2O(cwv_ind1,kz+1))')./(afit_H2O(cwv_ind1,kz+1))').^(1./(bfit_H2O(cwv_ind1,kz+1))')./starsun.m_H2O_avg(j);
              CWVint_atmcm = CWV1 + (starsun.Altavg(j)/1000-zkm_LBLRTM_calcs(kz))*(CWV2-CWV1)/(zkm_LBLRTM_calcs(kz+1)-zkm_LBLRTM_calcs(kz));
              Ucalc(j,:)    =CWVint_atmcm; 
              colTw(j,:)    =exp(- afit_allH2O(:,kz).*(nanmean(CWVint_atmcm(26:52))).^bfit_allH2O(:,kz));
              tau_h2oa(j,:) = real(-log(colTw(j,:)));
          else
              Ucalc(j,:)   =zeros(1,length(cwv_ind1)); 
              colTw(j,:)   =zeros(1,length(starsun.w));
              tau_h2oa(j,:)=zeros(1,length(starsun.w));
              
          end
      end
      %Uold=U;
      U=Ucalc;

      H2O_conv=1244.12; %converts cm-atm into pr cm or g/cm2.  the conversion factor has units of [atm*cm^3/g]. 
      Ufinal  = U/H2O_conv;
     %   U1=(1./repmat(starsun.m_H2O_avg((goodTime))',1,length(cwv_ind1))).*(((1./(-repmat(H2Oa((cwv_ind1))',1,length(starsun.UTavg((goodTime)))))))'.*...
     %       (log(Tw(:,Tw_wln)))).^((1./(repmat(H2Ob((cwv_ind1))',1,length(starsun.UTavg((goodTime))))))');
    
     % average U1 over wavelength
     avg_U1 = abs(real(nanmean(Ufinal(:,26:52),2)));%(1:78=920-980)%26-52=940-960 26-40=940-950 nm
     std_U1 = abs(real((nanstd(Ufinal(:,26:52),[],2)))); 
%      avg_U1(avg_U1==0)     = NaN;
%      std_U1(avg_U1==0)     = NaN;
     
    
    % filter noisy points
      
    avg_U1(idxuse==0)     = NaN;
    std_U1(idxuse==0)     = NaN;
    
    starsun.Altavg(starsun.Altavg<0)=0;
 end
 
 %% plots
 %-------
 if showfigure==1
     % plot Tw
     figure (1); plot(wvis(wln_ind2),Tw);legend('Tw by modified Langley');

     % plot cwv with wavelength
     figure (2);plot(wvis(cwv_ind1),Ufinal);      axis([0.92 0.98 0 (max(avg_U1))]);legend('cwv by Modified Langley');
     
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
 tau_h2ob = real((avg_U1*H2O_conv)*(cross_sections.h2o*Loschmidt));

 
 % overall std
 relstd_cwv      = (std(Ufinal(:,26:52),[],2)./mean(Ufinal(:,26:52),2))*100;
 relstdmean = real(nanmean(relstd_cwv));
 relstdstd  = real(nanstd (relstd_cwv));
 
 % save cwv into file
 % save .mat file
 % load c0mod_unc
 % uncertainty due to T coef with Alt = 2.5%
 %c0mod_unc = load(fullfile(starpaths, 'C:\MatlabCodes\data\c0mod_20120722_unc.mat')); 
 %
 cwv.UT      = starsun.UTavg;                               
 cwv.t       = starsun.tavg;                                    
 cwv.Alt     = starsun.Altavg;   
 cwv.Pst     = starsun.Presavg;   
 cwv.Lat     = starsun.Latavg;                                  
 cwv.Lon     = starsun.Lonavg;                                  
 cwv.cwv     = avg_U1;                                         cwv.cwv(isNaN(cwv.cwv))=-99999;cwv.cwv(cwv.cwv<=0)=-99999;
 cwv.std     = std_U1;                                         cwv.std(isNaN(cwv.std))=-99999;cwv.std(cwv.std<=0)=-99999;
 % cwv.unc_    = mean(c0mod_unc.c0mod_unc(cwv_ind1(26:52)));
 cwv.unc     = sqrt((((0.025)*cwv.cwv).^2+cwv.std.^2)/2);      cwv.unc(isNaN(cwv.unc))=-99999;cwv.unc(cwv.unc<=0)=-99999;
 cwv.note    = 'cwv retrieved by Modified Langley, 3s avg. spectra CWV altitude dependent';
 cwv.date    = datestr(starsun.t(1),'yyyymmdd');
 cwv_matfile = strcat(cwv.date,'_4starCWVtest','.mat');
 save(cwv_matfile,'-struct','cwv');
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
