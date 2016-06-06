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
%   no2.no2OD    = no2 optical depth
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
% -------------------------------------------------------------------------
%% function routine
function [no2] = retrieveNO2(s,wstart,wend,mode)

plotting = 0;
% load cross-sections
loadCrossSections_global_;

 Loschmidt=2.686763e19;                   % molec/cm3*atm
 % find wavelength range index
 w = s.w; t = s.t; toggle = s.toggle;
 tau_ray = s.tau_ray; rateslant = s.rateslant;
 
 istart = interp1(w,[1:length(w)],wstart, 'nearest');
 iend   = interp1(w,[1:length(w)],wend  , 'nearest');
 
 wln = find(w<=w(iend)&w>=w(istart)); 
 

  % select NO2 absorbing band to plot residuals for
 ires   = interp1(w(wln),[1:length(w(wln))],0.470  ,'nearest');
 
 % apply specified NO2 gas c0
 % decide which c0 to use
 % mode = 1;%0-MLO c0; 1-MLO ref spec
  
  [c0]=starc0gases(nanmean(t),toggle.verbose,'NO2',mode);
  
  if mode==0
      % when mode==0 need to choose wln
      c0 = c0(wln)';
  end
  
 
 % calculate residual spectrum (Rayleigh subtracted)
eta = repmat(log(c0),length(t),1) - log(rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*tau_ray(:,wln);

if plotting
% plot residual to fit (ind 12 in wln, which is 459nm).
        figure;
        plot(s.m_aero,1000*eta(:,ires),'.','color',[0.8,0.8,0.8],'markersize',8);
        axis([min(s.m_aero) max(s.m_aero) -10 20]);
end

% do linear retrieval first (no wavelength shift) 


    % this is end member array (original cross sections)
    
    basis = [no2_298Kcoef(wln), no2coefdiff(wln), o3coef(wln), o4coef(wln), ones(length(wln),1), w(wln)'.*ones(length(wln),1), ((w(wln)').^2).*ones(length(wln),1)];

    % solve
    % x = real(Abasis\spectrum_sub');
    
    ccoef_d=[];
    RR_d=[];
    % vectorize
    for k = length(t):-1:1

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
       no2_amount =  ccoef_d(1,:);
       no2VCD = real((((Loschmidt*no2_amount))./(s.m_NO2)')');
       tplot = serial2Hh(t); tplot(tplot<10) = tplot(tplot<10)+24;
       [no2VCDsmooth, sn] = boxxfilt(tplot, no2VCD, xts);
       no2vcd_smooth = real(no2VCDsmooth);
   elseif mode==1
       % load reference spectrum
       ref_spec = load('20160113NO2refspec.mat');
       no2SCD = real((((Loschmidt*ccoef_d(1,:))))') + ref_spec.no2scdref;%ref_spec.no2col*ref_spec.mean_m;
       tplot = serial2Hh(t); tplot(tplot<10) = tplot(tplot<10)+24;
       [no2SCDsmooth, sn] = boxxfilt(tplot, no2SCD, xts);
       no2vcd_smooth = real(no2SCDsmooth)./s.m_NO2;
   end
    
    
   % calculate error
   tau_OD  = s.tau_tot_slant;
   no2Err  = (tau_OD(:,wln)'-RR_d(:,:))./repmat((no2_298Kcoef(wln)),1,length(t)); 
   MSEno2DU = real(((1/length(wln)-7)*sum(no2Err.^2))');                          
   RMSEno2  = real(sqrt(real(MSEno2DU)))./s.m_NO2; % convert to vertical
          
   % prepare to plot spectrum OD and no2 cross section
   no2spectrum     = eta-RR_d' + (ccoef_d(1,:))'*basis(:,1)';
   no2fit          = (ccoef_d(1,:))'*basis(:,1)';
   no2residual     = eta-RR_d';
   RMSres = real(sqrt((sum((no2residual).^2,2))/(length(wln)-7)));
%    no2meas     = spectrum_sub - exp-((ccoef_d(2,:)/no2diff_norm')*basis(:,2)' - (ccoef_d(3,:)/o3_norm')*basis(:,3)' - (ccoef_d(4,:)')*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)');
%    no2fit      = exp(-(ccoef_d(1,:)')*basis(:,1)');
%    no2residual = spectrum_sub - exp(-(ccoef_d(1,:)')*basis(:,1)' - (ccoef_d(2,:)')*basis(:,2)' - (ccoef_d(3,:)')*basis(:,3)' - ccoef_d(4,:)'*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)');
%    

   if plotting
   % plot fitted and "measured" no2 spectrum
         for i=1:100:length(t)
             figure(8882);
             %plot(w((wln)),spectrum_sub(i,:),'--k','linewidth',2);hold on;
             %plot(w((wln)),no2meas(i,:),'-y','linewidth',2);hold on;
             %plot(w((wln)),RR_d(:,i),'--c','linewidth',2);hold on;
             plot(w((wln)),no2spectrum(i,:),'-k','linewidth',2);hold on;
             plot(w((wln)),no2fit(i,:),'--r','linewidth',2);hold on;
             plot(w((wln)),no2residual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcd_smooth(i)/(Loschmidt/1000)),' RMSE = ',num2str(RMSres(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');
             legend('measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             %legend('total spectrum baseline and rayliegh subtracted','reconstructed spectrum','measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             set(gca,'fontsize',12,'fontweight','bold');%axis([wstart wend -5e-3 0.04]);%legend('boxoff');
             pause(0.001);
         end
   end
   
   
   if plotting
       figure;subplot(211);%plot(tplot,no2VCD,'.r');hold on;
              plot(tplot,no2vcd_smooth,'.g');hold on;
              axis([tplot(1) tplot(end) 0 5e15]);
              xlabel('time');ylabel('no2 [molec/cm^{2}]');title(datestr(t(1),'yyyymmdd'));
              %legend('linear inversion','linear inversion smooth');
              legend('linear inversion smooth');
              subplot(212);plot(tplot,RMSres,'.r');hold on;
              axis([tplot(1) tplot(end) 0 0.005]);
              xlabel('time');ylabel('no2 RMSE');
   end

   % no2OD is the spectrum portion to subtract
    no2.no2_molec_cm2    = no2vcd_smooth;
    no2.no2resi          = RMSres;
    no2.no2OD            = (real((((Loschmidt*ccoef_d(1,:))))')*no2_298Kcoef')./repmat(s.m_NO2,1,length(w));%(no2VCD/Loschmidt)*no2_298Kcoef';% this is optical depth
    no2.no2SCD           = no2SCDsmooth;%real((((Loschmidt*ccoef_d(1,:))))');%no2SCDsmooth;%real((((Loschmidt*ccoef_d(1,:))))');



return;
