%% converts string date to day of year
function doy = datestr2doy(date,format)
% date is date string, format is date format
% i.e. 20140904 format is 'yyyymmdd'
  v = datevec(date,format);
  v0 = v;
  v0(:,2:3) = 1;
  doy = datenum(v) - datenum(v0) + 1;

return;