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
% 
% -------------------------------------------------------------------------
%% function routine
function [hcoh] = retrieveHCOH(s,wstart,wend,mode)

plotting = 0;
% load cross-sections
loadCrossSections_global;
w = s.w; toggle = s.toggle; 
tau_ray =s.tau_ray;
 Loschmidt=2.686763e19;                   % molec/cm3*atm
 % find wavelength range index
 istart = interp1(w,[1:length(w)],wstart, 'nearest');
 iend   = interp1(w,[1:length(w)],wend  , 'nearest');
 
 wln = find(w<=w(iend)&w>=w(istart)); 
 

 % decide which c0 to use
 % mode = 0-lamp?; 1-MLO ref spec
  
  [c0]=starc0gases(nanmean(s.t),toggle.verbose,'HCOH',mode);
  
  if mode==0
      % when mode==0 need to choose wln
      c0 = c0(wln)';
  end
  
 
 % calculate residual spectrum (Rayleigh subtracted)
eta = repmat(log(c0),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*tau_ray(:,wln);

% do linear retrieval first (no wavelength shift) 


    % this is end member array (original cross sections)
    
    basis = [hcohcoef(wln), no2_298Kcoef(wln), o3coef(wln), o4coef(wln), ones(length(wln),1), w(wln)'.*ones(length(wln),1), ((w(wln)').^2).*ones(length(wln),1)];
    % basis = [hcohcoef(wln), no2_298Kcoef(wln), o3coef(wln), o4coef(wln), ones(length(wln),1), w(wln)'.*ones(length(wln),1)];

    % solve
    % x = real(Abasis\spectrum_sub');
    
    ccoef_d=[];
    RR_d=[];
    
    for k=length(s.t):-1:1;

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
       hcoh_amount =  ccoef_d(1,:);
       hcohVCD = real((((1000*hcoh_amount))./(s.m_NO2)')');% conversion from atm x cm to DU
       tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
       [hcohVCDsmooth, sn] = boxxfilt(tplot, hcohVCD, xts);
       hcohvcd_smooth = real(hcohVCDsmooth);
   elseif mode==1
       % load reference spectrum
       ref_spec = load([starpaths,'20160113HCOHrefspec.mat']);
       hcohSCD = real((((1000*ccoef_d(1,:))))');% + ref_spec.hcohscdref;%ref_spec.no2col*ref_spec.mean_m;
       tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
       [hcohSCDsmooth, sn] = boxxfilt(tplot, hcohSCD, xts);
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
   RMSres = real(sqrt((sum((hcohresidual).^2,2))/(length(wln)-7)));
%    no2meas     = spectrum_sub - exp-((ccoef_d(2,:)/no2diff_norm')*basis(:,2)' - (ccoef_d(3,:)/o3_norm')*basis(:,3)' - (ccoef_d(4,:)')*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)');
%    no2fit      = exp(-(ccoef_d(1,:)')*basis(:,1)');
%    no2residual = spectrum_sub - exp(-(ccoef_d(1,:)')*basis(:,1)' - (ccoef_d(2,:)')*basis(:,2)' - (ccoef_d(3,:)')*basis(:,3)' - ccoef_d(4,:)'*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)');
%    

   if plotting
   % plot fitted and "measured" hcoh spectrum
         for i=1:100:length(s.t)
             figure(8882);
             %plot(w((wln)),spectrum_sub(i,:),'--k','linewidth',2);hold on;
             %plot(w((wln)),no2meas(i,:),'-y','linewidth',2);hold on;
             %plot(w((wln)),RR_d(:,i),'--c','linewidth',2);hold on;
             plot(w((wln)),hcohspectrum(i,:),'-k','linewidth',2);hold on;
             plot(w((wln)),hcohfit(i,:),'--r','linewidth',2);hold on;
             plot(w((wln)),hcohresidual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' hcohVCD= ',num2str(hcohvcd_smooth(i)),' RMSE = ',num2str(RMSres(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');
             legend('measured HCOH spectrum','fitted HCOH spectrum','residual');
             %legend('total spectrum baseline and rayliegh subtracted','reconstructed spectrum','measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             set(gca,'fontsize',12,'fontweight','bold');%axis([wstart wend -5e-3 0.04]);%legend('boxoff');
             pause(0.001);
         end
   end
   
   
   if plotting
       figure;subplot(211);%plot(tplot,no2VCD,'.r');hold on;
              plot(tplot,hcohvcd_smooth,'.g');hold on;
              axis([tplot(1) tplot(end) 0 10]);
              xlabel('time');ylabel('no2 [molec/cm^{2}]');title(datestr(s.t(1),'yyyymmdd'));
              %legend('linear inversion','linear inversion smooth');
              legend('linear inversion smooth');
              subplot(212);plot(tplot,RMSres,'.r');hold on;
              axis([tplot(1) tplot(end) 0 0.005]);
              xlabel('time');ylabel('no2 RMSE');
   end

   % no2OD is the spectrum portion to subtract
    hcoh.hcoh_DU          = hcohvcd_smooth;
    hcoh.hcohresi         = RMSres;
    hcoh.hcohOD           = (real((((ccoef_d(1,:))))')*hcohcoef')./repmat(s.m_NO2,1,length(w));%(no2VCD/Loschmidt)*no2_298Kcoef';% this is optical depth
    hcoh.hcohSCD           = hcohSCDsmooth;%real((((Loschmidt*ccoef_d(1,:))))');%no2SCDsmooth;%real((((Loschmidt*ccoef_d(1,:))))');

return;
