%% Details of the program:
% NAME:
%   SEmakearchive_ORACLES_AOD
%
% PURPOSE:
%  To generate AOD archive files for use wih KORUS-AQ
%
% CALLING SEQUENCE:
%   SEmakearchive_ORACLES_AOD
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
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined 
%  - flagfile 
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Osan AFB, Korea, May 7th, 2016
%                 ported over from SEmakearchive_ARISE_starzen.m
% MS, updated starinfo files path
% 2016-07-01, MS, tweaked for certain flag days for KORUS
% 2016-07-14, MS, twaeked to accept automatic flags
% 2016-09-04, SL,v2.0 ported from KORUS
% 2016-09-18, SL,v2.1, added variable paths depending on the user
% 2017-03-15, SL,v2.2, Fixed issue with altitude and some other value
%                      interpolation. Was doing nearest neighbor
%                      interpolation without maximum time distance, now set
%                      to only use nearest neighbor if less than 1 second
%                      away. Set new revision for R1
% 2017-04-05, SL,v2.3, Added reading of the tau_aero_subtract_all to use
%                      aod with gas subtracted
% -------------------------------------------------------------------------

function SEmakearchive_ORACLES_AOD
version_set('v2.3')
%% set variables
ICTdir = starpaths; %'C:\Users\sleblan2\Research\ORACLES\aod_ict\';
starinfo_path = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
starsun_path = starpaths; %'C:\Users\sleblan2\Research\ORACLES\data\';
if getUserName=='sleblan2';
    ICTdir = 'C:\Users\sleblan2\Research\ORACLES\aod_ict\';
    starinfo_path = 'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
    starsun_path = 'C:\Users\sleblan2\Research\ORACLES\data\';
end;
prefix='4STAR-AOD'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='1'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'P3';


%% Prepare General header for each file
HeaderInfo = {...
    'Jens Redemann';...                           % PI name
    'NASA Ames Research Center';...              % Organization
    'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';...     % Data Source
    'ORACLES 2016';...                                  % Mission name
    '1, 1';...                                   % volume number, number of file volumes
    '1';...                                      % time interval (see documentation)
    'Start_UTC, seconds, Elapsed seconds from 0 hours UT on day: DATE';...  % Independent variable name and description
    };

NormalComments = {...
    'PI_CONTACT_INFO: Jens.Redemann-1@nasa.gov';...
    'PLATFORM: NASA P3';...
    'LOCATION: Based at Walvis Bay, Namibia, Exact aircraft latitude, longitude, altitude are included in the data records';...
    'ASSOCIATED_DATA: N/A';...
    'INSTRUMENT_INFO: Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research';...
    'DATA_INFO: measurements represent Aerosol optical depth values of the column above the aircraft at measurement time nearest to Start_UTC.';...
    'UNCERTAINTY: Nominal AOD uncertainty is wavelength-dependent, for in-field archiving can be up to 0.03';...
    'ULOD_FLAG: -7777';...
    'ULOD_VALUE: N/A';...
    'LLOD_FLAG: -8888';...
    'LLOD_VALUE: N/A';...
    'DM_CONTACT_INFO: Samuel LeBlanc, samuel.leblanc@nasa.gov';...
    'PROJECT_INFO: ORACLES 2016 deployment; August-December 2016; Walvis Bay, Namibia';...
    'STIPULATIONS_ON_USE: Use of these data requires PRIOR OK from the PI.';...
    'OTHER_COMMENTS: N/A';...
    };

revComments = {...
    'R1: Fix on field archived data for erroneus altitude, position, and some AOD data interpolation. Column trace gas impact to AOD has been removed for O3, O4, H2O, NO2, CO2, and CH4. Updated calibration from Mauna Loa, November 2016 has been applied. There is still uncertainty in the impact of window deposition affection light transmission.';...
    'R0: First in-field data archival. The data is subject to uncertainties associated with detector stability, transfer efficiency of light through fiber optic cable, cloud screening, diffuse light, deposition on the front windows, and possible tracking instablity.';...
    };

%% Prepare details of which variables to save
%info.Start_UTC = 'Fractional Seconds, Elapsed seconds from midnight UTC from 0 Hours UTC on day given by DATE';
info.Latitude  = 'deg, Aircraft latitude (deg) at the indicated time';
info.Longitude = 'deg, Aircraft longitude (deg) at the indicated time';
info.GPS_Alt   = 'm, Aircraft GPS geometric altitude (m) at the indicated time';
info.qual_flag = 'unitless, quality of retrieved AOD: 0=good; 1=poor, due to clouds, tracking errors, or instrument stability';
info.amass_aer = 'unitless, aerosol optical airmass';

