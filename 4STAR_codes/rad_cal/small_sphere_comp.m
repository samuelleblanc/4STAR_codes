%% Details of the program:
% NAME:
%   small_sphere_comp
% 
% PURPOSE:
%  Compare the calibration of the small spheres
%  Uses the output from small_sphere_cal
%
% CALLING SEQUENCE:
%   small_sphere_comp
%
% INPUT:
%  - none
% 
% OUTPUT:
%  - plot of calibrated spectrum of the sphere
%
% DEPENDENCIES:
%  - save_fig.m (for saving the plots)
%  - startup.m (for making good looking plots)
%  - version_set.m (for version control of the script)
%
% NEEDED FILES:
%  - small sphere cal files in .mat format 
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, August 4th, 2014
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, October 17th, 2014
%                 - added the newest dates of infield calibrations
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, March 13th, 2015
%                 - added final radiance calibrations from cal lab from
%                 post ARISE
%                 - change startup to startup_plotting
%                 - added plot of change in resp function at different
%                 pixels (wavelength).
% Modified (V1.3): by Samuel LeBlanc, NASA Ames, 2016-10-04
%                  - added comparisons for KORUS+ORACLES
%
% -------------------------------------------------------------------------

%% start of function
function small_sphere_comp(varargin)
version_set('1.3');
startup_plotting
dir='C:\Users\sleblan2\Research\4STAR\cal\';
ll='\';

%campaign = 'ARISE';
campaign = 'KORUS_ORACLES';

%% setup the files to load and load them
%dates=['20140624';'20140716';'20140804';'20140825';'20140914';'20140920';'20140926';'20141024']; % ARISE
dates = ['20160330';'20160428';'20160514';'20160519';'20160521';'20160604';'20160923']
%ref=4; %ARISE
ref = 7;
num=length(dates(:,1));
%files=[dir dates(1,:) '_small_sphere_rad.mat';...
%       dir dates(2,:) '_small_sphere_rad.mat';...
%       dir dates(3,:) '_small_sphere_rad.mat';...
%       dir dates(4,:) '_small_sphere_rad.mat';...
%       dir dates(5,:) '_small_sphere_rad.mat';...
%       dir dates(6,:) '_small_sphere_rad.mat';...
%       dir dates(7,:) '_small_sphere_rad.mat']; 

for l=1:num;
    files(l,:) = [dir dates(l,:) '_small_sphere_rad.mat'];
    fields{l}=['r' dates(l,:)];
    d.(fields{l})=load(files(l,:));
    files_resp(l,:) = [dir dates(l,:) '_small_sphere_rad_responses.mat'];
    r.(fields{l})=load(files_resp(l,:));
end;

% set reference radiances
spref = d.(fields{ref}).rad;
% set reference response function
spref_vis_resp = r.(fields{ref}).vis.resp;
spref_nir_resp = r.(fields{ref}).nir.resp;

%% plot the radiances of the integrating sphere as it varies with multiple different 
figure(12); 
set(12,'Position',[20 30 1200 800]);
set(0,'DefaultAxesColorOrder',hsv(num))

ax1=subplot(2,1,1);
plot(d.(fields{1}).nm,d.(fields{1}).rad);
hold all;
for i=2:num
  plot(d.(fields{i}).nm,d.(fields{i}).rad);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Radiances (Wm^{-2}sr^{-1}\mum^{-1})');
title('Small integrating Sphere radiance');
legend(dates,'location','west');
ylim([0,150]);
xlim([300 1700]);


ax2=subplot(2,1,2);
plot(d.(fields{1}).nm,d.(fields{1}).rad./spref);
hold all;
for i=2:num
  plot(d.(fields{i}).nm,d.(fields{i}).rad./spref);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Ratio of Sphere Radiances');
title(['Change in sphere radiances compared to: ' dates(ref,:)]);
fi=[dir campaign '_Comp_rad_sphere'];
ylim([0.8,1.15]);
xlim([300 1700]);
grid on;

linkaxes([ax1,ax2],'x');
save_fig(12,fi,true);

%% plot the radiances of the integrating sphere for only the last few calibrations
figure(13); 
set(13,'Position',[20 30 1200 800]);

ax1=subplot(2,1,1);
plot(d.(fields{ref}).nm,d.(fields{ref}).rad);
hold all;
for i=ref+1:num
  plot(d.(fields{i}).nm,d.(fields{i}).rad);  
