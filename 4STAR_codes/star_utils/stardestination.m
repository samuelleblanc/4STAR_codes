function savematfile=stardestination(unconfirmed_savematfile)

% regulate destination for 4STAR codes including allstarmat.m.
% Yohei, 2012/04/11
% CJF: 20160922, fixing defaultsavefolder to be the datapath in starpaths
if ~isstr(unconfirmed_savematfile);
    error('Destination must be given in a string.');
elseif size(unconfirmed_savematfile,1)~=1;
    error('One destination file must be given.');
end;
[folder0, file0, ext0]=fileparts(unconfirmed_savematfile);
if exist(folder0)==7; % looks like a full path is already given; do a minimum check and return the input
    if ~isequal(lower(ext0), '.mat');
        error('Destination must be a mat file.');
    else
        savematfile=unconfirmed_savematfile;
    end;
else % ask for a full path
    if (strcmp(getUserName,'sleblan2'));
        defaultsavefolder=get_last_used_path();
    else
        if ~isempty(which('starpaths')); % look into pre-set path
            [defaultsavefolder, figurefolder, askforsourcefolder, author]=starpaths;
        else
            defaultsavefolder='';
        end;
    end;
    [savematfile, defaultsavefolder] = uiputfile(fullfile(defaultsavefolder, unconfirmed_savematfile), ...
        'Save file as');
    if ~isequal(savematfile,0);
        savematfile=fullfile(defaultsavefolder,savematfile);
        if (strcmp(getUserName,'sleblan2')); % special for Sam
            updateLastUsedPath(defaultsavefolder);
        end;
    end;
end;

%% function to get the last used path
function lastDir = get_last_used_path()

% name of mat file to save last used directory information
pname = strrep(userpath,';',filesep);
pathdir = [pname, 'filepaths',filesep];
if ~exist(pathdir,'dir')
    mkdir(pname, 'filepaths');
end
% pathdir = [pathdir,filesep];

lastDirMat = [pathdir, 'lastUsedDir.mat'];

% save the present working directory
savePath = pwd;
% set default dialog open directory to the present working directory
lastDir = savePath;
% load last data directory
if exist(lastDirMat, 'file') ~= 0
    % lastDirMat mat file exists, load it
    load('-mat', lastDirMat)
    % check if lastDataDir variable exists and contains a valid path
    if (exist('lastUsedDir', 'var') == 1) && ...
            (exist(lastUsedDir, 'dir') == 7)
        % set default dialog open directory
        lastDir = lastUsedDir;
    end
end;
return

%% function to save the last used path
function updateLastUsedPath(savefolder);
% name of mat file to save last used directory information
pname = strrep(userpath,';',filesep);
pathdir = [pname, 'filepaths',filesep];
if ~exist(pathdir,'dir')
    mkdir(pname, 'filepaths');
end
lastDirMat = [pathdir, 'lastUsedDir.mat'];

if ~isequal(savefolder,0)
    try
        % save last folder used to lastDirMat mat file
        lastUsedDir = savefolder;
        save(lastDirMat, 'lastUsedDir');
    catch
        % error saving lastDirMat mat file, display warning, the folder
        % will not be remembered
        disp(['Warning: Could not save file ''', lastDirMat, '''']);
    end
end
return