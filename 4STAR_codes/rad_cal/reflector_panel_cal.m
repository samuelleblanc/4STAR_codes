function s = reflector_panel_cal(s);

%% Details of the program:
% NAME:
%   reflector_panel_cal
%
% PURPOSE:
%  Used for linking the reflector panel measurements to the direct sun
%  barrel measurements. 
%
% CALLING SEQUENCE:
%   s = reflector_panel_cal(s)
%
% INPUT:
%  s: matlab starsun structure
%
% OUTPUT:
%  plots, and s starsun structure
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - reflector panel calibration 
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, MLO, Feb 10th, 2018
% -------------------------------------------------------------------------

%% codes
version_set('v1.0')

%% Get the limits and total sun values
ii = (s.t>=s.calreflector_time(1)) & ((s.t<=s.calreflector_time(2))) & (s.Str==2);
id = (s.t>=s.calreflector_time(1)) & ((s.t<=s.calreflector_time(2))) & (s.Str==1);

[n,edges,bins] = histcounts(s.rate(ii,400),6);

imax = bins==max(bins); % get the brightest bunch of points
b_tmp = bins; b_tmp(imax)=0;
idiff = b_tmp==max(b_tmp); % get the second brightest bunch of points - probably the diffuse light measurement
if sum(idiff)<=2;
    b_tmp(idiff)=0;
    idiff = b_tmp==max(b_tmp);
end;
rr = [1:length(id)]; yar = [1:length(s.t)]; 
iirr = yar(ii); idrr = yar(id);

rate_totrefl = s.rate(iirr(imax),:); % for the sky barrel total (direct beam + diffuse beam)
rate_diffrefl = s.rate(iirr(idiff),:); % for the sky barrel diffuse sky 

rate_totrefl_mean = mean(rate_totrefl);
rate_diffrefl_mean = mean(rate_diffrefl);
rate_directrefl = rate_totrefl_mean-rate_diffrefl_mean;

% get the sun measurement right before the scan
idiscont = diff(yar(id))>1;
ndis = rr(idiscont);
rdis = rr(id); nndis = rdis(ndis);

rate_dir = s.rate(nndis,:);
rate_dir_mean = mean(rate_dir);

%% plot out the values
figure;
plot(s.t(ii),s.rate(ii,400),'b.'); hold on;
plot(s.t(id),s.rate(id,400),'g.');

plot(s.t(iirr(imax)),s.rate(iirr(imax),400),'cs');
plot(s.t(iirr(idiff)),s.rate(iirr(idiff),400),'mo');
plot(s.t(nndis),s.rate(nndis,400),'rx');
ax = gca();
dynamicDateTicks;
legend('all reflector','all direct beam','total reflector','diffuse reflector','direct beam used');

ylabel(['Rate at ' num2str(s.w(400)*1000.0,'%5.0f') ' nm [counts/ms]']);
xlabel('Time [UTC]');

figure;
plot(s.t(ii),s.AZ_deg(ii),'b.'); hold on;
plot(s.t(id),s.AZ_deg(id),'g.');

plot(s.t(iirr(imax)),s.AZ_deg(iirr(imax)),'cs');
plot(s.t(iirr(idiff)),s.AZ_deg(iirr(idiff)),'mo');
plot(s.t(nndis),s.AZ_deg(nndis),'rx');
ax2 = gca();
dynamicDateTicks;
legend('all reflector','all direct beam','total reflector','diffuse reflector','direct beam used');

ylabel(['Azimuth angle']);
xlabel('Time [UTC]');
linkaxes([ax,ax2],'x');

figure;
plot(s.t(ii),s.nirTint(ii),'b.'); hold on;
plot(s.t(id),s.nirTint(id),'g.');

plot(s.t(iirr(imax)),s.nirTint(iirr(imax)),'cs');
plot(s.t(iirr(idiff)),s.nirTint(iirr(idiff)),'mo');
plot(s.t(nndis),s.nirTint(nndis),'rx');
ax3 = gca();
dynamicDateTicks;
legend('all reflector','all direct beam','total reflector','diffuse reflector','direct beam used');

ylabel(['NIR Integration times']);
xlabel('Time [UTC]');

linkaxes([ax,ax2,ax3],'x');

figure;
plot(s.t(ii),s.visTint(ii),'b.'); hold on;
plot(s.t(id),s.visTint(id),'g.');

plot(s.t(iirr(imax)),s.visTint(iirr(imax)),'cs');
plot(s.t(iirr(idiff)),s.visTint(iirr(idiff)),'mo');
plot(s.t(nndis),s.visTint(nndis),'rx');
ax4 = gca();
dynamicDateTicks;
legend('all reflector','all direct beam','total reflector','diffuse reflector','direct beam used');

ylabel(['vis Integration times']);
xlabel('Time [UTC]');

linkaxes([ax,ax2,ax3,ax4],'x');

%% plot out the spectra
figure;
plot(s.w.*1000.0,rate_totrefl,'c');hold on;

plot(s.w.*1000.0,rate_diffrefl,'m');
plot(s.w.*1000.0,rate_dir,'r');

plot(s.w.*1000.0,rate_totrefl_mean,'c','LineWidth',2);
plot(s.w.*1000.0,rate_diffrefl_mean,'m','LineWidth',2);
plot(s.w.*1000.0,rate_dir_mean,'r','LineWidth',2);

plot(s.w.*1000.0,rate_directrefl,'color',[1,0.5,0]);
plot(s.w.*1000.0,rate_directrefl./rate_dir_mean,'k');

ylabel('Rate [counts/ms]');
xlabel('Wavelength [nm]')
legend('total reflector','diffuse reflector','direct beam used')

end