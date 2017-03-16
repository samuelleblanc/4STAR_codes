%% Details of the program:
% NAME:
%   SEmakearchive_MLO_raw
%
% PURPOSE:
%  To generate raw archive from MLO for langley calculations
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
% Written (v1.0): Samuel LeBlanc, NASA Ames, 2017-03-07
% -------------------------------------------------------------------------

function SEmakearchive_MLO_raw

version_set('v1.0')
%% set variables
if ~isempty(strfind(lower(userpath),'msegalro')); %
    ICTdir = 'E:\MichalsData\KORUS-AQ\aod_ict\';%'C:\Users\sleblan2\Research\KORUS-AQ\aod_ict\R0\';%'D:\KORUS-AQ\aod_ict\';
    starinfo_path = 'E:\MichalsData\KORUS-AQ\starinfo\Jan-15-archive\';%'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';%'D:\KORUS-AQ\starinfo\';
    starsun_path = 'E:\MichalsData\KORUS-AQ\starsun\Jan-15-archive-starsun\aod_only\';%'C:\Users\sleblan2\Research\KORUS-AQ\data\';%'D:\KORUS-AQ\starsun\';
elseif ~isempty(strfind(lower(userpath),'sleblan2'));
    ICTdir = 'C:\Users\sleblan2\Research\MLO\2016_June\raw_ict\';%'D:\KORUS-AQ\aod_ict\';
    starinfo_path = 'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';%'D:\KORUS-AQ\starinfo\';
    starsun_path = 'C:\Users\sleblan2\Research\MLO\2016_June\';%'D:\KORUS-AQ\starsun\';
else
    ICTdir = 'D:\KORUS-AQ\aod_ict\';
    starinfo_path = 'D:\KORUS-AQ\starinfo\';
    starsun_path = 'D:\KORUS-AQ\starsun\';
end
prefix='MLO-4STAR-raw'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='0'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'ground';

%% prepare list of details for each flight
dslist={'20160702' '20160703' } ; %put one day string
%Values of jproc: 1=archive 0=do not archive
jproc=[         1          0  ] ; %set=1 to process

%% Prepare General header for each file
HeaderInfo = {...
    'Jens Redemann';...                           % PI name
    'NASA Ames Research Center';...              % Organization
    'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';...     % Data Source
    'MLO Langley calibration';...                        % Mission name
    '1, 1';...                                   % volume number, number of file volumes
    '1';...                                      % time interval (see documentation)
    'Start_UTC, seconds, Elapsed seconds from 0 hours UT on day: DATE';...  % Independent variable name and description
    };

NormalComments = {...
    'PI_CONTACT_INFO: Jens.Redemann-1@nasa.gov';...
    'PLATFORM: Mauna Loa Observatory';...
    'LOCATION: Based at the Mauna Loa Observatory in Hawaii, Elevation 3397 m, Latitude: 19.536 degrees North, Longitude: 155.57611 degrees West';...
    'ASSOCIATED_DATA: N/A';...
    'INSTRUMENT_INFO: Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research';...
    'DATA_INFO: measurements represent the raw counts divided by integration time at measurement time nearest to Start_UTC.';...
    'UNCERTAINTY: Nominal raw uncertainty is wavelength-dependent';...
    'ULOD_FLAG: -7777';...
    'ULOD_VALUE: N/A';...
    'LLOD_FLAG: -8888';...
    'LLOD_VALUE: N/A';...
    'DM_CONTACT_INFO: Samuel LeBlanc, samuel.leblanc@nasa.gov';...
    'PROJECT_INFO: Mauna Loa Calibration deployment; June-July 2016, Mauna Loa Observatory, Hawaii';...
    'STIPULATIONS_ON_USE: None. Consulting with PI before use is advised.';...
    'OTHER_COMMENTS: N/A';...
    };

revComments = {...
    'R0: First data excahnge of raw langley calibration data for selected channels . \n';...
    };

specComments_extra_uncertainty = 'Used for educational training. \n';

%% Prepare details of which variables to save
%info.Start_UTC = 'Fractional Seconds, Elapsed seconds from midnight UTC from 0 Hours UTC on day given by DATE';
info.amass_aer = 'unitless, aerosol optical airmass';

