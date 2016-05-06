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
%  function [no2] = retrieveNO2(s,wstart,wend)
%
% INPUT:
%  - s: starsun struct from starwarapper
%  - wstart  : wavelength range start in micron
%  - wend    : wavelength range start in micron
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
%  - backcor.m
%  - gram_schmidt.m
%
% NEEDED FILES:
%  - *.xs under data_folder
%
% EXAMPLE:
%  - [no2] = retrieveNO2(s,0.430,0.490);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, 2016-04 based on former versions
% 
% -------------------------------------------------------------------------
%% function routine
function [no2] = retrieveNO2(s,wstart,wend)

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
 
 % calculate residual spectrum (Rayleigh subtracted)
 eta = repmat(log(s.c0(wln)),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);

%% fit a linear line to spectra
%===============================
% linear fit calculated and subtracted from the spectrum to get an estimation of the aerosol amount 
% and any scattered contribution to the measurement
% calculate linear fit and create residual spectrum

for i=1:length(s.t)
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


if plotting
% plot residual to fit (which is 470nm).
        figure;
        plot(s.m_aero,1000*eta_residual(:,ires),'.','color',[0.8,0.8,0.8],'markersize',8);
        axis([min(s.m_aero) max(s.m_aero) -10 20]);
end

% do linear retrieval first (no wavelength shift) 
% basis = [no2coef(wln), no2coefdiff(wln), o4coef(wln), o3coef(wln)];
  

    % this is end member array (original cross sections)
    % basis = [no2_298Kcoef(wln), no2coefdiff(wln), o4coef(wln), o3coef(wln)];% this was original
    basis = [no2_298Kcoef(wln), no2coefdiff(wln), o3coef(wln), o4coef(wln), ones(length(wln),1)];

    
    % define baseline array
    
    to = [ones(length(wln),1) s.w(wln)'];
    
    % orthogonalize/ create normalization
     
    [qno2 rno2]         = gram_schmidt([to no2_298Kcoef(wln)]);      no2_norm     = sqrt(no2_298Kcoef(wln)'*no2_298Kcoef(wln));
    [qno2diff rno2diff] = gram_schmidt([to no2coefdiff(wln)]);       no2diff_norm = sqrt(no2coefdiff(wln)'*no2coefdiff(wln));
    [qo3  ro3 ]         = gram_schmidt([to o3coef(wln)]);            o3_norm      = sqrt(o3coef(wln)'*o3coef(wln));
    [qo4  ro4 ]         = gram_schmidt([to(:,1) o4coef(wln)]);       o4_norm      = sqrt(o4coef(wln)'*o4coef(wln));
   
    
    if plotting 
    % plot orthonormal cross sections
            figure(10011);
            plot(s.w(wln),20*eta_residual(15,:),'-k');hold on;
            plot(s.w(wln),qno2(:,end),'-r');hold on;
            plot(s.w(wln),qno2diff(:,end),'-m');hold on;
            plot(s.w(wln),qo3(:,end),'-c');hold on;
            plot(s.w(wln),o4coef(wln)/o4_norm,'-g');hold off;
            % plot(s.w(wln),qo4(:,end),'-g');hold off;
            %legend('meas','diff no2 298K','diff no2 220-298K','diff o3',' o4');
            % swirched to 298-220
            legend('meas','diff no2 298K','diff no2 298-220K','diff o3',' o4');
    end
    
    % Abasis = [qno2(:,end) no2coefdiff(wln) qo3(:,end) o4coef(wln) to];%./repmat(scale,length(b),1);
    % Abasis = [qno2(:,end) qno2diff(:,end)  qo3(:,end) o4coef(wln)];%./repmat(scale,length(b),1);
    % Abasis = [qno2(:,end) qno2diff(:,end)  qo3(:,end) qo4(:,end)];%./repmat(scale,length(b),1);
    % Abasis = [qno2(:,end)/no2_norm qno2diff(:,end)/no2diff_norm  qo3(:,end)/o3_norm qo4(:,end) ones(length(wln),1)];
    Abasis = [qno2(:,end)/no2_norm qno2diff(:,end)/no2diff_norm  qo3(:,end)/o3_norm o4coef(wln)/o4_norm ones(length(wln),1)];
    
    % solve
    % x = real(Abasis\spectrum_sub');
    
    ccoef_d=[];
    RR_d=[];
    scale = [no2_norm; no2diff_norm; o3_norm; 1; 1];
    
    for k=1:length(s.t);
        %coef=real(Abasis\spectrum_sub(k,:)');
        coef=real(Abasis\eta_residual(k,:)');
        % scale coef back
        scoef = coef;%./scale;
                
        % reconstruct spectrum
        %recon=Abasis*scoef;
        recon=Abasis*scoef;
        RR_d=[RR_d recon];
        ccoef_d=[ccoef_d scoef];
    end 
    
    % to get back to regular cross section:
    % test_spec=qno2*rno2;
    
    % calculate no2 vcd
    % covert from atm x cm to molec/cm^2
   no2_amount =  ccoef_d(1,:)/no2_norm/rno2(end,end);
   no2VCD = real((((Loschmidt*no2_amount))./(s.m_NO2)')');
   % no2VCD = real((((Loschmidt*ccoef_d(1,:))./(s.m_NO2)')'));
   % create smooth no2 time-series
   xts = 60/3600;   %60 sec in decimal time
   tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
   [no2VCDsmooth, sn] = boxxfilt(tplot, no2VCD, xts);
   no2vcd_smooth = real(no2VCDsmooth);
   
   % calculate error
   
   no2Err   = (eta_residual'-RR_d(:,:))./repmat((no2_298Kcoef(wln)),1,length(s.t));      
   MSEno2DU = real(((1/length(wln))*sum((no2Err).^2))');                                 
   RMSEno2  = real(sqrt(real(MSEno2DU)));
   
   if plotting
       figure;subplot(211);plot(tplot,no2VCD,'.r');hold on;
              plot(tplot,no2vcd_smooth,'.g');hold on;
              axis([tplot(1) tplot(end) 0 2.5e16]);
              xlabel('time');ylabel('no2 [molec/cm^{2}]');
              legend('linear inversion','linear inversion smooth');
              subplot(212);plot(tplot,RMSEno2,'.r');hold on;
              axis([tplot(1) tplot(end) 0 0.005]);
              xlabel('time');ylabel('no2 RMSE');
   end
          
   % prepare to plot spectrum OD and no2 cross section
   
   no2spectrum     = eta_residual-RR_d' + (ccoef_d(1,:)/no2_norm)'*basis(:,1)';
   no2fit          = (ccoef_d(1,:)/no2_norm)'*basis(:,1)';
   no2residual     = eta_residual-RR_d';
   
   no2meas     = eta_residual - (ccoef_d(2,:)')*basis(:,2)' - (ccoef_d(3,:)')*basis(:,3)' - (ccoef_d(4,:)')*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)';
   no2fit      = (ccoef_d(1,:)')*basis(:,1)';
   no2residual = eta_residual - (ccoef_d(1,:)')*basis(:,1)' - (ccoef_d(2,:)')*basis(:,2)' - (ccoef_d(3,:)')*basis(:,3)' - ccoef_d(4,:)'*basis(:,4)' - ccoef_d(5,:)'*basis(:,5)';
   
   if plotting
   % plot fitted and "measured" no2 spectrum
         for i=1:10:length(s.t)
             figure(8882);
             %plot(s.w((wln)),spectrum_sub(i,:),'--k','linewidth',2);hold on;
             %plot(s.w((wln)),no2meas(i,:),'-y','linewidth',2);hold on;
             %plot(s.w((wln)),RR_d(:,i),'--c','linewidth',2);hold on;
             plot(s.w((wln)),no2spectrum(i,:),'-k','linewidth',2);hold on;
             plot(s.w((wln)),no2fit(i,:),'--r','linewidth',2);hold on;
             plot(s.w((wln)),no2residual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcd_smooth(i)/(Loschmidt/1000)),' RMSE = ',num2str(RMSEno2(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');
             legend('measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             %legend('total spectrum baseline and rayliegh subtracted','reconstructed spectrum','measured NO_{2} spectrum','fitted NO_{2} spectrum','residual');
             set(gca,'fontsize',12,'fontweight','bold');axis([wstart wend -5e-3 0.02]);legend('boxoff');
             pause(0.001);
         end
   end

   % no2OD is the spectrum portion to subtract
    no2.no2_molec_cm2    = no2vcd_smooth;
    no2.no2resi          = RMSEno2;
    no2.no2OD            = (no2VCD/Loschmidt)*no2_298Kcoef';% this is optical depth
    