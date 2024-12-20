function [matfolder, figurefolder, askforsourcefolder, author]=starpaths(source, raw, reset)
%[matfolder, figurefolder, askforsourcefolder, author]=starpaths(source,raw,reset)
% returns paths for 4STAR folders.
% Mandatory directory settings:
%   None, to run this code. But to run starsun.m, C0, starinfo and cross
%   section files must exist directly under "matfolder".
%   The use of getnamedpath is intended to remove the need for specific
%   directory structures and allow individuals more freedom of organization
%   "starpaths" only recognizes two folders but current 4STAR Github usage
%   requires a distinction between files intended to be maintained in the
%   repository under "data_folder" and measurement data including mat files
%   generated by allstarmat, starsun, and so on. This may imply retiring
%   starpaths and replacing it with specific calls of getnamedpath as
%   appropriate for different files.  This would also suggest that the
%   author tag and askforsource state be defined elsewhere.  

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
% Modified (v2.0) by Connor, replaced user-dependent paths with getnamedpath. 
%            The author logic should probably be moved out of starpaths.
% Modified (v2.1) by Connor, added reset boolean as trailing argument.
% v2.2, 2020-05-04, Connor: replaced author list with call to "get_starauthor"
%---------------------------------------------------------------------
version_set('2.2');

% get the version of matlab
vv = version('-release');

askforsourcefolder=0; % in allstarmat.m, just ask for files.
if isavar('reset')&&reset
   setnamedpath('stardat','Select the location for raw *.dat files...');
   matfolder = setnamedpath('starmat',['Select the location for "allstarmat" files. [This should NOT be in the GitHub tree!]']);
   setnamedpath('starsun', 'Select the location for starsun mat-files. [This should NOT be in the GitHub tree!]');
   figurefolder=setnamedpath('starfig','4STAR image files.');
else
   getnamedpath('stardat','Select the location for raw *STAR files...');
   matfolder = getnamedpath('starmat','Select the location for "allstarmat" files...');
   getnamedpath('starsun', 'Select the location for starsun mat-file...');
   figurefolder=getnamedpath('starfig','4STAR image files.'); 
end


% Add new authors in "get_starauthor" function.
[author, askforsourcefolder] = get_starauthor;

% if ~isempty(strfind(lower(userpath),'msegalro')); %
%     askforsourcefolder=1; % in allstarmat.m, ask for a folder first; if that request is canceled, ask for files.
%     author='Michal';
% elseif ~isempty(strfind(lower(userpath),'meloe'));
%     author='Meloe';
% elseif ~isempty(strfind(lower(userpath),'qin'));
%     author='Qin';
% elseif ~isempty(strfind(lower(userpath),'d3k014')) || ~isempty(strfind(lower(userpath),'connor')) 
%     author='Connor';
% elseif ~isempty(strfind(lower(userpath),'jredeman'));
%     author='Jens';
% elseif ~isempty(strfind(lower(userpath),'livings'));
%     author='John';
% elseif ~isempty(strfind(lower(userpath),'ys')) || ~isempty(strfind(lower(userpath),'yohei'))
%     author='Yohei';
% elseif ~isempty(strfind(lower(userpath),'yohei')); % Yohei's laptop
%     author='Yohei';
%elseif ~isempty(strfind(lower(userpath),'samuel')) || ~isempty(strfind(lower(userpath),'sleblanc')) || ...
%        ~isempty(strfind(lower(userpath),'sleblan2')) || ~isempty(strfind(lower(getenv('USER')),'sleblan2')) ||  ~isempty(strfind(lower(userpath),'lebla')) % Sam's laptop
%    author='Samuel';
% elseif ~isempty(strfind(lower(userpath),'kpistone'))
%     author='Kristina';
% elseif ~isempty(strfind(lower(userpath), 'logan'))
%     author='Logan';
% else
%     warning('Update starpaths.m');
%     author='anon_star_user';
% end;


return
