function anc_inv = define_aeroinv_nc(fname)
% anc_aeroinv = define_aeroinv_ncfname);
% Loads a selected 4STAR skyscan *_SKY*.mat file (output from starsky_plus)
% and the companion source "SKY" mat file.
% Defines a netcdf file with dimensions time and scattering angle, and
% populates it. Wavelength-dependent values are broken out individually.

% Defined wavelength dimension and field, use for some 1-D parameters
% Defined wavelength dimension and field, attempt with N-dim parameters
% CJF: v1.0, 2019/09/05: initial version written for ORACLES 2016
%                        metadata will require modification for other deployments
% CJF: v1.1, 2019/09/06: added equivalent aeronet data level from filename
% CJF: v1.2, 2022/09/22: catch cases with not enough good_sky values
version_set('1.2');

if ~isavar('fname')
   fname = getfullname('4STAR*SKY*.created_*lv*.mat','4STAR_skyoutmat','Select sky mat file');
end

if iscell(fname)&&isafile(fname{1})&&length(fname)>1
   define_aeroinv_nc(fname(2:end));
end
if ~isadir(getnamedpath('aeroinv_nc'))
   aeroinv_nc = setnamedpath('aeroinv_nc','','Select directory for skyscan netcdf');
end


% The output mat file doesn't have time, but it does have a reference to
% the original filestem "fstem" that identifies the source .mat file that
% has time
if iscell(fname) fname = fname{1}; end; disp(fname)
aeroinv = load(fname);
skymat_fname= getfullname([aeroinv.fstem,'.mat']);
skyrad = load(skymat_fname);skyrad = skyrad.s;
skyrad.wl_ii = [ 283         407         627         876        1040];
[~,fname_] = fileparts(fname); lv_ii = strfind(fname_,'_lv')+3; Lev = sscanf(fname_(lv_ii:end),'%f')./10;
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
PF_angle.id = 2; PF_angle.isunlim = 0; PF_angle.length = 83;% I hope this is constant
radius.id = 3; radius.isunlim = 0; radius.length = 22; % I hope this is constant too
wavelength.id = 4; wavelength.isunlim = 0; wavelength.length = 5;dims.wavelength = wavelength;
dims.time = time; dims.SA = SA;  dims.PF_angle = PF_angle; dims.radius = radius;


ncdef.dims = dims;
anc_inv.ncdef = ncdef;
anc_inv.time = [];

att.PI = 'Jens Redemann';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.Institution = 'NASA Ames Research Center';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.Instrument = 'Spectrometers for Sky-Scanning, Sun-Tracking Atmospheric Research (4STAR)';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.Mission = 'ORACLES 2016';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.PI_CONTACT_INFO = 'jredemann@ou.edu';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.PLATFORM = 'NASA P3';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.LOCATION = 'Based at Walvis Bay, Namibia, aircraft latitude, longitude, altitude are included in the data records';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.DATA_INFO = 'Measurements represent airborne retrievals of aerosol properties derived from direct beam and angularly-resolved sky radiances at the location of the aircraft in the direction indicated by Az_sky and El_sky.  All measurements used in a single retrieval are reported at the time averaged over the sky scan.';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.RETRIEVAL_INFO = 'Retrieval code was provided by AERONET (version 2 Aerosol Inversions), input files modified for airborne application.';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.RETRIEVAL_DESCRIPTION = 'https://aeronet.gsfc.nasa.gov/new_web/Documents/Inversion_products_V2.pdf';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.Calibration_radiance = 'Resp from 20160330_VIS_SKY_Resp_from_20160330_018_VIS_ZEN_with_20160121125700HISS.dat';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.Calibration_direct_beam = 'C0 from 20160831_VIS_C0_refined_Langley_averaged_inflight_Langley_high_alt_ORACLES.dat.';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.UNCERTAINTY = 'AOD uncertainties varied with wavelength and time, typically between 0.01 and 0.02 (low 0.008, high 0.37), and are reported in 4STAR-AOD [files?]. Radiance uncertainties over the campaign are constant for a given wavelength, between 1.0%-1.2% from 470-995 nm.';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.DM_CONTACT_INFO = 'Connor Flynn, Connor.J.Flynn@ou.edu';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.PROJECT_INFO = 'ORACLES 2016 deployment; August-September 2016; Walvis Bay, Namibia';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.STIPULATIONS_ON_USE = 'This is the initial public release of the ORACLES-2016 sky radiance aerosol inversion data set. We strongly recommend that you consult the PI, both for updates to the data set, and for the proper and most recent interpretation of the data for specific science use.';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.REVISION = 'R0';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.R0 = 'Initial public archive of aerosol intensive properties from direct sun and sky radiances measured in-flight by 4STAR with telemetry from the P-3 and surface albedo from the SSFR. There are additional uncharacterized uncertainties related to potential effects of window deposition, and the potential for stray sunlight reflecting off internal surfaces';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
att.Processing_code_DOI = '10.5281/zenodo.1492911';
anc_inv = anc_add_att(anc_inv,[], att); clear('att');
%Now define vars, starting with time;
anc_inv.time = [mean(skyrad.t)];
anc_inv = anc_timesync(anc_inv); anc_inv.time = [];

