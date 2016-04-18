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
% 2015-02-19 MSR: replaced tau_OD with new starwrapper tau_tot fields
%                 added version set for better tracking of changes
%                 changed loadCrossSections into local function
% 2015-04-15 MSR: added various no2 spectral regions for testing
% 2015-04-21-23, MS: added versions of trace gas routined for testing
% 2015-08-06,    MS: reverted gasessubtract to original case of no2 for
%                    SEAC4RS; continue testing/editing on Michal branch
% 2015-10-21,    MS: O4/H2O are changed to be in vertical amount in
%                    o3corecalc routine so no need for the division here;
%                    this was also to correct total OD subtraction of
%                    tau_aero with the vertical amounts of O4/H2O
%                    corrected a bug to subtract o4 only in vis 
% 2016-02-22,    MS: reverted back to 2016-01-29 changes that were deleted!
%                    by recent merge
% 2016-04-06,    MS: chnaged back to original output after editing some
%                    things for MLO DB comparisons
% -------------------------------------------------------------------------
%% function routine

function [tau_sub , gas] = gasessubtract(s)
%----------------------------------------------------------------------
 version_set('1.0');
 showfigure = 0;
 
 colorfig = [0 0 1; 1 0 0; 1 0 1;1 1 0;0 1 1];
 
%% load cross-sections
   loadCrossSections_global;
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
%  nm_0490 = interp1(wvis,[1:length(wvis)],0.480,  'nearest');
%  nm_0675 = interp1(wvis,[1:length(wvis)],0.675,  'nearest');%0.675
 
 
 % no2 (with o3 and o4)
 nm_0300 = interp1(wvis,[1:length(wvis)],0.330,  'nearest');
 nm_0900 = interp1(wvis,[1:length(wvis)],0.900,  'nearest');
 nm_0400 = interp1(wvis,[1:length(wvis)],0.430,  'nearest');
 nm_0450 = interp1(wvis,[1:length(wvis)],0.450,  'nearest');
 nm_0480 = interp1(wvis,[1:length(wvis)],0.480,  'nearest');
 nm_0500 = interp1(wvis,[1:length(wvis)],0.490,  'nearest');
 nm_0515 = interp1(wvis,[1:length(wvis)],0.515,  'nearest');% this range has h2o in it...
 
 % hcoh (with no2, bro, o3 and o4)
 nm_0335 = interp1(wvis,[1:length(wvis)],0.335,  'nearest');
 nm_0359 = interp1(wvis,[1:length(wvis)],0.359,  'nearest');
 
 
 wln_vis1 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880)); 
 wln_vis2 = find(wvis<=wvis(nm_0870)&wvis>=wvis(nm_0780)); 
 wln_vis3 = find(wvis<=wvis(nm_0750)&wvis>=wvis(nm_0685)); 
 wln_vis4 = find(wvis<=wvis(nm_0695)&wvis>=wvis(nm_0684)); 
 wln_vis5 = find(wvis<=wvis(nm_0768)&wvis>=wvis(nm_0757)); 
 wln_vis6 = find(wvis<=wvis(nm_0675)&wvis>=wvis(nm_0490)); 
 wln_vis7 = find(wvis<=wvis(nm_0500)&wvis>=wvis(nm_0400)); 
 wln_vis8 = find(wvis<=wvis(nm_0450)&wvis>=wvis(nm_0400)); 
 wln_vis9 = find(wvis<=wvis(nm_0515)&wvis>=wvis(nm_0480)); 
 wln_vis10= find(wvis<=wvis(nm_0359)&wvis>=wvis(nm_0335)); 
 wln_nir1 = find(s.w<=s.w(nm_1240)&s.w>=s.w(nm_1040)); 
 wln_nir2 = find(s.w<=s.w(nm_1520)&s.w>=s.w(nm_1300)); 
 wln_nir3 = find(s.w<=s.w(nm_1630)&s.w>=s.w(nm_1555)); 
 
 qqvis = length(wvis);
 qqnir = length(wnir);
 pp    = length(s.t);
 qq    = length(s.w);
 
