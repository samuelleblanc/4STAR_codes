function [fullpath] = getnamedpath(pathfile,dialog)
%% GETNAMEDPATH, called to obtain paths to 4STAR data, images, and Github data_folder
% fullpath = getnamedpath(pathfile,dialog);
% 'pathfile' is a string indicating the filename of the mat-file where the 
% path is stored. If pathfile not provided, or is empty then default to lastpath.mat
% 'dialog' is a string that will be provided to the user to prompt for the
% selection of an appropriate path if the supplied pathfile isn't found or
% doesn't map to an existing directory.
%
% 2017-03-21, CJF: Modified for robustness. Potential replacement for starpaths
% 2017-08-05, CJF: Handle alternate forms for argument "reset"
% 2017-12-05, CJF: Removing 'RESET' argument
% 2022-10-27, SL: v1.2, Added handling of paths for network connected folders
version_set('1.2'); 

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
reset = false;
if exist([pathdir, pathfile],'file')
   pname = load([pathdir,pathfile]);
   if isstruct(pname)
      if isfield(pname,'pname')
         pname = pname.pname;
      elseif isfield(pname, 'fpath')
         pname = pname.fpath;
      end
   end
   if isempty(pname)||~isadir(pname)
      reset = true; 
      [~,pthfile,~]= fileparts(pathfile);
      pthfile = ['Path in "',pthfile,'" does not exist. ']; 
   end
else % reset it
   reset = true;
end
if ~isadir(pname)
   pname = pwd;
end

% If reset is true use uigetdir to update pname and pathfile.
% The downside to using uigetdir here is that the user can't see any of the
% files since it only shows directories.  It can be nicer to select a file
% within a directory and strip the filepath, so we let the user choose.

if reset
    if isavar('pthfile')&&~isempty(pthfile)
        dialog = [pthfile, dialog];
    end
pname = setnamedpath(pathfile,[],dialog);
end

pname = [pname,filesep]; 
ifileseps = strfind(pname,[filesep filesep]); 
pname = strrep(pname,[filesep filesep], filesep);
if any(ifileseps<2), pname = [filesep, pname]; end %for any leading double // for network attached drives
fullpath = pname;

return