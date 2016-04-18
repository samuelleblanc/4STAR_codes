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
% -------------------------------------------------------------------------
%% function routine
function [no2] = retrieveNO2(s,wstart,wend)

% load cross-sections
loadCrossSections_global;

 Loschmidt=2.686763e19;                   % molec/cm3*atm
 % find wavelength range index
 istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
 iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
 
 wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
 
%I_meas  = log(Idat) + o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*(Xdat) + x0(:,6)*(Xdat).^2 + x0(:,7)*(Xdat).^3;
%I_model = log(c0);%o3_coef.*x0(:,1)+ o4_coef.*x0(:,2) + h2o_coef.*x0(:,3) + x0(:,4)*ones(length(Xdat),1) + x0(:,5)*log(Xdat);


% use mid-day as reference
% [m_min, m_ind] = min(s.m_aero);
% c0 = mean(s.rateslant(m_ind-10:m_ind+10,wln));
% c0_std = std(s.rateslant(m_ind-10:m_ind+10,wln));
% 
% figure;
% subplot(211);
% plot(s.w(wln),c0,'-g');hold on;
% plot(s.w(wln),c0+3*c0_std,'--k');hold on;
% plot(s.w(wln),c0-3*c0_std,'--k');hold off;
% ylabel('rate [counts]');
% legend('solar noon rate','rate stdx3');
% subplot(212);
% plot(s.w(wln),c0,'-g');hold on;
% plot(s.w(wln),s.c0(wln),'-b');hold on;
% xlabel('wavelength [um]');
% ylabel('reference spectrum [counts]');
% legend('c0','solar noon reference');

eta = repmat(log(s.c0(wln)),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);%tr(s.m_ray, s.tau_ray)


%eta = repmat(log(c0),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);%tr(s.m_ray, s.tau_ray)

%% baseline subtraction
% begin of method 1
%==================
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
 
% plot residual to fit (ind 12 in wln, which is 459nm).
figure;
plot(s.m_aero,1000*spectrum_sub(:,12),'.','color',[0.8,0.8,0.8],'markersize',8);
axis([min(s.m_aero) max(s.m_aero) -10 20]);
% do linear retrieval first (no wavelength shift) 
% basis = [no2coef(wln), no2coefdiff(wln), o4coef(wln), o3coef(wln)];
basis = [no2_298Kcoef(wln), no2coefdiff(wln), o4coef(wln), o3coef(wln)];

