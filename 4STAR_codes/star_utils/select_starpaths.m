function [paths,setname] = select_starpaths
% [paths,setname] = select_starpaths
%% Details of the program:
% NAME:
%   select_starpaths
%
% PURPOSE:
%  Identify locations to find/save various 4STAR input/output files and
%  associate this collection of locations with user-specified name
%
% INPUT: None
%
% OUTPUT:
%  paths: struct containing the named paths 
%  setname: user-supplied name for the collection of paths
%
% DEPENDENCIES:
%  - set_starpaths
%
% NEEDED FILES:
%
% MODIFICATION HISTORY:
% Written (v1.0): Connor Flynn, PNNL, 2018-08-14
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

usrpath = userpath;
if isempty(usrpath)
    [~, usrpath]=system('hostname'); % somehow Yohei's laptop returns blank userpath; call for system hostname
end
usrpath = [strrep(usrpath,pathsep,''),filesep];
% append filesep
pathdir = [usrpath,'starpaths',filesep];
% If "starpaths" directory doesn't exist under userpath, create it
if ~isdir(pathdir)
    mkdir(usrpath, 'starpaths');
end

% Take a directory listing of pathdir *.mat
% 
mats = dir([pathdir,'*.mat']);
for M = length(mats):-1:1
   [~,mat,x] = fileparts(mats(M).name);
   men(M) = {mat};
end
if any(strcmp(men,'lastdata'))
   men(strcmp(men,'lastdata')) = [];
   men = [{'MANUAL'}, {'lastdata'},men];
end
mn = menu('Select a 4STAR data set...',men);

if mn==1
   newname = menu('Pick a name for this manual selection?','No','Yes');
   if newname > 1
      setname = input('Type the data set name...','s');
   else
      setname = [];
   end   
else
   setname = men{mn};
end
paths = set_starpaths(setname);

return