end
hold off;
xlabel('Wavelength [nm]');
ylabel('Radiances [Wm^{-2}sr^{-1}\mum^{-1}]');
title('Small integrating Sphere radiance');
legend(dates(ref:end,:),'location','west');
ylim([0,150]);
xlim([300 1700]);


ax2=subplot(2,1,2);
plot(d.(fields{ref}).nm,d.(fields{ref}).rad./spref);
hold all;
for i=ref+1:num
  plot(d.(fields{i}).nm,d.(fields{i}).rad./spref);  
end
hold off;
xlabel('Wavelength [nm]');
ylabel('Ratio of Sphere Radiances');
title(['Change in sphere radiances compared to: ' dates(ref,:)]);
fi=[dir campaign '_Comp_rad_sphere-subset'];
ylim([0.8,1.15]);
xlim([300 1700]);
grid on;

linkaxes([ax1,ax2],'x');
save_fig(13,fi,true);
disp('done')

%% plot the responses of the integrating sphere as it varies with multiple different 
figure(22); 
set(22,'Position',[20 30 1200 800]);
set(0,'DefaultAxesColorOrder',hsv(num))

ax1=subplot(2,2,1);
plot(r.(fields{1}).vis.nm,r.(fields{1}).vis.resp);
hold all;
for i=2:num
  plot(r.(fields{i}).vis.nm,r.(fields{i}).vis.resp);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Responses [cts/ms.(Wm^{-2}sr^{-1}\mum^{-1})^{-1}]');
title('Small integrating Sphere responses');
legend(dates,'location','west');
ylim([0,5.5]);
xlim([300 1000]);

ax2=subplot(2,2,3);
plot(r.(fields{1}).vis.nm,r.(fields{1}).vis.resp./spref_vis_resp);
hold all;
for i=2:num
  plot(r.(fields{i}).vis.nm,r.(fields{i}).vis.resp./spref_vis_resp);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Ratio of Sphere Responses');
title(['Change in sphere responses compared to: ' dates(ref,:)]);
ylim([0.8,1.15]);
xlim([300 1000]);
grid on;
linkaxes([ax1,ax2],'x');

axn1=subplot(2,2,2);
plot(r.(fields{1}).nir.nm,r.(fields{1}).nir.resp);
hold all;
for i=2:num
  plot(r.(fields{i}).nir.nm,r.(fields{i}).nir.resp);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Responses [cts/ms.(Wm^{-2}sr^{-1}\mum^{-1})^{-1}]');
title('Small integrating Sphere responses');
%legend(dates,'location','west');
ylim([0,0.25]);
xlim([930 1730]);

axn2=subplot(2,2,4);
plot(r.(fields{1}).nir.nm,r.(fields{1}).nir.resp./spref_nir_resp);
hold all;
for i=2:num
  plot(r.(fields{i}).nir.nm,r.(fields{i}).nir.resp./spref_nir_resp);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Ratio of Sphere Responses');
title(['Change in sphere responses compared to: ' dates(ref,:)]);
ylim([0.8,1.15]);
xlim([930 1730]);
grid on;
linkaxes([axn1,axn2],'x');

fi22=[dir campaign '_Comp_resp_sphere'];
save_fig(22,fi22,true);

%% Plot the time trace of the changes of radiance with each calibration
figure(14);
set(14,'Position',[20 30 1000 600]);
[n i500] = min(abs(d.(fields{1}).nm-500.0));
[n i650] = min(abs(d.(fields{1}).nm-650.0));
[n i800] = min(abs(d.(fields{1}).nm-800.0));
[n i1000] = min(abs(d.(fields{1}).nm-1000.0));
[n i1200] = min(abs(d.(fields{1}).nm-1200.0));
[n i1600] = min(abs(d.(fields{1}).nm-1600.0));

r500 = []; r650 = []; r800 = []; r1000 = []; r1200 = []; r1600 = [];
for x = fieldnames(d)'
    r500 = horzcat(r500, d.(x{:}).rad(i500));
    r650 = horzcat(r650, d.(x{:}).rad(i650));
    r800 = horzcat(r800, d.(x{:}).rad(i800));
    r1000 = horzcat(r1000, d.(x{:}).rad(i1000));
    r1200 = horzcat(r1200, d.(x{:}).rad(i1200));
    r1600 = horzcat(r1600, d.(x{:}).rad(i1600));
