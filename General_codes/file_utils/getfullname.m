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
% 2019-08-15, CJF: fixing empty userpath issue and also force disp(dialog)
% when not running on a PC to handle Mac OSX suppression of dialog titles

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
        dialog = ['Select a file for ',pathfile,'.'];
    else
        dialog = ['Select a file.'];
    end
end
if ~isavar('pathfile')||isempty(pathfile)
    pathfile = 'lastpath.mat';
end
if ~isavar('fspec')||isempty(fspec)
    fspec = '*.*';
end
if isempty(fspec)
    fspec = '*.*';
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
[~,fname,ext] = fileparts(fspec);
if (isafile(fspec)||isafile([pname,filesep,fname,ext]))&&~isadir(fspec)
    this = which(fspec,'-all');
    if isempty(this) % Then file exists, but not in path
        this = {fspec};
    end
    [~, fname, ext] = fileparts(this{1});
    fname = [fname ext];
else
    [pth,fstem,ext] = fileparts(fspec);
    fspec = [fstem,ext];
    if ~ispc; disp(dialog); end

    if isadir(pth)
        [fname,pname] = uigetfile([pth,filesep,fspec],dialog,'multiselect','on');
    elseif isadir(pname)
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
    if isavar('newpathfile')
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