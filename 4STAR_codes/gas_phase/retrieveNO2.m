%% Details of the function:
% NAME:
%   retrieveNO2
% 
% PURPOSE:
%   retrieves NO2 using a given (start,end) wavelength range
%   using differential cross section and linear inversion
% 
%
% CALLING SEQUENCE:
%  function [no2] = retrieveNO2(s,wstart,wend,mode)
%
% INPUT:
%  - s: starsun struct from starwarapper
%  - wstart  : wavelength range start in micron
%  - wend    : wavelength range start in micron
%  - mode    : %0-MLO c0; 1-MLO ref spec
% 
% 
% OUTPUT:
%   no2.no2vcdDU = no2 vertical column density [DU]
%   no2.no2resiDU= no2 residual [DU];
%   no2.no2OD    = no2 column optical depth
%   no2.no2_molec_cm2 = molecules per cm^2, vertical column density
%   no2.no2SCD   = no2 slant density    
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.
%  - loadCrossSections_global.m
%
% NEEDED FILES:
%  - *.xs under data_folder
%
% EXAMPLE:

%  - [no2] = retrieveNO2(s,0.450,0.490,1);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, 2016-04 based on former versions
% Modified from retrieveNO2_20160505
% MS, 2016-05-05, added usage of reference spectrum
% MS, 2016-08-24, created a bug in reading c0gases and ref amount
% MS, 2016-08-25, corrected a bug in reading Refspec
% MS, 2016-10-12, added features from retrieveNO2wfit
%                 determined polynomial order for ORACLES
%                 determined refSpec for ORACLES: 07-02 from MLO
% MS, 2018-03-26, updating no2OD and filtering for subtraction purposes
% MS, 2018-03-27, added NO2 column default values to filtered retrieved
%                 fileds (instead of NaN's)
% -------------------------------------------------------------------------
%% function routine
function [no2] = retrieveNO2(s,wstart,wend,mode,gxs)

plotting = 0;
% load cross-sections
loadCrossSections_global;

 Loschmidt=2.686763e19;                   % molec/cm3*atm
 % find wavelength range index
 istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
 iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
 
 wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
 
 % select NO2 absorbing band to plot residuals for
 ires   = interp1(s.w(wln),[1:length(s.w(wln))],0.470  ,'nearest');
 
 [tmp]=starc0gases(nanmean(s.t),s.toggle.verbose,'NO2',mode);
  
  if mode==0
      % when mode==0 need to choose wln
      c0 = tmp(wln)';
      %c0  = repmat(c0_,length(s.t),1);
  elseif mode==1
      c0 = tmp.no2refspec;
      %c0  = repmat(c0_,length(s.t),1);
  end
 if length(c0)>length(wln)
     c0 = c0(1:length(wln));
 elseif length(c0)<length(wln)
    wln = wln(1:length(c0));
 end
 % calculate residual spectrum (Rayleigh subtracted)
  eta = repmat(log(c0),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);
  eta_residual = NaN(size(eta));
  %ratesub=real(s.rate(:,wln)./(repmat(s.f,1,length(wln)))./tr(s.m_ray, s.tau_ray(:,wln)));
  %eta    =real(-log(ratesub./repmat(c0,length(s.t),1)));
  

%% fit a linear line to spectra
%===============================
% linear fit calculated and subtracted from the spectrum to get an estimation of the aerosol amount 
% and any scattered contribution to the measurement
% calculate linear fit and create residual spectrum

suns = find(s.Str==1 & s.Zn==0)'; 
for i=suns   
    p = polyfit(s.w(wln),eta(i,:),1);
    %p1 = p(1);
    %p0 = p(2);
    f  = polyval(p,s.w(wln));
    
    % create residual eta spectrum
    
    eta_residual(i,:) = eta(i,:) - f;
    
    % plot
    
%     figure(2222);
%     subplot(211);
%     plot(s.w(wln),eta(i,:),'.-','markersize',8);hold on;
%     plot(s.w(wln),f,'-r','linewidth',2);hold off;
%     legend('total OD','OD linear fit');title(serial2Hh(s.t(i)));
%     xlabel('wavelength');ylabel('OD');
%     subplot(212);
%     plot(s.w(wln),eta_residual(i,:),'-k','linewidth',2);
%     xlabel('wavelength');ylabel('residual spectrum');
%     pause(0.01);

    
end

% this is to check residual dependance with SZA/airmass
if plotting
% plot residual to fit (which is 470nm).
        figure;
        plot(s.m_aero,1000*eta_residual(:,ires),'.','color',[0.8,0.8,0.8],'markersize',8);
        axis([min(s.m_aero) max(s.m_aero) -10 20]);
        xlabel('airmass');ylabel('no2 eta ray-sub residual');
        
        figure;
        plot(serial2Hh(s.t),1000*eta_residual(:,ires),'.','color',[0.8,0.8,0.8],'markersize',8);
        axis([min(serial2Hh(s.t)) max(serial2Hh(s.t)) -10 20]);
        xlabel('time');ylabel('eta ray-sub residual');
end

%% run retrieval

% do linear retrieval first (no wavelength shift) 


    % this is end member array (original cross sections)
    
    if     s.t(1) <= datenum([2016 8 25 0 0 0]); 
      % pre-ORACLES
      basis = [no2_298Kcoef(wln), -no2coefdiff(wln),o3coef(wln), o4coef(wln), ones(length(wln),1), s.w(wln)'.*ones(length(wln),1) ((s.w(wln)').^2).*ones(length(wln),1)];
   
    elseif s.t(1) > datenum([2016 8 25 0 0 0]);   
      % ORACLES   
      basis = [no2_298Kcoef(wln), -no2coefdiff(wln),o3coef(wln), o4coef(wln), ones(length(wln),1), s.w(wln)'.*ones(length(wln),1), ((s.w(wln)').^2).*ones(length(wln),1), ((s.w(wln)').^3).*ones(length(wln),1)];
   
    end
    
    
    % solve
    % x = real(Abasis\spectrum_sub');
    
    ccoef_d=NaN(size(basis,2),length(s.t));
    RR_d=NaN(length(wln),length(s.t));
    for k=suns

        coef=real(basis\eta(k,:)');
        % coef=real(Abasis\spectrum_sub(k,:)');
        % scale coef back
        scoef = coef;%./scale;

        % reconstruct spectrum
        recon=basis*scoef;
        RR_d(:,k)=recon;
        ccoef_d(:,k)=scoef;
    end
    
    
    % to get back to regular cross section:
    % test_spec=qno2*rno2;
    
   % calculate no2 scd and vcd
   % create smooth no2 time-series
   xts = 60/3600;   %60 sec in decimal time
   if mode==0
        % covert from atm x cm to molec/cm^2
       no2_amount =  ccoef_d(1,:);% + ccoef_d(2,:);
       no2VCD = real((((Loschmidt*no2_amount))./(s.m_NO2)')');
       tplot = serial2Hh(s.t); %tplot(tplot<10) = tplot(tplot<10)+24;
       [no2VCDsmooth, sn] = boxxfilt(tplot, no2VCD, xts);
       no2vcd_smooth = real(no2VCDsmooth);
   elseif mode==1
       % load reference spectrum
       % ref_spec = load([starpaths,'20160113NO2refspec.mat']);
       no2SCD = real((((Loschmidt*ccoef_d(1,:))))') + tmp.no2scdref;%ref_spec.no2col*ref_spec.mean_m;
       %no2SCD = real(ccoef_d(1,:) + ccoef_d(2,:))*Loschmidt + tmp.no2scdref;%ref_spec.no2col*ref_spec.mean_m;
       tplot = serial2Hh(s.t); %tplot(tplot<10) = tplot(tplot<10)+24;
       [no2SCDsmooth, sn] = boxxfilt(tplot, no2SCD, xts);
       no2vcd_smooth = real(no2SCDsmooth)./s.m_NO2;
       % filter no2VCDsmooth for negative values
       no2vcd_smooth(no2vcd_smooth<0) = NaN;
       no2vcd_smooth(1000*eta_residual(:,ires)<0|1000*eta_residual(:,ires)>2) = NaN;
       quad = s.QdVlr./s.QdVtot;
       no2vcd_smooth(quad>=0.01|quad<=-0.01) = NaN;
       % insert default NO2 values in NaN's
       no2vcd_smooth(isnan(no2vcd_smooth)) = s.NO2col;
       no2OD = (no2vcd_smooth/Loschmidt)*no2_298Kcoef';
   end
    
    
   % calculate
   tau_OD  = s.tau_tot_slant;
   no2Err  = (tau_OD(:,wln)'-RR_d(:,:))./repmat((no2_298Kcoef(wln)),1,length(s.t)); 
   MSEno2DU = real(((1/length(wln)-7)*sum(no2Err.^2))');                          
   RMSEno2  = real(sqrt(real(MSEno2DU)))./s.m_NO2; % convert to vertical
          
   % prepare to plot spectrum OD and no2 cross section
   %no2spectrum     = eta-RR_d' + (ccoef_d(1,:))'*basis(:,1)';
   % this is to account for temp of xs
   no2spectrum     = eta-RR_d' + ((ccoef_d(1,:) + ccoef_d(2,:)))'*(basis(:,1)+basis(:,2))';%((ccoef_d(1,:) + ccoef_d(2,:)))'*basis(:,1)';
   % this is not temp diff.
   %no2fit          = (ccoef_d(1,:))'*basis(:,1)';
   no2fit          = (ccoef_d(1,:) + ccoef_d(2,:))'*(basis(:,1)+basis(:,2))';
   no2residual     = real(eta-RR_d');
   t=nansum((no2residual).^2,2);
   RMSres = sqrt(t)/(length(wln)-size(basis,2));
   %RMSres = real(sqrt((nansum((no2residual).^2,2))/(length(wln)-size(basis,2))));
%    no2meas     = spectrum_sub - exp-((ccoef_d(2,:)/no2diff_norm')*basis(:,2)' - (ccoef_d(3,:)/o3_norm')*basis(:,3)' - (ccoef_d(4,:)')*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)');
%    no2fit      = exp(-(ccoef_d(1,:)')*basis(:,1)');
%    no2residual = spectrum_sub - exp(-(ccoef_d(1,:)')*basis(:,1)' - (ccoef_d(2,:)')*basis(:,2)' - (ccoef_d(3,:)')*basis(:,3)' - ccoef_d(4,:)'*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)');
%    

   if plotting
   % plot fitted and "measured" no2 spectrum
         for i=1:500:length(s.t)
             figure(8882);
             %plot(s.w((wln)),eta1(i,:),'-y','linewidth',2);hold on;
             plot(s.w((wln)),eta(i,:),'--k','linewidth',2);hold on;
             %plot(s.w((wln)),s.tau_aero(i,wln).*s.m_aero(i),'--m','linewidth',2);hold on;
             plot(s.w((wln)),RR_d(:,i),'--c','linewidth',2);hold on;
             plot(s.w((wln)),no2spectrum(i,:),'-k','linewidth',2);hold on;
             plot(s.w((wln)),no2fit(i,:),'--r','linewidth',2);hold on;
             plot(s.w((wln)),no2residual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcd_smooth(i)/(Loschmidt/1000)),' RMSE = ',num2str(RMSres(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');
             %legend('measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             %legend('total spectrum baseline and rayliegh subtracted','tau-aero','reconstructed spectrum','measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             legend('total spectrum baseline and rayliegh subtracted','reconstructed spectrum','measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             set(gca,'fontsize',12,'fontweight','bold');%axis([wstart wend -5e-3 0.04]);%legend('boxoff');
             axis([wstart wend -0.2 0.2]);
             pause;
         end
   end
   
   
   if plotting
       figure;subplot(211);%plot(tplot,no2VCD,'.r');hold on;
              %plot(tplot,no2vcd_smooth,'.g');hold on;
              plot(tplot,no2vcd_smooth/(Loschmidt/1000),'.g');hold on;
              %axis([tplot(1) tplot(end) 0 5e17]);
              axis([tplot(1) tplot(end) 0 10]);
              %xlabel('time');ylabel('no2 [molec/cm^{2}]');title(datestr(s.t(1),'yyyymmdd'));
              xlabel('time');ylabel('no2 [DU]');title(datestr(s.t(1),'yyyymmdd'));
              %legend('linear inversion','linear inversion smooth');
              legend('linear inversion smooth');
              subplot(212);plot(tplot,RMSres,'.r');hold on;
              axis([tplot(1) tplot(end) 0 0.005]);
              xlabel('time');ylabel('no2 RMSE');
   end
   
   %% save variables

   % no2OD is the spectrum portion to subtract
    no2.no2_molec_cm2    = no2vcd_smooth;
    no2.no2resi          = RMSres;
    no2.no2OD            = no2OD; %(real((((Loschmidt*ccoef_d(1,:))))')*no2_298Kcoef')./repmat(s.m_NO2,1,length(s.w));%(no2VCD/Loschmidt)*no2_298Kcoef';% this is optical depth
    no2.no2SCD           = no2SCDsmooth;%real((((Loschmidt*ccoef_d(1,:))))');%no2SCDsmooth;%real((((Loschmidt*ccoef_d(1,:))))');
    
    % save additional params:
    % figure;
    % plot(serial2Hh(s.t),s.QdVlr./s.QdVtot,'og');
    % quad = s.QdVlr./s.QdVtot;
    % figure;
    % plot(serial2Hh(s.t(quad<=0.01&quad>=-0.01)),no2vcd_smooth(quad<=0.01&quad>=-0.01)/(Loschmidt/1000),'ob');hold on;
    % no2vcd_smooth2 = smooth(no2vcd_smooth(quad<=0.01&quad>=-0.01),60,'rlowess');
    % plot(serial2Hh(s.t(quad<=0.01&quad>=-0.01)),no2vcd_smooth2/(Loschmidt/1000),'xr');hold on;
    % 
    %     n.VCD_NO2   = no2vcd_smooth2/(Loschmidt/1000);
    %     n.resid_NO2 = RMSres(quad<=0.01&quad>=-0.01);
    %     n.UTC       = serial2Hh(s.t(quad<=0.01&quad>=-0.01));
    %     n.Alt       = s.Alt(quad<=0.01&quad>=-0.01);
    %     n.Latitude  = s.Lat(quad<=0.01&quad>=-0.01);
    %     n.Longitude = s.Lon(quad<=0.01&quad>=-0.01);
    

%     no2vcd_smooth2 = smooth(no2vcd_smooth,60,'rlowess');
%     n.VCD_NO2   = no2vcd_smooth2(1000*eta_residual(:,ires)>0&1000*eta_residual(:,ires)<2)/(Loschmidt/1000);
%     n.resid_NO2 = RMSres(1000*eta_residual(:,ires)>0&1000*eta_residual(:,ires)<2);
%     n.UTC       = serial2Hh(s.t(1000*eta_residual(:,ires)>0&1000*eta_residual(:,ires)<2));
%     n.Alt       = s.Alt(1000*eta_residual(:,ires)>0&1000*eta_residual(:,ires)<2);
%     n.Latitude  = s.Lat(1000*eta_residual(:,ires)>0&1000*eta_residual(:,ires)<2);
%     n.Longitude = s.Lon(1000*eta_residual(:,ires)>0&1000*eta_residual(:,ires)<2);
%     % save to mat
%     si = strcat('D:\MichalsData\KORUS-AQ\OMI\pandora_4star\KORUS_AQ_Archive\korusaq-4STAR-NO2_DC8_','20160529','.mat');
%     save(si,'-struct','n');
% %    

return;