var = [];var.wavelength = [];
dims = {'wavelength'};
vatts.long_name = 'wavelength'; vatts.units = 'nm';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = [];var.radius = [];
dims = {'radius'};
vatts.long_name = 'particle radius'; vatts.units = 'um';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = [];var.psd = [];
dims = {'radius','time'};
vatts.long_name = 'particle size distribution'; vatts.units = 'dV/dlnR';vatts.source = 'retrieval';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.QA_level = [];
dims = {'time'};
vatts.long_name = 'Quality assessment level'; vatts.units = 'unitless';vatts.source = '4STAR';
vatts.values = '1.0 1.5 2.0';
vatts.lev2 = 'Has 21+ values at all wavelengths with scattering angle >80 deg and multiple points in each of 4 scattering angle ranges, and <20% asymmetry between CW and CCW legs';
vatts.lev1p5 = 'Has 10+ values at all wavelengths with scattering angle >80 deg and at least one point in each of 4 scattering angle ranges';
vatts.lev1 = 'Has at least one point at all wavelengths in each of 4 scattering angle ranges';
vatts.Comment = 'Based on AERONET inversion criteria in https://aeronet.gsfc.nasa.gov/new_web/Documents/AERONETcriteria_final1.pdf';
vatts.Comment2 = 'A consequence of the symmetry requirement for level 2 is that PPL scans can assess at no higher than 1.5';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.sphericity = [];
dims = {'time'};
vatts.long_name = 'particle sphericity'; vatts.units = 'unitless';vatts.source = 'retrieval';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.sphericity_err = [];
dims = {'time'};
vatts.long_name = 'particle sphericity error'; vatts.units = 'unitless';vatts.source = 'retrieval';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = [];var.PF_angle = [];
dims = {'PF_angle'};
vatts.long_name = 'scattering angle for phase function'; vatts.units = 'degrees';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = [];var.sca_angle = [];
dims = {'SA','time'};
vatts.long_name = 'scattering angle for radiance'; vatts.units = 'degrees';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var



   var = []; var.('n_real') = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['refractive index, real']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.('n_imag') = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['refractive index, imaginary']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['SSA']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['single scattering albedo']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['AOD_fit_total']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['extinction AOD from retrieval, total PSD']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['AOD_fit_fine']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['extinction AOD from retrieval, fine mode']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['AOD_fit_coarse']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['extinction AOD from retrieval, coarse mode']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['AOD_meas']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['AOD from measurement']; vatts.units = 'unitless'; vatts.source = '4STAR';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['AAOD']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['absorption AOD']; vatts.units = 'unitless'; vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['TOD_meas']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['total optical depth from direct measurement']; vatts.units = 'unitless';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['TOD_fit']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['total optical depth from retrieval']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['TOD_meas_minus_fit']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['Measured - Retrieved total OD']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['AGOD']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = 'column absorbing gas optical depth'; vatts.units = 'unitless';vatts.source = '4STAR';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var

   var = []; var.(['sfc_alb']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = 'spectral surface albedo'; vatts.units = 'unitless';vatts.source = 'SSFR';
   anc_inv = anc_add_var(anc_inv,var,dims, vatts); clear vatts dims var   
   
   var = []; var.(['g_total']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['asymmetry parameter, total PSD']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['g_fine']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['asymmetry parameter, fine mode']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['g_coarse']) = NaN;
   dims = {'wavelength','time'};
   vatts.long_name = ['asymmetry parameter, coarse mode']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['PF_total']) = NaN;
   dims = {'PF_angle','wavelength','time'};
   vatts.long_name = ['Phase function, total PSD']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['PF_fine']) = NaN;
   dims = {'PF_angle','wavelength','time'};
   vatts.long_name = ['Phase function, fine mode']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['PF_coarse']) = NaN;
   dims = {'PF_angle','wavelength','time'};
   vatts.long_name = ['Phase function, coarse mode']; vatts.units = 'unitless';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
      
   var = []; var.(['normalized_sky_radiance']) = NaN;
   dims = {'SA','wavelength','time'};
   vatts.long_name = ['sky radiance divded by TOA']; vatts.units = '1/sr';vatts.source = '4STAR';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['normalized_sky_radiance_fit']) = NaN;
   dims = {'SA','wavelength','time'};
   vatts.long_name = ['sky radiances divded by TOA from retrieval']; vatts.units = '1/sr';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
   
   var = []; var.(['sky_radiance_fit_error']) = NaN;
   dims = {'SA','wavelength','time'};
   vatts.long_name = ['sky radiances meas - fit']; vatts.units = '%';vatts.source = 'retrieval';
   anc_inv = anc_add_var(anc_inv,var,dims,vatts); clear vatts dims var
      


