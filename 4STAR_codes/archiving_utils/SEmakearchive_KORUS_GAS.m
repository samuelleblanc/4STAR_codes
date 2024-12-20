%% Details of the program:
% NAME:
%   SEmakearchive_KORUS_GAS
%   based on ORACLES_GAS archive code
%
% PURPOSE:
%  To generate GAS archive files for use with ORACLES
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
% MS, 2016-05-10, adjusted routine to archive gases
% MS, 2016-05-12, adding CWV flags
% MS, 2016-05-14, fixing bugs in gas flags
% MS, 2016-05-26, setting NO2 to -99999 until new calibration is applied
% MS, 2016-10-18, adjusted for ORACLES
% MS, 2017-01-10, adjusted for KORUS
% -------------------------------------------------------------------------

function SEmakearchive_KORUS_GAS
version_set('v1.0')
%% set variables
ICTdir = 'D:\MichalsData\KORUS-AQ\gas_ict\';
starinfo_path = 'D:\MichalsData\KORUS-AQ\starinfo\Jan-15-archive\';
starsun_path = 'D:\MichalsData\KORUS-AQ\starsun_for_starflag\';
gasfile_path = 'D:\MichalsData\KORUS-AQ\gas_summary\Jan-15-archive\';
prefix='korusaq-4STAR-GASES'; 
rev='0'; % this is final archive (A/B...is field archive); some adjustments and improvements might be added to R1/R2
platform = 'DC8';



%% Prepare General header for each file
HeaderInfo = {...
    'Jens Redemann';...                          % PI name
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
    'STIPULATIONS_ON_USE: None.';...
    'OTHER_COMMENTS: N/A';...
    };

revComments = {...
    'R0: Final data archival. This data is using latest calibration.';...
    };


%% Prepare details of which variables to save
info.Latitude  = 'deg, Aircraft latitude (deg) at the indicated time';
info.Longitude = 'deg, Aircraft longitude (deg) at the indicated time';
info.GPS_Alt   = 'm, Aircraft GPS geometric altitude (m) at the indicated time';

info.amass_O3 = 'unitless, ozone optical airmass';
info.amass_NO2 = 'unitless, NO2 optical airmass';

info.CWV       = 'g/cm^2, column water vapor calculated as average of values retrieved in 940-960 nm band';
info.std_CWV   = 'g/cm^2, standard deviation of CWV';
info.QA_CWV    = 'unitless, quality of retrieved CWV: 0=good; 1=poor, due to clouds, tracking errors, instrument stability, or poor fit';
info.VCD_O3    = 'DU, ozone vetical column content retrieved from best fit over the Chappuis spectral band (500-680 nm)';
info.resid_O3  = 'DU, O3 rms difference between fitted and measured spectra';
info.QA_O3     = 'unitless, quality of retrieved O3: 0=good; 1=poor, due to clouds, tracking errors, instrument stability, or poor fit';
info.VCD_NO2   = 'DU, nitrogen dioxide vertical column content retrieved from best fit over the 460-490 nm spectral band';
info.resid_NO2 = 'DU, VCD_NO2 rms difference between fitted and measured spectra';
info.QA_NO2    = 'unitless, quality of retrieved NO2: 0=good; 1=poor, due to clouds, tracking errors, instrument stability, or poor fit';
% info.VCD_HCOH  = 'DU, formaldehyde vertical column content retrieved from best fit over the 335-359 nm spectral band; this is experimental product!!!';
% info.resid_HCOH= 'DU, VCD_HCOH rms difference between fitted and measured spectra';
% info.QA_HCOH   = 'unitless, quality of retrieved HCOH: 0=good; 1=poor, due to clouds, tracking errors, instrument stability, final calibration or poor fit; this is experimental!!!';


%set the format of each field
form = info;
names = fieldnames(info);
for ll=1:length(names); form.(names{ll}) = '%3.2f'; end;
form.GPS_Alt   = '%7.1f';
form.Latitude  = '%3.7f';
form.Longitude = '%4.7f';
form.QA_CWV    = '%1.0f';
form.QA_O3     = '%1.0f';
form.VCD_O3    = '%4.2f';
form.resid_O3  = '%4.3f';
form.resid_NO2 = '%4.5f';
%form.resid_HCOH= '%4.5f';
form.VCD_NO2   = '%4.3f';
%form.VCD_HCOH  = '%4.3f';
form.QA_NO2    = '%1.0f';
%form.QA_HCOH   = '%1.0f';
form.QA_CWV    = '%1.0f';
form.CWV       = '%2.3f';
form.std_CWV   = '%2.3f';


