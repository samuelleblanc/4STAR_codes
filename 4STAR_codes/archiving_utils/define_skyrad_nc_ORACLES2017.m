function anc_rad = define_skyrad_nc_ORACLES2017(skyrad_fname);
% anc_rad = define_skyrad_nc(skyrad_fname);
% Loads a selected 4STAR skyscan *_SKY*.mat file (output from starsky_plus)
% defines a netcdf file with dimensions time and scattering angle, and
% populates it. 

% CJF: v1.0, 2019/09/04: initial version 
% SL: v1.1, 2019/10/5: Updated version ported to ORACLES2017 with new header notes
version_set('1.1');

if ~isavar('skyrad_fname')
   skyrad_fname = getfullname('*sky*.mat','4STAR_skymat','Select sky mat file');
end

if iscell(skyrad_fname)&&isafile(skyrad_fname{1})&&length(skyrad_fname)>1
   define_skyrad_nc_ORACLES2017(skyrad_fname(2:end)); 
end
if ~isadir(getnamedpath('skyrad_nc'))
   anc_nc = setnamedpath('skyrad_nc','','Select directory for skyscan netcdf');
end
if iscell(skyrad_fname)
   skyrad_fname = skyrad_fname{1};
end
disp(skyrad_fname)
skyrad = load(skyrad_fname); skyrad = skyrad.s;
skyrad.wl_ii = [ 283         407         627         876        1040];
% produce 4STAR sky scan radiance netcdf files:

% Define dims: time, scattering_angle
% For each define id, length, isunlim

% Define vars
% For each var,under var.(fieldname) define id, datatype, dims (array of strings), and atts
%     for each att, define id, datatype,
%     and assign the vatt value under .vatts.(fieldname).(vattname)

% Remember to include scan #, and telemetry

% Defind recdim and dims, then add to ncdef.
recdim.name = 'time';
recdim.id = 0;
recdim.length = 0;
ncdef.recdim = recdim;

time.id = 0; time.isunlim = 1; time.length = 0;
SA.id = 1; SA.isunlim = 0; SA.length = 60;
wavelength.id = 2; wavelength.isunlim = 0; wavelength.length = 5;
dims.time = time; dims.SA = SA; dims.wavelength = wavelength;
ncdef.dims = dims;
anc_rad.ncdef = ncdef;
anc_rad.time = [];

att.PI = 'Jens Redemann';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.Institution = 'NASA Ames Research Center';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.Instrument = 'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.Mission = 'ORACLES 2017';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.PI_CONTACT_INFO = 'jredemann@ou.edu';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.PLATFORM = 'NASA P3';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.LOCATION = 'Based at Saot Tome, aircraft latitude, longitude, altitude are included in the data records';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.DATA_INFO = 'Measurements represent sky radiances at the location of the aircraft in the direction indicated by Az_sky and El_sky reported at the measurement time averaged over the sky scan.';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.Calibration = 'Resp from 20171102_VIS_SKY_Resp_from_4STAR_20171102_005_VIS_ZEN_with_20160121125700HISS.dat.';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.UNCERTAINTY = 'Radiance uncertainties are between 1.0%-1.2% from 470-995 nm. Pointing accuracy is better than 1 degree.';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.DM_CONTACT_INFO = 'Connor Flynn, Connor.J.Flynn@ou.edu';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.PROJECT_INFO = 'ORACLES 2017 deployment; August-September 2017; Sao Tome';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.STIPULATIONS_ON_USE = 'This is the initial public release of the ORACLES-2017 sky radiance data set. We strongly recommend that you consult the PI, both for updates to the data set, and for the proper and most recent interpretation of the data for specific science use.';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.REVISION = 'R0';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.R0 = 'Initial public archive of sky radiances measured in-flight by 4STAR for use with sky-radiance inversions. There are additional uncharacterized uncertainties related to potential effects of window deposition, and the potential for stray sunlight reflecting off internal surfaces';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');
att.Processing_code_DOI = '10.5281/zenodo.1492911';
anc_rad = anc_add_att(anc_rad,[], att); clear('att');

%Now define vars, starting with time;
anc_rad.time = mean(skyrad.t);
anc_rad = anc_timesync(anc_rad); anc_rad.time = [];

