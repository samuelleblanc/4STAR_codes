function [wo,slit] = slit_function_2STAR(t)
%% Details of the program:
% NAME:
%   slit_function_2STAR
%
% PURPOSE:
%  to return the 2star slit function
%
% INPUT:
%  t: time value (optional, defaults to now)
%
% OUTPUT:
%  wo: wavelength array, in nm, relative to center position of the slit fx
%  slit: slit function (normalize distribution of senstivity of light at different wavelengths) 
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - slit function file
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Mauna Loa Observatory, 2017-06-04
%                
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%% sanitize inputs
if nargin <1;
    t = now;
else
    try;
        t = t(1);
    catch;
        t = t;
    end;
end;


%% set the selction of the slit function
if t>=datenum(2015,1,1,0,0,0); % from the start
    fname = '2STAR_vis_slit_0.1nm_from_SSFR.dat';
    
end;

%% load the file
slit_2s = importdata(fullfile(starpaths,fname));
slit = slit_2s(:,2);
wo = slit_2s(:,1);
return