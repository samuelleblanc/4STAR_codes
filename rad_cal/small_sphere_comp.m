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
%
% -------------------------------------------------------------------------

%% start of function
function small_sphere_comp(varargin)
version_set('1.1');
startup
dir='C:\Users\sleblan2\Research\4STAR\cal\';
ll='\';


%% setup the files to load and load them
dates=['20140624';'20140716';'20140804';'20140825';'20140914';'20140920';'20140926'];
ref=4;
files=[dir dates(1,:) '_small_sphere_rad.mat';...
       dir dates(2,:) '_small_sphere_rad.mat';...
       dir dates(3,:) '_small_sphere_rad.mat';...
       dir dates(4,:) '_small_sphere_rad.mat';...
       dir dates(5,:) '_small_sphere_rad.mat';...
       dir dates(6,:) '_small_sphere_rad.mat';...
       dir dates(7,:) '_small_sphere_rad.mat'];
   
num=length(dates(:,1));
for l=1:num
    fields{l}=['r' dates(l,:)];
    d.(fields{l})=load(files(l,:));
    
end;

% set reference radiances
spref=d.(fields{ref}).rad;

%% plot the radiances of the integrating sphere as it varies with multiple different 
figure(12); 
set(12,'Position',[20 30 1200 800]);

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
fi=[dir 'Comp_rad_sphere'];
ylim([0.9,1.1]);
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
for i=ref:num
  plot(d.(fields{i}).nm,d.(fields{i}).rad);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Radiances (Wm^{-2}sr^{-1}\mum^{-1})');
title('Small integrating Sphere radiance');
legend(dates(ref:end,:));
ylim([0,150]);
xlim([300 1700]);


ax2=subplot(2,1,2);
plot(d.(fields{ref}).nm,d.(fields{ref}).rad./spref);
hold all;
for i=ref:num
  plot(d.(fields{i}).nm,d.(fields{i}).rad./spref);  
end
hold off;
xlabel('Wavelength (nm)');
ylabel('Ratio of Sphere Radiances');
title(['Change in sphere radiances compared to: ' dates(ref,:)]);
fi=[dir 'Comp_rad_sphere'];
ylim([0.9,1.1]);
xlim([300 1700]);
grid on;

linkaxes([ax1,ax2],'x');
save_fig(13,fi,true);
disp('done')

end

 
   
   