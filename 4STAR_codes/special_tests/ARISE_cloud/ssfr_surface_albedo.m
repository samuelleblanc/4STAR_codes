%% PURPOSE:
%   Generate the surface albedo of a few points for flight 20140919
%   Uses SSFR data
%
% CALLING SEQUENCE:
%   ssfr_surface_albedo
%
% INPUT:
%   none
% 
% OUTPUT:
%  plots of surface albedo
%  surface albedo file, interpolated to fit every nm
%
% DEPENDENCIES:
%  - startup.m
%  - save_fig.m
%
% NEEDED FILES:
%  SSFR calibspcs saved to matlab format
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, C130, Lat: 70.74N, Lon: 139.38W, Sep-21, 2014
%
% -------------------------------------------------------------------------

%% Start of function
function ssfr_surface_albedo

startup;
%% load the file
dir='C:\Users\sleblan2\Research\ARISE\c130\20140919_Flight13\';
fn=[dir 'SSFR_20140919.mat']
load(fn);

%% get the proper time
% for 20140919, over ocean, nn=7161, at 20.9261 UTC (under clouds)
% for 20140919, over ice, at 21.58UTC (under clouds)
to=20.9261;
to=21.58;
[n nn]=min(abs(tmhrs-to));

%% plot the spectra
figure(1);
plot(nadlambda,nspectra(:,nn),'g.',zenlambda,zspectra(:,nn),'r.')
legend('Nadir','Zenith');
xlabel('Wavelength [nm]');
ylabel('Irradiance [Wm^{-2}nm^{-1}sr^{-1}]');
title(['SSFR irradiances at: ' num2str(tmhrs(nn))]);
save_fig(1,[dir 'SSFR_UTC_' num2str(round(tmhrs(nn)*100))],true);

figure(2);
ns=interp1(nadlambda,nspectra(:,nn),zenlambda);
albe=ns./zspectra(:,nn);
albe_s=smooth(albe,'moving',5);
albe_s(find(albe_s >1))=1.0;
albe_s(find(albe_s <0))=0.0;
plot(zenlambda,albe,'b.',zenlambda,albe_s,'r-');
ylim([0 1]);
xlim([350 2100]);
title(['Surface albedo at:' num2str(tmhrs(nn))]);
xlabel('Wavelength [nm]');
ylabel('Albedo');
save_fig(2,[dir 'albedo_UTC_' num2str(round(tmhrs(nn)*100))],true);


%% save spectra to file
wvl=[350.0:1.0:1700.0];
alb=interp1(zenlambda,albe_s,wvl,'spline','extrap');
ia=find(alb<0.);
alb(ia)=0.0;
ib=find(alb>1.0);
alb(ib)=1.0;
dlmwrite([dir 'albedo_20140919_' num2str(round(tmhrs(nn)*100)) '.dat'],[wvl;alb]','\t');

return;
