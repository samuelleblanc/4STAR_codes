%% Details of the function:
%   retrieveHCOH
% 
% PURPOSE:
%   retrieves HCOH using a given (start,end) wavelength range
%   using differential cross section and linear inversion
%   hcoh (with no2, o3 and o4)
%   nm_0335 = interp1(wvis,[1:length(wvis)],0.335,  'nearest');
%   nm_0359 = interp1(wvis,[1:length(wvis)],0.359,  'nearest');
% 
%
% CALLING SEQUENCE:
%  function [hcoh] = retrieveHCOH(s,wstart,wend,1)
%
% INPUT:
%  - s: starsun struct from starwarapper
%  - wstart  : wavelength range start in micron
%  - wend    : wavelength range start in micron
%  - mode    : 1 - use refSpec, 0 - use other c0 (e.g. lamp/langley)
% 
% 
% OUTPUT:
%   hcoh.hcohvcdDU = hcoh vertical column density [DU]
%   hcoh.hcohresiDU= hcoh residual [DU];
%   hcoh.hcohOD    = hcoh optical depth
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.
%  - loadCrossSections_global.m
%  - backcor.m
%  - gram_schmidt.m
%
% NEEDED FILES:
%  - *.xs under data_folder
%
% EXAMPLE:
%  - [hcoh] = retrieveHCOH(s,0.335,0.359,1);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, 2016-05-18, on the plane over Korea
% 
% Modifications:
% MS, fixed bug in reading hcoh c0
% MS, 2016-10-12, adjusted to be similar to recent NO2 scheme
% -------------------------------------------------------------------------
%% function routine
function [hcoh] = retrieveHCOH(s,wstart,wend,mode,gxs)

plotting = 0;
% load cross-sections
loadCrossSections_global;

 Loschmidt=2.686763e19;                   % molec/cm3*atm
 % find wavelength range index
 istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
 iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
 
 wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
 
  % select HCOH absorbing band to plot residuals for
 ires   = interp1(s.w(wln),[1:length(s.w(wln))],0.339  ,'nearest');

 % decide which c0 to use
 % mode = 0-lamp?; 1-MLO ref spec
  
  [tmp]=starc0gases(nanmean(s.t),s.toggle.verbose,'HCOH',mode,s.instrumentname);
  
  if mode==0
      % when mode==0 need to choose wln
      c0 = tmp(wln)';
  elseif mode==1
      c0 = tmp.hcohrefspec;
  end
  
  
 
 % calculate residual spectrum (Rayleigh subtracted)
eta = repmat(log(c0),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);
eta_residual = NaN(size(eta));
%% fit a linear line to spectra
%===============================
% linear fit calculated and subtracted from the spectrum to get an estimation of the aerosol amount 
% and any scattered contribution to the measurement
% calculate linear fit and create residual spectrum

% for i=1:length(s.t)
suns = find(s.Str==1&s.Zn==0)';
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
end

%% run retrieval