for wl_ii = 1:length(skyrad.wl_ii)
   w_ii= skyrad.wl_ii(wl_ii); wl = 1000.*(skyrad.w(w_ii));
   wl_str = sprintf('_%2.0dnm',round(wl));wl_st = sprintf(' %2.0d nm',round(wl));
   
%    var = []; var.(['PF_total',wl_str]) = NaN;
%    dims = {'PF_angle','time'};
%    vatts.long_name = ['Phase function, total PSD',wl_st]; vatts.units = 'unitless';vatts.source = 'retrieval';
%    anc_inv = anc_add_var(anc_inv,var,dims,vatts);
%    
%    var = []; var.(['PF_fine',wl_str]) = NaN;
%    dims = {'PF_angle','time'};
%    vatts.long_name = ['Phase function, fine mode',wl_st]; vatts.units = 'unitless';vatts.source = 'retrieval';
%    anc_inv = anc_add_var(anc_inv,var,dims,vatts);
%    
%    var = []; var.(['PF_coarse',wl_str]) = NaN;
%    dims = {'PF_angle','time'};
%    vatts.long_name = ['Phase function, coarse mode',wl_st]; vatts.units = 'unitless';vatts.source = 'retrieval';
%    anc_inv = anc_add_var(anc_inv,var,dims,vatts);
% 
%       
%    var = []; var.(['normalized_sky_radiance',wl_str]) = NaN;
%    dims = {'SA','time'};
%    vatts.long_name = ['sky radiance divded by TOA',wl_st]; vatts.units = '1/sr';vatts.source = '4STAR';
%    anc_inv = anc_add_var(anc_inv,var,dims,vatts);
%    
%    var = []; var.(['normalized_sky_radiance_fit',wl_str]) = NaN;
%    dims = {'SA','time'};
%    vatts.long_name = ['sky radiances divded by TOA from retrieval',wl_st]; vatts.units = '1/sr';vatts.source = 'retrieval';
%    anc_inv = anc_add_var(anc_inv,var,dims,vatts)
%    
%    var = []; var.(['sky_radiance_fit_error',wl_str]) = NaN;
%    dims = {'SA','time'};
%    vatts.long_name = ['sky radiances meas - fit',wl_st]; vatts.units = '%';vatts.source = 'retrieval';
%    anc_inv = anc_add_var(anc_inv,var,dims,vatts)
%       

   
%    var = []; var.(['flux_dn',wl_str]) = NaN;
%    dims = {'time'};
%    vatts.long_name = 'downwelling flux'; vatts.units = 'W/m2';
%    anc_inv = anc_add_var(anc_inv,var,dims, vatts);
%    
%    var = []; var.(['flux_up',wl_str]) = NaN;
%    dims = {'time'};
%    vatts.long_name = 'upwelling flux'; vatts.units = 'W/m2';
%    anc_inv = anc_add_var(anc_inv,var,dims, vatts);
%    
%    var = []; var.(['flux_diff',wl_str]) = NaN;
%    dims = {'time'};
%    vatts.long_name = 'diffuse flux'; vatts.units = 'W/m2';
%    anc_inv = anc_add_var(anc_inv,var,dims, vatts);
end

