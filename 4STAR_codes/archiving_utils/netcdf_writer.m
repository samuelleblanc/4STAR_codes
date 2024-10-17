function netcdf_writer(prefix, platform, HeaderInfo, daystr, data, varinfo, dims, rev, ncdir)

%% Details of the program:
% NAME:
%   netcdf_writer
%
% PURPOSE:
%  To generate archive files in the netcdf format for the starzen radiances 
%
% CALLING SEQUENCE:
%   netcdf_writer(prefix, platform, HeaderInfo, daystr,data,info,dims,rev,ncdir)
%
% INPUT:
%  prefix:         Filename info data id (instrument name)
%  platform:      what platform this instrument is on
%  HeaderInfo:    Information to be put into the header of the file.
%                  Desscription of Header info is seen below. 
%  data:          Structure containing variables to write. All variables should be vectors of the same length at
%                  Start_UTC, and missing values should be NaNs. Field names in this structure will also be
%                  used as varialbe names in the output ICARTT file. Variables will printed in the same order in which they
%                  appear in the structure.
%  varinfo:          Structure of information for dependent variables. Field names should be the same as
%                  those in the data structure. Fields should contain short string descriptions of each variable.
%  dims:          Structure containing dimension variable names for each variable
%  rev:           revision letter (for preliminary data) or number (for final data). MUST BE A STRING!
%  ncdir:         full path for save directory.
%
% OUTPUT:
%  plots and ict file
%
% DEPENDENCIES:
%  - version_set.m
%  - t2utch.m
%  - ICARTTwriter.m
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined
%  - flagfile
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2019-10-04
% Modified
% -------------------------------------------------------------------------

%% Start code
version_set('v1.0')

%% %%% INPUT CHECKING %%%%%
if ~ischar(rev)
    error('Input rev must be a string.');
elseif length(rev)==1
    rev = ['R' rev];
end

if ~isstruct(data)
    error('Input data must be a structure.')
end
if ~isstruct(HeaderInfo)
    error('Input HeaderInfo must be a structure.')
end
if ~isstruct(varinfo)
    error('Input varinfo must be a structure.')
end
if ~isstruct(dims)
    error('Input dims must be a structure.')
end

names = fieldnames(data);
numvar = length(names);
for i=1:numvar    
    %check info
    if ~isfield(varinfo,names{i}) || isempty(varinfo.(names{i}))
        disp(['CAUTION: Info missing for variable ' names{i}])
        varinfo.(names{i}) = 'no decription.';
    end
    
    % check dimensions
    if ~isfield(dims,names{i})
        disp(['CAUTION: Dimensions missing for variable ' names{i}])
        dims.(names{i}) = {};
    end
end

% check directory
if ~isadir(ncdir)
    yn = input(['ncdir ' ncdir ' does not exist. Create? y/n [y]: '],'s');
    if isempty(yn) || yn=='y'
        mkdir(ncdir)
    else
        error(['Invalid save path ' ncdir]);
    end
end

% build the list of dimensions
nm = fieldnames(dims);
dimensions = {};
for i=1:length(nm)
    dimensions = {dimensions{:},dims.(nm{i}){:}};
end
dm = unique(dimensions);
ndim = length(dm);
% check if dimensions is defined in data
for i=1:ndim
   if ~isfield(data,dimensions{i}) 
       error(['Missing dimensions "' dimensions{i} '" variable in data struct'])
   end
end

%% %% Build the automatic files information %%%%
% dates
fltDateForm = datestr(datenum(daystr,'yyyymmdd'),'yyyy, mm, dd'); %formatted
revDate     = datestr(now,'yyyy, mm, dd'); %revision date
HeaderInfo.Date = fltDateForm;
HeaderInfo.File_Creation_date = revDate;

% Filenaming and opening
filename    = [prefix '_' platform '_' daystr '_' rev '.nc'];
filepath    = fullfile(ncdir,filename);
[ncid,message] = netcdf.create(filepath,'NC_WRITE');
if ncid==-1
    disp(message)
    return
end

%% Write out to file %%
% Write global attributes
hnames = fieldnames(HeaderInfo);
nch = netcdf.getConstant('GLOBAL');
for ig=1:length(hnames)
    netcdf.putAtt(ncid,nch,hnames{ig},HeaderInfo.(hnames{ig}));
end

% Write dimensions info
for idim=1:ndim
    n_dim.(dm{idim}) = length(data.(dm{idim}));
    id_dim.(dm{idim}) = netcdf.defDim(ncid,dm{idim},n_dim.(dm{idim}));
end

% Write out the definitions of data variables and their attributes
for j=1:numvar
    % get the dims
    dm_array = [];
    if length(dims.(names{j}))==0
        dm_array = [id_dim.(names{j})];
    else
        for q=1:length(dims.(names{j}))
            dm_array = [dm_array id_dim.(dims.(names{j}){q})];
        end        
    end
    if strcmp(upper(class(data.(names{j}))),'SINGLE')
        cla = 'Float';
    elseif strcmp(upper(class(data.(names{j}))),'UINT8')
        cla = 'ubyte';
    elseif strcmp(upper(class(data.(names{j}))),'INT8')
        cla = 'byte';
    else
        cla =  class(data.(names{j}));
    end
    id_data.(names{j}) = netcdf.defVar(ncid,names{j},cla,dm_array);
    dat_att = fieldnames(varinfo.(names{j}));
    for a=1:length(dat_att)
        netcdf.putAtt(ncid,id_data.(names{j}),dat_att{a},varinfo.(names{j}).(dat_att{a}));
    end
end

netcdf.endDef(ncid);

% store the variables
for j=1:numvar
    netcdf.putVar(ncid,id_data.(names{j}),data.(names{j})); 
end

netcdf.close(ncid);
disp(['Netcdf file written: ' filepath]);

end 