% do linear retrieval first (no wavelength shift) 


    % this is end member array (original cross sections)
    
    basis = [hcohcoef(wln), no2_298Kcoef(wln), -no2coefdiff(wln), o3coef(wln), o4coef(wln), ...
       ones(length(wln),1), s.w(wln)'.*ones(length(wln),1), ((s.w(wln)').^2).*ones(length(wln),1), ...
       ((s.w(wln)').^3).*ones(length(wln),1)];
    basis = [hcohcoef(wln), no2_298Kcoef(wln), brocoef(wln), o3coef(wln), o4coef(wln), ...
       ones(length(wln),1), s.w(wln)'.*ones(length(wln),1), ((s.w(wln)').^2).*ones(length(wln),1), ...
       ((s.w(wln)').^3).*ones(length(wln),1), ((s.w(wln)').^3).*ones(length(wln),1), ((s.w(wln)').^4).*ones(length(wln),1)];
    basis = [hcohcoef(wln), no2_298Kcoef(wln), brocoef(wln), o3coef(wln), o4coef(wln), ...
       ones(length(wln),1), s.w(wln)'.*ones(length(wln),1), ((s.w(wln)').^2).*ones(length(wln),1),...
       ((s.w(wln)').^3).*ones(length(wln),1), ((s.w(wln)').^4).*ones(length(wln),1)];

    % solve
    % x = real(Abasis\spectrum_sub');
    
%     ccoef_d=[];
%     RR_d=[];
%     
%     for k=1:length(s.t);
ccoef_d = NaN([size(basis,2),length(s.t)]);
RR_d = NaN([length(wln),length(s.t)]);

for k=suns
   coef=real(basis\eta(k,:)');
   % coef=real(Abasis\spectrum_sub(k,:)');
   % scale coef back
   scoef = coef;%./scale;
   % reconstruct spectrum
   recon=basis*scoef;
   RR_d(:,k) = recon;
   ccoef_d(:,k)= scoef;
end

    % to get back to regular cross section:
    % test_spec=qno2*rno2;
    
   % calculate hcoh scd and vcd
   % create smooth hcoh time-series
   
   xts = 60/3600;   %60 sec in decimal time
   if mode==0
        % covert from atm x cm to molec/cm^2
       hcoh_amount =  ccoef_d(1,:);% + ccoef_d(2,:);
       hcohVCD = real((((Loschmidt*hcoh_amount))./(s.m_NO2)')');
       tplot = serial2Hh(s.t); %tplot(tplot<10) = tplot(tplot<10)+24;
       [hcohVCDsmooth, sn] = boxxfilt(tplot, hcohVCD, xts);
       hcohvcd_smooth = real(hcohVCDsmooth);
       
   elseif mode==1
       
       hcohSCD = real((((Loschmidt*ccoef_d(1,:))))') + tmp.hcohscdref;
       %hcohVCD = real((hcohSCD/(Loschmidt/1000))./s.m_aero);
       tplot = serial2Hh(s.t); %tplot(tplot<10) = tplot(tplot<10)+24;
       [hcohSCDsmooth, sn] = boxxfilt(tplot, hcohSCD, xts);
       %[hcohvcd_smooth, sn] = (boxxfilt(tplot, hcohVCD, xts));
       hcohvcd_smooth = real(hcohSCDsmooth)./s.m_NO2;
   end
   
   
  
   % calculate error
   tau_OD  = s.tau_tot_slant;
   hcohErr  = (tau_OD(:,wln)'-RR_d(:,:))./repmat((hcohcoef(wln)),1,length(s.t)); 
   MSEhcohDU = real(((1/length(wln)-7)*sum(hcohErr.^2))');                          
   RMSEhcoh  = real(sqrt(real(MSEhcohDU)))./s.m_NO2; % convert to vertical
          
   % prepare to plot spectrum OD and no2 cross section
   hcohspectrum     = eta-RR_d' + (ccoef_d(1,:))'*basis(:,1)';
   hcohfit          = (ccoef_d(1,:))'*basis(:,1)';
   hcohresidual     = eta-RR_d';
   RMSres = real(sqrt((sum((hcohresidual).^2,2))/(length(wln)-size(basis,2))));
   
   

   if plotting
   % plot spectra and fits
         for i=1:500:length(s.t)
             figure(8882);
             %plot(s.w((wln)),eta(i,:),'--k','linewidth',2);hold on;
             %plot(s.w((wln)),s.tau_aero(i,wln).*s.m_aero(i),'--m','linewidth',2);hold on;
             %plot(s.w((wln)),RR_d(:,i),'--c','linewidth',2);hold on;
             plot(s.w((wln)),hcohspectrum(i,:),'-k','linewidth',2);hold on;
             plot(s.w((wln)),hcohfit(i,:),'--r','linewidth',2);hold on;
             plot(s.w((wln)),hcohresidual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' hcohVCD [DU] = ',num2str(hcohvcd_smooth(i)/(Loschmidt/1000)),' RMSE = ',num2str(RMSres(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');
             
             %legend('total spectrum baseline and rayliegh subtracted','tau-aero','reconstructed spectrum','measured HCOH spectrum','fitted HCOH spectrum','residual');
             legend('measured HCOH spectrum','fitted HCOH spectrum','residual');
             
             set(gca,'fontsize',12,'fontweight','bold');%axis([wstart wend -5e-3 0.04]);%legend('boxoff');
             pause;
         end
   end
   
   
   if plotting
       figure;subplot(211);
              %plot(tplot,hcohvcd_smooth,'.g');hold on;
              plot(tplot,hcohvcd_smooth/(Loschmidt/1000),'.g');hold on;
              axis([tplot(1) tplot(end) 0 10]);
              xlabel('time');
              ylabel('HCOH [molec/cm^{2}]');
              ylabel('HCOH [DU]');
              title(datestr(s.t(1),'yyyymmdd'));
              
              legend('linear inversion smooth');
              subplot(212);plot(tplot,RMSres,'.r');hold on;
              axis([tplot(1) tplot(end) 0 0.01]);
              xlabel('time');ylabel('HCOH RMSE');
   end

   
   %% save variables
   % hcohOD is the spectrum portion to subtract
    hcoh.hcoh_DU          = hcohvcd_smooth/(Loschmidt/1000);
    hcoh.hcohresi         = RMSres;
%     hcoh.hcohOD           = (real((((ccoef_d(1,:))))')*hcohcoef')./repmat(s.m_NO2,1,length(s.w));%(no2VCD/Loschmidt)*no2_298Kcoef';% this is optical depth
    hcoh.hcohOD           = hcohvcd_smooth*hcohcoef';
    hcoh.hcohSCD           = hcohSCDsmooth/(Loschmidt/1000);%real((((Loschmidt*ccoef_d(1,:))))');%no2SCDsmooth;%real((((Loschmidt*ccoef_d(1,:))))');



return;
