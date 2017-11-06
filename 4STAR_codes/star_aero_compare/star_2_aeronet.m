function star_2_aeronet();
%% PURPOSE:
%   Compare the 4STAR aod values to a cimel aeronet v1.5 ground site. 
%
% INPUT:
%  - None
% 
% OUTPUT:
%  - figures and a save file
%
% DEPENDENCIES:
%  version_set.m : to have version control of this m-script
%
% NEEDED FILES:
%  - starsun.mat for only the ground sites
%  - aeronet file spanning time of starsun. in either .lev10 or .lev15
%  format
%
% EXAMPLE:
%  ....
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2017-10-20
% Modified (v1.0): 
% -------------------------------------------------------------------------

%% start of function
version_set('1.0')

%% load the files
[file pname fi]=uigetfile('*starsun*.mat','Find starsun file for comparison .mat');

disp(['Loading the matlab file: ' pname file])
try; 
    load([pname file],'t','tau_aero_noscreening','w','m_aero');
catch;
    load([pname file]);
end;

[afile apname afi]=uigetfile('*.lev10; *.lev15; *.lev20','Select the aeronet file containing AOD (level 1.0, 1.5, or 2.0)');


end