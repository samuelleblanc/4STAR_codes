function [fpath] = getfilepath(pathfile,dialog,reset);
% function [fpath] = getfilepath(pathfile,dialog,reset);
% pathfile is a string indicating the filename stem of the mat-file to use
% containing the "filepath" desired.
% reset is a boolean indicating whether or not to query for a new filepath
% 2016-10-03, CJF: developing for use with 4STAR and other utilities to
% interactively associated a path to a file or group of files 

% Handle whether "reset" is provided or not
if ~exist('reset','var')
    reset = false;
end

% Handle incorrect class for "reset"
if ~islogical(reset)
    warning('Input arguement "reset" should be boolean')
    reset = false;
end

% Handle missing "dialog" argument
if ~exist('dialog','var')||isempty(dialog)
   if exist('pathfile','var')&&~isempty(pathfile)
      dialog = ['Select a directory for ',pathfile,'.'];
   else
      dialog = ['Select a directory.'];
   end
end

% Handle missing pathfile argument
if ~exist('pathfile','var')||isempty(pathfile)
   pathfile = 'lastpath.mat';
end

pname = strrep(strrep(userpath,';',filesep),':',filesep);
pathdir = [pname, 'filepaths',filesep];
if ~exist(pathdir,'dir')
    mkdir(pname, 'filepaths');
end

%
%Handle whether pathfile is provided with .mat extension or not
if ~exist([pathdir,pathfile],'file')&&exist([pathdir,pathfile,'.mat'],'file')
   pathfile = [pathfile,'.mat'];
elseif ~exist([pathdir,pathfile],'file')&&~exist([pathdir,pathfile,'.mat'],'file')
   if ~isempty(strfind(pathfile,'.mat'))
      newpathfile = pathfile;
   else
      newpathfile = [pathfile, '.mat'];
   end
   pathfile = 'lastpath.mat';
end

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
end

% If the resulting path doesn't exist or if reset is true then use uigetdir to get a new one.
if reset || ~isdir(pname)
    pname = uigetdir(pname,dialog);
    if pname==0
        pname = [];
    else
        pname = [pname, filesep];
    end
end

fpath = pname;
if isdir(fpath)
    save([pathdir,pathfile],'fpath');
    if exist('newpathfile','var')
        save([pathdir,newpathfile],'fpath');
    end
end

return