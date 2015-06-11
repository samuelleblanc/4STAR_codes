%% Details of the function:
% NAME:
%   archiveQA
% 
% PURPOSE:
%   plot diagnostic/product to examine starsun values
% 
%
% CALLING SEQUENCE:
%  
%
% INPUT:
% 
% 
% OUTPUT:
%  plots
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%  - getfullname__
%  - save_fig
%
% NEEDED FILES:
%  - *starsunfinal.mat files
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, NASA Ames,Feb,18,2015
%-------------------------------------------------------------------
%% function routine

function archiveQA

startup_plotting;

%% load starsun file
infile = getfullname__('*starsunfinal*.mat','F:','Select starsun file');
[pname, fname, ext] = fileparts(infile);
 pname = [pname, filesep];

% load file
load(infile,'tau_aero','tau_aero_noscreening','cwv','gas','m_aero','t','Alt','Lat','Lon','w','flags','tau_aero_polynomial','toggle');
%% prepare for plotting
lambda=[0.355 0.3800    0.4518    0.5008    0.5200    0.5320    0.55  0.6055    0.6753  0.7806    0.8645  1.0199    1.0642    1.2358    1.5587];
ColorSet = varycolor(length(lambda)*3);
legendall ={};
tplot = serial2Hh(t); tplot(tplot<10) = tplot(tplot<10)+24;

% plot AOD (wln)
for i=1:length(lambda)
    lambda_ind = interp1(w,[1:length(w)],lambda(i),'nearest');
    lambda_str = num2str(lambda(i)*1000);
    legendall = [legendall;lambda_str];
    figure(1);
    plot(tplot,tau_aero_noscreening(:,lambda_ind),'.','color',ColorSet(i*3-1,:));hold on;
end

figure(1);
title(fname(1:8),'fontsize',12);
xlabel('time [UT]','fontsize',12);
ylabel('AOD','fontsize',12);
legend(gca,legendall,'location',  'EastOutside');
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 0 0.1]);
fi=[strcat(pname, fname(1:8), 'tau_aero_wln')];
save_fig(1,fi,true);

% plot 500 nm AOD with flags
figure(2)
flags_ind = logical(flags.before_or_after_flight|flags.bad_aod|flags.unspecified_clouds);
% plot(tplot,tau_aero_noscreening(:,interp1(w,[1:length(w)],lambda(4),'nearest')),...
%       '.b');hold on;
 plot(tplot,tau_aero(:,interp1(w,[1:length(w)],lambda(4),'nearest')),...
      '.b');hold on;
plot(tplot(flags_ind),tau_aero_noscreening(flags_ind,interp1(w,[1:length(w)],lambda(4),'nearest')),...
     '.g');hold on;
title(fname(1:8),'fontsize',12);
xlabel('time [UT]','fontsize',12);
ylabel('AOD','fontsize',12);
legend('AOD-good','AOD-flagged');
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 0 0.3]);
fi=[strcat(pname, fname(1:8), 'tau_aero_flagged')];
save_fig(2,fi,true);

% plot CWV
figure(3)
ax(1)=subplot(211);
plot(tplot,cwv.cwv940m1,'.b');hold on;
plot(tplot,cwv.cwv940m2,'.m');hold on;
ylabel('CWV [g/cm^{2}]','fontsize',12);
legend('CWV-940 mean','CWV-940 fit');
title(fname(1:8),'fontsize',12);
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 0 1]);
ax(2)=subplot(212);
plot(tplot,cwv.cwv940m1std,'.b');hold on;
plot(tplot,cwv.cwv940m2resi,'.m');hold on;
xlabel('time [UT]','fontsize',12);
ylabel('CWV error [g/cm^{2}]','fontsize',12);
legend('CWV-940 std','CWV-940 fit residual');
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 0 1]);
fi=[strcat(pname, fname(1:8), 'cwv')];
save_fig(3,fi,true);

% plot O3
figure(4)
ax(1)=subplot(211);
plot(tplot,gas.o3,'.r');hold on;
plot(tplot(flags_ind),gas.o3(flags_ind),...
     '.g');hold on;
ylabel('O_{3} [DU]','fontsize',12);
legend('O_{3}-all','O_{3}-flagged');
title(fname(1:8),'fontsize',12);
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 250 350]);
ax(2)=subplot(212);
plot(tplot,gas.o3resi,'.m');hold on;
xlabel('time [UT]','fontsize',12);
ylabel('O_{3} RMSE [DU]','fontsize',12);
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 0 0.5]);
fi=[strcat(pname, fname(1:8), 'o3col')];
save_fig(4,fi,true);

% plot NO2
figure(5)
ax(1)=subplot(211);
plot(tplot,gas.no2,'.r');hold on;
plot(tplot(flags_ind),gas.no2(flags_ind),...
     '.g');hold on;
ylabel('NO_{2} [DU]','fontsize',12);
legend('NO_{2}-all','NO_{2}-flagged');
title(fname(1:8),'fontsize',12);
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 0 0.5]);
ax(2)=subplot(212);
plot(tplot,gas.o3resi,'.m');hold on;
xlabel('time [UT]','fontsize',12);
ylabel('NO_{2} RMSE [DU]','fontsize',12);
set(gca,'fontsize',12);
axis([tplot(1) tplot(end) 0 0.03]);
fi=[strcat(pname, fname(1:8), 'no2col')];
save_fig(5,fi,true);


return;