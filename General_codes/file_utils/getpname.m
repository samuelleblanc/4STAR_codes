function [pname] = getpname(pathfile,dialog)
% function [pname] = getpname(pathfile,dialog);
% pathfile is a string indicating the filename stem of the mat-file to use
% containing the "filepath" desired.
% Normally this is interactive but if a fspec specifies an exact file it
% is returned without interaction.

% 2022-06-09, CJF: Introducing to return path within existing or new pathfile

% Sometimes the userpath content becomes empty and needs to be reset to
% yield a valid path
if isempty(userpath)
    userpath('reset');
end
usrpath = userpath; 
    
usrpath = strrep(usrpath,';','');
if ~ispc
   usrpath = strrep(usrpath,':','');
end
usrpath = [usrpath,filesep]; 
% DRV = [];
% usrpath = userpath;
% if ~isempty(usrpath)&&strcmp(usrpath(2),':')
%    DRV = usrpath(1:2), usrpath = usrpath(3:end);
% end
% pname = strrep(strrep(usrpath,';',filesep),':',filesep);
pathdir = [usrpath,'filepaths',filesep];
if ~isadir(pathdir)
    mkdir(usrpath, 'filepaths');
end

if ~isavar('dialog')||isempty(dialog)
    if isavar('pathfile')&&~isempty(pathfile)
        dialog = ['Select a directory for ',pathfile,'.'];
    else
        dialog = ['Select a directory.'];
    end
end
if ~isavar('pathfile')||isempty(pathfile)
    pathfile = 'lastpath.mat';
end

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

if isafile([pathdir,pathfile])
    load([pathdir,pathfile]);
    if ~isavar('pname')||isempty(pname)
        pname = pwd;
    end
    if ~ischar(pname)||~isadir(pname)
        clear pname
        pname = [pwd,filesep];
    end
else
    pname = [pwd,filesep];
end;
if ~strcmp(pname(end),filesep)
    pname = [pname, filesep];
end

if ~isadir(pname)
    pname = strrep([uigetdir(dialog),filesep],[filesep filesep],filesep);
end
if ~strcmp(pname,filesep)
    % if ~isempty(pname)
    if isavar('newpathfile')
        save([pathdir,newpathfile], 'pname');
        pathfile = 'lastpath.mat';
        save([pathdir,pathfile],'pname');
    else
        save([pathdir,pathfile], 'pname');
    end
end

return