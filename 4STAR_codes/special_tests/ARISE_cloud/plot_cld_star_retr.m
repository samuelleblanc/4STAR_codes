%% PURPOSE:
%   Generate a time series of retrieved cloud properties from 4STAR
%
% CALLING SEQUENCE:
%   plot_cld_star_retr
%
% INPUT:
%   none
% 
% OUTPUT:
%  plots of time series of cloud optical thickness, effective radius, and
%  thermodynamic phase
%
% DEPENDENCIES:
%  - startup.m
%  - save_fig.m
%  - combine_star.m
%
% NEEDED FILES:
%  retr_20140919_sea.mat: matlab save file from the idl save: retrieve_kisq_20140919_v9.out
%  retr_20140919_ice.mat: matlab save file from the idl save: retrieve_kisq_20140919_ice_v9.out
%  20140919starzen.mat
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, Fairbanks, Alaska, Sep-27, 2014
%
% -------------------------------------------------------------------------

%% Start of function
function plot_cld_star_retr

startup;
%% load the files
dir='C:\Users\sleblan2\Research\ARISE\c130\20140919_Flight13\';
fn=[dir 'retr_20140919_sea.mat'];
disp(['restoring file:' fn]);
sea=load(fn);

fn=[dir 'retr_20140919_ice.mat'];
disp(['restoring file:' fn]);
ice=load(fn);

fn=[dir '20140919starzen.mat'];
disp(['restoring file:' fn]);
s=load(fn);

%% get the lat, lons, and alt for the correct time period
 %s.sea=combine_star(s,[20.85,20.97]);
 %s.ice=combine_star(s,[21.53,21.63]);

%% now make filter for the selected times
 % from the retrieve_kisq_v3_nas.pro on pleiades
 %  '20140919':fl=where(tmhrs gt 20.85 and tmhrs lt 20.97)
 %  '20140919_ice':fl=where(tmhrs gt 21.53 and tmhrs lt 21.63)
s.utc=t2utch(s.t);
fl.sea=find(s.utc > 20.8820 & s.utc < 20.97);
fl.ice=find(s.utc > 21.53 & s.utc < 21.63);

% make sure the filter has the same number of points as the retrieved points
if length(fl.ice)==length(ice.tmhrs); disp('** Ice retrieved points dont match **'), end;
if length(fl.sea)==length(sea.tmhrs); disp('** SEA retrieved points dont match **'), end;

% get a filter for non saturated spectra
fl.icenosat=find(s.sat_time(fl.ice)==0);
fl.seanosat=find(s.sat_time(fl.sea)==0);
fl.ices=fl.ice(fl.icenosat);
fl.seas=fl.sea(fl.seanosat);

fl.icenosi=find(s.sat_time(fl.ice)==0 & ice.wp_rtm==0);
fl.seanosi=find(s.sat_time(fl.sea)==0 & sea.wp_rtm==0);
fl.icesi=fl.ice(fl.icenosi);
fl.seasi=fl.sea(fl.seanosi);

%% plot the zenith retrievals
disp('plotting')
ss=10;
figure(1);
ax1=subplot(3,1,1);
plot(s.Lon(fl.ices),smooth(ice.tau_rtm(fl.icenosat),ss),'b');
hold on;
plot(s.Lon(fl.seas),smooth(sea.tau_rtm(fl.seanosat),ss),'g');
plot(s.Lon(fl.icesi),smooth(ice.tau_rtm(fl.icenosi),ss),'r+');
plot(s.Lon(fl.seasi),smooth(sea.tau_rtm(fl.seanosi),ss),'m+');
xlabel('Longitude [°]');
ylabel('Cloud Optical Depth');
legend('Over Ice','Over Sea','liquid cloud over ice','liquid cloud over sea');
hold off;

ax2=subplot(3,1,2);
plot(s.Lon(fl.ices),smooth(ice.ref_rtm(fl.icenosat),ss),'b');
hold on;
plot(s.Lon(fl.seas),smooth(sea.ref_rtm(fl.seanosat),ss),'g');
plot(s.Lon(fl.icesi),smooth(ice.ref_rtm(fl.icenosi),ss), 'r+');
plot(s.Lon(fl.seasi),smooth(sea.ref_rtm(fl.seanosi),ss),'m+');
xlabel('Longitude [°]'); 
ylabel('Effective Radius [/mum]');
legend('Over Ice','Over Sea','liquid cloud over ice','liquid cloud over sea');
hold off;

ax3=subplot(3,1,3);
plot(s.Lon(fl.ices),ice.wp_rtm(fl.icenosat),'b');
hold on;
plot(s.Lon(fl.seas),sea.wp_rtm(fl.seanosat),'g');
xlabel('Longitude [°]');
ylabel('Thermodynamic phase');
legend('Over Ice','Over Sea');
hold off;

ice_ratio_icecld=sum(ice.wp_rtm(fl.icenosat))/length(ice.wp_rtm(fl.icenosat))
sea_ratio_icecld=sum(sea.wp_rtm(fl.seanosat))/length(sea.wp_rtm(fl.seanosat))

linkaxes([ax1,ax2,ax3],'x');

save_fig(1,[dir '20140919_retr']);

stophere
return;
