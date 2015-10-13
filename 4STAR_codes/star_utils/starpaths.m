function [matfolder, figurefolder, askforsourcefolder, author]=starpaths(source,raw)

% returns paths for 4STAR folders.
% Mandatory directory settings:
%   None, to run this code. But to run starsun.m, C0, starinfo and cross
%   section files must exist directly under "matfolder".
% Recommended directory settings:
%   make 'raw' subfolder under your matfolder.
%   make 'fig' and 'small' subfolders under your figurefolder.
% Yohei, 2012/04/09, 2012/05/18, 2012/10/03
% MODIFICATION HISTORY:
% Modified: by Samuel LeBlanc, Oct-7, 2014
%           - added a new input commands 'source' and 'raw' (can be safely omitted)
%           - used to open seperate folder for each 'source' (which is
%           flight number in this case), to make it work copy codes from
%           under 'sleblan2'
% Modified (v1.0): by Samuel LeBlanc, Oct-10, 2014
%          - added version control of this script via the version_set.m script
% MS, 2014-11-19, changed michal username to msegalro
%                 changed folder paths
% Modified (v1.1): by Samuel LeBlanc, 2015-03-17
%                  - update to use use starpaths on pleaides
% Modified 2015-04-14, by Michal, added version check to be compatible
%                      on both computers, V 1.2
% Modified (v1.3): by Samuel LeBlanc, 2015-08-26
%                  - added check for linux, for use on pleaides
%---------------------------------------------------------------------
version_set('1.3');

% get the version of matlab
vv = version('-release');
newmatlab = false; 
if str2num(vv(1:4)) >= 2013;
    newmatlab = true;
end;

askforsourcefolder=0; % in allstarmat.m, just ask for files.
if ~isempty(strfind(lower(userpath),'msegalro')); %
    if newmatlab
        matfolder='C:\matlab\4STAR_codes\data_folder\';
        figurefolder='C:\matlab\4STAR_figs\';
    else
        matfolder='C:\MatlabCodes\data\';
        figurefolder='C:\MatlabCodes\figs\';
    end
    askforsourcefolder=1; % in allstarmat.m, ask for a folder first; if that request is canceled, ask for files.
    author='Michal';
elseif ~isempty(strfind(lower(userpath),'meloe'));
    matfolder='/Users/meloe/Programs.dir/Data.dir/4star.dir/starsun_datafiles/';
    figurefolder='/Users/meloe/Programs.dir/Read4star/4starfig';
    author='Meloe';
elseif ~isempty(strfind(lower(userpath),'qin'));
    matfolder='C:\zq_working_baeri\4star\data\';
    figurefolder='C:\zq_working_baeri\4star\figures\';
    author='Qin';
elseif ~isempty(strfind(lower(userpath),'d3k014')) | ~isempty(strfind(lower(userpath),'connor'));
    matfolder='D:\data\4STAR\yohei\mat\';
    matfolder='C:\Users\d3k014\Documents\GitHub\4STAR_codes\data_folder\';
    figurefolder='D:\data\4STAR\yohei\img\';
    author='Connor';
elseif ~isempty(strfind(lower(userpath),'jens'));
    matfolder='c:\Jens\Data\4STAR\data\';
    figurefolder='c:\Jens\Data\4STAR\figures\';
    author='Jens';
elseif ~isempty(strfind(lower(userpath),'livings'));
    matfolder=cd;
    figurefolder=cd;
    author='John';
elseif ~isempty(strfind(lower(userpath),'ys')) | ~isempty(strfind(lower(userpath),'yohei'))
    matfolder=fullfile(paths, '4star','data');
    figurefolder=fullfile(paths, '4star','figures');
    author='Yohei';
elseif ~isempty(strfind(lower(userpath),'samuel'))
    matfolder='C:\Users\Samuel\Research\4STAR\data\' ;
    figurefolder='C:\Users\Samuel\Research\4STAR\figs\fov\';
    author='Samuel';
elseif ~isempty(strfind(lower(userpath),'sleblan2'))
    if isunix;
      matfolder='/home5/sleblan2/4STAR/4STAR_codes/data_folder/' ;
      figurefolder='/home5/sleblan2/4STAR/figs/';
      author='Samuel';
      if nargin>0;
        matfolder = '/nobackupp8/sleblan2/SEAC4RS/dc8/SEAC4RS/';
        %pp='/nobackupp8/sleblan2/ARISE/c130/';
        %matfolder=[pp ls([pp '*ARISE*' source]) filesep];
        %if nargin>1; matfolder=[matfolder raw filesep]; end;
      end;
    else
      matfolder='C:\Users\sleblan2\Research\4STAR_codes\data_folder\' ;
      figurefolder='C:\Users\sleblan2\Research\4STAR\figs\';
      author='Samuel';
      if nargin>0;
        pp='C:\Users\sleblan2\Research\ARISE\c130\';
        matfolder=[pp ls([pp '*ARISE*' source]) filesep];
        if nargin>1; matfolder=[matfolder raw filesep]; end;
      end;
    end
elseif ~isempty(strfind(lower(getenv('USER')),'sleblan2')) % for running on pleiades
    matfolder='/home5/sleblan2/4STAR/4STAR_codes/data_folder/' ;
    figurefolder='/home5/sleblan2/4STAR/figs/';
    author='Samuel';
    if nargin>0;
        matfolder = '/nobackupp8/sleblan2/SEAC4RS/dc8/SEAC4RS/';
        %pp='/nobackupp8/sleblan2/ARISE/c130/';
        %matfolder=[pp ls([pp '*ARISE*' source]) filesep];
        %if nargin>1; matfolder=[matfolder raw filesep]; end;
    end;
else
    warning('Update starpaths.m');
    matfolder=cd;
    figurefolder=cd;
    author='';
end;
