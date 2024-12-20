%% Details of the program:
% NAME:
%   ICARTTwriter
%
% PURPOSE:
%  Generates an ICARTT file for field data.
% This funciton is based on the example  for flight data from the NASA ISAF formaldehyde instrument.
% For more info on format, see the ICARTT documentation:
% http://www-air.larc.nasa.gov/missions/etc/IcarttDataFormat.htm
% This file is intended to serve as a framework; header and comment information
% should be modified to suit the user's dataset.
% Note that revision and special comments are entered near the top of the file.
%
% CALLING SEQUENCE:
%   ICARTTwriter(dataI, locID, HeaderInfo, specComments, NormalComments, revComments, startDay,Start_UTC,data,info,form,rev,ICTdir)
%
% INPUT:
%  dataID:         Filename info data id (instrument name)
%  locID:          Location ID: what platform this instrument is on
%  HeaderInfo:     Information to be put into the header of the file.
%                   Desscription of Header info is seen below. 
%  specComments:   Special Comments, must end each line with a '/n'
%  NormalComments: Normal comments at the start of the header
%                   Description of what is included in normal comments see
%                   below.
%  revComments:    Comments related to revisions. Includes all revision
%                   history comments
%  startDay:       UTC beginning date for data, yyyymmdd
%  Start_UTC:      data timestamp. ICARTT format specifies that this is UTC seconds since the beginning of
%                   startDay. Other timestamps can be included as dependent variables. Note that appropriate
%                   timestamps may vary depending on how data is collected or averaged (see ICARTT documenation).
%  data:           Structure containing variables to write. All variables should be vectors of the same length at
%                   Start_UTC, and missing values should be NaNs. Field names in this structure will also be
%                   used as varialbe names in the output ICARTT file. Variables will printed in the same order in which they
%                   appear in the structure.
%  info:           Structure of information for dependent variables. Field names should be the same as
%                   those in the data structure. Fields should contain short string descriptions of each variable.
%  form:           Structure containing format strings for dependent variables. Field names should be the same as
%                   those in the data structure. Default value is '%6.3f'. For more info, see help for fprintf.
%  rev:            revision letter (for preliminary data) or number (for final data). MUST BE A STRING!
%  ICTdir:         full path for save directory.
%  missing_data_val: (defaults to -9999) the value to be put in the file if there is a missing data
%
% OUTPUT:
%  ict file
%
% DEPENDENCIES:
%  - version_set.m
%  - t2utch.m
%  - ICARTTwriter.m
%  - ...
%
% NEEDED FILES:
%  - starzen.mat file compiled from raw data using allstarmat and then
%  processed with starzen
%
% EXAMPLE USAGE:
%  startDay          = '20130603';
%  rev               = 'A';
%  ICTdir            = 'C:\Data\ICARTT\';
%  Start_UTC         = 0:9;
% 
%  data.Stop_UTC     = 1:10;
%  info.Stop_UTC     = 'seconds';
%  form.Stop_UTC     = '%6.0f';
% 
%  data.DOY_UTC      = 154 + Start_UTC/86400;
%  info.DOY_UTC      = 'Fractional day of year';
%  form.DOY_UTC     = '%6.6f';
% 
%  data.HCHO_ppbv    = rand(10,1);
%  info.HCHO_ppbv    = 'volume mixing ratio of formaldehyde';
%  form.HCHO_ppbv    = '%6.3f';
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, March 18th, 2015
%                 based on ICARTTwriter_example.m written by 20130606 GMW; gwolfe@umbc.edu
% Modified (v1.1): Samuel LeBlanc, Osan AB, Korea, May 15th, 2016
%                  - added the missing_data_val keyword
% Modified (v1.2): Samuel LeBlanc, Santa Cruz, 2017-06-28
%                  - modified the missing_data_val file writing to match
%                  the format of the missing data
% Modified (v1.3): Samuel LeBlanc, St-John's Newfoundland, Canada, 2017-09-16
%                  - fixed bug in line length when giving empty
%                  special_comments cell.
%
% -------------------------------------------------------------------------

function ICARTTwriter(dataID, locID, HeaderInfo, specComments, NormalComments, revComments, startDay,Start_UTC,data,info,form,rev,ICTdir,missing_data_val)
version_set('v1.3')
%----------------------------------------------------------
%  BEGIN INPUT OF MEASUREMENT-SPECIFIC INFO
%----------------------------------------------------------

% FILENAME INFO
%dataID      = 'HCHO';   %DATA ID (1st part of filename)
%locID       = 'NP3';    %LOCATION ID (2nd part of filename)

