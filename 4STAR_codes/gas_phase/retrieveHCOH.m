%% Details of the function:
% NAME:
%   retrieveHCOH
% 
% PURPOSE:
%   retrieves HCOH using a given (start,end) wavelength range
%   using differential cross section and linear inversion
%   hcoh (with no2, bro, o3 and o4)
%   nm_0335 = interp1(wvis,[1:length(wvis)],0.335,  'nearest');
%   nm_0359 = interp1(wvis,[1:length(wvis)],0.359,  'nearest');
% 
%
% CALLING SEQUENCE:
%  function [hcoh] = retrieveHCOH(s,wstart,wend)
%
% INPUT:
%  - s: starsun struct from starwarapper
%  - wstart  : wavelength range start in micron
%  - wend    : wavelength range start in micron
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
%  - [hcoh] = retrieveHCOH(s,0.335,0.359);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, 2016-04 based on former versions
% 
% 
% -------------------------------------------------------------------------
%% function routine
function [no2] = retrieveHCOH(s,wstart,wend)

plotting = 0;
% load cross-sections
loadCrossSections_global;

 Loschmidt=2.686763e19;                   % molec/cm3*atm
 % find wavelength range index
 istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
 iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
 
 wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
 
 % calculate residual spectrum (Rayleigh subtracted)
 eta = repmat(log(s.c0(wln)),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);

%% baseline subtraction
%=======================
% baseline is calculated to get an estimation of the aerosol amount at the 940 nm band for Tw conversion  
% calculate linear baseline for only the water vapor band region
% calculate polynomial baseline
order=1;  % order of baseline polynomial fit
poly=zeros(length(s.w(wln)),length(s.t));  % calculated polynomial
poly_c=zeros(length(s.t),(order)+1);       % polynomial coefficients
order_in=1;
thresh_in=0.01;
% deduce baseline
for i=1:length(s.t)
% function (fn) can be: 'sh','ah','stq','atq'
% for gui use (visualization) write:
% [poly2_,poly2_c_,iter,order,thresh,fn]=backcor(wvis(wln_ind),starsun.tau_aero(goodTime(i),wln_ind));
% spectrum calculated by modc0 calibration (vertical OD)
        [poly_,poly_c_,iter,order_lin,thresh,fn] = backcor(s.w(wln),eta(i,:),order_in,thresh_in,'atq');% backcor(wavelength,signal,order,threshold,function);
        poly(:,i)=poly_;        % calculated polynomials
        poly_c(i,:)=poly_c_';   % polynomial coefficients
        
        baseline(i,:) = poly_';
        spectrum(i,:) = eta(i,:);
        spectrum_sub(i,:)  = spectrum(i,:) - baseline(i,:);

        %plot OD baseline interpolation and total OD values
%                 figure(1111)
%                 subplot(211);
%                 plot(s.w(wln),eta(i,:),'.-','markersize',8);hold on;
%                 plot(s.w(wln),poly_,'-r','linewidth',2);hold off;
%                 legend('total OD','OD baseline');title(serial2Hh(s.t(i)));
%                 subplot(212);
%                 plot(s.w(wln),spectrum_sub(i,:),'-g','markersize',8);hold off;
%                 pause(0.01);

end

if plotting
% plot residual to fit (ind 12 in wln, which is 459nm).
        figure;
        plot(s.m_aero,1000*spectrum_sub(:,12),'.','color',[0.8,0.8,0.8],'markersize',8);
        axis([min(s.m_aero) max(s.m_aero) -10 20]);
end

