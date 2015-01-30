%% function that compares starsun generated with c0 versus lamp adjusted c0
function comparec0wlamp
%--------------------------------------------------------------------------
startup_plotting;
daystr = '20140919';

%% load files
rootdir = 'F:\ARISE\';
sd = load(strcat(rootdir,daystr,'\',daystr,'starsun.mat'),'w','t','sza','Alt','tau_aero','gas','cwv','c0');      % this is std file      (with c0)
ad = load(strcat(rootdir,daystr,'\',daystr,'starsun_wlamp.mat'),'w','t','sza','Alt','tau_aero','gas','cwv','c0');% this is adjusted file (with lamp-c0)

%% compare c0
% compare
figure;plot(sd.w,sd.c0,'-b',ad.w,ad.c0,'--g','linewidth',2);
xlabel('wavelength','fontsize',12);
ylabel('c0 (counts)','fontsize',12);
legend('c0','lampadjc0');
axis([0.3 1.7 0 600]);
% difference
figure;plot(sd.w,100*(ad.c0-sd.c0)./sd.c0,'-k','linewidth',2);
xlabel('wavelength','fontsize',12);
ylabel('c0 difference (%)','fontsize',12);
axis([0.3 1.7 -5 30]);
%% compare AOD
% with time (380 and 500 nm)
hh = serial2Hh(sd.t);
nm_380 = interp1(sd.w,[1:length(sd.w)],0.38, 'nearest');
nm_500 = interp1(sd.w,[1:length(sd.w)],0.50, 'nearest');
nm_400 = interp1(sd.w,[1:length(sd.w)],0.40, 'nearest');
nm_490 = interp1(sd.w,[1:length(sd.w)],0.49, 'nearest');
figure;
ax(1)=subplot(211);plot(hh,sd.tau_aero(:,nm_380),'.b',hh,ad.tau_aero(:,nm_380),'.g');
ylabel('AOD (380 nm)','fontsize',12);axis([min(hh) max(hh) 0 0.15]);
legend('c0','lampadjc0');
ax(2)=subplot(212);plot(hh,ad.tau_aero(:,nm_380) - sd.tau_aero(:,nm_380),'.k');
xlabel('time [hr]','fontsize',12);
ylabel('AOD (380 nm) lampadjc0-c0','fontsize',12);
linkaxes(ax,'x');
% spectral
hh19 = interp1(hh,[1:length(hh)],23, 'nearest');
figure;plot(sd.w,sd.tau_aero(hh19,:),'-b',ad.w,ad.tau_aero(hh19,:),'-g');
xlabel('wavelength','fontsize',12);
ylabel('AOD','fontsize',12);
axis([0.35 1.7 0 0.15]);

% correlation with no2
load('20130925cross_sections_uv_vis_swir_Tech5wlnFWHM.mat');
hold on;plot(wln/1000,no2/500,'--r');

[dataout,lagout]=xcorAlign([ad.tau_aero(hh19,nm_400:nm_490)' no2(nm_400:nm_490)]);
[dataout1,lagout1]=xcorAlign([sd.tau_aero(hh19,nm_400:nm_490)' no2(nm_400:nm_490)]);
%[x,c]=CXCOV(ad.tau_aero(hh19,nm_400:nm_490)', no2(nm_400:nm_490));
% delay = alignVectors(ad.tau_aero(hh19,nm_400:nm_490)', no2(nm_400:nm_490));
%a=[ad.tau_aero(hh19,nm_400:nm_490)]';
%b=[ad.tau_aero(hh19,nm_400:nm_490-1) 0]';
%c= no2(nm_400:nm_490);
%corrcoef(b,c)
%% compare AE
% w=0.5; % wavelength, in um
% ang=(-2)*tau_aero_polynomial(:,1)*log(w)-tau_aero_polynomial(:,2);

%% compare column O3



%% compare CWV
% currently cwv is being calculated using the same c0mod, so no difference
% need to decide which to implement
figure;
ax(1)=subplot(211);plot(hh,sd.cwv.cwv940m1,'.b',hh,ad.cwv.cwv940m1,'.g');
ylabel('CWV','fontsize',12);axis([min(hh) max(hh) 0 0.15]);
legend('c0','lampadjc0');
ax(2)=subplot(212);plot(hh,ad.cwv.cwv940m1 - sd.cwv.cwv940m1,'.k');
xlabel('time [hr]','fontsize',12);
ylabel('CWV lampadjc0-c0','fontsize',12);
linkaxes(ax,'x');
%% comapre NO2