var = []; var.scan_tag = [];
dims = {'time'};
vatts.long_name = 'sky scan file tag'; vatts.units = 'unitless';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.scan_type = [];
dims = {'time'};
vatts.long_name = 'sky scan type'; vatts.units = 'unitless';
vatts.values = '1 = ALM; 3 = PPL';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var clear('vatts');

var = []; var.Lat = [];
dims = {'time'};
vatts.long_name = 'Latitude'; vatts.units = 'degrees N';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.Lon = [];
dims = {'time'};
vatts.long_name = 'Longitude'; vatts.units = 'degrees E';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.GPS_Altitude = [];
dims = {'time'};
vatts.long_name = 'Aircraft altitude'; vatts.units = 'm above mean sea level';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.Heading = [];
dims = {'time'};
vatts.long_name = 'Aircraft heading'; vatts.units = 'degrees N, CW';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.Pitch = [];
dims = {'time'};
vatts.long_name = 'Aircraft pitch'; vatts.units = 'degrees nose-up';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.Roll = [];
dims = {'time'};
vatts.long_name = 'Aircraft roll'; vatts.units = 'degrees right-down';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.GPS_Altitude_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of aircraft altitude'; vatts.units = 'm above mean sea level';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.Heading_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of heading'; vatts.units = 'degrees N, CW';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.Pitch_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of pitch'; vatts.units = 'degrees nose-up';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.Roll_std = [];
dims = {'time'};
vatts.long_name = 'standard deviation of roll'; vatts.units = 'degrees right-down';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.T_static = [];
dims = {'time'};
vatts.long_name = 'outside air temperature, static'; vatts.units = 'degrees C';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.P_static = [];
dims = {'time'};
vatts.long_name = 'ambient pressure'; vatts.units = 'mbar';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.RH = [];
dims = {'time'};
vatts.long_name = 'outside relative humidity'; vatts.units = '%';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.SAZ = [];
dims = {'time'};
vatts.long_name = 'solar azimuth angle'; vatts.units = 'deg CW';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.SZA = [];
dims = {'time'};
vatts.long_name = 'solar zenith angle'; vatts.units = 'deg from vertical';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.SEL = [];
dims = {'time'};
vatts.long_name = 'solar elevation angle'; vatts.units = 'deg from horizon';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.m_ray = [];
dims = {'time'};
vatts.long_name = 'airmass, Rayleigh'; vatts.units = 'unitless';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

var = []; var.PWV = [];
dims = {'time'};
vatts.long_name = 'precipitable water vapor'; vatts.units = 'cm';
anc_inv = anc_add_var(anc_inv, var, dims, vatts); clear vatts dims var

sky_str = {'good_sky'};
sky = sky_str{:};
var = [];

% make sure these are dimensioned correctly, should be col x 1
var.PF_angle = aeroinv.PF_angle(:,1);
anc_inv.vdata.PF_angle = var.PF_angle; var = [];
anc_inv.vdata.wavelength = 1000.*aeroinv.Wavelength;

% var.radius = aeroinv.radius;
anc_inv.vdata.radius =  aeroinv.radius;