info.raw0380 = 'digital counts, Raw counts from detector at 380.0 nm';
info.raw0452 = 'digital counts, Raw counts from detector at 451.7 nm';
info.raw0501 = 'digital counts, Raw counts from detector at 500.7 nm';
info.raw0520 = 'digital counts, Raw counts from detector at 520.0 nm';
info.raw0532 = 'digital counts, Raw counts from detector at 532.0 nm';
info.raw0550 = 'digital counts, Raw counts from detector at 550.3 nm';
info.raw0606 = 'digital counts, Raw counts from detector at 605.5 nm';
info.raw0620 = 'digital counts, Raw counts from detector at 619.7 nm';
info.raw0675 = 'digital counts, Raw counts from detector at 675.2 nm';
info.raw0781 = 'digital counts, Raw counts from detector at 780.6 nm';
info.raw0865 = 'digital counts, Raw counts from detector at 864.6 nm';
info.raw1020 = 'digital counts, Raw counts from detector at 1019.9 nm';
info.raw1040 = 'digital counts, Raw counts from detector at 1039.6 nm';
info.raw1064 = 'digital counts, Raw counts from detector at 1064.2 nm';
info.raw1236 = 'digital counts, Raw counts from detector at 1235.8 nm';
info.raw1559 = 'digital counts, Raw counts from detector at 1558.7 nm';
info.raw1627 = 'digital counts, Raw counts from detector at 1626.6 nm';

info.rateaero0380 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 380.0 nm';
info.rateaero0452 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 451.7 nm';
info.rateaero0501 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 500.7 nm';
info.rateaero0520 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 520.0 nm';
info.rateaero0532 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 532.0 nm';
info.rateaero0550 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 550.3 nm';
info.rateaero0606 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 605.5 nm';
info.rateaero0620 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 619.7 nm';
info.rateaero0675 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 675.2 nm';
info.rateaero0781 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 780.6 nm';
info.rateaero0865 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 864.6 nm';
info.rateaero1020 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 1019.9 nm';
info.rateaero1040 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 1039.6 nm';
info.rateaero1064 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 1064.2 nm';
info.rateaero1236 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 1235.8 nm';
info.rateaero1559 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 1558.7 nm';
info.rateaero1627 = 'counts/ms, dark substracted counts per integration time substracted by contributions from rayleigh scattering, O3, 04, NO2, CO2, CH4, and N20 at 1626.6 nm';

save_wvls  = [380.0,451.7,500.7,520,532.0,550.3,605.5,619.7,675.2,780.6,864.6,1019.9,1039.6,1039.6,1064.2,1235.8,1558.7,1626.6];
iradstart = 1; % the start of the field names related to wavelengths

%set the format of each field
form = info;
names = fieldnames(info);
for ll=1:length(names); form.(names{ll}) = '%2.3f'; end;

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
    UTCflight=t2utch(s.langley2)+24.0;
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
    starfile = fullfile(starsun_path, [daystr 'starsun.mat']);
    if ~exist(starfile);
        starfile = fullfile(starsun_path, ['4STAR_' daystr 'starsun.mat']);
    end;
    disp(['loading the starsun file: ' starfile])
    load(starfile, 't','raw','rateaero','tau_aero_noscreening','w','Lat','Lon','Alt','m_aero','note');
    
    %% fill with NaN the data structure, with appropriate sizes
    disp('initializing the data fields')
    for n=1:length(names)
        data.(names{n}) = NaN(num,1);
    end
    
    %% fill up some of the data and interpolate for proper filling
    tutc = t2utch(t);
    [nnutc,iiutc] = unique(tutc);
    data.amass_aer = interp1(nnutc,m_aero(iiutc),UTC);    
    
    %% Now go through the times of radiances/aod, and fill up the related variables
    disp('filing up the data')
    for n=1:length(save_wvls); [uu,i] = min(abs(w-save_wvls(n)/1000.0)); save_iwvls(n)=i; end;
    for nn=iradstart:iradstart+length(save_wvls)-1;
        ii = nn-iradstart+1;  
            [tutc_unique,itutc_unique] = unique(tutc);
            data.(names{nn}) = interp1(tutc_unique,raw(itutc_unique,save_iwvls(ii)),UTC,'nearest');

    end;
    
    % do the same but for uncertainty
    for nn=iradstart+length(save_wvls):length(names);
        ii = nn-iradstart-length(save_wvls)+1;
        [tutc_unique,itutc_unique] = unique(tutc);

                data.(names{nn}) = interp1(tutc_unique,rateaero(itutc_unique,save_iwvls(ii)),UTC,'nearest');

    end;
    
    %% make sure that no UTC, Alt, Lat, and Lon is displayed when no measurement
    inans = find(isnan(data.(names{iradstart+2})));
    %data.UTC(inans) = NaN;
    data.amass_aer(inans) = NaN;
    for i=iradstart:length(names)
        data.(names{i})(inans) = NaN;
    end
    
    %% Now print the data to ICT file
    disp('Printing to file')
    ICARTTwriter(prefix, platform, HeaderInfo, specComments, NormalComments, revComments, daystr,Start_UTCs,data,info,form,rev,ICTdir)
end;


