function ssfr = fix_ssfr_nc_time(ssfr)
% Fixes SSFR SEAC4RS netcdf files supplied by Sam Leblanc to correct time
% fields with duplicate entries and 2-second jumps by interpolating over
% funky points
if ~exist('ssfr','var')
    ssfr = ancload(getfullname('*.cdf','ssfr_cdf','Select SSFR netcdf file.'));
end

% ssfr_alb_fname = getfullname__;
% ssfr_alb = load(ssfr_alb_fname);
if exist(ssfr,'file')
    ssfr = anc_load(ssfr);
end
[pname, fname, ext] = fileparts(ssfr.fname);
secs = round(ssfr.vdata.TMHRS.*60.*60);

fix = false(size(secs));
i = [2:length(fix)-1];
fix(i) = secs(i)==secs(i+1);
% sum(fix)

secs(fix) = interp1(find(~fix), secs(~fix),find(fix),'linear','extrap');
% figure; plot([1:length(diff(secs))],diff(secs),'-o')

ssfr.vdata.TMHRS(fix) = secs(fix)./(60*60);
ssfr.time = datenum(fname(1:8),'yyyymmdd')+ssfr.vdata.TMHRS./24;
% save([pname, filesep,fname, '.mat'],'-struct','ssfr');

return;