var = [];var.wavelength = [];
dims = {'wavelength'};
vatts.long_name = 'wavelength'; vatts.units = 'nm';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = [];var.sca_angle = [];
dims = {'SA','time'};
vatts.long_name = 'Scattering angle'; vatts.units = 'degrees';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.radiance = NaN(60,length(skyrad.wl_ii),1);
dims = {'SA','wavelength','time'};
vatts.long_name = 'radiance'; vatts.units = 'mW/m^2/nm/sr';
anc_rad = anc_add_var(anc_rad,var,dims, vatts); clear vatts dims var

var = []; var.scan_tag = [];
dims = {'time'};
vatts.long_name = 'sky scan file tag'; vatts.units = 'unitless';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.scan_type = [];
dims = {'time'};
vatts.long_name = 'sky scan type'; vatts.units = 'unitless';
vatts.values = '1 = ALM A; 2 = ALM B; 3 = PPL';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var 

var = []; var.Lat = [];
dims = {'time'};
vatts.long_name = 'Lattitude'; vatts.units = 'degrees N';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.Lon = [];
dims = {'time'};
vatts.long_name = 'Longitude'; vatts.units = 'degrees E';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.GPS_Altitude = [];
dims = {'time'};
vatts.long_name = 'Aircraft altitude'; vatts.units = 'm above mean sea level';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.Heading = [];
dims = {'time'};
vatts.long_name = 'Aircraft heading'; vatts.units = 'degrees N, CW';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.Pitch = [];
dims = {'time'};
vatts.long_name = 'Aircraft pitch'; vatts.units = 'degrees nose-up';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.Roll = [];
dims = {'time'};
vatts.long_name = 'Aircraft roll'; vatts.units = 'degrees right-down';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.GPS_Altitude_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of aircraft altitude'; vatts.units = 'm above mean sea level';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.Heading_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of heading'; vatts.units = 'degrees N, CW';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.Pitch_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of pitch'; vatts.units = 'degrees nose-up';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.Roll_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of roll'; vatts.units = 'degrees right-down';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.T_static = [];
dims = {'time'};
vatts.long_name = 'outside air temperature, static'; vatts.units = 'degrees C';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.P_static = [];
dims = {'time'};
vatts.long_name = 'ambient pressure'; vatts.units = 'mbar';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.RH = [];
dims = {'time'};
vatts.long_name = 'outside relative humidity'; vatts.units = '%';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.SAZ = [];
dims = {'time'};
vatts.long_name = 'solar azimuth angle'; vatts.units = 'deg CW';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.SZA = [];
dims = {'time'};
vatts.long_name = 'solar zenith angle'; vatts.units = 'deg from vertical';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.SEL = [];
dims = {'time'};
vatts.long_name = 'solar elevation angle'; vatts.units = 'deg from horizon';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.AZ_sky = [];
dims = {'time'};
vatts.long_name = 'azimuth angle of scene'; vatts.units = 'deg CW';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.EL_sky = [];
dims = {'time'};
vatts.long_name = 'elevation angle of scene'; vatts.units = 'deg from horizon';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

var = []; var.m_ray = [];
dims = {'time'};
vatts.long_name = 'airmass, Rayleigh'; vatts.units = 'unitless';
anc_rad = anc_add_var(anc_rad, var, dims, vatts); clear vatts dims var

% for wl_ii = 1:length(skyrad.wl_ii)
%    w_ii= skyrad.wl_ii(wl_ii); wl = 1000.*(skyrad.w(w_ii));
%    wl_str = sprintf('_%2.0dnm',round(wl));
%    
% %    var = []; var.(['radiance',wl_str]) = NaN(60,1);
% %    dims = {'SA','time'};
% %    vatts.long_name = 'radiance'; vatts.units = 'mW/m^2/nm/sr';
% %    anc_rad = anc_add_var(anc_rad,var,dims, vatts);
% end

anc_rad.vdata.wavelength = 1000.* skyrad.w(skyrad.wl_ii);

