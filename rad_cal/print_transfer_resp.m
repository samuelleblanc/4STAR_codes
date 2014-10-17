%% Details of the function:
% NAME:
%   print_transfer_resp
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
%  startup.m
%  write_SkyResp_files_2
%  version_set
%
% NEEDED FILES:
%  - yyyymmdd_small_sphere_rad.mat
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, on Hercules C130, lat: 70 lon: -148, September 15th, 2014
%
% -------------------------------------------------------------------------

%% Start of function
function print_transfer_resp
version_set('1.0');

startup
dir='C:\Users\sleblan2\Research\4STAR\cal\';

[fname,pname]=uigetfile('*_small_sphere_rad.mat','Select the small sphere radiance cal',dir);
uf=[pname fname];
disp(['opening file: ' uf])
load([pname fname]);

stophere
print_vis.fname=strrep(print_vis.fname,st,fnum)
print_nir.fname=strrep(print_nir.fname,st,fnum)
print_vis.time=vis.time;
print_nir.time=nir.time;
print_vis.resp=cal.(lampstr).vis.resp(iint_vis,:);
print_nir.resp=cal.(lampstr).nir.resp(iint_nir,:);
print_vis.rad=cal.(lampstr).vis.rad;
print_nir.rad=cal.(lampstr).nir.rad;
print_vis.rate=mean(cal.(lampstr).vis.rate);
print_nir.rate=mean(cal.(lampstr).nir.rate);
print_nir.tint=cal.(lampstr).nir.t_ms(iint_nir);
print_vis.tint=cal.(lampstr).vis.t_ms(iint_vis);

write_SkyResp_files_2(print_vis,print_nir,hiss,pname,lampstr);
disp('file printed');
