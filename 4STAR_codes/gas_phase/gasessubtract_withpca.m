%% Details of the function:
% NAME:
%   gasessubtract
% 
% PURPOSE:
%   retrieval of gases amounts using best fit amounts for: 
%   h20,o2,co2,ch4,o3,o4,no2; these amounts are being
%   subtracted from tau_aero spectrum (Rayleigh corrected)
% 
%
% CALLING SEQUENCE:
%  function [tau_sub gas] = gasessubtract(starsun)
%
% INPUT:
%  - starsun: starsun struct from starwarapper
%  - model_atmosphere: needed to decide which coef set to use
% 
% 
% OUTPUT:
%  - tau_sub: subtracted tau_aero spectrum
%  - gas: gases struct that includes all retrieved values
%  - gas.O3conc and gas.NO2conc are in DU and are retrieved products
%  - note that currently NO2 is not optimized as well!
%  - other quantities in gas struct are still subject to further check
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%
% NEEDED FILES:
%  - *.xs read by loadCrosSsections.m file 
%
% EXAMPLE:
%  - [tau_sub gas] = gasessubtract(starsun);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MSR), NASA Ames,July 25th, 2014
% 2014-08-07 MSR: cleaned subroutine
% 2014-08-14 MSR: no2 subtraction is constant (no2 retrieval not optimized)
% 2014-11-17 MSR: cleaned routine (deleted repeated CWV routine)
%                 switched tau_OD_wvsubtract to be an input variable from cwvcorecalc: starsun.cwv.tau_OD_wvsubtract;  
%                 optimized gases subtraction from total OD spectra
% 2015-02-18 MSR: added pca filter before no2 retrieval
% -------------------------------------------------------------------------
%% function routine

function [tau_sub gas] = gasessubtract(s)
%----------------------------------------------------------------------
 showfigure = 0;
 Loschmidt=2.686763e19;                   % molec/cm3*atm
 colorfig = [0 0 1; 1 0 0; 1 0 1;1 1 0;0 1 1];
 % load cross-sections
 loadCrossSections;
%----------------------------------------------------------------------
%% set wavelength ranges for best fit calc

wvis = s.w(1:1044);
wnir = s.w(1045:end);
%
% find wavelength range for vis/nir gases bands
% h2o
 nm_0685 = interp1(wvis,[1:length(wvis)],0.680,  'nearest');
 nm_0750 = interp1(wvis,[1:length(wvis)],0.750,  'nearest');
 nm_0780 = interp1(wvis,[1:length(wvis)],0.781,  'nearest');
 nm_0870 = interp1(wvis,[1:length(wvis)],0.869,  'nearest');
 nm_0880 = interp1(wvis,[1:length(wvis)],0.8820, 'nearest');%0.8823
 nm_0990 = interp1(wvis,[1:length(wvis)],0.9940, 'nearest');%0.994
 nm_1040 = interp1(s.w,[1:length(s.w)],1.038,  'nearest');
 nm_1240 = interp1(s.w,[1:length(s.w)],1.245,  'nearest');
 nm_1300 = interp1(s.w,[1:length(s.w)],1.241,  'nearest');% 1.282
 nm_1520 = interp1(s.w,[1:length(s.w)],1.555,  'nearest');
 % o2
 nm_0684 = interp1(wvis,[1:length(wvis)],0.684,  'nearest');
 nm_0695 = interp1(wvis,[1:length(wvis)],0.695,  'nearest');
 nm_0757 = interp1(wvis,[1:length(wvis)],0.756,  'nearest');
 nm_0768 = interp1(wvis,[1:length(wvis)],0.780,  'nearest');
 % co2
 nm_1555 = interp1(s.w,[1:length(s.w)],1.555,  'nearest');
 nm_1630 = interp1(s.w,[1:length(s.w)],1.630,  'nearest');
 % o3 (with h2o and o4)
 nm_0470 = interp1(wvis,[1:length(wvis)],0.470,  'nearest');
 nm_0490 = interp1(wvis,[1:length(wvis)],0.490,  'nearest');
 nm_0675 = interp1(wvis,[1:length(wvis)],0.6823,  'nearest');%0.675
 
 % no2 (with o3 and o4)
 nm_0400 = interp1(wvis,[1:length(wvis)],0.430,  'nearest');
 nm_0500 = interp1(wvis,[1:length(wvis)],0.490,  'nearest');
 
 wln_vis1 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880)); 
 wln_vis2 = find(wvis<=wvis(nm_0870)&wvis>=wvis(nm_0780)); 
 wln_vis3 = find(wvis<=wvis(nm_0750)&wvis>=wvis(nm_0685)); 
 wln_vis4 = find(wvis<=wvis(nm_0695)&wvis>=wvis(nm_0684)); 
 wln_vis5 = find(wvis<=wvis(nm_0768)&wvis>=wvis(nm_0757)); 
 wln_vis6 = find(wvis<=wvis(nm_0675)&wvis>=wvis(nm_0490)); 
 wln_vis7 = find(wvis<=wvis(nm_0500)&wvis>=wvis(nm_0400)); 
 wln_nir1 = find(s.w<=s.w(nm_1240)&s.w>=s.w(nm_1040)); 
 wln_nir2 = find(s.w<=s.w(nm_1520)&s.w>=s.w(nm_1300)); 
 wln_nir3 = find(s.w<=s.w(nm_1630)&s.w>=s.w(nm_1555)); 
 
 qqvis = length(wvis);
 qqnir = length(wnir);
 pp    = length(s.t);
 qq    = length(s.w);
 
 sundist   = repmat(s.f(1),length(s.t),length(s.w));
 calibc0   = repmat(s.c0,length(s.t),1);
 spc       = s.rate./calibc0./sundist;
 Tslant    = spc.*exp((s.tau_ray).*repmat(s.m_ray,1,length(s.w)));
 tau_ODslant = -log(Tslant);
 tau_OD      = tau_ODslant./repmat(s.m_aero,1,qq);
 
 %rateall    = real(starsun.rate./repmat(starsun.f,1,qq)./tr(starsun.m_ray, starsun.tau_ray)); % rate adjusted for the Rayleigh component
 %tau_OD     = real(-log(rateall./repmat(starsun.c0,pp,1)));%./repmat(starsun.m_aero,1,qq));   % total slant optical depth (Rayeigh subtracted)
 
