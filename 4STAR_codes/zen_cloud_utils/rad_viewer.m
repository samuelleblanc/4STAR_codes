%% PURPOSE:
%   Simple program that loops through starzen files to display spectra of 
%   zenith radiances, and a time series of radiances 
%   file to view is hardcoded in code
%
% CALLING SEQUENCE:
%   rad=rad_viewer()
%
% INPUT:
%   none
% 
% OUTPUT:
%  - plots that updates (movie) of zenith radiance
%  - time series plot of zenith radiance as a contour
%
% DEPENDENCIES:
%  -version_set.m
%
% NEEDED FILES:
%  - starzen.mat file for a given day
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, date unknown, 2014
%
% -------------------------------------------------------------------------

%% Start of function
function rad=rad_viewer();
version_set('1.0');

folder='C:\Users\Samuel\Research\4STAR\SEAC4RS\20130913\';
file='20130913starzen_SL.mat';
disp(['Loading file: ' folder file])
load([folder file]);

disp('Making radiance array')
wvl=w*1000;
rad=rate;
for i=1:length(t); rad(i,:)=rate(i,:)./skyresp/1000; end;
tms=datevec(t);
hrs=tms(:,4)+tms(:,5)/60+tms(:,6)/3600;


%now start a loop for plotting
figure(1);
figure(2);

for i=1:length(t);
    figure(1);
    plot(wvl,rad(i,:));
    ylim([0 0.8]);
    xlim([350 1700]);
    title(['Zenith Radiance' num2str(i)]);
    xlabel('Wavelength [nm]');
    ylabel('Radiance [Wm^-^2sr^-^1nm^-^1]');
    
    figure(2);
    plot(wvl,rad(i,:)/max(rad(i,:)));
    ylim([0 1.0]);
    xlim([350 1700]);
    title(['Zenith Radiance' num2str(i)]);
    xlabel('Wavelength [nm]');
    ylabel('Normalized Radiance');
    
    pause(0.01);
end;

figure(3);
contour(wvl,hrs,rad);
xlabel('Wavelength [nm]');
ylabel('Time [Hrs]');
title('Zenith radiance vs. time');
caxis([0 1.0]);
h=colorbar('Ylim', [0 1.0]);
ylabel(h,'Radiance [Wm^-^2sr^-^1nm^-^1]');

disp('Done');

return