% do linear retrieval first (no wavelength shift) 
% basis = [no2coef(wln), no2coefdiff(wln), o4coef(wln), o3coef(wln)];
  

    % this is end member array (original cross sections)
    basis = [no2_298Kcoef(wln), no2coefdiff(wln), o4coef(wln), o3coef(wln)];

    
    % define baseline array
    
    to = [ones(length(wln),1) s.w(wln)'];
    
    % orthogonalize/ create normalization
     
    [qno2 rno2]         = gram_schmidt([to no2_298Kcoef(wln)]);      no2_norm     = sqrt(no2_298Kcoef(wln)'*no2_298Kcoef(wln));
    [qno2diff rno2diff] = gram_schmidt([to no2coefdiff(wln)]);       no2diff_norm = sqrt(no2coefdiff(wln)'*no2coefdiff(wln));
    [qo3  ro3 ]         = gram_schmidt([to o3coef(wln)]);            o3_norm      = sqrt(o3coef(wln)'*o3coef(wln));
    [qo4  ro4 ]         = gram_schmidt([to(:,1) o4coef(wln)]);       o4_norm      = sqrt(o4coef(wln)'*o4coef(wln));
   
    
    if plotting 
    % plot orthonormal cross sections
            figure(1001);
            plot(s.w(wln),spectrum_sub(15,:),'-k');hold on;
            plot(s.w(wln),qno2(:,end),'-r');hold on;
            plot(s.w(wln),qno2diff(:,end),'-m');hold on;
            plot(s.w(wln),qo3(:,end),'-c');hold on;
            %plot(s.w(wln),o4coef(wln)*100000,'-g');hold off;
            plot(s.w(wln),qo4(:,end),'-g');hold off;
            legend('meas','diff no2 298K','diff no2 220-298K','diff o3',' diff o4');
    end
    
    % Abasis = [qno2(:,end) no2coefdiff(wln) qo3(:,end) o4coef(wln) to];%./repmat(scale,length(b),1);
    % Abasis = [qno2(:,end) qno2diff(:,end)  qo3(:,end) o4coef(wln)];%./repmat(scale,length(b),1);
    Abasis = [qno2(:,end) qno2diff(:,end)  qo3(:,end) qo4(:,end)];%./repmat(scale,length(b),1);
    
    
    % solve
    % x = real(Abasis\spectrum_sub');
    
    ccoef_d=[];
    RR_d=[];
    scale = [no2_norm; no2diff_norm; o3_norm; 1];
    for k=1:length(s.t);
        coef=real(Abasis\spectrum_sub(k,:)');
        % scale coef back
        scoef = coef./scale;
        %scoef = scale.*coef;
        
        % reconstruct spectrum
        recon=Abasis*scoef;
        RR_d=[RR_d recon];
        ccoef_d=[ccoef_d scoef];
    end 
    
    % to get back to regular cross section:
    % test_spec=qno2*rno2;
    
    % calculate no2 vcd
   % no2VCD = real((((ccoef(1,:))*1000)./(s.m_NO2)')');
   no2VCD = real((((1000*ccoef_d(1,:)))./(s.m_NO2)')');
   % create smooth no2 time-series
   xts = 60/3600;   %60 sec in decimal time
   tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
   [no2VCDsmooth, sn] = boxxfilt(tplot, no2VCD, xts);
   no2vcd_smooth = real(no2VCDsmooth);
   
   % calculate error
   
   no2Err   = (spectrum_sub'-RR_d(:,:))./repmat((no2_298Kcoef(wln)),1,length(s.t));      % in atm cm to DU
   MSEno2DU = real(((1/length(wln))*sum((no2Err).^2))');                                 % convert from atm cm to DU
   RMSEno2  = real(sqrt(real(MSEno2DU)));%/(1000)/scale(1);
   
   if plotting
       figure;subplot(211);plot(tplot,no2VCD,'.r');hold on;
              plot(tplot,no2vcd_smooth,'.g');hold on;
              axis([tplot(1) tplot(end) 0 0.3]);
              xlabel('time');ylabel('no2 [DU]');
              legend('linear inversion','linear inversion smooth');
              subplot(212);plot(tplot,RMSEno2,'.r');hold on;
              axis([tplot(1) tplot(end) 0 0.010]);
              xlabel('time');ylabel('no2 RMSE [DU]');
   end
          
   % prepare to plot spectrum OD and no2 cross section
   
   no2spectrum     = spectrum_sub-RR_d' + 1000*ccoef_d(1,:)'*basis(:,1)';
   no2fit          = 1000*ccoef_d(1,:)'*basis(:,1)';
   no2residual     = spectrum_sub-RR_d';
   
   if plotting
   % plot fitted and "measured" no2 spectrum
         for i=1:10:length(s.t)
             figure(8882);
             %plot(s.w((wln)),spectrum_sub(i,:),'--k','linewidth',2);hold on;
             %plot(s.w((wln)),RR(:,i),'--c','linewidth',2);hold on;
             plot(s.w((wln)),no2spectrum(i,:),'-k','linewidth',2);hold on;
             plot(s.w((wln)),no2fit(i,:),'-r','linewidth',2);hold on;
             plot(s.w((wln)),no2residual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcd_smooth(i)),' RMSE = ',num2str(RMSEno2(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');
             legend('measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             %legend('total spectrum baseline and rayliegh subtracted','reconstructed spectrum','measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
             pause(0.001);
         end
   end

   % no2OD is the spectrum portion to subtract
    no2.no2DU    = no2vcd_smooth;
    no2.no2resiDU= RMSEno2;
    no2.no2OD    = (no2VCD/1000)*no2_298Kcoef';%no2fit/1000;% this is optical depth
    