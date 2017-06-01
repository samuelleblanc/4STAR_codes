function [fullname] = setnamedpath(fspec,pathfile,dialog)
%% SETNAMEDPATH, called to set directory to named path by selecting file
% fullpath = setnamedpath(fspec,pathfile,dialog)
% 'fspec' is a string containing a file mask to be applied to the pick list
% 'pathfile' is a string indicating the filename of the mat-file where the
% path is stored. If pathfile not provided, or is empty then default to lastpath.mat
% 'dialog' is a string that will be provided to the user to prompt for the
% selection of an appropriate path if the supplied pathfile isn't found or
% doesn't map to an existing directory.

version_set('1.0');

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

% Handle missing or empty fspec argument
if ~exist('fspec','var')||isempty(fspec)
   fspec = '*.*';
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
elseif exist([pathdir, 'lastpath.mat'],'file')
     pname = load([pathdir,'lastpath.mat']);
   if isstruct(pname)
      if isfield(pname,'pname')
         pname = pname.pname;
      elseif isfield(pname, 'fpath')
         pname = pname.fpath;
      end
   end 
end
if ~isdir(pname)
   pname = pwd; pname = strrep([pname, filesep],[filesep filesep],filesep);
end

[fname_path,fname,ext] = fileparts(fspec);
if exist(fspec,'dir')
   pname = strrep([fspec,filesep],[filesep filesep], filesep);
elseif exist(fspec,'file')
   pname = strrep([fname_path, filesep],[filesep filesep],filesep);
else
   if exist(fname_path,'dir')
      [fname,pname] = uigetfile([fname_path,filesep,fname, ext],dialog);
   elseif exist(pname, 'dir')
      [fname,pname] = uigetfile([pname,filesep,fname, ext],dialog);
   else
      [fname,pname] = uigetfile([fname ext],dialog);
   end
end
if ischar(pname)
   save([pathdir,pathfile], 'pname');
end
fullname = pname;

return