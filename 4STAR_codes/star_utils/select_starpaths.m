function [paths,setname] = select_starpaths

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