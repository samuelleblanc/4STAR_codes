%% Details of the function:
% NAME:
%   retrieveO3
% 
% PURPOSE:
%   retrieves O3 using a given (start,end) wavelength range
%   using differential cross section and linear inversion
% 
%
% CALLING SEQUENCE:
%  function [o3] = retrieveO3(s,wstart,wend)
%
% INPUT:
%  - s: starsun struct from starwarapper
%  - wstart  : wavelength range start in micron
%  - wend    : wavelength range start in micron
% 
% 
% OUTPUT:
%   o3.o3vcdDU = o3 vertical column density [DU]
%   o3.o3resiDU= o3 residual [DU];
%   o3.o3OD    = o3 optical depth
%   o3.o4OD    = o4 optical depth (from O3 band retrieval)
%   o3.h2oOD   = h2o optical depth from O3 band retrieval
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.
%  - loadCrossSections_global.m
%
% NEEDED FILES:
%  - *.xs under data_folder
%
% EXAMPLE:
%  - [o3] = retrieveO3(s,0.490,0.6823);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, 2016-04 based on former versions
% from gasessubtract.m
% -------------------------------------------------------------------------
%% function routine
function [o3] = retrieveO3(s,wstart,wend)

plotting = 0;
% load cross-sections
loadCrossSections_global;

 % find wavelength range index
 istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
 iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
 
 wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
 
 % calculate residual spectrum (Rayleigh subtracted)
 % eta = repmat(log(s.c0(wln)),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);
 
 
%% retrieve by doing linear inversion first and then fit   
%% linear inversion
 
 basis=[o3coef(wln), o4coef(wln), no2coef(wln) h2ocoef(wln)...
        ones(length(wln),1) s.w(wln)'.*ones(length(wln),1) ((s.w(wln)').^2).*ones(length(wln),1) ((s.w(wln)').^3).*ones(length(wln),1)];
 
   ccoef=[];
   RR=[];
   % o3 inversion is being done on total slant path (not Rayleigh
   % subtracted)
   for k=1:length(s.t);
        meas = log(s.c0(wln)'./s.rateslant(k,(wln))');
        coef=basis\meas;
        %coefo3=basiso3\tau_OD(k,(wln))';
        recon=basis*coef;
        RR=[RR recon];
        ccoef=[ccoef coef];
   end
   
   % calculate vcd
   
   % create smooth o3 time-series
   xts = 60/3600;   %60 sec in decimal time
   
   o3VCD = real((((ccoef(1,:))*1000))')./s.m_O3;
   tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
   [o3VCDsmooth, sn] = boxxfilt(tplot, o3VCD, xts);
   o3vcd_smooth = real(o3VCDsmooth);
   
   % checkexiting toolbox
   %v=ver;f=any(strcmp('optim', {v.Name}));
   %license('test', 'optim_toolbox')
   
   % save linear inversion coefficients as input to constrained retrieval
   
   x0=[ccoef(1,:)' ccoef(2,:)' ccoef(4,:)' ccoef(5,:)' ccoef(6,:)' ccoef(7,:)' ccoef(8,:)'];
   
   O3conc=[];H2Oconc=[];O4conc=[];O2conc=[];O3resi=[];o3OD=[];
   
   % perform constrained retrieval
   
  [O3conc, H2Oconc, O4conc, O3resi, o3OD, varall_lin] = o3corecalc_lin_adj(s,o3coef,o4coef,h2ocoef,wln,s.tau_aero,x0);
   
   
   [O3conc_s, sn] = boxxfilt(tplot, O3conc, xts);
   O3conc_smooth = real(O3conc_s);
   % save smooth values
   %gas.o3 = O3conc_smooth;
   %gas.o3resi = (O3resi);
   %gas.o4  = O4conc; % already converted in routine./s.m_ray; % slant converted to vertical
   %gas.h2o = H2Oconc;% already converted in routine./s.m_H2O;% slant converted to vertical
   %gas.o3OD  = o3OD; % this is to be subtracted from slant path this is slant
   %tplot = serial2hs(s.t);
   
   o3amount  = -log(exp(-(real(O3conc/1000)*o3coef')));%(O3conc/1000)*o3coef';
   o4coefVIS = zeros(length(s.w),1); o4coefVIS(1:1044) = o4coef(1:1044);
   o4amount  = -log(exp(-(real(O4conc)*o4coef')));%O4conc*o4coef';
   h2ocoefVIS= zeros(length(s.w),1); h2ocoefVIS(wln) = h2ocoef(wln);
   h2oamount = -log(exp(-(real(H2Oconc)*h2ocoefVIS')));%H2Oconc*h2ocoefVIS';
   %tau_OD_fitsubtract = tau_ODslant - o3amount - o4amount -h2oamount;
   %tau_OD_fitsubtract4 = tau_OD_fitsubtract3 - real(o3amount) - real(o4amount) -real(h2oamount);% subtraction of remaining gases in o3 region
   
    
%    % calculate error
   tau_OD  = s.tau_tot_vertical;% need to also check tau_tot_slant;
   o3Err   = (tau_OD(:,wln)'-RR(:,:))./repmat((o3coef(wln)),1,length(s.t));    % in atm cm
   MSEo3DU = real(((1/length(wln))*sum(o3Err.^2))');                           % convert from atm cm to DU
   RMSEo3  = real(sqrt(real(MSEo3DU)));
   
   gas.o3Inv    = o3VCD;%o3vcd_smooth is the default output;
   gas.o3Inv    = o3vcd_smooth;
   gas.o3resiInv= RMSEo3;

   if plotting
       figure;subplot(211);plot(tplot,o3VCD,'.r');hold on;
              plot(tplot,o3vcd_smooth,'.g');hold on;
              plot(tplot,O3conc_smooth,'.r');hold on;
              axis([tplot(1) tplot(end) 250 350]);
              xlabel('time');ylabel('o3 [DU]');
              legend('inversion','inversion smooth','constrained inversion smooth');
              subplot(212);plot(tplot,RMSEo3,'.r');hold on;
              axis([tplot(1) tplot(end) 0 5]);
              xlabel('time');ylabel('o3 RMSE [DU]');
              title([datestr(s.t(1),'yyyy-mm-dd'), 'linear inversion']);
   end
          
   % prepare to plot spectrum OD and o3 cross section
   
   tau_OD = log(repmat(s.c0(wln),length(s.t),1)./s.rateslant(:,(wln)));
   o3spectrum     = tau_OD-RR' + ccoef(1,:)'*basis(:,1)';
   o3fit          = ccoef(1,:)'*basis(:,1)';
   o3residual     = tau_OD-RR';

   if plotting
%      plot fitted and "measured" o3 spectrum
         for i=1:1000:length(s.t)
             figure(111);
             plot(s.w((wln)),o3spectrum(i,:),'-k','linewidth',2);hold on;
             plot(s.w((wln)),o3fit(i,:),'-r','linewidth',2);hold on;
             plot(s.w((wln)),o3residual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' o3VCD= ',num2str(o3vcd_smooth(i)),' RMSE = ',num2str(RMSEo3(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted O_{3} spectrum','residual');
             set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
             pause(1);
         end
   end

   % save parameters
    o3.o3DU    = O3conc_smooth;
    o3.o3resiDU= O3resi;%RMSEo3;
    
    o3.o4      = O4conc;
    o3.h2o     = H2Oconc;
    
    o3.o3OD    = o3amount;%(O3conc/1000)*o3coef';
    o3.o4OD    = o4amount;
    o3.h2oOD   = h2oamount;
    
  
 
 return;