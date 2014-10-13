%% Details of the function:
% NAME:
%   make_secondary_resp
% 
% PURPOSE:
%   Print to file the response function from the secondary cal
%   Uses output from small_sphere_cal
%
% CALLING SEQUENCE:
%  s=print_transfer_resp
%
% INPUT:
%  - non on command line
% 
% OUTPUT:
%  - response function file
%
% DEPENDENCIES:
%  - startup
%  - startupbusiness
%  - starwrapper
%  - write_SkyResp_files_2
%  - version_set
%
% NEEDED FILES:
%  - yyyymmdd_small_sphere_rad.mat
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, on Hercules C130, lat: 70 lon: -148, September
% 15th, 2014
%
% -------------------------------------------------------------------------

%% Start of function
function make_secondary_resp(varargin)
version_set('1.0')
startup
dir='C:\Users\sleblan2\Research\4STAR\cal\';

%% get the value of radiance of the small sphere at transfer time
smsph_cal='20140716_small_sphere_rad.mat';
r=load([dir smsph_cal]);
archi.units='Wm^{-2}nm^{-1}sr^{-1}'; archi.fname=[dir smsph_cal];
lampstr='Small integrating sphere';

%% load the current measurement (sky barrel spectra) of the lamps
%********************
% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('park', varargin{:});
contents=[];
if isempty(contents0);
    savematfile=[];
    return;
end;
load(sourcefile,contents0{:});

%% add variables and make adjustments common among all data types. Also
% combine the two structures.
    s=starwrapper(vis_park, nir_park,'applytempcorr',false);
    %for i=1:length(s.t); s.rad(i,:)=s.rate(i,:)./s.skyresp; end;

%% make plots of the rate vs. time
figure(1);
plot(s.t,s.rate(:,500));
u=findstr(s.filename{1},'20140914');
if ~isempty(u)
    ij=1:length(s.t);
    fls=s.sat_time==0;
    fli=ij<160;
    fl=and(fls,fli');
    s.rate_dark=s.rate(find(s.rate(:,500) > -10),:);
plot    s.rate=s.rate-nanmean(s.rate_dark);
else
    fl=s.sat_time==0;
end;
hold on;
plot(s.t(fl),s.rate(fl,500),'r.');
xlabel('time');
ylabel('counts/ms');
title('time trace of response');  
save_fig(1,[dir 'rates'],1);
%% determine the new response function
% make a mean of the rate data that is not saturated
s.meanrate=nanmean(s.rate(fl,:));
s.stdrate=nanstd(s.rate(fl,:));
s.resp=s.meanrate./r.rad;
s.stdresp=s.stdrate./r.rad;
 
% 
% [fname,pname]=uigetfile('*_small_sphere_rad.mat','Select the small sphere radiance cal',dir);
% uf=[pname fname];
% disp(['opening file: ' uf])
% load([pname fname]);
% 
%stophere
print_vis.nm=r.nm(1:1044); print_nir.nm=r.nm(1045:1556);
print_vis.fname=s.filename{1};
print_nir.fname=s.filename{2};
print_vis.time=s.t;
print_nir.time=s.t;
print_vis.resp=s.resp(1:1044);
print_nir.resp=s.resp(1045:1556); %cal.(lampstr).nir.resp(iint_nir,:);
print_vis.rad=r.rad(1:1044); %cal.(lampstr).vis.rad;
print_nir.rad=r.rad(1045:1556); %cal.(lampstr).nir.rad;
print_vis.rate=s.meanrate(1:1044); %mean(cal.(lampstr).vis.rate);
print_nir.rate=s.meanrate(1045:1556); %mean(cal.(lampstr).nir.rate);
print_nir.tint=unique(s.nirTint);
print_vis.tint=unique(s.visTint);


figure(2);
plot(r.nm, s.resp);

write_SkyResp_files_2(print_vis,print_nir,archi,dir,lampstr);
disp('file printed');
