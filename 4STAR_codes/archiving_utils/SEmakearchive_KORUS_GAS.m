%% Details of the program:
% NAME:
%   SEmakearchive_KORUS_GAS
%
% PURPOSE:
%  To generate GAS archive files for use wih KORUS-AQ
%
% CALLING SEQUENCE:
%   SEmakearchive_KORUS_GAS
%
% INPUT:
%  none
%
% OUTPUT:
%  ict files
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
% Written (v1.0): Samuel LeBlanc, Osan AFB, Korea, May 10th, 2016
%                 ported over from SEmakearchive_KORUS_AOD.m
%
% -------------------------------------------------------------------------

function SEmakearchive_KORUS_GAS
version_set('v1.0')
%% set variables
ICTdir = 'C:\Users\sleblan2\Research\KORUS-AQ\gas_ict\';
starinfo_path = 'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
starsun_path = 'C:\Users\sleblan2\Research\KORUS-AQ\data\';
prefix='korusaq-4STAR-GASES'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='A'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'DC8';



%% Prepare General header for each file
HeaderInfo = {...
    'Jens Redemann';...                           % PI name
    'NASA Ames Research Center';...              % Organization
    'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';...     % Data Source
    'KORUS-AQ';...                                  % Mission name
    '1, 1';...                                   % volume number, number of file volumes
    '1';...                                      % time interval (see documentation)
    'Start_UTC, seconds, Elapsed seconds from 0 hours UT on day: DATE';...  % Independent variable name and description
    };

NormalComments = {...
    'PI_CONTACT_INFO: Jens.Redemann-1@nasa.gov';...
    'PLATFORM: NASA DC8';...
    'LOCATION: based in Osan Air Force Base in South Korea, Exact aircraft latitude, longitude, altitude are included in the data records';...
    'ASSOCIATED_DATA: N/A';...
    'INSTRUMENT_INFO: Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research';...
    'DATA_INFO: measurements represent total column gas content above the aircraft at measurement time nearest to Start_UTC.';...
    'UNCERTAINTY: included';...
    'ULOD_FLAG: -7777';...
    'ULOD_VALUE: N/A';...
    'LLOD_FLAG: -8888';...
    'LLOD_VALUE: N/A';...
    'DM_CONTACT_INFO: Michal Segal-Rozenhaimer, michal.segalrozenhaimer@nasa.gov';...
    'PROJECT_INFO: KORUS-AQ deployment; April-June 2016; Osan AFB, Korea';...
    'STIPULATIONS_ON_USE: Use of these data requires PRIOR OK from the PI.';...
    'OTHER_COMMENTS: N/A';...
    };

revComments = {...
    'RA: First in-field data archival. Calibration coefficients are not final. The data is subject to uncertainties associated with detector stability, transfer efficiency of light through fiber optic cable, diffuse light, deposition on the front windows, and possible tracking instablity.\n';...
    };


%% Prepare details of which variables to save
info.Latitude  = 'deg, Aircraft latitude (deg) at the indicated time';
info.Longitude = 'deg, Aircraft longitude (deg) at the indicated time';
info.GPS_Alt   = 'm, Aircraft GPS geometric altitude (m) at the indicated time';

info.amass_O3 = 'unitless, ozone optical airmass';
info.amass_NO2 = 'unitless, NO2 optical airmass';

info.CWV       = 'g/cm^2, column water vapor calculated as average of values retrieved in 940-960 nm band';
info.std_CWV   = 'g/cm^2, standard deviation of CWV';
info.QA_CWV    = 'unitless, quality of retrieved CWV: 0=good; 1=poor, due to clouds, tracking errors, or instrument stability';
info.VCD_O3    = 'DU, ozone vetical column content retrieved from best fit over the Chappuis spectral band';
info.resid_O3  = 'DU, O3 rms difference between fitted and measured spectra';
info.QA_O3     = 'unitless, quality of retrieved O3: 0=good; 1=poor, due to clouds, tracking errors, or instrument stability';
info.VCD_NO2   = 'DU, nitrogen dioxide vertical column content retrieved from best fit over the 450-490 nm spectral band';
info.resid_NO2 = 'DU, VCD_NO2 rms difference between fitted and measured spectra';
info.QA_NO2    = 'unitless, quality of retrieved NO2: 0=good; 1=poor, due to clouds, tracking errors, or instrument stability';