info.AOD0380 = 'unitless, Aerosol optical depth at 380.0 nm';
info.AOD0452 = 'unitless, Aerosol optical depth at 451.7 nm';
info.AOD0501 = 'unitless, Aerosol optical depth at 500.7 nm';
info.AOD0520 = 'unitless, Aerosol optical depth at 520.0 nm';
info.AOD0532 = 'unitless, Aerosol optical depth at 532.0 nm';
info.AOD0550 = 'unitless, Aerosol optical depth at 550.3 nm';
info.AOD0606 = 'unitless, Aerosol optical depth at 605.5 nm';
info.AOD0620 = 'unitless, Aerosol optical depth at 619.7 nm';
info.AOD0675 = 'unitless, Aerosol optical depth at 675.2 nm';
info.AOD0781 = 'unitless, Aerosol optical depth at 780.6 nm';
info.AOD0865 = 'unitless, Aerosol optical depth at 864.6 nm';
info.AOD1020 = 'unitless, Aerosol optical depth at 1019.9 nm';
info.AOD1040 = 'unitless, Aerosol optical depth at 1039.6 nm';
info.AOD1064 = 'unitless, Aerosol optical depth at 1064.2 nm';
info.AOD1236 = 'unitless, Aerosol optical depth at 1235.8 nm';
info.AOD1559 = 'unitless, Aerosol optical depth at 1558.7 nm';
info.AOD1627 = 'unitless, Aerosol optical depth at 1626.6 nm';

save_wvls  = [380.0,451.7,500.7,520,532.0,550.3,605.5,619.7,675.2,780.6,864.6,1019.9,1039.6,1039.6,1064.2,1235.8,1558.7,1626.6];
iradstart = 6; % the start of the field names related to wavelengths

%set the format of each field
form = info;
names = fieldnames(info);
for ll=1:length(names); form.(names{ll}) = '%2.3f'; end;
form.GPS_Alt = '%7.1f';
form.Latitude = '%3.7f';
form.Longitude = '%4.7f';
form.qual_flag = '%1.0f';

%% prepare list of details for each flight
dslist={'20160824' '20160825' '20160827' '20160830' '20160831' '20160902' '20160904' '20160906', '20160908', '20160910','20160912','20160914','20160918','20160920','20160924','20160925','20160927','20160929','20160930'} ; %put one day string
%Values of jproc: 1=archive 0=do not archive
jproc=[         0          0          0          0          0          0          0          1           0           0          0          0          0          0          0          0          0          0          0] ; %set=1 to process