for sky_str = {'good_almA','good_almB','good_ppl'}
   sky = sky_str{:};
   var = [];
   if isfield(skyrad, sky)&&sum(skyrad.(sky))>5
      t = length(anc_rad.time)+1;
      anc_rad.time(t) = mean(skyrad.t(skyrad.(sky)));
      
      var.sca_angle = NaN([60,1]);
      SA = skyrad.SA(skyrad.(sky)); var.sca_angle(1:length(SA))=SA;
      anc_rad.vdata.sca_angle(:,t) = var.sca_angle; var = [];
      
      var.rad = NaN(60,length(anc_rad.vdata.wavelength),1);
      rad = skyrad.skyrad(skyrad.(sky),skyrad.wl_ii); var.rad(1:size(rad,1),1:length(anc_rad.vdata.wavelength)) = rad;
      anc_rad.vdata.radiance(:,:,t)= var.rad;
      
      var.scan_tag = sscanf(skyrad.filen,'%d');
      anc_rad.vdata.scan_tag(t) = var.scan_tag; var = [];
      
      var.scan_type = double(strcmp(sky,'good_almA')) + ...
         2.*double(strcmp(sky,'good_almB')) + ...
         3.*double(strcmp(sky,'good_ppl'));
      anc_rad.vdata.scan_type(t) = var.scan_type; var = [];
      
      anc_rad.vdata.Lat(t) = mean(skyrad.Lat(skyrad.(sky)));
      anc_rad.vdata.Lon(t) = mean(skyrad.Lon(skyrad.(sky)));
      anc_rad.vdata.GPS_Altitude(t) = mean(skyrad.Alt(skyrad.(sky)));
      anc_rad.vdata.Heading(t) = mean(skyrad.Headng(skyrad.(sky)));
      anc_rad.vdata.Pitch(t) = mean(skyrad.pitch(skyrad.(sky)));
      anc_rad.vdata.Roll(t) = mean(skyrad.roll(skyrad.(sky)));
      anc_rad.vdata.GPS_Altitude_std(t) = std(skyrad.Alt(skyrad.(sky)));
      anc_rad.vdata.Heading_std(t) = std(skyrad.Headng(skyrad.(sky)));
      anc_rad.vdata.Pitch_std(t) = std(skyrad.pitch(skyrad.(sky)));
      anc_rad.vdata.Roll_std(t) = std(skyrad.roll(skyrad.(sky)));
      anc_rad.vdata.P_static(t) = mean(skyrad.Pst(skyrad.(sky)));
      anc_rad.vdata.T_static(t) = mean(skyrad.Tst(skyrad.(sky)));
      anc_rad.vdata.RH(t) = mean(skyrad.RH(skyrad.(sky)));
      anc_rad.vdata.SAZ(t) = mean(skyrad.sunaz(skyrad.(sky)));
      anc_rad.vdata.SZA(t) = mean(skyrad.sza(skyrad.(sky)));
      anc_rad.vdata.SEL(t) = mean(skyrad.sunel(skyrad.(sky)));
      anc_rad.vdata.AZ_sky(t) = mean(skyrad.Az_sky(skyrad.(sky)));
      anc_rad.vdata.EL_sky(t) = mean(skyrad.El_sky(skyrad.(sky)));
      anc_rad.vdata.m_ray(t) = mean(skyrad.m_ray(skyrad.(sky)));
%       for wl_ii = 1:length(skyrad.wl_ii)
%          w_ii = skyrad.wl_ii(wl_ii);
%          wl = 1000.*(skyrad.w(w_ii));
%          wl_str = sprintf('_%2.0dnm',round(wl));
% %          anc_rad.vdata.(['radiance',wl_str])(:,t) = NaN(60,1);
% %          rad = skyrad.skyrad(skyrad.(sky),w_ii);
% %          anc_rad.vdata.(['radiance',wl_str])(1:length(rad),t)= rad;
%       end      
   end      
end
try
    anc_rad = anc_timesync(anc_rad);
    fname = ['4STAR-skyrad_P3_',datestr(anc_rad.time(1),'yyyymmdd.HHMMSS'),'_R0.nc'];
    anc_rad.fname = [getnamedpath('skyrad_nc'),fname];
    anc_rad.clobber = true;anc_rad.verbose = false; anc_rad.quiet = true;quiet = anc_rad.quiet;
    anc_rad = anc_check(anc_rad); anc_rad = rmfield(anc_rad,'quiet');
    anc_save(anc_rad,[],quiet);
catch 
    disp(['Problem with data from file: ' skyrad_fname ' *** skipping ***'])
    anc_rad = [];
end
% anc_rad = anc_bundle_files(['4STAR-skyrad_P3_*_R0.nc'],'skyrad_nc');
% anc_save(anc_rad)

% 4STAR-skyrad_P3_yyyymmdd_R0.nc
% 4STAR-aeroinv-