function SEmakearchive_ORACLES_2017_zenrad

%% Details of the program:
% NAME:
%   SEmakearchive_ORACLES_2017_zenrad
%
% PURPOSE:
%  To generate Zenith Radiance archive files for use wih ORACLES 2017
%
% CALLING SEQUENCE:
%   SEmakearchive_ORACLES_2017_zenrad
%
% INPUT:
%  none
%
% OUTPUT:
%  netcdf (*.nc) files
%
% DEPENDENCIES:
%  - version_set.m
%  - t2utch.m
%  - starzen_to_netcdf.m
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starzen.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, 2019-10-03
%                 based on over from SEmakearchive_ORACLES_2017_zenrad.m
% -------------------------------------------------------------------------

%% Start the code
version_set('v1.0')

%% set variables
starinfo_path = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
starzen_path = getnamedpath('ORACLES2017_starzen')
ncdir = getnamedpath('ORACLES2017_zen_nc')

prefix='4STAR-ZENRAD'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='0'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'P3';

%% Prepare General header for each file
HeaderInfo.PI =  'Jens Redemann';                           % PI name
HeaderInfo.Institution = 'NASA Ames Research Center';        % Organization
HeaderInfo.Instrument = 'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';   % Data Source
HeaderInfo.Mission = 'ORACLES 2017';                         % Mission name
HeaderInfo.PI_contact_info = 'jredemann@ou.edu';
HeaderInfo.Platform = 'NASA P3';
HeaderInfo.Location = 'Based in Sao Tome. Exact aircraft latitude, longitude, altitude are included in the data records.';
HeaderInfo.Data_info = 'Measurements represent downwelling radiances measured while sampling at Zenith from under clouds.';
HeaderInfo.DM_Contact_info = 'Samuel LeBlanc, samuel.leblanc@nasa.gov';
HeaderInfo.Project_info = 'ORACLES 2017 deployment; August-September 2017; Based out of Sao Tome.';
HeaderInfo.STIPULATIONS_ON_USE = 'This is the initial public release of the 4STAR-ZENRAD ORACLES-2017 data set. We strongly recommend that you consult the PI, both for updates to the data set, and for the proper and most recent interpretation of the data for specific science use.';...
HeaderInfo.R0_comments = 'Final calibrations, the data is subject to uncertainties associated with detector stability, transfer efficiency of light through fiber optic cable, cloud screening, diffuse light, deposition on the front windows. Potential of higher uncertainty at wavelengths between 390 nm - 430 nm.';

%% Prepare the information/attributes for each saved variable
info.Latitude.units  = 'deg N';
info.Latitude.long_name = 'Aircraft latitude (deg) at the indicated time..';

info.Longitude.units = 'deg E';
info.Longitude.long_name = 'Aircraft longitude (deg) at the indicated time.';

info.GPS_Alt.units = 'm';
info.GPS_Alt.long_name = 'Aircraft GPS geometric altitude above sea level (m) at the indicated time.';

info.wavelength.units = 'nm';
info.wavelength.long_name = 'Wavelength of measured radiance.';

info.day_of_year.units = 'day';
info.day_of_year.long_name = 'Number of days since January 1, fractions of integer rerpesent the partial day.';

info.UTC_time.units = 'seconds';
info.UTC_time.long_name = 'Seconds since midnight UTC';

info.Zenrad.units = 'W/m^2 nm sr';
info.Zenrad.long_name = 'Zenith looking radiances measured under cloud.';
info.Zenrad.UNCERTAINTY = 'Nominal uncertainty at 1.2%-1.5% accross the spectra.';

%% Prepare the dimensions of each variable
dims.Latitude = {'UTC_time'};
dims.Longitude = {'UTC_time'};
dims.GPS_Alt = {'UTC_time'};
dims.wavelength = {};
dims.day_of_year = {'UTC_time'};
dims.UTC_time = {};
dims.Zenrad = {'UTC_time';'wavelength'};