%  sundist   = repmat(s.f(1),length(s.t),length(s.w));
%  calibc0   = repmat(s.c0,length(s.t),1);
%  spc       = s.rate./calibc0./sundist;
%  Tslant    = spc.*exp((s.tau_ray).*repmat(s.m_ray,1,length(s.w)));
%  tau_ODslant = -log(Tslant);
%  tau_OD      = tau_ODslant./repmat(s.m_aero,1,qq);
 
 tau_OD = s.tau_tot_vertical;% need to also check tau_tot_slant;
 
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
  tau_OD_fitsubtract1 = real(s.cwv.tau_OD_wvsubtract./repmat(s.m_aero,1,qq));  %m_aero and m_H2O are the same
%----------------------------------------------------------------------
%% subtract/retrieve CO2
    wln = wln_nir3;
   [CH4conc CO2conc CO2resi co2OD,tau_co2ch4_subtract] = co2corecalc(s,ch4coef,co2coef,wln,tau_OD);
   gas.band1600co2 = CO2conc;       % this is vertical column amount
   gas.band1600ch4 = CH4conc;       % this is vertical column amount
   gas.band1600resi= CO2resi;
   co2amount = CO2conc*co2coef';    % this is wavelength dependent slant OD
   ch4amount = CH4conc*ch4coef';    % this is wavelength dependent slant OD
   tau_OD_fitsubtract2 = tau_OD_fitsubtract1 - real(co2amount) - real(ch4amount);   % this is wv, co2 and ch4 subtraction
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

%% perform pca on spectrum
%    wln4pca = find(wvis<=wvis(nm_0900)&wvis>=wvis(nm_0300));    
%    [s] =starPCA(s,wln4pca,0);
%     s.O3inm_startpca = interp1(wvis(wln4pca),[1:length(wln4pca)],0.490,   'nearest');
%     s.O3inm_endpca   = interp1(wvis(wln4pca),[1:length(wln4pca)],0.6823,  'nearest');
    
   % retrieve o3
   wln = wln_vis6;
   
   % load TOA solar spectrum
     kurvis = importdata(fullfile(starpaths,'MChKur4star_air_vis.ref'));%kur2star_vis.ref
     kur.visnm     = kurvis.data(:,1);
     kur.visIrad   = kurvis.data(:,2);
     % interpolate to wln
     s.kurO3 = interp1(kur.visnm/1000, kur.visIrad, s.w(wln),'pchip','extrap');
   
   %O3conc=[];H2Oconc=[];O4conc=[];O3resi=[];o3OD=[];
   %[O3conc H2Oconc O4conc O3resi o3OD varall_lin] = o3corecalc_lin(s,o3coef,o4coef,h2ocoef,wln,tau_OD);
   
   %[O3conc H2Oconc O4conc O3resi o3OD varall] = o3corecalc_nonlin(s,o3coef,o4coef,h2ocoef,wln,tau_OD,varall_lin);
   
%    wln = wln_vis6;
%    O3conc=[];H2Oconc=[];O4conc=[];O3resi=[];o3OD=[];
%   [O3conc H2Oconc O4conc NO2conc O3resi o3OD varall] = o3corecalc_lin_wno2(s,o3coef,o4coef,h2ocoef,no2coef,wln,tau_OD);
%    
   %gas.o3 = O3conc;
   %gas.o3resi = (O3resi);
   %gas.o4  = O4conc;% already converted in routine./s.m_ray; % slant converted to vertical
   %gas.h2o = H2Oconc;% already converted in routine./s.m_H2O;% slant converted to vertical
   %gas.o3OD  = o3OD;          % this is to be subtracted from slant path this is slant
   %tplot = serial2hs(s.t);
   
%    figure;subplot(211);plot(tplot,O3conc,'.r');hold on;
%           axis([tplot(1) tplot(end) 250 350]);
%           xlabel('time');ylabel('o3 [DU]');
%           legend('best fit','best fit smooth');
%           subplot(212);plot(tplot,sqrt(O3resi),'.r');hold on;
%           axis([tplot(1) tplot(end) 0 5]);
%           xlabel('time');ylabel('o3 RMSE [DU]');
%           title([datestr(s.t(1),'yyyy-mm-dd'), 'best fit']);
   
