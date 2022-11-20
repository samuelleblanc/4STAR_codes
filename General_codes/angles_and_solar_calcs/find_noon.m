function noon = find_noon(lat, lon, time,dt)
%returns the time of noon at lat, lon on the day of time(1) to within dt
% lat and lon are positive degrees N and E, respectively.
% time is a Matlab datenum.
% dt is optional but if provided is in units of day
% if not provided dt is min(diff(time))
% 2022-11-05, Connor Flynn
if ~isavar('dt')
   dt = 1./(24*60*60);
end
if ~isavar('time')
   time = now;
end
if length(time)==1
   time = linspace(floor(time), floor(time+1),61);
end

[zen, ~, ~, ~, ~, ~] = sunae(lat, lon, time);
[~,ij] = min(zen); ii = max([1,ij-1]); jj = min([ij+1, length(zen)]);
delta = time(jj)-time(ii);
if dt < delta
   noon = find_noon(lat,lon,double(linspace(time(ii), time(jj),60)),dt );
else
   noon = mean(time([ii jj]));
end
return