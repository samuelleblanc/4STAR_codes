function SEmakearchive_AirSHARP_2024_AOD_nc

%% Details of the program:
% NAME:
%   SEmakearchive_AirSHARP_2024_AOD_nc
%
% PURPOSE:
%  To generate AOD netcdf archive files for use wih AirSHARP 2024
%
% CALLING SEQUENCE:
%   SEmakearchive_AirSHARP_2024_AOD_nc
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
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2024-10-14
%                 based on over from SEmakearchive_ORACLES_2018_zenrad.m
% -------------------------------------------------------------------------

%% Start the code
version_set('v1.0')

%% set variables
starinfo_path = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
starsun_path = getnamedpath('AirSHARP2024')
ncdir = getnamedpath('AirSHARP2024_AOD_nc')
instrumentname = '4STARB';


prefix=[instrumentname '-AOD']; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='A'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'TwinOtter';

%% Prepare General header for each file
HeaderInfo.PI =  'Samuel LeBlanc';                           % PI name
HeaderInfo.Institution = 'NASA Ames Research Center';        % Organization
HeaderInfo.Instrument = 'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR) - B';   % Data Source
HeaderInfo.Mission = 'AirSHARP 2024';                         % Mission name
HeaderInfo.PI_contact_info = 'Samuel.leblanc@nasa.gov';
HeaderInfo.Platform = 'NPS Twin Otter';
HeaderInfo.Location = 'Based in Marina, California, measuring in the Monterey Bay. Exact aircraft latitude, longitude, altitude are included in the data records';
HeaderInfo.Data_info = 'Measurements represent aerosol optical depth measured while sampling the direct solar irradiance.';
HeaderInfo.DM_Contact_info = 'Samuel LeBlanc, samuel.leblanc@nasa.gov';
HeaderInfo.Project_info = 'AirSHARP 2024 deployment for PACE validation; October 2024; Based out of Marina, CA';
HeaderInfo.STIPULATIONS_ON_USE = 'This is the initial public release of the 4STAR-AOD data set. We strongly recommend that you consult the PI, both for updates to the data set, and for the proper and most recent interpretation of the data for specific science use.';...
%HeaderInfo.R0_comments = 'Final calibrations, the data is subject to uncertainties associated with detector stability, transfer efficiency of light through fiber optic cable, cloud screening, diffuse light, deposition on the front windows. Potential of higher uncertainty at wavelengths between 390 nm - 430 nm.';
HeaderInfo.RA_comments = 'Initial field release of the 4STARB-AOD data. The data is subject to uncertainties associated with detector stability, transfer efficiency of light through fiber optic cable, cloud screening, diffuse light, deposition on the front windows. See included uncertainties.';
%% Prepare the information/attributes for each saved variable
info.Latitude.units  = 'deg N';
info.Latitude.long_name = 'Aircraft latitude (deg) at the indicated time, from the MetNAV ict file';

info.Longitude.units = 'deg E';
info.Longitude.long_name = 'Aircraft longitude (deg) at the indicated time, from the MetNAV ict file';

info.GPS_Alt.units = 'm';
info.GPS_Alt.long_name = 'Aircraft GPS geometric altitude above sea level (m) at the indicated time, from the MetNAV ict file';

info.wavelength.units = 'nm';
info.wavelength.long_name = 'Wavelength of measured AOD.';

info.day_of_year.units = 'day';
info.day_of_year.long_name = 'Fractional day of year, Number of days since January 1';

info.UTC_time.units = 'seconds';
info.UTC_time.long_name = 'Seconds since midnight UTC';

info.AOD.units = 'unitless';
info.AOD.long_name = 'Aerosol optical depth of the column above the aircraft.';
%info.AOD.UNCERTAINTY = 'Nominal uncertainty at 1.2%-1.5% accross the spectra.';

info.AOD_uncertainty.units = 'unitless';
info.AOD_uncertainty.long_name = 'Uncertainty of the aerosol optical depth of the column above the aircraft based on calibration coefficient variance, tracking uncertainty, trace gas optical depth contamination, and window deposition, see LeBlanc et al. 2020 for some details.';

info.qual_flag.units = 'unitless';
info.qual_flag.long_name = 'Quality flag for AOD values, if 0=good or 1=poor; due to clouds, tracking errors, or instrument stability.';

info.m_aero.units = 'unitless';
info.m_aero.long_name = 'aerosol optical airmass factor';

info.FMF.units = 'unitless';
info.FMF.long_name = 'Aerosol optical Fine Mode Fraction following Spectral Deconvolution Algorithm ONeill et al., 2001';

info.AOD_angstrom_470_865.units = 'unitless';
info.AOD_angstrom_470_865.long_name = 'Angstrom exponent calculated from the ratio of AOD at 470 nm and 865 nm, is equivalent to the inverse of the slope of the log(AOD) at these 2 wavelengths, -dlog(AOD)/dlog(wavelength)';
wvls_angs = [470.0,865.0];


%% Prepare the dimensions of each variable
dims.Latitude = {'UTC_time'};
dims.Longitude = {'UTC_time'};
dims.GPS_Alt = {'UTC_time'};
dims.wavelength = {};
dims.day_of_year = {'UTC_time'};
dims.UTC_time = {};
dims.AOD = {'UTC_time';'wavelength'};
dims.AOD_uncertainty = {'UTC_time';'wavelength'};
dims.qual_flag = {'UTC_time'};
dims.m_aero = {'UTC_time'};
dims.AOD_angstrom_470_865 = {'UTC_time'};
dims.FMF = {'UTC_time'};