% plot spectra
% figure;plot(starsun.w,tau_ODslant(17760,:)/starsun.m_aero(17760),'-b');
% hold on;plot(starsun.w,starsun.tau_aero(17760,:),'--r');
% %hold on;plot(wvis,-log(spc_vis_lamp(2252,:)),'--c');
% legend('lampOD','tau-aero');xlabel('wavelength');ylabel('vertical OD');

% figure;plot([wvis wnir],tau_ODslant(end-500,:),'-b');
% hold on;plot([wvis wnir],starsun.tau_a_avg(end-500,:),'--r');
% %hold on;plot(wvis,-log(spc_vis_lamp(2252,:)),'--c');
% legend('total OD (Rayleigh sub)','tau-aero (constant subtraction)');xlabel('wavelength');ylabel('vertical OD');

% make subtraction array
% tau_OD_wvsubtract  = tau_OD;
% spectrum           = tau_OD(:,wln);
%
%-------------------------------------
% assign wv subtracted array (from cwvcorecalc.m routine) to OD
% 1 is only wv subtracted (no O3 region)-input from cwvcorecalc routine
  tau_OD_fitsubtract1 = s.cwv.tau_OD_wvsubtract./repmat(s.m_aero,1,qq);  %m_aero and m_H2O are the same
%----------------------------------------------------------------------
%% subtract/retrieve CO2
    wln = wln_nir3;
   [CH4conc CO2conc CO2resi co2OD,tau_co2ch4_subtract] = co2corecalc(s,ch4coef,co2coef,wln,tau_OD);
   gas.band1600co2 = CO2conc;       % this is vertical column amount
   gas.band1600ch4 = CH4conc;       % this is vertical column amount
   gas.band1600resi= CO2resi;
   co2amount = CO2conc*co2coef';    % this is wavelength dependent slant OD
   ch4amount = CH4conc*ch4coef';    % this is wavelength dependent slant OD
   tau_OD_fitsubtract2 = tau_OD_fitsubtract1 - co2amount - ch4amount;   % this is wv, co2 and ch4 subtraction