if isfield(skyrad, sky)&&sum(skyrad.(sky))>5
   t = length(anc_inv.time)+1;
   anc_inv.time(t) = mean(skyrad.t(skyrad.(sky)));

   [~,fname_] = fileparts(fname); lv_ii = strfind(fname_,'_lv')+3;
   lev = sscanf(fname_(lv_ii:end),'%f')./10;
   anc_inv.vdata.QA_level(t) = lev;

   var.sca_angle = NaN([60,1]);
   SA = aeroinv.sky_radiances_angle; var.sca_angle(1:length(SA))=SA;
   anc_inv.vdata.sca_angle(:,t) = var.sca_angle; var = [];
   
   anc_inv.vdata.psd(:,t) = aeroinv.psd;
   anc_inv.vdata.sphericity(:,t) = aeroinv.Sphericity;
   anc_inv.vdata.sphericity_err(:,t) = aeroinv.Sphericity_err;
   
   anc_inv.vdata.(['n_real'])(:,t) =aeroinv.refractive_index_real_r;
   anc_inv.vdata.(['n_imag'])(:,t) =aeroinv.refractive_index_imaginary_r;
   anc_inv.vdata.(['SSA'])(:,t) = aeroinv.ssa_total;
   anc_inv.vdata.(['AOD_fit_total'])(:,t) = aeroinv.ext_total;
   anc_inv.vdata.(['AOD_fit_fine'])(:,t) = aeroinv.ext_fine;
   anc_inv.vdata.(['AOD_fit_coarse'])(:,t) = aeroinv.ext_coarse;
   anc_inv.vdata.(['AOD_meas'])(:,t) = aeroinv.aod;
   anc_inv.vdata.(['AAOD'])(:,t) = aeroinv.aaod;
   anc_inv.vdata.(['TOD_meas'])(:,t) = aeroinv.tod_meas;
   anc_inv.vdata.(['TOD_fit'])(:,t) = aeroinv.tod_fit;
   anc_inv.vdata.(['TOD_meas_minus_fit'])(:,t) = aeroinv.tod_meas_less_fit;
   anc_inv.vdata.(['AGOD'])(:,t) = skyrad.AGOD(skyrad.wl_ii);
   anc_inv.vdata.(['g_total'])(:,t) = aeroinv.g_tot;
   anc_inv.vdata.(['g_fine'])(:,t) = aeroinv.g_fine;
   anc_inv.vdata.(['g_coarse'])(:,t) = aeroinv.g_coarse;
   anc_inv.vdata.(['sfc_alb'])(:,t) = aeroinv.sfc_alb;
   anc_inv.vdata.(['PF_total'])(:,:,t) = aeroinv.PF_total;
   anc_inv.vdata.(['PF_fine'])(:,:,t) = aeroinv.PF_fine;
   anc_inv.vdata.(['PF_coarse'])(:,:,t) = aeroinv.PF_coarse;
   
   var.rads = NaN([60,size(aeroinv.Wavelength)]);
   rads = aeroinv.sky_radiances_measured; var.rads(1:length(rads),:)=rads;
   anc_inv.vdata.(['normalized_sky_radiance'])(:,:,t) = var.rads; var = [];
   var.rads = NaN([60,size(aeroinv.Wavelength)]);
   rads = aeroinv.sky_radiances_fit(:,wl_ii); var.rads(1:length(rads))=rads;
   anc_inv.vdata.(['normalized_sky_radiance_fit'])(:,:,t) = var.rads; var = [];
   var.rads = NaN([60,size(aeroinv.Wavelength)]);
   rads = aeroinv.sky_radiances_pct_diff(:,wl_ii); var.rads(1:length(rads))=rads;
   anc_inv.vdata.(['sky_radiance_fit_error'])(:,:,t) = var.rads; var = [];

   
   for wl_ii = 1:length(skyrad.wl_ii)
      w_ii= skyrad.wl_ii(wl_ii); wl = 1000.*(skyrad.w(w_ii));
      wl_str = sprintf('_%2.0dnm',round(wl));wl_st = sprintf(' %2.0d nm',round(wl));

%       anc_inv.vdata.(['PF_total',wl_str])(:,t) = aeroinv.PF_total(:,wl_ii);
%       anc_inv.vdata.(['PF_fine',wl_str])(:,t) = aeroinv.PF_fine(:,wl_ii);
%       anc_inv.vdata.(['PF_coarse',wl_str])(:,t) = aeroinv.PF_coarse(:,wl_ii);
% 
%       var.rads = NaN([60,1]);
%       rads = aeroinv.sky_radiances_measured(:,wl_ii); var.rads(1:length(rads))=rads;
%       anc_inv.vdata.(['normalized_sky_radiance',wl_str])(:,t) = var.rads; var = [];
%       var.rads = NaN([60,1]);
%       rads = aeroinv.sky_radiances_fit(:,wl_ii); var.rads(1:length(rads))=rads; 
%       anc_inv.vdata.(['normalized_sky_radiance_fit',wl_str])(:,t) = var.rads; var = [];
%       var.rads = NaN([60,1]);
%       rads = aeroinv.sky_radiances_pct_diff(:,wl_ii); var.rads(1:length(rads))=rads; 
%       anc_inv.vdata.(['sky_radiance_fit_error',wl_str])(:,t) = var.rads; var = [];

