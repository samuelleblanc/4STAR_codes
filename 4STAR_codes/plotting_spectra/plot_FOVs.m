%% Details of the program:
% NAME:
%   plot_FOVs
% 
% PURPOSE:
%   Loads the star.mat files and creates carpet plots for each FOV run in
%   that file
%
% CALLING SEQUENCE:
%  plot_FOVs(filein)
%
% INPUT:
%  - filein: filepath for the star.mat file
% 
% OUTPUT:
%  - various plots
%
% DEPENDENCIES:
%  - starwavelengths.m
%  - scat_ang_degs.m
%  - FOV_scan.m
%  - starpaths.m
%  - version_set.m
%
% NEEDED FILES:
%  - saved yyyymmddstar.mat files
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, August 15th, 2014, Happy Acadian Day!
% Modified v1.0: by Samuel LeBlanc, NASA Ames, 2014-11-24,
%           -added version control
% -------------------------------------------------------------------------

%% Start of function
function plot_FOVs(filein)
version_set('1.0')
%% setup and load the files
if nargin<1 || isempty(filein)
    [filename, sourcefolder]=uigetfile2({'*star.mat';'*starfov.mat'},'Pick the star.mat or starfov.mat files');
    filein=[sourcefolder filename];
end;

s=load(filein);

%% check the fields for the fov
a(1)=isfield(s,'vis_fova');
a(2)=isfield(s,'nir_fova');
p(1)=isfield(s,'vis_fovp');
p(2)=isfield(s,'nir_fovp');
if a(1) | a(2) | p(1) | p(2);
    disp('found the fov strucutures')
else 
    disp('No FOV found, exiting')
    return
end;

%% Now iterate through each fov structure
if a(1)
    disp('doing the vis_fova')
  for i=1:length(s.vis_fova)
      disp(['..on file:' num2str(i)])
      ins=FOV_scan(s.vis_fova(i));
  end;
end

if a(2)
    disp('doing the nir_fova')
  for i=1:length(s.nir_fova)
      disp(['..on file:' num2str(i)])
      ins=FOV_scan(s.nir_fova(i));
  end;
end
if p(1)
    disp('doing the vis_fovp')
  for i=1:length(s.vis_fovp)
      disp(['..on file:' num2str(i)])
      ins=FOV_scan(s.vis_fovp(i));
  end;
end
if p(2)
    disp('doing the nir_fovp')
  for i=1:length(s.nir_fovp)
      disp(['..on file:' num2str(i)])
      ins=FOV_scan(s.nir_fovp(i));
  end;
end


return