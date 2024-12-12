function [fullpath] = setnamedpath(pathfile,fspec,dialog)
%% SETNAMEDPATH, called to set directory to named path by selecting file
% fullpath = setnamedpath(pathfile,fspec,dialog)
% 'pathfile' is a string indicating the filename of the mat-file where the
% path is stored. If pathfile not provided, or is empty then default to lastpath.mat
% 'fspec' is a string containing either the explicit path to be used or
% the starting point for a browse window if fspec is empty or ~isadir.
% If fspec is a directory
% Adding a wildcard to fspec will force browse.
% 'dialog' is a string that will be provided to the user to prompt for the
% selection of an appropriate path if the supplied pathfile isn't found or
% doesn't map to an existing directory.
%
% 2022-10-27, SL: Added handling of paths for network connected folders

version_set('1.1');

% Handle missing "pathfile" argument. If 'pathfile' wasn't provided or is
% empty then default to lastpath.mat
if isempty(who('pathfile'))||isempty(pathfile)
    pathfile = 'lastpath.mat';
end

% Handle missing or empty "fspec" argument
if ~isavar('fspec')||isempty(fspec)
    fspec = '';
end
fspec = strrep(fspec,[filesep filesep],filesep);
% if ~strcmp(fspec(end),filesep)
%     fspec(end+1) = filesep;
% else
%     fspec = strrep(fspec,[filesep filesep],filesep);
% end

[pname,fstem,ext] = fileparts(fspec);
if ~isempty(pname)
    pname = [pname filesep];
end
fstem = [fstem ext];
pickdir = isempty(fstem);
% If fstem is empty then use uigetdir to select a directory
% else use uigetfile to select a file within a directory


% Handle missing "dialog" argument
if isempty(who('dialog'))||isempty(dialog)
    if pickdir
        if ~isempty(who('pathfile'))&&~isempty(pathfile)&&~strcmp(pathfile,'lastpath.mat')
            dialog = ['Select a directory for ',pathfile,'.'];
        else
            dialog = ['Select a directory.'];
        end
    else
        if ~isempty(who('pathfile'))&&~isempty(pathfile)&&~strcmp(pathfile,'lastpath.mat')
            dialog = ['Select a file within the directory for ',pathfile,'.'];
        else
            dialog = ['Select a file within the desired directory.'];
        end
    end
end

% Store pathfiles in a directory below the userpath named "filepaths"
% Non-trivial to make transparent over different architectures and OS.
% Handle ideosyncracies having to do with different platforms and Matlab
% versions associated with pathsep and filesep. Some versions of Matlab
% return userpath with a terminating filesep character but some don't.
% Handle both cases by adding it every time and then removing duplicates.

[~, pathfile, ~] = fileparts(pathfile); pathfile = [pathfile,'.mat'];
% remove trailing pathsep from userpath
usrpath = userpath;
if isempty(usrpath)
    [~, usrpath]=system('hostname'); % somehow Yohei's laptop returns blank userpath; call for system hostname
end
usrpath = [strrep(usrpath,pathsep,''),filesep];
% append filesep
pathdir = [usrpath,'filepaths',filesep];
% If "filepaths" directory doesn't exist under userpath, create it
if ~isadir(pathdir)
    mkdir(usrpath, 'filepaths');
end

% Check whether a valid directory has been provided in fspec
% if not then browse...
if ~isempty(fspec)&&isadir(fspec)
    % clean up termination of fspec to have one and only one filesep
    save([pathdir,pathfile], 'pname');
else
%     !! Check this!!
%     while ~isadir(pname)||isempty(pname)
        % if not, check if fspec is a valid path stem plus mask.
        if ~isempty(pname)&&isadir(pname)
            if pickdir
                [pname] = uigetdir([pname,fstem],dialog);
            else
                [fname,pname] = uigetfile([pname,fstem],dialog);
            end
        else
            % if not, then load lastpath (if it exists) and
            if isafile([pathdir,pathfile])
                pname = load([pathdir, pathfile]);
            elseif isafile([pathdir,'lastpath.mat'])
                pname = load([pathdir,'lastpath.mat']);
            end
            if isstruct(pname)
                if isfield(pname,'pname')
                    pname = pname.pname;
                elseif isfield(pname, 'fpath')
                    pname = pname.fpath;
                elseif isfield(pname,'lastUsedDir')
                   pname = pname.lastUsedDir
                end
            end
            if ~isadir(pname)
<<<<<<< Updated upstream
                pname = pwd;
=======
                pname = pwd; pname = [pname, filesep]; pname = strrep(pname, [filesep filesep], filesep);
>>>>>>> Stashed changes
            end
            pname = [pname, filesep,'..',filesep];
            if pickdir
                [pname] = uigetdir([pname,fstem],dialog);
            else
                [fname,pname] = uigetfile([pname,fstem],dialog);
            end
        end
        pname = [pname, filesep]; 
        ifileseps = strfind(pname,[filesep filesep]); 
        pname = strrep(pname,[filesep filesep], filesep);
        if any(ifileseps<2), pname = [filesep, pname]; end %for any leading double // for network attached drives
        if ~isempty(pname)&&isadir(pname)
            save([pathdir,'lastpath.mat'],'pname');
        end
%     end
    if ~isempty(pname)&&isadir(pname)
        save([pathdir,pathfile], 'pname');
    end
end
fullpath = pname;
%
% % If fspec does not represent an existing directory, then save it to pathfile.
%
% % If the pathfile exists, then load it.
% if ~isempty(dir([pathdir, pathfile]))
%    pname = load([pathdir,pathfile]);
%    if isstruct(pname)
%       if isfield(pname,'pname')
%          pname = pname.pname;
%       elseif isfield(pname, 'fpath')
%          pname = pname.fpath;
%       end
%    end
% elseif ~isempty(dir([pathdir, 'lastpath.mat']))
%      pname = load([pathdir,'lastpath.mat']);
%    if isstruct(pname)
%       if isfield(pname,'pname')
%          pname = pname.pname;
%       elseif isfield(pname, 'fpath')
%          pname = pname.fpath;
%       end
%    end
% end
% if ~isadir(pname)
%    pname = pwd; pname = strrep([pname, filesep],[filesep filesep],filesep);
% end
%
% [fname_path,fname,ext] = fileparts(fspec);
% if isadir(fspec)
%    pname = strrep([fspec,filesep],[filesep filesep], filesep);
% elseif ~isempty(who(fspec))
%    pname = strrep([fname_path, filesep],[filesep filesep],filesep);
% else
%    if isadir(fname_path)
%       [fname,pname] = uigetfile([fname_path,filesep,fname, ext],dialog);
%    elseif isadir(pname)
%       [fname,pname] = uigetfile([pname,filesep,fname, ext],dialog);
%    else
%       [fname,pname] = uigetfile([fname ext],dialog);
%    end
% end
% if ischar(pname)
%    save([pathdir,pathfile], 'pname');
% end
% fullpath = pname;

return