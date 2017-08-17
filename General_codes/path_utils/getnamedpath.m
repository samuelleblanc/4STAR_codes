function [fullpath] = getnamedpath(pathfile,dialog,reset)
%% GETNAMEDPATH, called to obtain paths to 4STAR data, images, and Github data_folder
% fullpath = getnamedpath(pathfile,dialog,reset);
% 'pathfile' is a string indicating the filename of the mat-file where the 
% path is stored. If pathfile not provided, or is empty then default to lastpath.mat
% 'dialog' is a string that will be provided to the user to prompt for the
% selection of an appropriate path if the supplied pathfile isn't found or
% doesn't map to an existing directory.
% 'reset' indicates whether to reset the pathfile contents.  It can be
% provided as a string 'reset' or 'true' or 't', or as a numeric that will be cast
% into a logical as reset = logical(reset), so 1 = true, ~1 = false.
%
% 2017-03-21, CJF: Modified for robustness. Potential replacement for starpaths
% 2017-08-05, CJF: Handle alternate forms for argument "reset"

version_set('1.1'); 
% Handle whether "reset" is provided or not
if ~exist('reset','var')
   reset = false;
else
   % Handle incorrect class for "reset"
   if ischar(reset)
      reset = strcmpi(reset,'reset')||strcmpi(reset(1),'t');
   end
   try
      reset = logical(reset);
   catch
      warning('Input argument "reset" should be logical, not NaN or complex. Ignoring...')
      reset = false;
   end
end
% Handle missing "dialog" argument
if ~exist('dialog','var')||isempty(dialog)
   if exist('pathfile','var')&&~isempty(pathfile)
      dialog = ['Select a directory for ',pathfile,'.'];
   else
      dialog = ['Select a directory.'];
   end
end

% Handle missing pathfile argument. If 'pathfile' wasn't provided or is
% empty then default to lastpath.mat
if ~exist('pathfile','var')||isempty(pathfile)
    pathfile = 'lastpath.mat';
end

% Store pathfiles in a directory below the userpath. 
% Handle ideosyncracies having to do with different platforms and Matlab
% versions associated with pathsep and filesep. Some versions of Matlab
% return userpath with a terminating filesep character but some don't.
% Handle both cases by adding it every time and then removing duplicates.
[~, pathfile, ~] = fileparts(pathfile); pathfile = [pathfile,'.mat'];

% remove trailing pathsep from userpath
usrpath = userpath;
if isempty(usrpath)
    [~, usrpath]=system('hostname'); % somehow Yohei's laptop returns blank userpath; call for system hostname
end;
usrpath = [strrep(usrpath,pathsep,''),filesep];
% append filesep
pathdir = [usrpath,'filepaths',filesep];
% If "filepaths" directory doesn't exist under userpath, create it
if ~exist(pathdir,'dir')
    mkdir(usrpath, 'filepaths');
end

pname = pwd;
% Attempt to load the pathfile. If it doesn't exist, or
% if it contains a non-existent directory then set reset to true.

% If the pathfile exists, then load it.
if exist([pathdir, pathfile],'file')
   pname = load([pathdir,pathfile]);
   if isstruct(pname)
      if isfield(pname,'pname')
         pname = pname.pname;
      elseif isfield(pname, 'fpath')
         pname = pname.fpath;
      end
   end
   if isempty(pname)||~isdir(pname)
      reset = true;
   end
else % reset it
   reset = true;
end
if ~isdir(pname)
   pname = pwd;
end

% If reset is true use uigetdir to update pname and pathfile.
% The downside to using uigetdir here is that the user can't see any of the
% files since it only shows directories.  It can be nicer to select a file
% within a directory and strip the filepath, so we let the user choose.
pickdir = 0;
if reset
   pname = uigetdir(pname,dialog);
   if ~ischar(pname)
      pname = [];
   end
   pname = [pname,filesep]; pname = strrep(pname, [filesep filesep], filesep);
   save([pathdir,pathfile],'pname');
end

pname = [pname,filesep]; 
fullpath = strrep(pname,[filesep filesep],filesep);

return