ccoef=[];
   RR=[];
   for k=1:length(s.t);
        coef=basis\spectrum_sub(k,:)';
        recon=basis*coef;
        RR=[RR recon];
        ccoef=[ccoef coef];
   end
   
   % calculate no2 vcd
   no2VCD = real((((ccoef(1,:))*1000)./(s.m_NO2)')');
   % create smooth no2 time-series
   xts = 60/3600;   %60 sec in decimal time
   tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
   [no2VCDsmooth, sn] = boxxfilt(tplot, no2VCD, xts);
   no2vcd_smooth = real(no2VCDsmooth);
   
   % calculate error
  
   no2Err   = (spectrum_sub'-RR(:,:))./repmat((no2_298Kcoef(wln)),1,length(s.t));       % in atm cm
   MSEno2DU = real((1000*(1/length(wln))*sum(no2Err.^2))');                             % convert from atm cm to DU
   RMSEno2  = real(sqrt(real(MSEno2DU)));
   
   figure;subplot(211);plot(tplot,no2VCD,'.r');hold on;
          plot(tplot,no2vcd_smooth,'.g');hold on;
          axis([tplot(1) tplot(end) 0 0.3]);
          xlabel('time');ylabel('no2 [DU]');
          legend('linear inversion','linear inversion smooth');
          subplot(212);plot(tplot,RMSEno2,'.r');hold on;
          axis([tplot(1) tplot(end) 0 0.010]);
          xlabel('time');ylabel('no2 RMSE [DU]');
          
   % prepare to plot spectrum OD and no2 cross section
   
   no2spectrum     = spectrum_sub-RR' + ccoef(1,:)'*basis(:,1)';
   no2fit          = ccoef(1,:)'*basis(:,1)';
   no2residual     = spectrum_sub-RR';
   
   % plot fitted and "measured" no2 spectrum
     for i=1:100:length(s.t)
         figure(8888);
         plot(s.w((wln)),no2spectrum(i,:),'-k','linewidth',2);hold on;
         plot(s.w((wln)),no2fit(i,:),'-r','linewidth',2);hold on;
         plot(s.w((wln)),no2residual(i,:),':k','linewidth',2);hold off;
         xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcd_smooth(i)),' RMSE = ',num2str(RMSEno2(i))),...
                'fontsize',14,'fontweight','bold');
         ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted NO_{2} spectrum','residual');
         set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
         pause(0.001);
     end

   % no2OD is the spectrum portion to subtract
    gas.no2Inv    = no2vcd_smooth;%NO2conc;%in [DU]
    gas.no2resiInv= RMSEno2;%sqrt(NO2resi);
    
    
    
    
    % define baseline array
    
    to = [ones(length(wln),1) s.w(wln)'];
    
    % orthogonalize/ create normalization
     
    [qno2 rno2]         = gram_schmidt([to no2_298Kcoef(wln)]);      no2_norm     = sqrt(no2_298Kcoef(wln)'*no2_298Kcoef(wln));
    [qno2diff rno2diff] = gram_schmidt([to no2coefdiff(wln)]);       no2diff_norm = sqrt(no2coefdiff(wln)'*no2coefdiff(wln));
    [qo3  ro3 ]         = gram_schmidt([to o3coef(wln)]);            o3_norm      = sqrt(o3coef(wln)'*o3coef(wln));
    [qo4  ro4 ]         = gram_schmidt([to(:,1) o4coef(wln)]);       o4_norm      = sqrt(o4coef(wln)'*o4coef(wln));
   
    
     
    % plot orthonormal cross sections
    figure(1001);
    plot(s.w(wln),spectrum_sub(15,:),'-k');hold on;
    plot(s.w(wln),qno2(:,end),'-r');hold on;
    plot(s.w(wln),qno2diff(:,end),'-m');hold on;
    plot(s.w(wln),qo3(:,end),'-c');hold on;
    %plot(s.w(wln),o4coef(wln)*100000,'-g');hold off;
    plot(s.w(wln),qo4(:,end),'-g');hold off;
    legend('meas','diff no2 298K','diff no2 220-298K','diff o3',' diff o4');
    
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
   
   no2Err   = (spectrum_sub'-RR_d(:,:))./repmat((no2_298Kcoef(wln)),1,length(s.t));      % in atm cm
   MSEno2DU = real(((1/length(wln))*sum(no2Err.^2))');                                 % convert from atm cm to DU
   RMSEno2  = real(sqrt(real(MSEno2DU)));
   
   figure;subplot(211);plot(tplot,no2VCD,'.r');hold on;
          plot(tplot,no2vcd_smooth,'.g');hold on;
          axis([tplot(1) tplot(end) 0 0.3]);
          xlabel('time');ylabel('no2 [DU]');
          legend('linear inversion','linear inversion smooth');
          subplot(212);plot(tplot,RMSEno2,'.r');hold on;
          axis([tplot(1) tplot(end) 0 0.010]);
          xlabel('time');ylabel('no2 RMSE [DU]');
          
   % prepare to plot spectrum OD and no2 cross section
   
   no2spectrum     = spectrum_sub-RR_d' + 1000*ccoef_d(1,:)'*basis(:,1)';
   no2fit          = 1000*ccoef_d(1,:)'*basis(:,1)';
   no2residual     = spectrum_sub-RR_d';
   
   % plot fitted and "measured" no2 spectrum
     for i=1:100:length(s.t)
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

   % no2OD is the spectrum portion to subtract
    gas.no2Inv    = no2vcd_smooth;%NO2conc;%in [DU]
    gas.no2resiInv= RMSEno2;%sqrt(NO2resi);
    
  
    
    
    
    
    
    
    
    
    
    
    
    
    % scale back
    scale = [no2_norm no2diff_norm o3_norm 1];
    scd_   = x./scale;
    scd    = [scd;scd_];
    recon_=Abasis*x';
    recon=[recon; recon_'];
    res_ = b - recon_;
    res  = [res;res_'];
    xno2 = sc_(1)*no2coef(wln);
    
    figure(11);plot(s.w(wln),b*7,'-k');hold on;
           plot(s.w(wln),(recon_),'--r');
    
%     if issparse(A), [Q,R,e]=qr(A,'vector');
%     else R = triu(qr(A));  [Q,rr,e]=qr(A,'vector'); end
%     x = R\(R'\(A'*b));
%     xno2 = Q*rr(:,5)*x(5);
%     xo4  = Q*rr(:,4)*x(6);
%     xo3  = Q*rr(:,3)*x(7);
%     r = b - A*x;
%     err = R\(R'\(A'*r));
%     error = [error;err'];
%     x = x + err;
    
    figure(1111);
    plot(s.w(wln),b-Abasis(:,[5:end])*(x([5:end]))','-k');hold on;% diff no2 meas
    plot(s.w(wln),xno2,':r');hold off;legend('no2 meas','no2 fit');
%     
 
 
 
 
%% end of baseline subtraction 