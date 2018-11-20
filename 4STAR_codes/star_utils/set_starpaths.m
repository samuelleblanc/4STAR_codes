function data = set_starpaths(dataset,reset)
% data = set_starpaths(dataset,reset)
% Used to set paths for 4STAR data, mat files, images, etc.
% If 'dataset' is provided and has previously been defined it will be loaded
% unless reset is supplied and true.
% If 'dataset' is not provided or hasn't been defined or is no longer valid
% then new paths will be prompted
% Data paths are returned as fields in "data"

% Mandatory directory settings:
%   None, to run this code.  

% Named directory paths:
%   'stardat'  where you want to find raw data files
%   'starmat'  where you want to find/put allstar.mat files
%   'starsun'  where you want to find/put starsun.mat files
%   'starsky'  where you want to find/put starsky.mat files
%   'starimg'  where you want to find/put *.png files
%   'starfig'  where you want to find/put *.fig files
%   'starppt'  where you want to find/put *.ppt files

% Connor, 2017/12/05
% Connor, 2018-08-12: Modified to accept a named 'dataset' and to return a 
% struct containing the paths
% Connor, 2018-11-20: Modified to define consistent path names
% Fixed logic that was causing pre-defined paths to overwrite new paths
%---------------------------------------------------------------------
version_set('3.0');

% get the version of matlab
vv = version('-release');

if ~isavar('dataset')||isempty(dataset)
   dataset = 'lastdata';
end
if ~isavar('reset')||isempty(reset)
   reset = false;
end
if ischar(reset)
   if strcmpi(reset,'reset')||strcmpi(reset,'true')
      reset = true;
   else
      reset = false;
   end
end
reset = logical(reset);

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

if isafile([pathdir,dataset,'.mat'])&&~reset
   data = load([pathdir,dataset,'.mat']);
end
if ~isavar('data')||isempty(data)||reset
   data.stardat =[];
   data.starfig = [];
   data.starimg = [];
   data.starmat =[];
   data.starppt =[];
   data.starsky =[];
   data.starsun =[];
end
 
fields = fieldnames(data);
for fld = 1:length(fields)
   field = fields{fld};
   while ~isdir(data.(field)) 
%    while ~isdir(data.(field)) || ~strcmp(data.(field),getnamedpath(field))
      if isempty(data.(field)) || ~isdir(getnamedpath(field))
         data.(field) = setnamedpath(field);
      else
         data.(field) = setnamedpath(field,getnamedpath(field));
      end
   end   
   setnamedpath(field,data.(field));
end

save([pathdir, 'lastdata.mat'],'-struct','data');
save([pathdir, dataset,'.mat'],'-struct','data');

return