%% prepare list of details for each flight
dslist={'20241007' '20241008' '20241012' '20241018' '20241019' '20241020'} ; %put one day string
%Values of jproc: 1=archive 0=do not archive
jproc=[         1          1          1          1          1           1] ;

%% run through each flight, load and process
idx_file_proc=find(jproc==1);
for i=idx_file_proc
    
    %% get the flight time period
    daystr=dslist{i};
    disp(['on day:' daystr])

    %% get the special comments
    switch daystr
        case '20241007'
            HeaderInfo.Special_comments = 'Twin Otter Check flight.';
        otherwise
            HeaderInfo.Special_comments = '';
    end
    
    %% read file to be saved
    starfile = fullfile(starsun_path, [instrumentname '_' daystr 'starsun.mat']);
    disp(['loading the starsun file: ' starfile])
    s = load(starfile, 't','tau_aero','tau_aero_noscreening','tau_aero_err','w','tau_aero_polynomial','Lat','Lon','Alt','note','flags','m_aero');
    s.w = s.w.*1000.0;
    [nul,iw1] = min(abs(s.w-wvls_angs(1)));
    [nul,iw2] = min(abs(s.w-wvls_angs(2)));
    iwvls_angs = [iw1,iw2];
    
    %% get the wavelengths to archive
    [iwvl,save_wvls,iwvl_archive] = get_wvl_subset(s.t(1),instrumentname);
    
    %% read starinfo
    infofile_ = ['starinfo_' daystr '.m'];
    infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
    s.dummy = '';s.instrumentname = instrumentname;
    try
        s = infofnt(s);
    catch
        eval([infofile_(1:end-2),'(s);']);
    end
    UTCflight=t2utch(s.flight);
    %HeaderInfo.Date = daystr;
    
    %% Combine the flag values
    disp('...Setting the flags')
    if isfield(s.flags,'flagfile') & ~isfield(s.flags,'t')
        flags = load(which(s.flags.flagfile));
    else
       flags = s.flags; 
    end
    s.valid_time = [min(s.t)+1.0/12,max(s.t)];% set flight time to start and end of data, not total flight
    [qual_flag,flag] = convert_flags_to_qual_flag(flags,s.t,s.valid_time); 
    data.qual_flag = s.t*0+1; % sets the default to 1
    % tweak for different flag files
    flag.utc = t2utch(flags.t);
    [ii,dt] = knnsearch(flag.utc,t2utch(s.t));
    idd = dt<1.0/3600.0; % Distance no greater than one second.
    data.qual_flag(idd) = qual_flag(ii(idd));
    data.qual_flag = cast(data.qual_flag,'int8');
    
    %% Get the polyfit Fine Mode Fraction from O'Neill Spectral Deconvolution Algorithm
    [FMF, Afl, Al, Apl]=polyfit2FMF(0.5,s.tau_aero_polynomial(:,1),s.tau_aero_polynomial(:,2));
    FMF = real(FMF);
    FMF(FMF>1.0) = NaN; %set the FMF to bad.
    FMF(FMF<0.001) = NaN; %set the FMF to bad.
    
    %% Get the Angstrom exponent
    ae = real(sca2angstrom(s.tau_aero_noscreening(:,iwvls_angs), s.w(iwvls_angs)));
    ae(ae<=-0.5) = NaN;
    ae(ae>3.0) = NaN;
    
    %% Fill out the data to be saved
    data.Latitude = s.Lat;
    data.Longitude = s.Lon;
    data.GPS_Alt = s.Alt;
    data.wavelength = s.w(iwvl_archive);
    data.day_of_year = day(datetime(s.t(:),'ConvertFrom','datenum'),'dayofyear')+t2utch(s.t(:))./24.0;
    data.UTC_time = t2utch(s.t(:)).*3600.0;
    data.AOD = s.tau_aero_noscreening(:,iwvl_archive);
    data.AOD_uncertainty = s.tau_aero_err(:,iwvl_archive);
    data.m_aero = s.m_aero;
    data.AOD_angstrom_470_865 = ae;
    data.FMF = FMF;
    
    %% check for exta uncertainty
    if isfield(s,'AODuncert_constant_extra')
        data.AOD_uncertainty = data.AOD_uncertainty +s.AODuncert_constant_extra;
    end
    
    %% NaN out any zenith radiances before or after the flight
    %flt = or(s.t>s.flight(2),s.t<s.flight(1));
    %data.AOD(flt) = NaN;
    %data.FMF(flt) = NaN;
    
    %% Set the flag to bad if uncertainty is too large (greater than 0.06)
    [nul,iw500] = min(abs(s.w(iwvl_archive)-500.0));
    ihigh_uncert = data.AOD_uncertainty(:,iw500)>0.06;
    if any(ihigh_uncert)
        data.qual_flag = bitor(data.qual_flag,ihigh_uncert);
    end
    
    %% extract special comments about response functions from note
    calComments = {};
    if ~isempty(strfind(s.note, 'C0'));
        temp_cells = strfind(s.note,'C0');
        inote = find(not(cellfun('isempty',temp_cells)));
        for n=1:length(inote);
            calComments{end+1} = [strrep(s.note{inote(n)},'Co from','Using the C0 calibration file: ') '\n'];
        end
    end
    
    info.AOD.Calibration_file = sprintf('%s ',calComments{:});
    
    %% Now print the data to netcdf file
    disp('Printing to file')
    netcdf_writer(prefix, platform, HeaderInfo, daystr,data,info,dims,rev,ncdir)
end
end




