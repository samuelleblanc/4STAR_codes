function [filename, pathname, filterindex] = uigputfile2(varargin)

%UIPUTFILE2 Standard open file dialog box which remembers last opened folder
%   UIPUTFILE2 is a wrapper for Matlab's UIPUTFILE function which adds the
%   ability to remember the last folder opened.  UIPUTFILE2 stores
%   information about the last folder opened in a mat file which it looks
%   for when called.
%
%   UIPUTFILE2 can only remember the folder used if the current directory
%   is writable so that a mat file can be stored.  Only successful file
%   selections update the folder remembered.  If the user cancels the file
%   dialog box then the remembered path is left the same.
%
%   Modified to save last directory file in userpath which users typically 
%   have write access to.
%
%   Usage is the same as UIPUTFILE.
%
%
%   See also UIGETFILE, UIPUTFILE, UIGETDIR.

%   Written by Chris J Cannell and Aditya Gadre
%   Contact ccannell@mindspring.com for questions or comments.
%   12/05/2005
%  2016/02/12 CJF Modified to use userpath

% name of mat file to save last used directory information
pname = strrep(userpath,';',filesep);
if ~ispc
    pname = strrep(pname,':',filesep);
end;
pname = [pname, filesep]; pname = strrep(pname, [filesep, filesep], filesep);
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
end

% load folder to open dialog box in
cd(lastDir);
% call uiputfile with arguments passed from uigetfile2 function
[filename, pathname, filterindex] = uiputfile(varargin{:});
% change path back to original working folder
cd(savePath);

% if the user did not cancel the file dialog then update lastDirMat mat
% file with the folder used
if ~isequal(filename,0) && ~isequal(pathname,0)
    try
        % save last folder used to lastDirMat mat file
        lastUsedDir = pathname;
        save(lastDirMat, 'lastUsedDir');
    catch
        % error saving lastDirMat mat file, display warning, the folder
        % will not be remembered
        disp(['Warning: Could not save file ''', lastDirMat, '''']);
    end
end
