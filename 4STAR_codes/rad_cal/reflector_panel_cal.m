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

% get the bins for the vis spectrometer
[n,edges,bins] = histcounts(s.rate(ii,400),6);

imax = bins==max(bins); % get the brightest bunch of points
b_tmp = bins; b_tmp(imax)=0;
idiff = b_tmp==max(b_tmp); % get the second brightest bunch of points - probably the diffuse light measurement
if sum(idiff)<=2;
    b_tmp(idiff)=0;
    idiff = b_tmp==max(b_tmp);
end;

% and the bins for the nir spectrometer
[nl,edges,binsl] = histcounts(s.rate(ii,1200),6);

imaxl = binsl==max(binsl); % get the brightest bunch of points
b_tmpl = binsl; b_tmpl(imaxl)=0;
idiffl = b_tmpl==max(b_tmpl); % get the second brightest bunch of points - probably the diffuse light measurement
if sum(idiffl)<=2;
    b_tmpl(idiffl)=0;
    idiffl = b_tmpl==max(b_tmpl);
end;
rr = [1:length(id)]; yar = [1:length(s.t)]; 
iirr = yar(ii); idrr = yar(id);
imm = imax & imaxl;
idd = idiff & idiffl;
rate_totrefl = s.rate(iirr(imm),:); % for the sky barrel total (direct beam + diffuse beam)
rate_diffrefl = s.rate(iirr(idd),:); % for the sky barrel diffuse sky 

rate_totrefl_mean = mean(rate_totrefl);
rate_diffrefl_mean = mean(rate_diffrefl);
rate_directrefl = rate_totrefl_mean-rate_diffrefl_mean;

% get the sun measurement right before the scan
idiscont = diff(yar(id))>1;
ndis = rr(idiscont);
rdis = rr(id); nndis = rdis(ndis);

rate_dir = s.rate(nndis,:);
rate_dir_mean = mean(rate_dir);

% get the solar angles during reflector panel measurements. 
disp('Assuming Panel is placed vertically')
incident_angle = mean(90.0-s.sza(ii));
viewing_angle = incident_angle.*-1.0;
R = spectralon_brdf(incident_angle,viewing_angle);
phi_spectralon = 0.9949; % reflectivity of spectralon should be slightly spectrally dependent

% get the incident solar light
iio = find(ii); io = iio(1); 
sol_toa = get_toa_spectrum_at_starwvl(s.t(1),s.f(io),s.instrumentname);
sol_surf = sol_toa.*R.*phi_spectralon.*cos(s.sza(io)*pi/180.0); 

view_solid_angle = 0.001378; %For a conic FOv of the sky-barrel of 2.4 deg wide.
view_solid_angle = 0.001589; % Update of the FOV for sky-barrel at 2.8 deg wide.

Irr_to_rad_conversion_factor = R.*phi_spectralon.*view_solid_angle./pi./2.0; % for converting the direct sun irradiance on panel to radiance 

%% plot out the values
figure;
subplot(1,2,1)
plot(s.t(ii),s.rate(ii,400),'b.'); hold on;
plot(s.t(id),s.rate(id,400),'g.');

plot(s.t(iirr(imm)),s.rate(iirr(imm),400),'cs');
plot(s.t(iirr(idd)),s.rate(iirr(idd),400),'mo');
plot(s.t(nndis),s.rate(nndis,400),'rx');
ax = gca();
dynamicDateTicks;
legend('all reflector','all direct beam','total reflector','diffuse reflector','direct beam used');

ylabel(['Rate at ' num2str(s.w(400)*1000.0,'%5.0f') ' nm [counts/ms]']);
xlabel('Time [UTC]');

subplot(1,2,2)
plot(s.t(ii),s.rate(ii,1200),'b.'); hold on;
plot(s.t(id),s.rate(id,1200),'g.');

plot(s.t(iirr(imm)),s.rate(iirr(imm),1200),'cs');
plot(s.t(iirr(idd)),s.rate(iirr(idd),1200),'mo');
plot(s.t(nndis),s.rate(nndis,1200),'rx');
ax = gca();
dynamicDateTicks;
legend('all reflector','all direct beam','total reflector','diffuse reflector','direct beam used');

ylabel(['Rate at ' num2str(s.w(1200)*1000.0,'%5.0f') ' nm [counts/ms]']);
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
subplot(1,3,1)
plot(s.w.*1000.0,rate_totrefl,'c');hold on;
plot(s.w.*1000.0,rate_totrefl_mean,'k','LineWidth',2);
ylabel('Rate [counts/ms]');
xlabel('Wavelength [nm]')
title('Total reflected')
grid on;

subplot(1,3,2)
plot(s.w.*1000.0,rate_diffrefl,'m');hold on;
plot(s.w.*1000.0,rate_diffrefl_mean,'k','LineWidth',2);
ylabel('Rate [counts/ms]');
xlabel('Wavelength [nm]')
title('Diffuse Reflector')
grid on;