%set the format of each field
form = info;
names = fieldnames(info);
for ll=1:length(names); form.(names{ll}) = '%3.2f'; end;
form.GPS_Alt = '%7.1f';
form.Latitude = '%3.7f';
form.Longitude = '%4.7f';
form.QA_CWV = '%1.0f';
form.QA_O3 = '%1.0f';
form.QA_NO2 = '%1.0f';
form.CWV = '%2.3f';
form.std_CWV = '%2.3f';


%% prepare list of details for each flight
dslist={'20160426' '20160501' '20160503' '20160504' '20160506' } ; %put one day string
%Values of jproc: 1=archive 0=do not archive
jproc=[         1          0          0          0          0   ] ; %set=1 to process


%% run through each flight, load and process
idx_file_proc=find(jproc==1);
for i=idx_file_proc
    
    %% get the flight time period
    daystr=dslist{i};
    disp(['on day:' daystr])
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
    starfile = fullfile(starsun_path, [daystr 'starsun.mat']);
    disp(['loading the starsun file: ' starfile])
    load(starfile, 't','gas','Lat','Lon','Alt','m_O3','note','m_NO2','cwv');
    
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
    data.amass_O3 = interp1(nnutc,m_O3(iiutc),UTC);  
    data.amass_NO2 = interp1(nnutc,m_NO2(iiutc),UTC);  
    

     %% Load the flag file
%     if isfield(s, 'flagfilename');
%         disp(['Loading flag file: ' s.flagfilename])
%         flag = load(s.flagfilename); 
%     else
%         [flagfilename, pathname] = uigetfile2('*.mat', ...
%             ['Pick starflag file for day:' daystr]);
%         disp(['Loading flag file: ' s.flagfilename])
%         flag = load([pathname flagfilename]);
%     end
%     

     %% Combine the flag values
     disp('Setting the flags to default to 0 to start')
     data.QA_CWV = Start_UTCs*0;
     data.QA_O3 = Start_UTCs*0;
     data.QA_NO2 = Start_UTCs*0;
%     if isfield(flag,'manual_flags');
%         qual_flag = flag.manual_flags.screen;
%     else
%         qual_flag = bitor(flag.before_or_after_flight,flag.bad_aod);
%         qual_flag = bitor(qual_flag,flag.cirrus);
%         qual_flag = bitor(qual_flag,flag.frost);
%         qual_flag = bitor(qual_flag,flag.low_cloud);
%         qual_flag = bitor(qual_flag,flag.unspecified_clouds);
%     end
%     data.qual_flag = Start_UTCs*0+1; % sets the default to 1
%     flag.utc = t2utch(flag.time.t);
%     [ii,dt] = knnsearch(flag.utc,UTC');
%     idd = dt<1.0/3600.0; % Distance no greater than one second.
%     data.qual_flag(idd) = qual_flag(ii(idd));
    

    %% Now go through the times of radiances, and fill up the related variables
    disp('filing up the data')
    % get the indices for the proper times
    [iig,dtg] = knnsearch(tutc,UTC');
    iddg = dtg<1.0/3600.0; % Distance no greater than one second.
    
    data.CWV(iddg)      = cwv.cwv940m1(iig(iddg));
    data.std_CWV(iddg)  = cwv.cwv940m1std(iig(iddg));
    data.VCD_O3(iddg)   = gas.o3.o3DU(iig(iddg));
    data.resid_O3(iddg) = gas.o3.o3resiDU(iig(iddg));
    
    if isfield(gas.no2,'no2resiDU')
        data.VCD_NO2(iddg)  = gas.no2.no2DU;
        data.resid_NO2(iddg)= gas.no2.no2resiDU;
    else
        disp('Applying Loschmidt to convert NO2 from molecules to DU')
        Loschmidt           = 2.686763e19; %molecules/cm2
        data.VCD_NO2(iddg)  = gas.no2.no2_molec_cm2/(Loschmidt/1000);
        data.resid_NO2(iddg)= gas.no2.no2resi/(Loschmidt/1000);
    end
    
    
    %% make sure that no UTC, Alt, Lat, and Lon is displayed when no measurement
    inans = find(isnan(data.AOD0501));
    data.GPS_Alt(inans) = NaN;
    data.Latitude(inans) = NaN;
    data.Longitude(inans) = NaN;
    data.amass_O3(inans) = NaN;
    data.amass_NO2(inans) = NaN;
    for i=iradstart:length(names)
        data.(names{i})(inans) = NaN;
    end
    
    %% Now print the data to ICT file
    disp('Printing to file')
    ICARTTwriter(prefix, platform, HeaderInfo, specComments, NormalComments, revComments, daystr,Start_UTCs,data,info,form,rev,ICTdir)
end;
