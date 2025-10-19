function [fpath] = getfilepath(pathfile,dialog,reset);
% function [fpath] = getfilepath(pathfile,dialog,reset);
% pathfile is a string indicating the filename stem of the mat-file to use
% containing the "filepath" desired.
% reset is a boolean indicating whether or not to query for a new filepath
% 2016-10-03, CJF: developing for use with 4STAR and other utilities to
% interactively associated a path to a file or group of files 

% Handle whether "reset" is provided or not
if ~isavar('reset')
    reset = false;
end

% Handle incorrect class for "reset"
if ~islogical(reset)
    warning('Input arguement "reset" should be boolean')
    reset = false;
end

% Handle missing "dialog" argument
if ~isavar('dialog')||isempty(dialog)
   if isavar('pathfile')&&~isempty(pathfile)
      dialog = ['Select a directory for ',pathfile,'.'];
   else
      dialog = ['Select a directory.'];
   end
end

% Handle missing pathfile argument
if ~isavar('pathfile')||isempty(pathfile)
   pathfile = 'lastpath.mat';
end

pname = strrep(strrep(userpath,';',filesep),':',filesep);
pathdir = [pname,filesep, 'filepaths',filesep];
if ~isadir(pathdir)
    mkdir([pname,filesep, 'filepaths']);
end

%
%Handle whether pathfile is provided with .mat extension or not
if ~isafile([pathdir,pathfile])&&isafile([pathdir,pathfile,'.mat'])
   pathfile = [pathfile,'.mat'];
elseif ~isafile([pathdir,pathfile])&&~isafile([pathdir,pathfile,'.mat'])
   if ~isempty(strfind(pathfile,'.mat'))
      newpathfile = pathfile;
   else
      newpathfile = [pathfile, '.mat'];
   end
   pathfile = 'lastpath.mat';
end

% If the pathfile exists, then load it.
if isafile([pathdir, pathfile])
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
if reset || ~isadir(pname)
    pname = uigetdir(pname,dialog);
    if pname==0
        pname = [];
    else
        pname = [pname, filesep];
    end
end

fpath = pname;
if isadir(fpath)
    save([pathdir,filesep,pathfile],'fpath');
    if isavar('newpathfile')
        save([pathdir,newpathfile],'fpath');
    end
end

return