%HeaderInfo = {...
%    'Hanisco, Thomas F.';...                     % PI name
%    'NASA Goddard Space Flight Center';...       % Organization
%    'ISAF In Situ Airborne Formaldehyde';...     % Data Source
%    'SENEX';...                                  % Mission name
%    '1, 1';...                                   % volume number, number of file volumes
%    '1';...                                      % time interval (see documentation)
%    'Start_UTC, seconds';...                     % Independent variable name and description
%    };

%%%%% SPECIAL COMMENTS %%%%%
% Enter for each file as needed.
% Remember to end each line with \n.
%switch startDay
%    case '19820123'
%        specComments = {...
%            'This is an example.\n';...
%            'It has three comments.\n';...
%            'Savvy?\n';...
%            };
%    otherwise
%        specComments = {};
%end

%NormalComments = {...
%    'PI_CONTACT_INFO: NASA GSFC, Code 614, Greenbelt, MD 20771; thomas.hanisco@nasa.gov; 301-614-6598';...
%    'PLATFORM: NOAA WP-3D';...
%    'LOCATION: SENEX Field Campaign';...
%    'ASSOCIATED DATA: N/A';...
%    'INSTRUMENT_INFO: In situ laser induced fluorescence detection of formaldehyde';...
%    'DATA INFO: All data in parts per trillion by volume (pptv). 10 Hz data is available upon request.';...
%    'UNCERTAINTY: Calibration uncertainty is +/-10 percent. Offset uncertainty is +/- 10 pptv.';...
%    'ULOD_FLAG: -7777';...
%    'ULOD_VALUE: N/A';...
%    'LLOD_FLAG: -8888';...
%    'LLOD_VALUE: N/A';...
%    'DM_CONTACT_INFO: Glenn Wolfe, NASA GSFC; glenn.m.wolfe@nasa.gov; 301-614-6008';...
%    'PROJECT_INFO: SENEX Field Campaign, Nashville, TN, June and July 2013';...
%    'STIPULATIONS_ON_USE: Use of these data requires prior approval from the PI.';...
%    'OTHER_COMMENTS: N/A';...
%    };

%%%%% REVISION COMMENTS %%%%%
% Latest revision should appear at top of list.
% Remember to end each line with \n.
% if isletter(rev(end))
%     % preliminary data
%     revComments = {...
%         'RA: Preliminary field data.\n';...
%         };
% else
%     % final data
%     revComments = {...
%         'R0: Final data.\n';...
%         };
% end

%----------------------------------------------------------
%  END INPUT OF MEASUREMENT-SPECIFIC INFO
%----------------------------------------------------------

%%%%% INPUT CHECKING %%%%%
if ~ischar(rev)
    error('Input rev must be a string.');
elseif length(rev)==1
    rev = ['R' rev];
end

if ~isstruct(data)
    error('Input data must be a structure.')
end

L = length(Start_UTC);
names = fieldnames(data);
numvar = length(names);
for i=1:numvar
    %check lengths
    d = data.(names{i});
    if ~isvector(d) || length(d)~=L
        error(['Data field ' names{i} ' must be same size as Start_UTC.'])
    end
    data.(names{i}) = d(:); %make column vector
    
    %check info
    if ~isfield(info,names{i}) || any(isnan(info.(names{i}))) || isempty(info.(names{i}))
        disp(['CAUTION: Info missing for variable ' names{i}])
        info.(names{i}) = 'no decription.';
    end
    
    % check format
    if ~isfield(form,names{i}) || any(isnan(form.(names{i}))) || isempty(form.(names{i}))
        disp(['CAUTION: Format string missing for variable ' names{i}])
        form.(names{i}) = '%6.3f';
    end
end

%check directory
if ~isadir(ICTdir)
    yn = input(['ICTdir ' ICTdir ' does not exist. Create? y/n [y]: '],'s');
    if isempty(yn) || yn=='y'
        mkdir(ICTdir)
    else
        error(['Invalid save path ' ICTdir]);
    end
end

%check the missing_data_val
if ~exist('missing_data_val','var')
  missing_data_val = -9999.0;
end

%%%%% DATA HANDLING %%%%%
data = struct2cell(data);
for i=1:length(data);
    data{i} = double(data{i});
