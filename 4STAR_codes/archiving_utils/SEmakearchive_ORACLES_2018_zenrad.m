function SEmakearchive_ORACLES_2018_zenrad

%% Details of the program:
% NAME:
%   SEmakearchive_ORACLES_2018_zenrad
%
% PURPOSE:
%  To generate Zenith Radiance archive files for use wih ORACLES 2018
%
% CALLING SEQUENCE:
%   SEmakearchive_ORACLES_2018_zenrad
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
%                 based on over from SEmakearchive_ORACLES_2018_zenrad.m
% -------------------------------------------------------------------------

%% Start the code
version_set('v1.0')

%% set variables
starinfo_path = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
starsun_path = getnamedpath('ORACLES2018_starzen')
ICTdir = getnamedpath('ORACLES2018_zen_nc')

prefix='4STAR-ZENRAD'; %'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-SKYSCAN'; % 'SEAC4RS-4STAR-AOD'; % 'SEAC4RS-4STAR-WV';
rev='0'; % A; %0 % revision number; if 0 or a string, no uncertainty will be saved.
platform = 'P3';

%% Prepare General header for each file
HeaderInfo.PI =  'Samuel LeBlanc';                           % PI name
HeaderInfo.Institution = 'NASA Ames Research Center';        % Organization
HeaderInfo.Instrument = 'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';   % Data Source
HeaderInfo.Mission = 'ORACLES 2018';                         % Mission name
HeaderInfo.PI_CONTACT_INFO = 'Samuel.leblanc@nasa.gov';     
HeaderInfo.PLATFORM = 'NASA P3';
HeaderInfo.Location = 'Based in Sao Tome. Exact aircraft latitude, longitude, altitude are included in the data records';
HeaderInfo.DATA_INFO = 'Measurements represent downwelling radiances measured while sampling at Zenith from under clouds.';
HeaderInfo.DM_CONTACT_INFO = 'Samuel LeBlanc, samuel.leblanc@nasa.gov';
HeaderInfo.PROJECT_INFO = 'ORACLES 2018 deployment; September-October 2018; Based out of Sao Tome';
HeaderInfo.STIPULATIONS_ON_USE = 'This is the initial public release of the 4STAR-ZENRAD ORACLES-2018 data set. We strongly recommend that you consult the PI, both for updates to the data set, and for the proper and most recent interpretation of the data for specific science use.';...
HeaderInfo.R0_comments = 'Final calibrations, the data is subject to uncertainties associated with detector stability, transfer efficiency of light through fiber optic cable, cloud screening, diffuse light, deposition on the front windows.';

%% Prepare the information/attributes for each saved variable
info.Latitude.units  = 'deg N';
info.Latitude.long_name = 'Aircraft latitude (deg) at the indicated time';

info.Longitude.units = 'deg E';
info.Longitude.long_name = 'Aircraft longitude (deg) at the indicated time';

info.GPS_Alt.units = 'm';
info.GPS_Alt.long_name = 'Aircraft GPS geometric altitude above sea level (m) at the indicated time';

info.wavelength.units = 'nm';
info.wavelength.long_name = 'Wavelength of measured radiance.';

info.day_of_year.units = 'day';
info.day_of_year.long_name = 'Number of days since January 1';

info.UTC_time.units = 'seconds';
info.UTC_time.long_name = 'Seconds since midnight UTC';

info.Zenrad.units = 'W/m^2 nm sr';
info.Zenrad.long_name = 'Zenith looking radiances measured under cloud.';
info.Zenrad.UNCERTAINTY = 'Nominal uncertainty at 1.2%-1.5% accross the spectra.';
info.Zenrad.Calibration_file = '{}';

%% Prepare the dimensions of each variable
dims.Latitude = ['UTC_time'];
dims.Longitude = ['UTC_time'];
dims.GPS_Alt = ['UTC_time'];
dims.wavelength = [];
dims.day_of_year = ['UTC_time'];
dims.UTC_time = [];
dims.Zenrad = ['UTC_time';'wavelength'];






