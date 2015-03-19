%% Details of the program:
% NAME:
%   SEmakearchive_ARISE_zenrad
%
% PURPOSE:
%  To generate zenith radiance spectra archive files
%
% CALLING SEQUENCE:
%   SEmakearchive_ARISE_zenrad
%
% INPUT:
%  none
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
%  - starzen.mat file compiled from raw data using allstarmat and then
%  processed with starzen
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, March 18th, 2015
%                 based on SEmakearchive_John_Nov2014_V06.m
%                 based on ICARTTwriter_example.m
% Modified:
%
% -------------------------------------------------------------------------

function SEmakearchive_ARISE_zenrad
version_set('v1.0')
%% set variables
ICTdir = 'C:\Users\sleblan2\Research\ARISE\starzen_ict\';
starinfo_path = 'C:\Users\sleblan2\Research\ARISE\starinfo\';
starzen_path = 'C:\Users\sleblan2\Research\ARISE\starzen\';
prefix='ARISE-4STAR-ZEN-RAD'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='0'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'C130';



%% Prepare General header for each file
HeaderInfo = {...
    'Phil Russell';...                           % PI name
    'NASA Ames Research Center';...              % Organization
    'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';...     % Data Source
    'ARISE';...                                  % Mission name
    '1, 1';...                                   % volume number, number of file volumes
    '1';...                                      % time interval (see documentation)
    'Start_UTC, seconds, Elapsed seconds from 0 hours UT on day given by DATE';...  % Independent variable name and description
    };

NormalComments = {...
    'PI_CONTACT_INFO: Philip.B.Russell@nasa.gov (650-604-5404)';...
    'PLATFORM: NASA C-130';...
    'LOCATION: Arctic, Aircraft latitude, longitude, altitude are included in the data records';...
    'ASSOCIATED_DATA: N/A';...
    'INSTRUMENT_INFO: Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research - Used as a Zenith spectral radiance measurement at flight altitude';...
    'DATA_INFO: measurements represent best measured radiance values over 1 second periods at Start_UTC.';...
    'UNCERTAINTY: Nominal radiance uncertainty is wavelength-dependent and ranges from 3 %% to 5 %%. Specific uncertainty not included at this point';...
    'ULOD_FLAG: -7777';...
    'ULOD_VALUE: N/A';...
    'LLOD_FLAG: -8888';...
    'LLOD_VALUE: N/A';...
    'DM_CONTACT_INFO: ';...
    'PROJECT_INFO: SISE deployment; August-October 2014; Fairbanks, AK';...
    'STIPULATIONS_ON_USE: Use of these data requires PRIOR OK from the PI.';...
    'OTHER_COMMENTS: N/A';...
    };

revComments = {...
    'R0: First archive of zenith radiances. The data is subject to uncertainties associated with detector stability, transfer efficiency of light through fiber optic cable, diffuse light, and deposition on the front windows. .\n';...
    };

%% Prepare details of which variables to save
info.UTC       = 'Fractional Hours, Elapsed hours from midnight UTC from 0 Hours UTC on day given by DATE';
info.GPS_Alt   = 'm, Aircraft GPS geometric altitude (m) at the indicated time';
info.Latitude  = 'deg, Aircraft latitude (deg) at the indicated time';
info.Longitude = 'deg, Aircraft longitude (deg) at the indicated time';
info.RADMAX    = 'W.m^-2.sr^-1.nm^-1, Maximum Zenith radiance in between 350 nm to 1700 nm';
info.RAD0465   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 465.4 nm';
info.RAD0500   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 499.9 nm';
info.RAD0530   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 530.3 nm';
info.RAD0555   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 555.1 nm';
info.RAD0600   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 599.8 nm';
info.RAD0610   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 610.1 nm';
info.RAD0675   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 675.2 nm';
info.RAD0870   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 870.0 nm';
info.RAD0936   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 936.1 nm';
info.RAD1000   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1000.0 nm';
info.RAD1040   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1039.6 nm';
info.RAD1065   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1064.2 nm';
info.RAD1200   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1199.4 nm';
info.RAD1237   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1237.4 nm';
info.RAD1241   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1240.5 nm';
info.RAD1270   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1269.9 nm';
info.RAD1500   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1500.2 nm';
info.RAD1565   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1565.3 nm';
info.RAD1580   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1579.5 nm';
info.RAD1595   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1594.9 nm';
info.RAD1610   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1610.2 nm';
info.RAD1620   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1620.3 nm';
info.RAD1634   = 'W.m^-2.sr^-1.nm^-1, Zenith radiance  at 1634.0 nm';

