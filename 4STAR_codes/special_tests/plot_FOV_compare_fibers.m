%% Details of the program:
% NAME:
%   plot_FOV_compare_fibers
%
% PURPOSE:
%  quick and dirty program to plot FOV results from the check on fiber optics
%  Used to compile all FOV tests for easy viewing and
%  comparison
%  currently compares FOV with 1" fibrance, 10" fibrance, cladding mode
%  mask, and GRIN rod.
%
% INPUT:
%  none
%
% OUTPUT:
%  plots
%
% DEPENDENCIES:
%  - version_set.m
%  - t2utch.m
%  - starwavelength.m
%  - smoothn.m : for time series smoothing
%  - linfitxy.m : for linear fitting with uncertainties
%
% NEEDED FILES:
%  - star.mat file compiled from raw data using allstarmat of each FOV
%  test day
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, August 27th, 2015
%
% -------------------------------------------------------------------------

function plot_FOV_compare_fibers
version_set('v1.0')
clear;
toggle.make_new_save = false;
dir = 'C:\Users\sleblan2\Research\4STAR\roof\';

%% Get wavelengths
[wv,wn] = starwavelengths();

[nul,i500] = min(abs(wv-0.500));
[nul,i650] = min(abs(wv-0.650));
[nul,i750] = min(abs(wv-0.750));
[nul,i850] = min(abs(wv-0.850));
[nul,i1200] = min(abs(wn-1.20));

fo = load([dir + '20150720\20150720starfov.mat')

 tests(1).label = 'Mask';
 tests(1).ifov = 1;
 
 tests(2).label = 'GRIN rod';
 tests(2).ifov = 2;
 
 tests(3).label = 'GRIN rod #2';
 tests(3).ifov = 3;
 
 tests(4).label = '10in. Fibrance';
 tests(4).ifov = 4;
 
 tests(5).label = 'Bare Fiber';
 tests(5).ifov = 5;
 
 tests(6).label = 'Bare Fiber with diffuser';
 tests(6).ifov = 6;
 
 for i=1:length(tests);
     disp(['On test #' num2str(i) '/' num2str(length(tests))])
     % get the center
     icenter = 20
     
     
     %get the Scattering angle
     dza = (90-abs(vis_fova(i).El_deg(icenter))) - (90-vis_fova(i).sunel(icenter))
     sza = (90-abs(vis_fova(i).sunel)) + dza
     daz = vis_fova(i).Az_deg(icenter) - vis_fova(i).sunaz(icenter)
     saz = vis_fova(i).sunaz + daz

     tests(i).SA = scat_ang_degs(sza,saz,90.0-abs(vis_fova(i).El_deg),vis_fova(i).AZ_deg)
   
     
 end;
end