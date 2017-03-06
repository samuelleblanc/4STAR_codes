function [fullpath] = getnamedpath(pathfile,path_type)
% function [fullpath] = getnamedpath(pathfile,path_type);
% pathfile is a string indicating the filename stem of the mat-file to use
% containing the "filepath" desired.
% Normally this is interactive but if a unique match is found to fspec it
% is returned without interaction.
% 2017-03-02, CJF: creating to open named paths. 
usrpath = userpath;
usrpath = strrep(usrpath,';','');
if ~ispc
   usrpath = strrep(usrpath,':','');
end
usrpath = [usrpath,filesep]; 
% pname = strrep(strrep(usrpath,';',filesep),':',filesep);
pathdir = [usrpath,'filepaths',filesep];
if ~exist(pathdir,'dir')
    mkdir(usrpath, 'filepaths');
end
pathdir = [pathdir,filesep]; pathdir = strrep(pathdir,[filesep filesep],filesep);

if ~exist('path_type','var')||isempty(path_type)
    if exist('pathfile','var')&&~isempty(pathfile)
        path_type = ['Select a path for ',pathfile,'.'];
    else
        path_type = ['Select a path.'];
    end
end
if ~exist('pathfile','var')||isempty(pathfile)
    pathfile = 'lastpath.mat';
end
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

if exist([pathdir,pathfile],'file')
    load([pathdir,pathfile]);
    if ~exist('pname','var')||isempty(pname)
        pname = pwd;
    end
    if ~ischar(pname)||~exist(pname,'dir')
        clear pname
        pname = [pwd,filesep];
    end
else
    tmp = getfullname('*.*',pathfile,['Select a file in the directory you want to use for ' path_type]);
    if ~isempty(tmp)
       [pname, ~,~] = fileparts(tmp);
    end
%     pname = [pwd,filesep];
end;
pname = [pname,filesep]; 
fullpath = strrep(pname,[filesep filesep],filesep);

return