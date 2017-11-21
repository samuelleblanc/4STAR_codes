%% PURPOSE:
%   Generate a time series of albedo at 500 and 1600 nm from SSFR data
%
% CALLING SEQUENCE:
%   ssfr_time_albedo
%
% INPUT:
%   none
% 
% OUTPUT:
%  plots of time series of albedo at 500 nm and 1600 nm
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
% Written: Samuel LeBlanc, Fairbanks, Alaska, Sep-27, 2014
%
% -------------------------------------------------------------------------

%% Start of function
function ssfr_time_albedo

startup;
%% load the file
dir='C:\Users\sleblan2\Research\ARISE\c130\20140919_Flight13\';
fn=[dir 'SSFR_20140919.mat']
load(fn);

%% interpol the nadir spectra to zenith lambdas
disp('interpoling...');
for i=1:length(tmhrs);
    ns(:,i)=interp1(nadlambda,nspectra(:,i),zenlambda);
    alb(:,i)=ns(:,i)./zspectra(:,i);
end;

%% setup the figures and ploting
figure(1);
[nn n500]=min(abs(zenlambda-500));
[nn n1600]=min(abs(zenlambda-1600));
plot(tmhrs,smooth(alb(n500,:),5),tmhrs,smooth(alb(n1600,:),5));
title('Albedo');
xlabel('UTC [Hours]');
ylabel('Albedo');
ylim([0 1]);
legend('500 nm','1600 nm');
save_fig(1,[dir '20140919_time_albedo'],true);


stophere
return;