end;
data = cell2mat(data'); %single matrix, with one column for each variable
data(~isfinite(data)) = missing_data_val; %replace missing data

%%%%% NUMBERS AND FORMATTING BS %%%%%
numhead  = length(HeaderInfo);                  %number of beginning header lines
numrev   = length(revComments);                 %number of revisions
numspec  = length(specComments);                %number of special comments
numnorm  = length(NormalComments) + numrev;     %number of normal comments
numlines = numhead + numvar + numspec + numnorm + 9 ;%number of lines in header, with extra lines indicating number of lines

fStrmiss = ''; %format for independent variable
for i=1:numvar; fStrmiss = [fStrmiss ', ' form.(names{i})]; end;
fStrmiss = [fStrmiss(2:end) ' \n'];
missStr = sprintf(fStrmiss,repmat(missing_data_val,1,numvar)); %missing data flag
%fprintf(fid,fStr,Start_UTC(i),data(i,:))
%missStr = repmat([num2str(missing_data_val) ', '],1,numvar);         %missing data flag
missStr = [missStr(1:end-2) '\n'];

scaleStr = repmat('1, ',1,numvar);            %scaling factor
scaleStr = [scaleStr(1:end-2) '\n'];

%%%%% DATES %%%%%
fltDateForm = datestr(datenum(startDay,'yyyymmdd'),'yyyy, mm, dd'); %formatted
revDate     = datestr(now,'yyyy, mm, dd'); %revision date

%%%%% FILENAMING %%%%%
filename    = [dataID '_' locID '_' startDay '_' rev '.ict'];
filepath    = fullfile(ICTdir,filename);
[fid,message] = fopen(filepath,'w'); %open file and overwrite if it exists
if fid==-1
    disp(message)
    return
end

%%%%% START HEADER PRINTING %%%%%
fprintf(fid,[int2str(numlines) ', 1001\n']);    % Number of header lines, file format index
if numhead ~= 7,
    error('Header Info does not have 7 lines, please change either Header info or ICARTTwriter program')
end;
fprintf(fid, [HeaderInfo{1} '\n']);               % PI name
fprintf(fid, [HeaderInfo{2} '\n']);               % Organization
fprintf(fid, [HeaderInfo{3} '\n']);               % Data Source
fprintf(fid, [HeaderInfo{4} '\n']);               % Mission name
fprintf(fid, [HeaderInfo{5} '\n']);               % volume number, number of file volumes
fprintf(fid,[fltDateForm ', ' revDate '\n']);   % data date, revision date
fprintf(fid, [HeaderInfo{6} '\n']);               % time interval (see documentation)
fprintf(fid, [HeaderInfo{7} '\n']);               % Independent variable
fprintf(fid,[int2str(numvar),'\n']);            % Number of dependent variables
fprintf(fid,scaleStr);                          % Scaling factors
fprintf(fid,missStr);                           % Missing data indicator

%%%%% DEPENDENT VARIABLE NAMES/DESCRIPTIONS %%%%%
for i=1:numvar
    fprintf(fid,[names{i} ', ' info.(names{i}) '\n']);
end

%%%%% SPECIAL COMMENTS %%%%%
fprintf(fid,[int2str(numspec) '\n']); % Number of special comment lines
for i=1:numspec
    if ~strcmp(specComments{i}(end-1:end),'\n')
        specComments{i} = [specComments{i} '\n'];
    end
    fprintf(fid,specComments{i});
end

%%%%% NORMAL COMMENTS %%%%%
fprintf(fid,[int2str(numnorm+2) '\n']); % Number of normal comment lines
if numnorm-numrev ~= 15,
    error('Normal Comments does not have 15 lines, please change either Normal Comments or ICARTTwriter program')
end;
fprintf(fid, [NormalComments{1} '\n']);
fprintf(fid, [NormalComments{2} '\n']);
fprintf(fid, [NormalComments{3} '\n']);
fprintf(fid, [NormalComments{4} '\n']);
fprintf(fid, [NormalComments{5} '\n']);
fprintf(fid, [NormalComments{6} '\n']);
fprintf(fid, [NormalComments{7} '\n']);
fprintf(fid, [NormalComments{8} '\n']);
fprintf(fid, [NormalComments{9} '\n']);
fprintf(fid, [NormalComments{10} '\n']);
fprintf(fid, [NormalComments{11} '\n']);
fprintf(fid, [NormalComments{12} '\n']);
fprintf(fid, [NormalComments{13} '\n']);
fprintf(fid, [NormalComments{14} '\n']);
fprintf(fid, [NormalComments{15} '\n']);
fprintf(fid,['REVISION:' rev '\n']);
for i=1:numrev
    if any(regexp(revComments{i},'\n$')),
        fprintf(fid,revComments{i});
    else
        fprintf(fid,[revComments{i} '\n']); 
    end
end %revision comments

%%%%% PRINT DATA %%%%%%
%build variable names string and formatting string
nameStr = strtok(HeaderInfo{7},','); %start with independent variable name
fStr = '%6.0f'; %format for independent variable
for i=1:numvar
    nameStr = [nameStr ', ' names{i}];
    fStr = [fStr ', ' form.(names{i})];
end
fStr = [fStr '\n'];

%print it
fprintf(fid,[nameStr '\n']);
for i=1:L
    fprintf(fid,fStr,Start_UTC(i),data(i,:));
end

status = fclose(fid);
if status
    disp('Problem closing file.');
end
disp(['ICARTT file written: ' filepath]);