save_wvls  = [465,500,530,555,600,610,675,870,936,1000,1040,1065,1200,1237,1241,1270,1500,1565,1580,1595,1610,1620,1634];
save_iwvls = [364,407,445,476,532,545,627,876,962,1073,1095,1109,1190,1214,1216,1235,1395,1444,1455,1467,1479,1487,1498];
iradstart = 6; % the start of the field names related to wavelengths
goodwvls = [30:950]; % array of wavelength indices that are not subject to high variability and can find the maximum values

%set the format of each field
form = info;
names = fieldnames(info);
for ll=1:length(names); form.(names{ll}) = '%2.6f'; end;
form.GPS_Alt = '%7.1f';
form.Latitude = '%3.7f';
form.Longitude = '%4.7f';

%% prepare list of details for each flight
dslist={'20140830' '20140901' '20140902' '20140904' '20140905' '20140906' '20140907' '20140909' '20140910' '2010911' '20140913' '20140915' '20140916' '20140917' '20140918' '20140919' '20140921' '20140924' '20141002' '20141004' } ; %put one day string
%Values of jproc: 1=archive 0=do not archive
jproc=[         1          1          1          1          1          1          1          1          1          0         1          1          1          1          0          0          1          1          1          0  ] ; %set=1 to process

%% run through each flight, load and process
idx_file_proc=find(jproc==1);
for i=idx_file_proc
    %% get the flight time period
    daystr=dslist{i};
    disp(['on day:' daystr])
    keyword = 'flight';
    try; run([starinfo_path 'starinfo' daystr '.m']); end; eval(['assignin(''caller'',keyword, ' keyword ');']);
    UTCflight=t2utch(flight);
    
    %% build the Start_UTC time array, spaced at one second each
    Start_UTCs = [UTCflight(1)*3600:UTCflight(2)*3600];
    UTC = Start_UTCs/3600.;
    num = length(Start_UTCs);
    
    %% get the special comments
    switch daystr
        case '20140919'
            specComments = {...
                'Platinum day for over, under, and within cloud at sea ice edge.\n',...
                };
        otherwise
            specComments = {};
    end
    
    %% read file to be saved
    starfile = fullfile(starzen_path, [daystr 'starzen.mat']);
    disp(['loading the starzen file: ' starfile])
    load(starfile, 't','t_rad','w','Lat','Lon','Alt','rads','note');
    
    %% extract special comments about response functions from note
    if ~isempty(strfind(note, 'Resp'));
        temp_cells = strfind(note,'Resp');
        inote = find(not(cellfun('isempty',temp_cells)));
        for n=1:length(inote);
            specComments{end+1} = [strrep(note{inote(n)},'Resp from','Response function used: ') '\n'];
        end
    end
    
    %% fill with NaN the data structure, with appropriate sizes
    disp('initializing the data fields')
    for n=1:length(names)
        data.(names{n}) = NaN(num,1);
    end
    
    %% fill up some of the data and interpolate for proper filling
    data.UTC = UTC;
    tutc = t2utch(t);
    ialt = find(Alt>0); % filter out bad data
    [nutc,iutc] = unique(tutc(ialt));
    data.GPS_Alt = interp1(nutc,Alt(ialt(iutc)),UTC);
    [nnutc,iiutc] = unique(tutc);
    data.Latitude = interp1(nnutc,Lat(iiutc),UTC);
    data.Longitude = interp1(nnutc,Lon(iiutc),UTC);
    
    %% Now go through the times of radiances, and fill up the related variables
    disp('filing up the data')
    tutc_rad = t2utch(t_rad);
    rads = rads / 1000.0; % to convert from W.m^-2.sr^-1.um^-1 to W.m^-2.sr^-1.nm^-1
    
    for nn=iradstart:length(names)
        ii = nn-iradstart+1;
        % filter for bad data but keep nans
        iflt = find(rads(:,save_iwvls(ii)) > 0 | isnan(rads(:,save_iwvls(ii))));
        data.(names{nn}) = interp1(tutc_rad(iflt),rads(iflt,save_iwvls(ii)),UTC);
    end;
    %special case for maximum radiances
    mrad = max(rads(:,goodwvls),[],2);
    iflt = find(mrad > 0 | isnan(mrad));
    data.RADMAX = interp1(tutc_rad(iflt),mrad(iflt),UTC);
    
    %% make sure that no UTC, Alt, Lat, and Lon is displayed when no measurement
    inans = find(isnan(data.RADMAX));
    data.UTC(inans) = NaN;
    data.GPS_Alt(inans) = NaN;
    data.Latitude(inans) = NaN;
    data.Longitude(inans) = NaN;
    
    %% Now print the data to ICT file
    disp('Printing to file')
    ICARTTwriter(prefix, platform, HeaderInfo, specComments, NormalComments, revComments, daystr,Start_UTCs,data,info,form,rev,ICTdir)
end;
