function [savematfile, contents]=starsun(varargin)

% starsun(source, savematfile)
% reads 4STAR _FORJ data, gets relevant variables, makes adjustments, and
% saves the results in a mat file.  
% 
% Input (leave blank or say 'ask' to prompt user interface)
%   source: either single/multiple dat file path(s) or a single mat file.
%   A string or cell. 
%   savematfile: a mat file path in a string. 
% 
% See starwrapper.m for required files.
% 
% Example
%   starforj; % this prompts user interfaces 
%   starforj({'D:\4star\data\raw\20130207_007_VIS_FORJ.dat';'D:\4star\data\raw\20130207_007_NIR_FORJ.dat'}, 'D:\4star\data\99999999starforj.mat');
%   [savematfile, contents]=starforj(...) returns the path for the resulting mat-file and its contents.
% 
% Yohei, 2013/02/07, after starsun.m.
% Sam, v1.0,2015/09/01, added version control, change to use toggle switches as
%                   input
version_set('1.0');

%********************
% regulate input and read source
%********************

toggle.verbose = true;
toggle.applytempcorr = false;
toggle.doflagging = false;
toggle.gassubtract = false;
toggle.runwatervapor = false;
toggle.booleanflagging = false;
toggle.starflag_mode = 1; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle.doflagging = false; % for running any Yohei style flagging
toggle.dostarflag = false; 

if (~isempty(varargin));
    [toggle_in,vars] = parse_struct(varargin{:});
    toggle = catstruct(toggle,toggle_in);
else
    vars = varargin;
end


[sourcefile, contents0, savematfile]=startupbusiness('forj', vars{:});
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
    error('This part of starforj.m to be developed. For now both vis and nir structures must be present.');
elseif ~isequal(sort(contents0), sort([{'vis_forj'};{'nir_forj'}]))
    error('vis_forj and nir_forj must be the sole contents for starforj.m.');
end;
load(sourcefile,contents0{:});

% add variables and make adjustments common among all data types. Also
% combine the two structures.
s=starwrapper(vis_forj, nir_forj,toggle);

%********************
% save
%********************
save(savematfile, '-struct', 's', '-mat'); 
contents=[contents; fieldnames(s)];
