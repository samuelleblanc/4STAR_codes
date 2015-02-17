function [savematfile, contents]=starzen(varargin)
version_set('1.1');

toggle.verbose = true;
toggle.subsetting_Tint = true;
toggle.pca_filter = true;
toggle.applytempcorr = false;
toggle.doflagging = false;

% starsun(source, savematfile)
% reads 4STAR _SKY data, gets relevant variables, makes adjustments, and
% saves the results in a mat file.
%
% Input (leave blank or say 'ask' to prompt user interface)
%   source: either single/multiple dat file path(s) or a single mat file.
%   A string or cell.
%   savematfile: a mat file path in a string.
%
% Example
%   starsky; % this prompts user interfaces
%   starsky({'D:\4star\data\raw\20120307_013_VIS_SKYP.dat';'D:\4star\data\raw\20120307_013_NIR_SKYP.dat'}, 'D:\4star\data\99999999skysun.mat');
%   [savematfile, contents]=starsun(...) returns the path for the resulting mat-file and its contents.
%
% Yohei, 2012/03/19, 2012/04/11, 2012/06/27, 2012/08/14, 2012/10/01
% CJF, 2012/10/05, modified to load one pair of sky scans at a time, save
% one mat file per filen, placeholder for radiance cals, preparing for sky
% scan and aeronet inversion
% Yohei, 2012/10/05, updated tracking error computation. masked lines to
% generate figures.
% SL, v1.0, 2014/10/10, added version control of this script with version_set
% SL, v1.1, 2015/02/13, - added subsetting program for selecting only the
%                       radiance values that are not saturated within sets of integration times
%                       - added a toggle system for controlling which
%                       subprograms are run
%                       - added a program for removing noise via Principal
%                       Component Analysis in the rads
%********************
% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('zen', varargin{:});
contents=[];
if isempty(contents0);
    savematfile=[];
    return;
end;

%********************
% do the common tasks
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
for i=1:length(s.t); s.rad(i,:)=s.rate(i,:)./s.skyresp; end;

% run through the sets of integration times to get the highest signal, without saturation
if s.toggle.subsetting_Tint;
    s = subset_high_signal_no_sat(s);
    % now apply a principal component analysis to filter out some noise issues
    if s.toggle.pca_filter;
         s = pca_rads(s);
    end;
end;

% [mat_dir, fname, ext] = fileparts(savematfile);
% star_light_fname = [mat_dir,filesep,datestr(star.t(1),'yyyymmdd'),'starsun_LIGHT.mat'];
if exist('program_version','var');
    s.program_version = program_version;
end;
if ~exist(savematfile,'file')
    save(savematfile, '-struct', 's', '-mat');
else
    save(savematfile, '-struct', 's', '-mat', '-append');
end
contents=[contents; fieldnames(s)];

% star_anet_aip_process(s);


end


