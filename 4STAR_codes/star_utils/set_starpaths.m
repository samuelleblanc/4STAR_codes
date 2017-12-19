function set_starpaths
%set_starpaths
% Forces user to select paths for raw_data, allstar mat-files, starsun
% mat-files, and figure files
% Mandatory directory settings:
%   None, to run this code.  

% Named directory paths:
%   'rawdata' where you want to find raw data files
%   'allstarmat' where you want to find/put allstar.mat files
%   'starsun' where you want to find/put starsun.mat files
%   'starsky' where you want to find/put starsky.mat files
%   'figs'    where you want to find/oput *.fig, *.png, etc.


% Connor, 2017/12/05
%---------------------------------------------------------------------
version_set('1.0');

% get the version of matlab
vv = version('-release');

setnamedpath('rawdata'); 
setnamedpath('allstarmat'); 
setnamedpath('starsun'); 
setnamedpath('starsky','*.mat'); 
setnamedpath('figs'); 

return
