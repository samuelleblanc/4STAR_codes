%% PURPOSE:
%   Create a radiometrically calibrated zenith radiance measurements from
%   4STAR flight data (ZEN). makes adjustments, and saves the results in a mat file.
%
% CALLING SEQUENCE:
%   [savematfile, contents]=starzen(varargin)
%
% INPUT:
%   varargin: file path to be read in, leave blank or 'ask' for interactive file selection, 
%             either single/multiple dat file path(s) or a single mat file.
%             in format of a string or cell. 
%             Can use savematfile, a mat file path in a string.put in 'star.mat' or raw '.dat' files  
% 
% OUTPUT:
%  resp: response functions for specific calibrations (right now set for 9 lamps)
%  - plots of all vis and nir response functions for a given day with
%    corresponding variation to each other
%
% DEPENDENCIES:
%  - version_set.m : for version control of this file
%  - startupbusiness
%  - starwrapper
%  - pca_rad
%  - subset_high_signal_no_sat
%  - catstruct.m
%  - parse_struct.m
%
% NEEDED FILES:
%  SKY_RESP files
%
% EXAMPLE:
%   starzen; % this prompts user interfaces
%   starzen({'D:\4star\data\raw\20120307_013_VIS_ZEN.dat';'D:\4star\data\raw\20120307_013_NIR_ZEN.dat'}, 'D:\4star\data\99999999starzen.mat');
%   [savematfile, contents]=starzen(...) returns the path for the resulting mat-file and its contents.
%
% MODIFICATION HISTORY:
% Written: Yohei Shinozuka, NASA Ames, 2012/03/19
% Modified: Yohei, 2012/03/19, 2012/04/11, 2012/06/27, 2012/08/14, 2012/10/01
% Modified: CJF, 2012/10/05, modified to load one pair of sky scans at a time, save
%           one mat file per filen, placeholder for radiance cals, preparing for sky
%           scan and aeronet inversion
% Modified: Yohei, 2012/10/05, updated tracking error computation. masked lines to
%           generate figures.
% Modified (v1.0): Samuel LeBlanc, 2014/10/10, added version control of this script with version_set
% Modified (v1.1): Samuel LeBlanc, 2015/02/13, 
%                 - added subsetting program for selecting only the
%                   radiance values that are not saturated within sets of integration times
%                 - added a toggle system for controlling which
%                   subprograms are run
%                 - added a program for removing noise via Principal
%                   Component Analysis in the rads
% Modified (v1.2): Samuel LeBlanc, 2015/03/16
%                 - changed comments
% Modified (v1.3): Samuel LeBlanc, NASA Ames, 2015-07-21
%                 - added checking of input for toggle structure to change
%                 the default behaviour
%                 - added dependence to catstruct and parse_struct 
% Modified (v1.4): Samuel LeBlanc, NASA Ames, 2015-11-05
%                 - added using the default toggles defined in outside file
% Modified (v1.5): Samuel LeBlanc, NASA Ames, 2015-02-17
%                 - added a catstruct to program version 
% -------------------------------------------------------------------------


function [savematfile, contents]=starzen(varargin)
version_set('1.5');

toggle = update_toggle; % use the default toggles that are set

if (~isempty(varargin));
    [toggle_in,vars] = parse_struct(varargin{:});
    toggle = catstruct(toggle,toggle_in);
else
    vars = varargin;
end
%********************
%% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('zen', vars{:});
contents=[];
if isempty(contents0);
    savematfile=[];
    return;
end;

%********************
%% do the common tasks
%********************
% grab structures
if numel(contents0)==1;
    error('This part of starsky.m to be developed. For now both vis and nir structures must be present.');
elseif ~(any(~isempty(strfind(contents0,'nir_zen')))&any(~isempty(strfind(contents0,'nir_zen'))))
    ~isequal(sort(contents0), sort([{'vis_zen'};{'nir_zen'}]))
    error('vis_zen and nir_zen must be the sole contents for starzen.m.');
end;
load(sourcefile,contents0{:},'program_version');

% add variables and make adjustments common among all data types. Also
% combine the two structures.
s = starwrapper(vis_zen, nir_zen,toggle);

%% Do specific Zenith radiance tasks
for i=1:length(s.t); s.rad(i,:)=s.rate(i,:)./s.skyresp; end;

% run through the sets of integration times to get the highest signal, without saturation
if s.toggle.subsetting_Tint;
    s = subset_high_signal_no_sat(s);
    % now apply a principal component analysis to filter out some noise issues
    if s.toggle.pca_filter;
         s = pca_rads(s);
    end;
end;

%% Save results
% [mat_dir, fname, ext] = fileparts(savematfile);
% star_light_fname = [mat_dir,filesep,datestr(star.t(1),'yyyymmdd'),'starsun_LIGHT.mat'];
if exist('program_version','var');
   s.program_version = catstruct(program_version,evalin('base','program_version'));
end;
if ~exist(savematfile,'file')
    save(savematfile, '-struct', 's', '-mat');
else
    save(savematfile, '-struct', 's', '-mat', '-append');
end
contents=[contents; fieldnames(s)];

% star_anet_aip_process(s);


end