%% prepare list of details for each flight
dslist={'20170801' '20170802' '20170807' '20170809' '20170812' '20170813' '20170815' '20170817' '20170818' '20170819' '20170821' '20170824' '20170826' '20170828' '20170830' '20170831' '20170902' '20170903' '20170904' '20171026'} ; %put one day string
%Values of jproc: 1=archive 0=do not archive

jproc=[         1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1           1          0] ;
%jproc=[         1          1          1          0          0          0          0          0          0          0          0          0          0          0          0          0          0          1          1          0] ;
%jproc=[         0          0          0          0          0          0          0          1          0          0          0          0          0          0          0          0          0          0          0          0] ; %set=1 to proces s
%jproc=[         1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          0] ;

%% run through each flight, load and process
idx_file_proc=find(jproc==1);
for i=idx_file_proc
    if isfield(HeaderInfo, 'Special_Comment')
        HeaderInfo = rmfield(HeaderInfo, 'Special_Comment');
    end
    %% get the flight time period
    daystr=dslist{i};
    disp(['on day:' daystr])
    %cd starinfo_path
    %infofile_ = fullfile(starinfo_path, ['starinfo_' daystr '.m']);
    infofile_ = ['starinfo_' daystr '.m'];
    infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
    s = ''; s.dummy = '';s.instrumentname = '4STAR';
    try
        s = infofnt(s);
    catch
        eval([infofile_(1:end-2),'(s);']);
    end
    UTCflight=t2utch(s.flight);
    %HeaderInfo.Date = daystr;
    
    
    %% get the special comments
    switch daystr
        case '20170819'
                HeaderInfo.Special_Comment ='NIR spectrometer partial failure, all radiances with wavelengths larger than 1000 nm are to be ignored.';
        case '20170821'
                HeaderInfo.Special_Comment ='NIR spectrometer failure, all radiances with wavelengths larger than 1000 nm are to be ignored.';
        case '20170831'
                HeaderInfo.Special_Comment ='Window deposition for this flight is larger than average, Uncertainties in radiance should be incresed to 8%.';
        case '20170802'
                HeaderInfo.Special_Comment = 'Aborted flight, nearly no data.';
        otherwise
            try
                HeaderInfo = rmfield(HeaderInfo,'Special_Comment');
            catch
                disp('sp')
            end
    end
    
    %% read file to be saved
    starfile = fullfile(starzen_path, ['4STAR_' daystr 'starzen.mat']);
    disp(['loading the starzen file: ' starfile])
    t_rad = []; rads = [];
    load(starfile, 't_rad','rads','w','iset','Lat','Lon','Alt','note','t');
    
    %% Fill out the data to be saved
    data.Latitude = Lat(iset);
    data.Longitude = Lon(iset);
    data.GPS_Alt = Alt(iset);
    data.wavelength = w(:);
    try
        data.day_of_year = day(datetime(t_rad(:),'ConvertFrom','datenum'),'dayofyear')+t2utch(t_rad(:))./24.0;
        data.UTC_time = t2utch(t_rad(:)).*3600.0;
    catch
        t_rad = t(iset);
        data.day_of_year = day(datetime(t_rad(:),'ConvertFrom','datenum'),'dayofyear')+t2utch(t_rad(:))./24.0;
        data.UTC_time = t2utch(t_rad(:)).*3600.0;
    end
    
    data.Zenrad = rads;
    
    %% NaN out any zenith radiances before or after the flight
    flt = or(t_rad>s.flight(2),t_rad<s.flight(1));
    data.Zenrad(flt) = NaN;
    
    %% extract special comments about response functions from note
    calComments = {};
    if ~isempty(strfind(note, 'Resp'));
        temp_cells = strfind(note,'Resp');
        inote = find(not(cellfun('isempty',temp_cells)));
        for n=1:length(inote);
            calComments{end+1} = [strrep(note{inote(n)},'Resp from','Using the Response function calibration file: ') '\n'];
        end
    end
    
    info.Zenrad.Calibration_file = sprintf('%s ',calComments{:});
    
    
    %% Now print the data to ICT file
    disp('Printing to file')
    netcdf_writer(prefix, platform, HeaderInfo, daystr,data,info,dims,rev,ncdir)
end
end