%% prepare list of details for each flight
dslist={'20160501' '20160503' '20160504' '20160506' '20160510' '20160511' '20160512' '20160516' '20160517' '20160519' '20160521' '20160524' '20160526' '20160529' '20160530' '20160601' '20160602' '20160604' '20160608' '20160609' '20160614'} ; %put one day string
%Values of jproc: 1=archive 0=do not archive
jproc=[         0          0          0          0          0          0          0          0          0          0          0           0         0          0          0          0          0          0          0          1          0]  ; %set=1 to process


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
    starfile = fullfile(starsun_path, ['4STAR_' daystr 'starsun_for_starflag.mat']);
    disp(['loading the starsun file: ' starfile])
    load(starfile, 't','Lat','Lon','Alt');
    note = {'C0 from 20160702GASrefspec.mat'};
    gasfile = fullfile(gasfile_path, [daystr '_gas_summary.mat']);
    load(gasfile);
    %% extract special comments about response functions from note
    if ~isempty(strfind(note, 'C0'));
        temp_cells = strfind(note,'C0');
        inote = find(not(cellfun('isempty',temp_cells)));
        for n=1:length(inote);
            specComments{end+1} = [strrep(note{inote(n)},'C0 from','Using the calibration file: ') '\n'];
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
    data.amass_O3 = interp1(nnutc,m_o3(iiutc),UTC);  
    data.amass_NO2 = interp1(nnutc,m_no2(iiutc),UTC);  
    

 %% Load the flag files for the gases
 % 
    if isfield(s, 'flagfilenameCWV');
        disp(['Loading flag file: ' s.flagfilenameCWV])
        flagCWV = load(s.flagfilenameCWV); 
        disp(['Loading flag file: ' s.flagfilenameO3])
        flagO3 = load(s.flagfilenameO3); 
        disp(['Loading flag file: ' s.flagfilenameNO2])
        flagNO2 = load(s.flagfilenameNO2); 
        %disp(['Loading flag file: ' s.flagfilenameHCOH])
        %flagHCOH = load(s.flagfilenameHCOH); 
        
    else
        % CWV
        [flagfilenameCWV, pathname] = uigetfile2('*.mat', ...
            ['Pick starflag file for day:' daystr]);
        disp(['Loading flag file: ' s.flagfilenameCWV])
        flagCWV = load([pathname flagfilenameCWV]);
        
        % O3
        [flagfilenameO3, pathname] = uigetfile2('*.mat', ...
            ['Pick starflag file for day:' daystr]);
        disp(['Loading flag file: ' s.flagfilenameO3])
        flagO3 = load([pathname flagfilenameO3]);
        
         % NO2
        [flagfilenameNO2, pathname] = uigetfile2('*.mat', ...
            ['Pick starflag file for day:' daystr]);
        disp(['Loading flag file: ' s.flagfilenameNO2])
        flagNO2 = load([pathname flagfilenameNO2]);
        
         % HCOH
%         [flagfilenameHCOH, pathname] = uigetfile2('*.mat', ...
%             ['Pick starflag file for day:' daystr]);
%         disp(['Loading flag file: ' s.flagfilenameHCOH])
%         flagHCOH = load([pathname flagfilenameHCOH]);
        
    end   

     %% Combine the flag values
     
     
     % read CWV flag file
%      if isfield(flagCWV,'manual_flags');
%         QA_CWV = flagCWV.manual_flags.screen;
%     else
        QA_CWV = bitor(flagCWV.before_or_after_flight,flagCWV.bad_aod);
        QA_CWV = bitor(QA_CWV,flagCWV.cirrus);
        QA_CWV = bitor(QA_CWV,flagCWV.frost);
        QA_CWV = bitor(QA_CWV,flagCWV.low_cloud);
        QA_CWV = bitor(QA_CWV,flagCWV.unspecified_clouds);