%% run through each flight, load and process
idx_file_proc=find(jproc==1);
for i=idx_file_proc
    %% get the flight time period
    daystr=dslist{i};
    disp(['on day:' daystr])
    %cd starinfo_path
    %infofile_ = fullfile(starinfo_path, ['starinfo_' daystr '.m']);
    infofile_ = ['starinfo_' daystr '.m'];
    infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
    s.dummy = '';
    try
        s = infofnt(s);
    catch
        eval([infofile_(1:end-2),'(s)']);
    end
    UTCflight=t2utch(s.flight);
    HeaderInfo{7} = strrep(HeaderInfo{7},'DATE',daystr);
    
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
    starfile = fullfile(starsun_path, ['4STAR_' daystr 'starsun.mat']);
    disp(['loading the starsun file: ' starfile])
    load(starfile, 't','tau_aero_noscreening','w','Lat','Lon','Alt','m_aero','note');
    try;
        load(starfile,'tau_aero_subtract_all'); 
        tau = tau_aero_subtract_all;
    catch;
        disp('*** tau_aero_subtract_all not available, reverting to tau_aero_noscreening ***')
        tau = tau_aero_noscreening; 
    end;
    
    %% extract special comments about response functions from note
    if ~isempty(strfind(note, 'C0'));
        temp_cells = strfind(note,'C0');
        inote = find(not(cellfun('isempty',temp_cells)));
        for n=1:length(inote);
            specComments{end+1} = [strrep(note{inote(n)},'C0 from','Using the C0 calibration file: ') '\n'];
        end
    end
    
    %% fill with NaN the data structure, with appropriate sizes
    disp('initializing the data fields')
    for n=1:length(names)
        data.(names{n}) = NaN(num,1);
    end
    
    %% fill up some of the data and interpolate for proper filling
    tutc = t2utch(t);
    ialt = find(Alt>0); % filter out bad data
    [nutc,iutc] = unique(tutc(ialt));
    data.GPS_Alt = interp1(nutc,Alt(ialt(iutc)),UTC);
    [nnutc,iiutc] = unique(tutc);
    data.Latitude = interp1(nnutc,Lat(iiutc),UTC);
    data.Longitude = interp1(nnutc,Lon(iiutc),UTC);
    data.amass_aer = interp1(nnutc,m_aero(iiutc),UTC);    
    
    %% Load the flag file
    if isfield(s, 'flagfilename');
        disp(['Loading flag file: ' s.flagfilename])
        flag = load(s.flagfilename); 
    else
        [flagfilename, pathname] = uigetfile2('*.mat', ...
            ['Pick starflag file for day:' daystr]);
        disp(['Loading flag file: ' pathname flagfilename])
        flag = load([pathname flagfilename]);
    end
    
    %% Combine the flag values
    disp('Setting the flags')
    if isfield(flag,'manual_flags');
        qual_flag = ~flag.manual_flags.good;
    elseif strcmp(daystr,'20160529') || strcmp(daystr,'20160601') || strcmp(daystr,'20160604')
        qual_flag = bitor(flag.flags.before_or_after_flight,flag.flags.bad_aod);
        qual_flag = bitor(qual_flag,flag.flags.cirrus);
        qual_flag = bitor(qual_flag,flag.flags.frost);
        qual_flag = bitor(qual_flag,flag.flags.low_cloud);
        qual_flag = bitor(qual_flag,flag.flags.unspecified_clouds);
    elseif isfield(flag,'flags');
        qual_flag = bitor(flag.flags.before_or_after_flight,flag.flags.bad_aod);
        qual_flag = bitor(qual_flag,flag.flags.cirrus);
        qual_flag = bitor(qual_flag,flag.flags.frost);
        qual_flag = bitor(qual_flag,flag.flags.low_cloud);
        qual_flag = bitor(qual_flag,flag.flags.unspecified_clouds);
    elseif isfield(flag,'before_or_after_flight');
        % only for automatic flagging
        qual_flag = bitor(flag.before_or_after_flight,flag.bad_aod);
        try
            qual_flag = bitor(qual_flag,flag.cirrus);
            qual_flag = bitor(qual_flag,flag.frost);
            qual_flag = bitor(qual_flag,flag.low_cloud);
            qual_flag = bitor(qual_flag,flag.unspecified_clouds);
        catch
            disp('No flags for cirrus, frost, low_cloud, or unsecified_clouds found, Keep moving on')
        end
    elseif isfield(flag,'screened')
       flag_tags = [1  ,2 ,3,10,90,100,200,300,400,500,600,700,800,900,1000];
       flag_names = {'unknown','before_or_after_flight','tracking_errors','unspecified_clouds','cirrus',...
                     'inst_trouble' ,'inst_tests' ,'frost','low_cloud','hor_legs','vert_legs','bad_aod','smoke','dust','unspecified_aerosol'};
        for tag = 1:length(flag_tags)
            flag.(flag_names{tag}) = flag.screened==flag_tags(tag);
        end  
        qual_flag = bitor(flag.before_or_after_flight,flag.bad_aod);
        qual_flag = bitor(qual_flag,flag.cirrus);
        qual_flag = bitor(qual_flag,flag.frost);
        qual_flag = bitor(qual_flag,flag.low_cloud);
        qual_flag = bitor(qual_flag,flag.unspecified_clouds);
        if length(flag.screened)==length(t);
           flag.time.t = t; 
        end
    else
        error('No flagfile that are useable')
    end
    data.qual_flag = Start_UTCs*0+1; % sets the default to 1
    % tweak for different flag files
    if strcmp(daystr,'20160529') || strcmp(daystr,'20160601') || strcmp(daystr,'20160604')
        flag.utc = t2utch(flag.flags.time.t);
    %elseif strcmp(daystr,'20160530') || strcmp(daystr,'20160602') || strcmp(daystr,'20160608') || strcmp(daystr,'20160609')
    %    flag.utc = UTC';
    else
        try;
            flag.utc = t2utch(flag.time.t);
        catch;
            flag.utc = t2utch(flag.flags.time.t);
        end;
    end
    [ii,dt] = knnsearch(flag.utc,UTC');
    idd = dt<1.0/3600.0; % Distance no greater than one second.
    data.qual_flag(idd) = qual_flag(ii(idd));
    
    %% Now go through the times of radiances, and fill up the related variables
    disp('filing up the data')
    for n=1:length(save_wvls); [uu,i] = min(abs(w-save_wvls(n)/1000.0)); save_iwvls(n)=i; end;
    % make sure to only have unique values
    [tutc_unique,itutc_unique] = unique(tutc);
    [idat,datdt] = knnsearch(tutc_unique,UTC');
    iidat = datdt<1.0/3600.0; % Distance no greater than 1.0 seconds.
    for nn=iradstart:length(names)
        ii = nn-iradstart+1;
        data.(names{nn}) = UTC*0.0+NaN;
        data.(names{nn})(iidat) = tau(itutc_unique(idat(iidat)),save_iwvls(ii));
    end;
    
    %% make sure that no UTC, Alt, Lat, and Lon is displayed when no measurement
    inans = find(isnan(data.AOD0501));
    %data.UTC(inans) = NaN;
    data.GPS_Alt(inans) = NaN;
    data.Latitude(inans) = NaN;
    data.Longitude(inans) = NaN;
    data.amass_aer(inans) = NaN;
    for i=iradstart:length(names)
        data.(names{i})(inans) = NaN;
    end
    
    %% Now print the data to ICT file
    disp('Printing to file')
    ICARTTwriter(prefix, platform, HeaderInfo, specComments, NormalComments, revComments, daystr,Start_UTCs,data,info,form,rev,ICTdir)
end;

function name = getUserName ()
    if isunix() 
        name = getenv('USER'); 
    else 
        name = getenv('username'); 
    end
return
