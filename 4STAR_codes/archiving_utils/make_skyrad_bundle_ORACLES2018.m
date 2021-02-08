netcdf.setDefaultFormat('NC_FORMAT_CLASSIC'); define_skyrad_nc_ORACLES2018;

skyrad_files = getfullname(['4STAR-skyrad_P3_*_R0.nc'],'skyrad_nc');
while ~isempty(skyrad_files)
first_day = skyrad_files{1}; [~,first_day] = fileparts(first_day); first_day = first_day(1:25);
same_day =  foundstr(skyrad_files,first_day);
anc_rad = anc_bundle_files(skyrad_files(same_day));

% anc_rad = anc_bundle_files(getfullname(['4STAR-skyrad_P3_*_R0.nc'],'skyrad_nc'));
% fname = ['4STAR-skyrad_P3_',datestr(anc_rad.time(1),'yyyy'),'_R0.nc'];

fname = ['4STAR-skyrad_P3_',datestr(anc_rad.time(1),'yyyymmdd'),'_R0.nc'];
anc_rad.fname = [getnamedpath('skyrad_nc'),fname];
anc_rad.clobber = true;anc_rad.verbose = false; anc_rad.quiet = true;
anc_rad = anc_check(anc_rad); anc_rad = rmfield(anc_rad,'quiet');
anc_save(anc_rad);
skyrad_files(same_day) = [];
end

netcdf.setDefaultFormat('NC_FORMAT_CLASSIC'); define_aeroinv_nc_ORACLES2018;

aeroinv_files = getfullname(['4STAR-aeroinv_P3_*_R0.nc'],'aeroinv_nc');
while ~isempty(aeroinv_files)
first_day = aeroinv_files{1}; [~,first_day] = fileparts(first_day); first_day = first_day(1:25);
same_day =  foundstr(aeroinv_files,first_day);
anc_inv = anc_bundle_files(aeroinv_files(same_day));

% anc_inv = anc_bundle_files(getfullname(['4STAR-aeroinv_P3_*_R0.nc'],'aeroinv_nc'));
% fname = ['4STAR-aeroinv_P3_',datestr(anc_inv.time(1),'yyyy'),'_R0.nc'];
fname = ['4STAR-aeroinv_P3_',datestr(anc_inv.time(1),'yyyymmdd'),'_R0.nc'];
anc_inv.fname = [getnamedpath('aeroinv_nc'),fname];
anc_inv.clobber = true;anc_inv.verbose = false; anc_inv.quiet = true;
anc_inv = anc_check(anc_inv); anc_inv = rmfield(anc_inv,'quiet');
anc_save(anc_inv);
aeroinv_files(same_day) = [];
end
anc_inn = anc_load(anc_inv.fname);
figure; plot(anc_inn.vdata.PF_angle, squeeze(anc_inn.vdata.PF_total(:,:,1)),'-')
% Produces a plot showing the phase function for all angles (the first :),
% and for all wavelengths (the second :), but only for the first time (the