%     end
    % CWV
    data.QA_CWV = Start_UTCs*0+1; % sets the default to 1
    flagCWV.utc = t2utch(flagCWV.time.t);
    [ii,dt] = knnsearch(flagCWV.utc,UTC');
    idd = dt<1.0/3600.0; % Distance no greater than one second.
    data.QA_CWV(idd) = QA_CWV(ii(idd));
     
    
    % read O3 flag file 
%     if isfield(flagO3,'manual_flags');
%         QA_O3 = flagO3.manual_flags.screen;
%     else
        QA_O3 = bitor(flagO3.before_or_after_flight,flagO3.bad_aod);
        QA_O3 = bitor(QA_O3,flagO3.cirrus);
        QA_O3 = bitor(QA_O3,flagO3.frost);
        QA_O3 = bitor(QA_O3,flagO3.low_cloud);
        QA_O3 = bitor(QA_O3,flagO3.unspecified_clouds);
%     end
    
    % O3
    data.QA_O3 = Start_UTCs*0+1; % sets the default to 1
    flagO3.utc = t2utch(flagO3.time.t);
    [ii,dt] = knnsearch(flagO3.utc,UTC');
    idd = dt<1.0/3600.0; % Distance no greater than one second.
    data.QA_O3(idd) = QA_O3(ii(idd));
    
    % read NO2 flag file 
%     if isfield(flagNO2,'manual_flags');
%         QA_NO2 = flagNO2.manual_flags.screen;
%     else
        QA_NO2 = bitor(flagNO2.before_or_after_flight,flagNO2.bad_aod);
        QA_NO2 = bitor(QA_NO2,flagNO2.cirrus);
        QA_NO2 = bitor(QA_NO2,flagNO2.frost);
        QA_NO2 = bitor(QA_NO2,flagNO2.low_cloud);
        QA_NO2 = bitor(QA_NO2,flagNO2.unspecified_clouds);
%     end
    
    % NO2
    data.QA_NO2 = Start_UTCs*0+1; % sets the default to 1
    flagNO2.utc = t2utch(flagNO2.time.t);
    [ii,dt] = knnsearch(flagNO2.utc,UTC');
    idd = dt<1.0/3600.0; % Distance no greater than one second.
    data.QA_NO2(idd) = QA_NO2(ii(idd));
    
     % read HCOH flag file 
%     if isfield(flagHCOH,'manual_flags');
%         QA_HCOH = flagHCOH.manual_flags.screen;
%     else
%         QA_HCOH = bitor(flagHCOH.before_or_after_flight,flagHCOH.bad_aod);
%         QA_HCOH = bitor(QA_HCOH,flagHCOH.cirrus);
%         QA_HCOH = bitor(QA_HCOH,flagHCOH.frost);
%         QA_HCOH = bitor(QA_HCOH,flagHCOH.low_cloud);
%         QA_HCOH = bitor(QA_HCOH,flagHCOH.unspecified_clouds);
%     end
    
    % HCOH
%     data.QA_HCOH = Start_UTCs*0+1; % sets the default to 1
%     flagHCOH.utc = t2utch(flagHCOH.time.t);
%     [ii,dt] = knnsearch(flagHCOH.utc,UTC');
%     idd = dt<1.0/3600.0; % Distance no greater than one second.
%     data.QA_HCOH(idd) = QA_HCOH(ii(idd));
    
    
     %disp('Setting some flags to default to 1')
     %data.QA_CWV = Start_UTCs*0;
     %data.QA_O3  = Start_UTCs*0;
     %data.QA_HCOH = Start_UTCs*0 + 1;% set to 1; this is experimental
    

    %% Now go through the times, and fill up the related variables
    disp('filing up the data')
    % get the indices for the proper times
    [iig,dtg] = knnsearch(tutc,UTC');
    iddg = dtg<1.0/3600.0; % Distance no greater than one second.
    
    %cwv
    data.CWV(iddg)      = cwv(iig(iddg));
    data.std_CWV(iddg)  = cwv_std(iig(iddg));
    %o3
    data.VCD_O3(iddg)   = o3DU(iig(iddg));
    data.resid_O3(iddg) = o3resiDU(iig(iddg));
    %no2
    data.VCD_NO2(iddg)  = no2DU(iig(iddg));
    data.resid_NO2(iddg)= no2resiDU(iig(iddg));
    %hcoh
%     data.VCD_HCOH(iddg) = hcoh_DU(iig(iddg));
%     data.resid_HCOH(iddg)= hcohresi(iig(iddg));

    
%     if isfield(gas.no2,'no2DU')
%         data.VCD_NO2(iddg)  = no2DU;
%         data.resid_NO2(iddg)= no2resiDU;
%     else
        %disp('Applying Loschmidt to convert NO2 from molecules to DU')
        %Loschmidt           = 2.686763e19; %molecules/cm2
        %data.VCD_NO2(iddg)  = Start_UTCs(iddg)*0+(-99999);% until new calibration is applied; no2_molec_cm2(iig(iddg))/(Loschmidt/1000);
        %data.resid_NO2(iddg)= Start_UTCs(iddg)*0+(-99999);% until new calibration is applied; no2err_molec_cm2(iig(iddg))/(Loschmidt/1000);
%     end
    
    
    %% make sure that no UTC, Alt, Lat, and Lon is displayed when no measurement
    inans = find(isnan(data.VCD_O3));
    data.GPS_Alt(inans) = NaN;
    data.Latitude(inans) = NaN;
    data.Longitude(inans) = NaN;
    data.amass_O3(inans) = NaN;
    data.amass_NO2(inans) = NaN;
%     for i=iradstart:length(names)
%         data.(names{i})(inans) = NaN;
%     end
    
    %% Now print the data to ICT file
    disp('Printing to file')
    % missing_data_val = -99999
    ICARTTwriter(prefix, platform, HeaderInfo, specComments, NormalComments, revComments, daystr,Start_UTCs,data,info,form,rev,ICTdir,-99999)
end;