%       anc_inv.vdata.(['flux_dn',wl_str])(t) = aeroinv.flux_dn(wl_ii);
%       anc_inv.vdata.(['flux_up',wl_str])(t) = aeroinv.flux_up(wl_ii);
%       anc_inv.vdata.(['flux_diff',wl_str])(t) = aeroinv.flux_diffuse(wl_ii);
   end
   
   
   var.scan_tag = sscanf(skyrad.filen,'%d');
   anc_inv.vdata.scan_tag(t) = var.scan_tag; var = [];
   var.scan_type = double(skyrad.isALM) + 3.*double(skyrad.isPPL);
   anc_inv.vdata.scan_type(t) = var.scan_type; var = [];
   anc_inv.vdata.Lat(t) = mean(skyrad.Lat(skyrad.(sky)));
   anc_inv.vdata.Lon(t) = mean(skyrad.Lon(skyrad.(sky)));
   anc_inv.vdata.GPS_Altitude(t) = mean(skyrad.Alt(skyrad.(sky)));
   anc_inv.vdata.Heading(t) = mean(skyrad.Headng(skyrad.(sky)));
   anc_inv.vdata.Pitch(t) = mean(skyrad.pitch(skyrad.(sky)));
   anc_inv.vdata.Roll(t) = mean(skyrad.roll(skyrad.(sky)));
   anc_inv.vdata.GPS_Altitude_std(t) = std(skyrad.Alt(skyrad.(sky)));
   anc_inv.vdata.Heading_std(t) = std(skyrad.Headng(skyrad.(sky)));
   anc_inv.vdata.Pitch_std(t) = std(skyrad.pitch(skyrad.(sky)));
   anc_inv.vdata.Roll_std(t) = std(skyrad.roll(skyrad.(sky)));
   anc_inv.vdata.P_static(t) = mean(skyrad.Pst(skyrad.(sky)));
   anc_inv.vdata.T_static(t) = mean(skyrad.Tst(skyrad.(sky)));
   anc_inv.vdata.RH(t) = mean(skyrad.RH(skyrad.(sky)));
   anc_inv.vdata.SAZ(t) = mean(skyrad.sunaz(skyrad.(sky)));
   anc_inv.vdata.SZA(t) = mean(skyrad.sza(skyrad.(sky)));
   anc_inv.vdata.SEL(t) = mean(skyrad.sunel(skyrad.(sky)));
   anc_inv.vdata.AZ_sky(t) = mean(skyrad.Az_sky(skyrad.(sky)));
   anc_inv.vdata.EL_sky(t) = mean(skyrad.El_sky(skyrad.(sky)));
   anc_inv.vdata.m_ray(t) = mean(skyrad.m_ray(skyrad.(sky)));
   anc_inv.vdata.PWV(t) = skyrad.PWV;
end
if ~isempty(anc_inv.time)
   anc_inv = anc_timesync(anc_inv);
   fname = ['4STAR-aeroinv_P3_',datestr(anc_inv.time(1),'yyyymmdd.HHMMSS'),'_R0.nc'];
   anc_inv.fname = [getnamedpath('aeroinv_nc'),fname];
   anc_inv.clobber = true;anc_inv.verbose = false; anc_inv.quiet = true;
   anc_inv = anc_check(anc_inv); anc_inv = rmfield(anc_inv,'quiet');
   quiet = true; anc_save(anc_inv,[],quiet);
else
   warning('Netcdf file not generated, time field is empty.');
end
% anc_rad = anc_bundle_files(['4STAR-skyrad_P3_*_R0.nc'],'skyrad_nc');
% anc_save(anc_rad)

% 4STAR-skyrad_P3_yyyymmdd_R0.nc
% 4STAR-aeroinv-