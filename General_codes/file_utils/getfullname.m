function [fullname] = getfullname(fspec,pathfile,dialog)
% function [fullname] = getfullname(fspec,pathfile,dialog);
% fspec is a string indicating the file mask to be used with uigetfile
% pathfile is a string indicating the filename stem of the mat-file to use
% containing the "filepath" desired.
% Normally this is interactive but if a unique match is found to fspec it
% is returned without interaction.
% 2009-01-08, CJF: Uploading to 4STAR matlab_files repository
% 2011-04-07, CJF: modifying with userpath to hopefully get around needing
% access to the protected matlabroot directory
usrpath = userpath;
if isempty(usrpath)
    [~, usrpath]=system('hostname'); % somehow Yohei's laptop returns blank userpath; call for system hostname
end;
usrpath = [strrep(usrpath,pathsep,''),filesep];

pathdir = [usrpath,'filepaths',filesep];
if ~isdir(pathdir)
    mkdir(pathdir);
end

if isempty(who('dialog'))||isempty(dialog)
    if ~isempty(who('pathfile'))&&~isempty(pathfile)
        dialog = ['Select a file for ',pathfile,'.'];
    else
        dialog = ['Select a file.'];
    end
end
if isempty(who('pathfile'))||isempty(pathfile)
    pathfile = 'lastpath.mat';
end
if isempty(who('fspec'))||isempty(fspec)
    fspec = '*.*';
end
if isempty(fspec)
    fspec = '*.*';
end

if isempty(dir([pathdir,pathfile]))&&~isempty(dir([pathdir,pathfile,'.mat']))
    pathfile = [pathfile,'.mat'];
elseif isempty(dir([pathdir,pathfile]))&&isempty(dir([pathdir,pathfile,'.mat']))
    if ~isempty(strfind(pathfile,'.mat'))
        newpathfile = pathfile;
    else
        newpathfile = [pathfile, '.mat'];
    end
    pathfile = 'lastpath.mat';
end

if ~isempty(dir([pathdir,pathfile]))
    load([pathdir,pathfile]);
    if isempty(who('pname'))||isempty(pname)
        pname = pwd;
    end
    if ~ischar(pname)||~isdir(pname)
        clear pname
        pname = [pwd,filesep];
    end
else
    pname = [pwd,filesep];
end;
if ~strcmp(pname(end),filesep)
    pname = [pname, filesep];
end
[~,fname,ext] = fileparts(fspec);
if (~isempty(dir(fspec))||~isempty(dir([pname,filesep,fname,ext])))&&~isdir(fspec)...
        &&(isempty(strfind(fspec,'*'))&&isempty(strfind(fspec,'%'))&&isempty(strfind(fspec,'?')))
    this = which(fspec,'-all');
    if isempty(this) % Then file exists, but not in path
        this = {fspec};
    end
    [~, fname, ext] = fileparts(this{1});
    fname = [fname ext];
else
    [pth,fstem,ext] = fileparts(fspec);
    fspec = [fstem,ext];
    if isdir(pth)
        [fname,pname] = uigetfile([pth,filesep,fspec],dialog,'multiselect','on');
    elseif isdir(pname)
        [fname,pname] = uigetfile([pname,filesep,fspec],dialog,'multiselect','on');
    else
        [fname,pname] = uigetfile(fspec,dialog,'multiselect','on');
    end
end
if ~isequal(pname,0)
    % if ~isempty(pname)
    if ~iscell(fname)
        fullname = fullfile(pname,filesep, fname);
    else
        for L = length(fname):-1:1
            fullname(L) = {fullfile(pname, fname{L})};
        end
    end
    if ~isempty(who('newpathfile'))
        save([pathdir,newpathfile], 'pname');
        pathfile = 'lastpath.mat';
        save([pathdir,pathfile],'pname');
    else
        save([pathdir,pathfile], 'pname');
    end
else
    fullname = [];
end

return