end

plot(r500,'*-')
hold all;
plot(r650,'*-')
plot(r800,'*-')
plot(r1000,'*-')
plot(r1200,'*-')
plot(r1600,'*-')
hold off;
set(gca,'xticklabel',fields)
xlabel('Calibrations');
ylabel('Radiances [Wm^{-2}sr^{-1}\mum^{-1}]');
legend('500 nm','650 nm','800 nm','1000 nm','1200 nm','1600 nm');
title('Small sphere calibration over time');
grid;
fi4 = [dir campaign '_Comp_rad_sphere_time'];
save_fig(14,fi4);

%% plot the relative time trace of radiance change with each calibration
figure(15);
set(15,'Position',[20 30 1000 600]);
plot(r500/r500(2)*100.0,'*-')
hold all;
plot(r650/r650(2)*100.0,'*-')
plot(r800/r800(2)*100.0,'*-')
plot(r1000/r1000(2)*100.0,'*-')
plot(r1200/r1200(2)*100.0,'*-')
plot(r1600/r1600(2)*100.0,'*-')
plot(r1600*0.0+100.0,'k-')
hold off;
set(gca,'xticklabel',fields)
xlabel('Calibrations');
ylabel('Relative Radiances [%]');
legend('500 nm','650 nm','800 nm','1000 nm','1200 nm','1600 nm');
title('Small sphere relative calibration over time');
grid;
fi5 = [dir campaign '_Comp_rel_rad_sphere_time'];
save_fig(15,fi5);

%% Plot the time trace of the changes of responses with each calibration
figure(24);
set(24,'Position',[20 30 1000 600]);
[n i500] = min(abs(r.(fields{1}).vis.nm-500.0));
[n i650] = min(abs(r.(fields{1}).vis.nm-650.0));
[n i800] = min(abs(r.(fields{1}).vis.nm-800.0));
[n i1000] = min(abs(r.(fields{1}).nir.nm-1000.0));
[n i1200] = min(abs(r.(fields{1}).nir.nm-1200.0));
[n i1600] = min(abs(r.(fields{1}).nir.nm-1600.0));

r500 = []; r650 = []; r800 = []; r1000 = []; r1200 = []; r1600 = [];
for x = fieldnames(d)'
    r500 = horzcat(r500, r.(x{:}).vis.resp(i500));
    r650 = horzcat(r650, r.(x{:}).vis.resp(i650));
    r800 = horzcat(r800, r.(x{:}).vis.resp(i800));
    r1000 = horzcat(r1000, r.(x{:}).nir.resp(i1000));
    r1200 = horzcat(r1200, r.(x{:}).nir.resp(i1200));
    r1600 = horzcat(r1600, r.(x{:}).nir.resp(i1600));
end

plot(r500,'*-')
hold all;
plot(r650,'*-')
plot(r800,'*-')
plot(r1000,'*-')
plot(r1200,'*-')
plot(r1600,'*-')
hold off;
set(gca,'xticklabel',fields)
xlabel('Calibrations');
ylabel('Responses [Cts/ms.(Wm^{-2}sr^{-1}\mum^{-1})^{-1}]');
legend('500 nm','650 nm','800 nm','1000 nm','1200 nm','1600 nm');
title('Small sphere responses over time');
grid;
fi24 = [dir campaign '_Comp_resp_sphere_time'];
save_fig(24,fi24);

%% plot the relative time trace of response change with each calibration
figure(25);
set(25,'Position',[20 30 1000 600]);
plot(r500/r500(2)*100.0,'*-')
hold all;
plot(r650/r650(2)*100.0,'*-')
plot(r800/r800(2)*100.0,'*-')
plot(r1000/r1000(2)*100.0,'*-')
plot(r1200/r1200(2)*100.0,'*-')
plot(r1600/r1600(2)*100.0,'*-')
plot(r1600*0.0+100.0,'k-')
hold off;
set(gca,'xticklabel',fields)
xlabel('Calibrations');
ylabel('Relative Responses [%]');
legend('500 nm','650 nm','800 nm','1000 nm','1200 nm','1600 nm');
title('Small sphere relative responses over time');
grid;
fi25 = [dir campaign '_Comp_rel_resp_sphere_time'];
save_fig(25,fi25);
end

 
   
   