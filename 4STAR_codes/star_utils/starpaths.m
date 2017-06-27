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
% Modified (v1.5): by Kristina Pistone, 2016-06-29: added data path for my
%                   machine
% Modified (v1.6): by Samuel LeBlanc, 2016-10-28
%                   - added time dependent paths
%---------------------------------------------------------------------
version_set('1.6');

% get the version of matlab
vv = version('-release');
newmatlab = false; 
if str2num(vv(1:4)) >= 2013;
    newmatlab = true;
end;
if isempty(userpath)
    [~, userpath1]=system('hostname'); % somehow Yohei's laptop returns blank userpath; call for system hostname
else
    userpath1='';
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
elseif ~isempty(strfind(lower(userpath),'d3k014')) | ~isempty(strfind(lower(userpath),'connor')) 
    author='Connor';
    if isdir('/Users/d3k014/Desktop/data/4STAR/')
        matfolder = '/Users/d3k014/Desktop/data/4STAR/processed/';
        figurefolder = '/Users/d3k014/Desktop/data/4STAR/img/';
    else
    matfolder='C:\Users\d3k014\Documents\GitHub\4STAR_codes\data_folder\';
    figurefolder='D:\data\4STAR\yohei\img\';
    end

elseif ~isempty(strfind(lower(userpath),'jredeman'));
    matfolder='c:\jens\Matlab\4STAR_codes-master\data_folder\';
    figurefolder='c:\Jens\Data\4STAR\figures\';
    author='Jens';
elseif ~isempty(strfind(lower(userpath),'livings'));
    matfolder=cd;
    figurefolder=cd;
    author='John';
elseif ~isempty(strfind(lower(userpath),'ys')) | ~isempty(strfind(lower(userpath),'yohei'))
    if now > datenum(2016,10,10,0,0,0);
        matfolder=fullfile(paths, 'data');
        figurefolder=fullfile(paths, 'figures');
        author='Yohei';
    else;
        matfolder=fullfile(paths, '4star','data');
        figurefolder=fullfile(paths, '4star','figures');
        author='Yohei';
    end;
elseif ~isempty(strfind(lower(userpath1),'yohei')); % Yohei's laptop
    matfolder=fullfile(paths, 'code\4STAR_codes\data_folder');
    figurefolder=fullfile(paths, '4star','figures');
    author='Yohei';
elseif ~isempty(strfind(lower(userpath),'samuel'))
    matfolder='C:\Users\Samuel\Research\4STAR\data\' ;
    figurefolder='C:\Users\Samuel\Research\4STAR\figs\fov\';
    author='Samuel';
elseif ~isempty(strfind(lower(userpath),'sleblan2'))
    if isunix;
        matfolder='/u/sleblan2/4STAR/4STAR_codes/data_folder/' ;
        figurefolder='/u/sleblan2/4STAR/figs/';
        author='Samuel';
        if nargin>0;
            matfolder = '/nobackup/sleblan2/SEAC4RS/dc8/SEAC4RS/';
            %pp='/nobackupp8/sleblan2/ARISE/c130/';
            %matfolder=[pp ls([pp '*ARISE*' source]) filesep];
            %if nargin>1; matfolder=[matfolder raw filesep]; end;
        end;
    else
        matfolder='C:\Users\sleblan2\Research\4STAR_codes\data_folder\' ;
        figurefolder='C:\Users\sleblan2\Research\MLO\2017_May\figs\';
        author='Samuel';
        if nargin>0;
            try
                if str2num(source)>20160711.0;
                    pp = 'C:\Users\sleblan2\Research\ORACLES\data\';
                    matfolder = [pp];
                end;
            catch
                pp='C:\Users\sleblan2\Research\ARISE\c130\';
                matfolder=[pp ls([pp '*ARISE*' source]) filesep];
                if nargin>1; matfolder=[matfolder raw filesep]; end;
            end;
        end;
    end
elseif ~isempty(strfind(lower(getenv('USER')),'sleblan2')) % for running on pleiades
    matfolder='/u/sleblan2/4STAR/4STAR_codes/data_folder/' ;
    figurefolder='/u/sleblan2/4STAR/figs/';
    author='Samuel';
    if nargin>0;
        matfolder = '/nobackupp8/sleblan2/SEAC4RS/dc8/SEAC4RS/';
        %pp='/nobackupp8/sleblan2/ARISE/c130/';
        %matfolder=[pp ls([pp '*ARISE*' source]) filesep];
        %if nargin>1; matfolder=[matfolder raw filesep]; end;
    end;
elseif ~isempty(strfind(lower(userpath),'kpistone'))
    matfolder='C:\Users\kpistone\Documents\4STAR\data\' ;
    figurefolder='C:\Users\kpistone\Documents\4STAR\data\figs\';
    author='Kristina';
else
    warning('Update starpaths.m');
%     matfolder=cd;
      matfolder='D:\Documents\GitHub\4STAR_codes\data_folder\';
%     figurefolder=cd;
    figurefolder='D:\data\4STAR\yohei\img\';
    author='cjf';
end;

return
