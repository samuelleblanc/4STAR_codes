%% Details of the program:
% NAME:
%   load_sphere_transfer
% 
% PURPOSE:
%  Load the value of radiances for the small integrating sphere from the
%  transfer cal 
%
% CALLING SEQUENCE:
%   tra=load_sphere_transfer(t,dir)
%
% INPUT:
%  t: matlab time array of the desired measurement time
%  dir: folder at which to find the transfer file
% 
% OUTPUT:
%  tra: structure of radiances, radiance uncertainties, and wavelengths of the small sphere
%
% DEPENDENCIES:
%  - version_set.m
%
% NEEDED FILES:
%  - small sphere calibrated radiance values saved in .mat format
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, October 15th, 2014
% Modified: 
%
% -------------------------------------------------------------------------

%% start of function
function tra=load_sphere_transfer(t,dir)
version_set('1.0');

%% prepare input
if nargin < 1
    t=now;
elseif nargin < 2
    dir=uigetfolder(starpaths,'Find folder that contains the small_sphere_cal.mat');
end;

%% select the correct file to load
if isnumeric(t);
    if t >= datenum([2014 06 24 0 0 0]) && t < datenum([2014 07 16 0 0 0]);
        daystr='20140624';
    elseif t >= datenum([2014 07 16 0 0 0]);
        daystr='20140716';
    end;
else; % special collections
    disp('No Special collections yet')
end;

tfile=[dir daystr '_small_sphere_rad.mat'];
tra=load(tfile);
tra.fname=tfile;

if ~any(strcmp(fieldnames(tra),'units'));
  tra.units='[W/m^2.sr.um]';
end;
end