%  tau_OD_fitsubtract2 = tau_OD_fitsubtract1 - tau_co2ch4_subtract;
%     figure;
%     plot(starsun.w,tau_OD(end-500,:),'-b');hold on;
%     plot(starsun.w,tau_OD(end-500,:)-co2amount(end-500,:),'--g');xlabel('wavelength');ylabel('OD');
%     plot(starsun.w,tau_OD(end-500,:)-ch4amount(end-500,:),'--c');xlabel('wavelength');ylabel('OD');
%     plot(starsun.w,tau_OD(end-500,:)-co2amount(end-500,:)-ch4amount(end-500,:),'--k');xlabel('wavelength');ylabel('OD');
%     legend('total OD','OD after CO2 subtraction','OD after CH4 subtraction','OD after CO2+CH4 subtraction');
   %tau_aero_fitsubtract = tau_OD_wvsubtract - co2amount - ch4amount;
   %tau_aero_fitsubtract(:,wln_nir3) = tau_OD(:,wln_nir3) - co2subtract;
   %spec_subtract(:,wln_nir3) = co2spec;
%%
%% subtract/retrieve O2
% for ii=2
%     if ii==1
%         wln = wln_vis4;
%     elseif ii==2
      wln = wln_vis5;
%     end
% !!! to improve use modc0 in o2 region? and shift/stretch
%     O2conc = []; O2resi = [];
%    [O2conc O2resi o2OD] = o2corecalc(starsun,o2coef,wln,tau_ODslant);
%    if ii==1
%        gas.band680o2  = O2conc./starsun.m_ray_avg;% slant converted to vertical
%        gas.band680resi= O2resi;
%        gas.band680OD  = o2OD;
%    elseif ii==2
%        gas.band760o2  = O2conc;%./starsun.m_ray_avg;% slant converted to vertical
%        gas.band760resi= O2resi;
%        gas.band760OD  = o2OD;
%    end
% end
%o2amount = -log(exp(-(real(O2conc)*o2coef')));%O2conc*o2coef';
tau_OD_fitsubtract3 = tau_OD_fitsubtract2;% - o2amount;% o2 subtraction
% figure;
% plot(starsun.w,tau_ODslant(end-500,:),'-b');hold on;
% plot(starsun.w,tau_ODslant(end-500,:)-o2amount(end-500,:),'--c');xlabel('wavelength');ylabel('OD');
% legend('total OD','OD after O2 subtraction');
%tau_aero_fitsubtract(:,wln_vis5) = tau_ODslant(:,wln_vis5) - o2subtract;
%tau_aero_fitsubtract(:,wln_vis5) = o2subtract(:,wln_vis5);
%spec_subtract(:,wln_vis5) = o2spec;
%%
%% subtract/retrieve O3/h2o/o4 region
   wln = wln_vis6;
   O3conc=[];H2Oconc=[];O4conc=[];O3resi=[];o3OD=[];
   [O3conc H2Oconc O4conc O3resi o3OD] = o3corecalc(s,o3coef,o4coef,h2ocoef,wln,tau_OD);
   gas.o3  = O3conc; % in [DU] slant converted to vertical
   gas.o4  = O4conc; % slant converted to vertical
   gas.h2o = H2Oconc;% slant converted to vertical
   gas.o3resi= sqrt(O3resi);
   gas.o3OD  = o3OD;                    % this is to be subtracted from slant path;
   
   o3amount = -log(exp(-(real(O3conc/1000)*o3coef')));%(O3conc/1000)*o3coef';
   o4amount = -log(exp(-(real(O4conc)*o4coef')));%O4conc*o4coef';
   h2ocoefVIS = zeros(qq,1); h2ocoefVIS(wln_vis6) = h2ocoef(wln_vis6);
   h2oamount= -log(exp(-(real(H2Oconc)*h2ocoefVIS')));%H2Oconc*h2ocoefVIS';
   %tau_OD_fitsubtract = tau_ODslant - o3amount - o4amount -h2oamount;
   tau_OD_fitsubtract4 = tau_OD_fitsubtract3 - o3amount - o4amount -h2oamount;% subtraction of remaining gases in o3 region
%    figure;
%    plot(starsun.w,tau_ODslant(end-500,:),'-b');hold on;
%    plot(starsun.w,tau_ODslant(end-500,:)-o3amount(end-500,:),'--r');xlabel('wavelength');ylabel('OD');
%    plot(starsun.w,tau_ODslant(end-500,:)-o4amount(end-500,:),'--c');xlabel('wavelength');ylabel('OD');
%    plot(starsun.w,tau_ODslant(end-500,:)-h2oamount(end-500,:),'--g');xlabel('wavelength');ylabel('OD');
%    plot(starsun.w,tau_ODslant(end-500,:)-o3amount(end-500,:)-o4amount(end-500,:)-h2oamount(end-500,:),'-k','linewidth',1.5);hold on;
%    plot(starsun.w,starsun.tau_a_avg(end-500,:),'-m','linewidth',1.5);
%    xlabel('wavelength');ylabel('OD');
%   
%    legend('total OD','OD after O3 subtraction','OD after O4 subtraction','OD after H2O subtraction','OD after O3+O4+H2O subtraction','tau-aero');
%    
   %tau_aero_fitsubtract(:,wln_vis6) = tau_ODslant(:,wln_vis6) - o3subtract;
   %spec_subtract(:,wln_vis6)        = o3subtract(:,wln_vis6);
%%
%% subtract/retrieve NO2/O3/O4 region
   wln = wln_vis7;
   NO2conc = []; NO2resi=[];
   
   % perform pca (full spectrum)
   [s.pcadata s.pcavisdata s.pcanirdata s.pcvis s.pcnir s.eigvis s.eignir s.pcanote] =starPCAshort(s);
   
   % reconstruct spectra for no2 retrieval
   rate_pca      = s.pcadata(:,1:1044)./repmat(s.f(1),pp,length(wvis));
   tau_pca       = -log(rate_pca./repmat(s.c0(1:length(wvis)),pp,1));
   tau_pca_mRay  = tau_pca - s.tau_ray(:,1:length(wvis)).*repmat(s.m_ray,1,length(wvis));
   tau4no2       = tau_pca_mRay./repmat(s.m_aero,1,length(wvis));
   
   % compare pca/no-pca
%    figure;
%    plot(wvis,tau_OD (10000,1:1044),'-b'); hold on;
%    plot(wvis,tau4no2(10000,1:1044),'--r');hold on;
%    legend('tau','taupca');
   
   % perform fit on pca spectra
   [NO2conc NO2resi no2OD tau_OD_fitsubtract5] = no2corecalc(s,no2coef,o4coef,o3coef,wln,tau4no2);
   no2dat = [NO2conc NO2resi];
   save('no2dat_pca_all.dat','-ASCII','no2dat');
   % perform fit on original spectra
   %[NO2conc NO2resi no2OD tau_OD_fitsubtract5] = no2corecalc(s,no2coef,o4coef,o3coef,wln,tau_OD);
   
   % perform linear inversion
   % all coef are in [atm x cm]
   basisno2=[no2coef(wln), o4coef(wln), o3coef(wln) ones(length(wln),1) wvis(wln)'.*ones(length(wln),1) ((wvis(wln)').^2).*ones(length(wln),1)];

   ccoefno2pca=[];
   RRno2pca=[];
   for k=1:pp;
        coefno2pca=basisno2\tau_pca_mRay(k,(wln))';
        reconno2pca=basisno2*coefno2pca;
        RRno2pca=[RRno2pca reconno2pca];
        ccoefno2pca=[ccoefno2pca coefno2pca];
   end
   
   % calculate no2 vcd
   no2VCDpca = real((((ccoefno2pca(1,:))*1000)./(s.m_NO2)')');
   % create smooth no2 time-series
   xts = 60/3600;   %60 sec in decimal time
   tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
   [no2VCDsmoothpca, sn] = boxxfilt(tplot, no2VCDpca, xts);
   no2vcdpca_smooth = real(no2VCDsmoothpca);
   
   % calculate error
   no2Err   = (tau_pca_mRay(:,(wln))'-RRno2pca(:,:))./repmat((no2coef(wln)),1,pp);    % in atm cm
   MSEno2DU = real((1000*(1/length(wln))*sum(no2Err.^2))');                           % convert from atm cm to DU
   RMSEno2  = real(sqrt(real(MSEno2DU)));
   
   figure;subplot(211);plot(tplot,no2VCDpca,'.r');hold on;
          plot(tplot,no2vcdpca_smooth,'.g');hold on;
          axis([tplot(1) tplot(end) 0 0.3]);
          xlabel('time');ylabel('no2 [DU]');
          legend('pca inversion','pca inversion smooth');
          subplot(212);plot(tplot,RMSEno2,'.r');hold on;
          axis([tplot(1) tplot(end) 0 0.005]);
          xlabel('time');ylabel('no2 RMSE [DU]');
          
   % prepare to plot spectrum OD and no2 cross section
   no2spectrum_pca     = tau_pca_mRay(:,(wln))-RRno2pca' + ccoefno2pca(1,:)'*basisno2(:,1)';
   no2fit_pca          = ccoefno2pca(1,:)'*basisno2(:,1)';
   no2residual_pca     = tau_pca_mRay(:,(wln))-RRno2pca';
   
   % 8. plot fitted and "measured" no2 spectrum
     for i=1:10:length(s.t)
         figure(888);
         plot(wvis((wln)),no2spectrum_pca(i,:),'-k','linewidth',2);hold on;
         plot(wvis((wln)),no2fit_pca(i,:),'-r','linewidth',2);hold on;
         plot(wvis((wln)),no2residual_pca(i,:),':k','linewidth',2);hold off;
         xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcdpca(i)),' RMSE = ',num2str(RMSEno2(i))),...
                'fontsize',14,'fontweight','bold');
         ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted NO_{2} spectrum','residual');
         set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
         pause(0.001);
     end

   % no2OD is the spectrum portion to subtract
   gas.no2  = NO2conc;%in [DU]
   gas.no2resi= sqrt(NO2resi);
   gas.no2OD  = no2OD;% this is to be subtracted from total OD;
   no2amount = (NO2conc)*no2coef';
   %no2amount = (1.86e-4)*repmat(no2coef',pp,1);  % constant value
   tau_OD_fitsubtract5 = tau_OD_fitsubtract4 - no2amount;
   tau_sub = tau_OD_fitsubtract5;%tau_OD_fitsubtract4;
   %tau_sub(:,1:nm_0490) = starsun.tau_a_avg(:,1:nm_0490);
   tau_sub(:,1:nm_0470) = s.tau_aero(:,1:nm_0470);
%    figure;
%    plot(starsun.w,tau_ODslant(end-500,:),'-b');hold on;
%    plot(starsun.w,tau_ODslant(end-500,:)-no2amount(end-500,:),'--y');xlabel('wavelength');ylabel('OD');
%    legend('total OD','OD after NO2 subtraction');
   %tau_aero_fitsubtract(:,wln_vis7) = tau_ODslant(:,wln_vis7) - no2subtract;
   %spec_subtract(:,wln_vis6)        = o3subtract(:,wln_vis6);
%% end fmincon
%%
% plot subtraction results
% comment out to increase speed
% for k=1:500:length(starsun.t)
%    figure(1111);
%    plot(starsun.w,tau_ODslant(k,:),'-b','linewidth',2);hold on;
%    plot(starsun.w,tau_ODslant_fitsubtract1(k,:),'--r','linewidth',2);hold on;%wv
%    plot(starsun.w,tau_ODslant_fitsubtract2(k,:),'--g','linewidth',2);hold on;%co2+ch4
%    plot(starsun.w,tau_ODslant_fitsubtract3(k,:),'--c','linewidth',2);hold on;%o2
%    plot(starsun.w,tau_ODslant_fitsubtract4(k,:),'--y','linewidth',2);hold on;%o3+o4+h2o
%    plot(starsun.w,tau_sub(k,:),'--m','linewidth',2);hold on;%no2
%    plot([wvis wnir],starsun.tau_a_avg(k,:),':k','linewidth',2);hold off;
%    xlabel('wavelength');ylabel('OD');legend('total OD','wv (940 nm) subtraction','co2+ch4 subtraction','o2 subtraction','o3+o4+h2o subtraction','no2 subtraction','tau-aero');
%    xlabel('wavelength','fontsize',12);ylabel('OD','fontsize',12);
%                        title([datestr(starsun.t(k),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Altavg(k)) 'm']);
%                        ymax = yopt + 0.2;
%                        if max(ymax)<0 
%                            ymaxax=1; 
%                        else
%                            ymaxax=max(ymax);
%                        end;
%                       axis([0.35 1.65 0 ymaxax]);
%                       pause(0.0001);
% end
%%
%---------------------------------------------------------------------
 return;