%    o3amount = -log(exp(-(real(O3conc/1000)*o3coef')));%(O3conc/1000)*o3coef';
%    o4coefVIS = zeros(qq,1); o4coefVIS(1:1044) = o4coef(1:1044);
%    o4amount = -log(exp(-(real(O4conc)*o4coef')));%O4conc*o4coef';
%    h2ocoefVIS = zeros(qq,1); h2ocoefVIS(wln_vis6) = h2ocoef(wln_vis6);
%    h2oamount= -log(exp(-(real(H2Oconc)*h2ocoefVIS')));%H2Oconc*h2ocoefVIS';
%    %tau_OD_fitsubtract = tau_ODslant - o3amount - o4amount -h2oamount;
%    tau_OD_fitsubtract4 = tau_OD_fitsubtract3 - real(o3amount) - real(o4amount) -real(h2oamount);% subtraction of remaining gases in o3 region
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

%% retrieve by doing linear inversion first and then fit   
%% LS for O3
 
 basiso3=[o3coef(wln), o4coef(wln), no2coef(wln) h2ocoef(wln) ones(length(wln),1) wvis(wln)'.*ones(length(wln),1) ((wvis(wln)').^2).*ones(length(wln),1) ((wvis(wln)').^3).*ones(length(wln),1)];% this seem to yield good O3 for MLO
 % not necessary to use no2 here
 %basiso3=[o3coef(wln), o4coef(wln), no2coef(wln) h2ocoef(wln) ones(length(wln),1) wvis(wln)'.*ones(length(wln),1) ((wvis(wln)').^2).*ones(length(wln),1) ((wvis(wln)').^3).*ones(length(wln),1) ((wvis(wln)').^4).*ones(length(wln),1)];% this seem to yield good O3 for MLO
 
 % adding O2 cross section
 %basiso3=[o3coef(wln), o4coef(wln), no2coef(wln) h2ocoef(wln) o2coef(wln) ones(length(wln),1) wvis(wln)'.*ones(length(wln),1) ((wvis(wln)').^2).*ones(length(wln),1) ((wvis(wln)').^3).*ones(length(wln),1)];% this seem to yield good O3 for MLO
 % not necessary to use no2 here

   ccoefo3=[];
 
   RRo3=[];
   for k=1:pp;
        meas = log(s.c0(wln)'./s.rateslant(k,(wln))');
        coefo3=basiso3\meas;
        %coefo3=basiso3\tau_OD(k,(wln))';
        recono3=basiso3*coefo3;
        RRo3=[RRo3 recono3];
        ccoefo3=[ccoefo3 coefo3];
   end
   
   % calculate o3 vcd
   o3VCD = real((((ccoefo3(1,:))*1000))')./s.m_O3;
   % create smooth o3 time-series
   xts = 60/3600;   %60 sec in decimal time
   tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
   [o3VCDsmooth, sn] = boxxfilt(tplot, o3VCD, xts);
   o3vcd_smooth = real(o3VCDsmooth);
   
   x0=[ccoefo3(1,:)' ccoefo3(2,:)' ccoefo3(4,:)' ccoefo3(5,:)' ccoefo3(6,:)' ccoefo3(7,:)' ccoefo3(8,:)'];
   %x0=[ccoefo3(1,:)' ccoefo3(2,:)' ccoefo3(4,:)' ccoefo3(5,:)' ccoefo3(6,:)' ccoefo3(7,:)' ccoefo3(8,:)' ccoefo3(9,:)'];
   
   O3conc=[];H2Oconc=[];O4conc=[];O2conc=[];O3resi=[];o3OD=[];
   
  %[O3conc H2Oconc O4conc O3resi o3ODnew varall_lin] = o3corecalc_lin_adj_poly4(s,o3coef,o4coef,h2ocoef,wln,tau_OD,x0);
   
  [O3conc H2Oconc O4conc O3resi o3ODnew varall_lin] = o3corecalc_lin_adj(s,o3coef,o4coef,h2ocoef,wln,tau_OD,x0);
   
   
   [O3conc_s, sn] = boxxfilt(tplot, O3conc, xts);
   O3conc_smooth = real(O3conc_s);
   % archive smooth values
   gas.o3 = O3conc_smooth;
   gas.o3resi = (O3resi);
   gas.o4  = O4conc;% already converted in routine./s.m_ray; % slant converted to vertical
   gas.h2o = H2Oconc;% already converted in routine./s.m_H2O;% slant converted to vertical
   gas.o3OD  = o3OD;          % this is to be subtracted from slant path this is slant
   tplot = serial2hs(s.t);
   
   o3amount = -log(exp(-(real(O3conc/1000)*o3coef')));%(O3conc/1000)*o3coef';
   o4coefVIS = zeros(qq,1); o4coefVIS(1:1044) = o4coef(1:1044);
   o4amount = -log(exp(-(real(O4conc)*o4coef')));%O4conc*o4coef';
   h2ocoefVIS = zeros(qq,1); h2ocoefVIS(wln_vis6) = h2ocoef(wln_vis6);
   h2oamount= -log(exp(-(real(H2Oconc)*h2ocoefVIS')));%H2Oconc*h2ocoefVIS';
   %tau_OD_fitsubtract = tau_ODslant - o3amount - o4amount -h2oamount;
   tau_OD_fitsubtract4 = tau_OD_fitsubtract3 - real(o3amount) - real(o4amount) -real(h2oamount);% subtraction of remaining gases in o3 region
   
    
%    % calculate error
%    % no2Err   = (tau_pca_mRay(:,(wln))'-RRno2pca(:,:))./repmat((no2coef(wln)),1,pp);    % in atm cm
   o3Err   = (tau_OD(:,wln)'-RRo3(:,:))./repmat((o3coef(wln)),1,pp);      % in atm cm
   MSEo3DU = real((1000*(1/length(wln))*sum(o3Err.^2))');                 % convert from atm cm to DU
   RMSEo3  = real(sqrt(real(MSEo3DU)));
   
   gas.o3Inv    = o3VCD;%o3vcd_smooth is the default output;
   gas.o3Inv    = o3vcd_smooth;
   gas.o3resiInv= RMSEo3;
   
%    figure;subplot(211);plot(tplot,o3VCD,'.r');hold on;
%           plot(tplot,o3vcd_smooth,'.g');hold on;
%           axis([tplot(1) tplot(end) 250 350]);
%           xlabel('time');ylabel('o3 [DU]');
%           legend('inversion','inversion smooth');
%           subplot(212);plot(tplot,RMSEo3,'.r');hold on;
%           axis([tplot(1) tplot(end) 0 5]);
%           xlabel('time');ylabel('o3 RMSE [DU]');
%           title([datestr(s.t(1),'yyyy-mm-dd'), 'linear inversion']);
          
   % prepare to plot spectrum OD and o3 cross section
   %o3spectrum     = tau_OD(:,wln);%-RRo3' + ccoefo3(1,:)'*basiso3(:,1)';
   o3spectrum     = tau_OD(:,wln)-RRo3' + ccoefo3(1,:)'*basiso3(:,1)';
   o3fit          = ccoefo3(1,:)'*basiso3(:,1)';
   o3residual     = tau_OD(:,wln)-RRo3';
   
%      plot fitted and "measured" o3 spectrum
%      for i=1:1000:length(s.t)
%          figure(888);
%          plot(wvis((wln)),o3spectrum(i,:),'-k','linewidth',2);hold on;
%          plot(wvis((wln)),o3fit(i,:),'-r','linewidth',2);hold on;
%          plot(wvis((wln)),o3residual(i,:),':k','linewidth',2);hold off;
%          xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' o3VCD= ',num2str(o3vcd_smooth(i)),' RMSE = ',num2str(RMSEo3(i))),...
%                 'fontsize',14,'fontweight','bold');
%          ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted O_{3} spectrum','residual');
%          set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
%          pause(1);
%      end
%%
%% subtract/retrieve NO2/O3/O4 region
   wln = wln_vis7;
   NO2conc = []; NO2resi=[];
   %[NO2conc, NO2resi, no2OD, tau_OD_fitsubtract5, varall] = no2corecalc_lin(s,no2coef,o4coef,o3coef,wln,tau_OD);
   %[NO2conc, NO2resi, no2O3conc, no2O4conc, varall] = no2corecalc_lin(s,no2coef,o4coef,o3coef,wln,tau_OD);
%    gas.no2  = NO2conc;%in [DU]
%    gas.no2resi= NO2resi;
   
%    wln = wln_vis10;
%    HCOHconc = []; HCOHresi=[];
%   [HCOHconc, HCOHresi, O3conc, O4conc, NO2conc, BrOconc,allvar] = hcohcorecalc_lin(s,hcohcoef,o4coef,o3coef,no2coef,brocoef,wln,tau_OD);
%    gas.hcoh    = HCOHconc;%in [DU]
%    gas.hcohresi= HCOHresi;
%    % perform pca (full spectrum)
%    [s.pcadata s.pcavisdata s.pcanirdata s.pcvis s.pcnir s.eigvis s.eignir s.pcanote] =starPCAshort(s);
%    
%    % reconstruct spectra for no2 retrieval
%    rate_pca      = s.pcadata(:,1:1044)./repmat(s.f(1),pp,length(wvis));
%    tau_pca       = -log(rate_pca./repmat(s.c0(1:length(wvis)),pp,1));
%    tau_pca_mRay  = tau_pca - s.tau_ray(:,1:length(wvis)).*repmat(s.m_ray,1,length(wvis));
%    tau4no2       = tau_pca_mRay./repmat(s.m_aero,1,length(wvis));
%    
   % compare pca/no-pca
%    figure;
%    plot(wvis,tau_OD (10000,1:1044),'-b'); hold on;
%    plot(wvis,tau4no2(10000,1:1044),'--r');hold on;
%    legend('tau','taupca');
   

   % perform pca on no2 wln range
   wln4pca = find(wvis<=wvis(nm_0900)&wvis>=wvis(nm_0300)); 
      
   [s] =starPCA(s,wln4pca,0);
   
   % perform fit on pca spectra
    pcastr = strcat('pca_',num2str(round(1000*s.w(wln4pca(1)))),'_',num2str(round(1000*s.w(wln4pca(end)))));
    
% %% test several wavelength ranges first
for jj=2%1:3

    if jj==1
        wln = find(wvis<=wvis(nm_0500)&wvis>=wvis(nm_0400)); %wln_vis7
        % find no2 range within wln4pca (since using pca OD)
       nm_startpca = interp1(wvis(wln4pca),[1:length(wln4pca)],0.430,  'nearest');
       nm_endpca   = interp1(wvis(wln4pca),[1:length(wln4pca)],0.490,  'nearest');
    elseif jj==2
        wln = find(wvis<=wvis(nm_0450)&wvis>=wvis(nm_0400)); %wln_vis8
        % find no2 range within wln4pca
       nm_startpca = interp1(wvis(wln4pca),[1:length(wln4pca)],0.430,  'nearest');
       nm_endpca   = interp1(wvis(wln4pca),[1:length(wln4pca)],0.450,  'nearest');
    elseif jj==3
       wln = find(wvis<=wvis(nm_0515)&wvis>=wvis(nm_0480)); %wln_vis9
        % find no2 range within wln4pca
       nm_startpca = interp1(wvis(wln4pca),[1:length(wln4pca)],0.480,  'nearest');
       nm_endpca   = interp1(wvis(wln4pca),[1:length(wln4pca)],0.515,  'nearest');
    end

%    
%    [NO2conc NO2resi no2OD tau_OD_fitsubtract5] = no2corecalc(s,no2coef,o4coef,o3coef,wln,s.(pcastr).pcadata);
%    no2dat = [NO2conc NO2resi];
%    save('no2dat_pca_430_490OD.dat','-ASCII','no2dat');
%    tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;

%    perform fit
%----------------
if jj==3
   [NO2conc NO2resi no2OD tau_OD_fitsubtract5] = no2corecalc(s,no2coef,o4coef,o3coef,wln,tau_OD);
   % perform fit on pca spectra
   %[NO2conc NO2resi no2OD tau_OD_fitsubtract5] = no2corecalc_wh2o(s,no2coef,o4coef,o3coef,h2ocoef,wln,s.(pcastr).pcaOD,nm_startpca,nm_endpca);
   % perform linear inversion
   % all coef are in [atm x cm]
   basisno2=[no2coef(wln), o4coef(wln), o3coef(wln) h2ocoef(wln) ones(length(wln),1) wvis(wln)'.*ones(length(wln),1) ((wvis(wln)').^2).*ones(length(wln),1)];

else
    % perform fit on pca spectra w/o water vapor region
   [NO2conc NO2resi no2OD tau_OD_fitsubtract5] = no2corecalc(s,no2coef,o4coef,o3coef,wln,s.(pcastr).pcaOD,nm_startpca,nm_endpca);
   %[ss NO2conc NO2resi no2OD tau_aero_subtract] = no2corecalc_wss(s,no2coef,o4coef,o3coef,wln,tau_OD,nm_startpca,nm_endpca);
   % perform linear inversion
   % all coef are in [atm x cm]
   % basisno2=[no2coef(wln), o4coef(wln), o3coef(wln) ones(length(wln),1) log(wvis(wln))'.*ones(length(wln),1)];
   basisno2=[no2coef(wln), o4coef(wln), o3coef(wln) ones(length(wln),1) wvis(wln)'.*ones(length(wln),1)];

end

% figure;subplot(211);plot(tplot,NO2conc,'.g');
%           axis([tplot(1) tplot(end) 0 0.5]);
%           xlabel('time');ylabel('no2 [DU]');
%           if jj==1
%               title('NO2 retrieval 430-490 nm');
%           elseif jj==2
%               title('NO2 retrieval 430-450 nm');
%           elseif jj==3
%               title('NO2 retrieval 480-515 nm');
%           end
%           subplot(212);plot(tplot,NO2resi,'.r');hold on;
%           axis([tplot(1) tplot(end) 0 0.005]);
%           xlabel('time');ylabel('no2 RMSE [DU]');
          
          


   ccoefno2pca=[];
   RRno2pca=[];
   for k=1:pp;
        %coefno2pca=basisno2\tau_pca_mRay(k,(wln))';
        coefno2pca=basisno2\s.(pcastr).pcaOD(k,nm_startpca:nm_endpca)';
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
   % no2Err   = (tau_pca_mRay(:,(wln))'-RRno2pca(:,:))./repmat((no2coef(wln)),1,pp);    % in atm cm
   no2Err   = (s.(pcastr).pcadata(:,nm_startpca:nm_endpca)'-RRno2pca(:,:))./repmat((no2coef(wln)),1,pp);      % in atm cm
   MSEno2DU = real((1000*(1/length(wln))*sum(no2Err.^2))');                                               % convert from atm cm to DU
   RMSEno2  = real(sqrt(real(MSEno2DU)));
   
%    figure;subplot(211);plot(tplot,no2VCDpca,'.r');hold on;
%           plot(tplot,no2vcdpca_smooth,'.g');hold on;
%           axis([tplot(1) tplot(end) 0 0.3]);
%           xlabel('time');ylabel('no2 [DU]');
%           legend('pca inversion','pca inversion smooth');
%           subplot(212);plot(tplot,RMSEno2,'.r');hold on;
%           axis([tplot(1) tplot(end) 0 0.005]);
%           xlabel('time');ylabel('no2 RMSE [DU]');
          
   % prepare to plot spectrum OD and no2 cross section
   %no2spectrum_pca     = tau_pca_mRay(:,(wln))-RRno2pca' + ccoefno2pca(1,:)'*basisno2(:,1)';
   no2spectrum_pca     = s.(pcastr).pcadata(:,nm_startpca:nm_endpca)-RRno2pca' + ccoefno2pca(1,:)'*basisno2(:,1)';
   no2fit_pca          = ccoefno2pca(1,:)'*basisno2(:,1)';
   %no2residual_pca     = tau_pca_mRay(:,(wln))-RRno2pca';
   no2residual_pca     = s.(pcastr).pcadata(:,nm_startpca:nm_endpca)-RRno2pca';
   
   % 8. plot fitted and "measured" no2 spectrum
%      for i=1:100:length(s.t)
%          figure(888);
%          plot(wvis((wln)),no2spectrum_pca(i,:),'-k','linewidth',2);hold on;
%          plot(wvis((wln)),no2fit_pca(i,:),'-r','linewidth',2);hold on;
%          plot(wvis((wln)),no2residual_pca(i,:),':k','linewidth',2);hold off;
%          xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' no2VCD= ',num2str(no2vcdpca_smooth(i)),' RMSE = ',num2str(RMSEno2(i))),...
%                 'fontsize',14,'fontweight','bold');
%          ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted NO_{2} spectrum','residual');
%          set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
%          pause(0.001);
%      end

   % no2OD is the spectrum portion to subtract
    gas.no2Inv    = no2vcdpca_smooth;%NO2conc;%in [DU]
    gas.no2resiInv= RMSEno2;%sqrt(NO2resi);
%    gas.no2  = no2vcdpca_smooth;%NO2conc;%in [DU]
%    gas.no2resi= RMSEno2;%sqrt(NO2resi);
   
   gas.no2  = NO2conc;%in [DU]
   gas.no2resi= NO2resi;
   
   % save gas data to .txt file
   Loschmidt=2.686763e19; %molecules/cm2
   no2_molec_cm2    = no2vcdpca_smooth*(Loschmidt/1000);
   no2err_molec_cm2 = RMSEno2*(Loschmidt/1000);
   
   
%    dat2sav = [real(serial2Hh(s.t)) real(s.sza) real(s.m_aero) real(s.tau_aero(:,407)) real(s.m_O3) real(O3conc) real(O3resi) real(O3conc_smooth) real(o3vcd_smooth)...
%               real(RMSEo3) real(NO2conc) real(NO2resi) real(no2VCDpca) real(no2vcdpca_smooth) real(RMSEno2) real(no2_molec_cm2) real(no2err_molec_cm2)...
%               real(s.cwv.cwv940m1) real(s.cwv.cwv940m1std) real(s.cwv.cwv940m2) real(s.cwv.cwv940m2resi)];
%    
%    fi = strcat(datestr(s.t(1),'yyyymmdd'),'_gas_summary_meanc0_rateslantPoly4noFORJcorr.dat');
%    save(['C:\Users\msegalro.NDC\Documents\R\4STAR_analysis\data\' fi],'-ASCII','dat2sav');
   
   %gas.no2OD  = no2OD;% this is to be subtracted from total OD;
   %no2amount = (NO2conc)*no2coef';
   %no2amount = (no2vcdpca_smooth/1000)*no2coef';
   no2amount = (NO2conc/1000)*no2coef';
   %no2amount = (1.86e-4)*repmat(no2coef',pp,1);  % constant value
   
   
   tau_OD_fitsubtract5 = tau_OD_fitsubtract4 - real(no2amount);
   tau_sub = tau_OD_fitsubtract5;%tau_OD_fitsubtract4;
   
   
   
   tau_sub(:,1:nm_0470) = s.tau_aero(:,1:nm_0470);
%    figure;
%    plot(starsun.w,tau_ODslant(end-500,:),'-b');hold on;
%    plot(starsun.w,tau_ODslant(end-500,:)-no2amount(end-500,:),'--y');xlabel('wavelength');ylabel('OD');
%    legend('total OD','OD after NO2 subtraction');
   %tau_aero_fitsubtract(:,wln_vis7) = tau_ODslant(:,wln_vis7) - no2subtract;
   %spec_subtract(:,wln_vis6)        = o3subtract(:,wln_vis6);
%% end fmincon

end % test no2 spectral range results
%%
% plot subtraction results
% comment out to increase speed
% for k=1:500:length(starsun.t)
%    figure(1111);
%    plot(s.w,tau_OD(k,:),'-b','linewidth',2);hold on;
%    plot(s.w,tau_ODslant_fitsubtract1(k,:),'--r','linewidth',2);hold on;%wv
%    plot(s.w,tau_ODslant_fitsubtract2(k,:),'--g','linewidth',2);hold on;%co2+ch4
%    plot(s.w,tau_ODslant_fitsubtract3(k,:),'--c','linewidth',2);hold on;%o2
%    plot(s.w,real(tau_OD_fitsubtract4(k,:)),'--y','linewidth',2);hold on;%o3+o4+h2o
%    plot(s.w,real(tau_OD_fitsubtract5(k,:)),'--m','linewidth',2);hold
%    on;%no2
%    plot(s.w,tau_sub(k,:),'--m','linewidth',2);hold on;%no2
%    plot([wvis wnir],starsun.tau_a_avg(k,:),':k','linewidth',2);hold off;
%    xlabel('wavelength');ylabel('OD');legend('total OD','wv (940 nm) subtraction','co2+ch4 subtraction','o2 subtraction','o3+o4+h2o subtraction','no2 subtraction','tau-aero');
%    legend('total OD','o3 (+o4+h2o) subtraction','no2 subtraction');
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