subplot(1,3,3)
plot(s.w.*1000.0,rate_dir,'r');hold on;
plot(s.w.*1000.0,rate_dir_mean,'k','LineWidth',2);
ylabel('Rate [counts/ms]');
xlabel('Wavelength [nm]')
title('Direct sun beam')
grid on;

figure;
%plot(s.w.*1000.0,rate_totrefl,'c');hold on;

%plot(s.w.*1000.0,rate_diffrefl,'m');
%plot(s.w.*1000.0,rate_dir,'r');

plot(s.w.*1000.0,rate_totrefl_mean,'c','LineWidth',2);hold on
plot(s.w.*1000.0,rate_diffrefl_mean,'m','LineWidth',2);
plot(s.w.*1000.0,rate_dir_mean,'r','LineWidth',2);

plot(s.w.*1000.0,rate_directrefl,'color',[1,0.5,0]);
plot(s.w.*1000.0,rate_directrefl./rate_dir_mean.*100.0,'k');
plot(s.w.*1000.0,rate_directrefl./rate_dir_mean.*Irr_to_rad_conversion_factor,'k');
grid on;

ylabel('Rate [counts/ms]');
xlabel('Wavelength [nm]')
legend('total reflector','diffuse reflector','direct beam used','direct only reflector','ratio direct reflector/sun x100','Sun barrel to sky barrel')
%plot the sun to sky barrel ratio
figure; 
plot(s.w.*1000.0,rate_directrefl./rate_dir_mean./Irr_to_rad_conversion_factor,'.');
grid on;
ylim([1.2e4,1.9e4])
ylabel({'Ratio of barrel throughput';'(Sky rate / (sun rate * panel irradiance to radiance))'})
xlabel('Wavelength [nm]')

%% Calibrate direct sun beam
% Calculate response function at TOA, with c0 (rate/f/c0)
[visc0, nirc0]=starc0(s.t(io),false,s.instrumentname)
sunresp = sol_toa ./ [visc0 nirc0]; %(W/m^2/nm) / (counts/ms) #bad should use not c0, but c0 including rayleigh....
sun_irr = rate_dir_mean .* sunresp; % W/m^2/nm

%% Calculate the absolute radiance measured
sun_rad = sun_irr.*Irr_to_rad_conversion_factor; % W/m^2/nm/sr
resp = rate_directrefl./sun_rad./1000000.0; %counts/ms / (W/m^2/nm/sr)

%% Plot out and print the responses and calibrated values
figure; 
subplot(1,2,1)
plot(s.w.*1000.0, sun_rad.*100.0, '.k'); hold on;
plot(s.w.*1000.0, sun_irr, '+b');
xlabel('Wavelength [nm]')
ylabel('Radiance / Irradiance')
legend('Sun only panel rad. x 100 [W/m^2/nm/sr]','Sun direct beam Irr.[W/m^2/nm]')
ylim([0,2]);

subplot(1,2,2)
plot(s.w.*1000.0, sunresp.*10.0, 'xm');hold on;
plot(s.w.*1000.0, resp, 'sr');
xlabel('Wavelength [nm]')
ylabel('Response functions')
legend('Sun barrel Irr. response x10 [counts/ms / W/m^2/nm]','Sky barrel rad. response [counts/ms / W/m^2/nm/sr]')
ylim([0,7]);

print_vis.fname= [s.instrumentname '_Spectralon_panel_' datestr(s.t(io),'HHMMSS')];
print_nir.fname=[s.instrumentname '_Spectralon_panel_' datestr(s.t(io),'HHMMSS')];
print_vis.time=s.t(ii);
print_nir.time=s.t(ii);
print_vis.resp=resp(1:1044);
print_nir.resp=resp(1045:end);
print_vis.rad=sun_rad(1:1044);
print_nir.rad=sun_rad(1045:end);
print_vis.rate=rate_directrefl(1:1044);
print_nir.rate=rate_directrefl(1045:end);
print_nir.tint=s.visTint(io);
print_vis.tint=s.nirTint(io);
print_vis.nm = s.w(1:1044).*1000.0;
print_nir.nm = s.w(1045:end).*1000.0;

refl.units = 'W/m^2/nm/sr';
refl.fname = [s.instrumentname '_' s.daystr '_' num2str(s.visfilen(io),'%03.0f') '.dat'];

write_SkyResp_files_2(print_vis,print_nir,refl,getnamedpath('stardat'),'Spectralon_panel');
disp('file printed');

%% Save the conversion ratio
%conv.factor = rate_directrefl./rate_dir_mean./Irr_to_rad_conversion_factor;
%conv.w = s.w;
%conv.t = s.t(io);
%conv.long_description = 'Ratio of barrel throughput (Sky rate / (sun rate * panel irradiance to radiance))';
%conv.daystr = s.daystr;
%
%save([getnamedpath('starmat'),s.instrumentname,'_',s.daystr,'_skytosun_ratio.mat'],'-struct','conv');

end