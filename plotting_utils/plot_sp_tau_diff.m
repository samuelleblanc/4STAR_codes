%% quick program to plot aod spectra investigating temperature effects
% plotting the spectra for 20130906 at high and low altitudes

%% load the starsun
dir='C:\Users\sleblan2\Research\4STAR\SEAC4RS\';
if ~exist('utc');
    load([dir '20130906\20130906starsun.mat']);

    % make the time
    tt=datevec(t);
    utc=tt(:,4)+tt(:,5)./60.0+tt(:,6)./3600.0+24.0*(tt(:,3)-tt(1,3));
end;

%find the times of high and low
[nul ihigh]=min(abs(utc-22.15));
[nul ilow]=min(abs(utc-22.35));
splow=mean(tau_aero(ilow-2:ilow+2,:));
sphigh=mean(tau_aero(ihigh-2:ihigh+2,:));

%% load the liquid and ice water absorption
ic=csvread('C:\Users\sleblan2\Research\libradtran\ice\CRYSTALS_H2O-ice_Warren.csv',1);
wa=csvread('C:\Users\sleblan2\Research\libradtran\ice\H2O_absorption_Cumming_2013.csv',1);
wv=csvread('C:\Users\sleblan2\Research\libradtran\ice\H2O_vapor_absorption_Ptashnik_2004.csv',1);

ice.w=ic(:,1);
ice.abs=ic(:,3).*4.0.*pi./ice.w.*1000000.0;

wat.w=10000000.0./wa(:,1)./1000.0;
wat.abs=wa(:,2);

wva.w=10000000.0./wv(:,1)./1000.0;
wva.abs=wv(:,2)./10.;

%% make the plots
figure(4);
ax1=subplot(2,1,1);
plot(w,splow,'b',w,sphigh,'r');
 ylim([-0.1,0.1]);
 xlabel('Wavelength (\mum)');
 ylabel('AOD');
 grid on;
 legend('Low','High');
 title('AOD spectra for 20130906, near 22.2 UTC');
 
ax2=subplot(2,1,2);
semilogy(w,sphigh-splow);
 xlabel('Wavelength (\mum)');
 ylabel('High-low AOD');
 hold on;
 plot(wat.w,wat.abs.*0.0001,'r');
 plot(wat.w,wat.abs.*0.00001,'m');
 plot(ice.w,ice.abs.*0.0001,'g');
 plot(ice.w,ice.abs.*0.00001,'y');
 %plot(wva.w,wva.abs.*0.01,'k');
 hold off;
 xlim([0.2,1.8]);
 legend('AOD diff','liquid water 0.1 mm','liquid water 0.01 mm','ice water 0.1 mm','ice water 0.01 mm');
 ylim([10^-5,10^1]);
linkaxes([ax1,ax2],'x');
 
 
 