function [zen, az, soldst, ha, dec, el, am] = sunae(lat, lon, time);
%[zen, az, soldst, ha, dec, el, am] = sunae(lat, lon, time);
% Requires lat (pos N) and lon (pos E).  If no time is supplied, now is assumed.
% Returns zenith angle, azimuth angle, solar distance in AU, hour
% angle, declination angle, elevation angle, and airmass
% All angles in degrees, airmass = NaN for el < 0
% Designed to replicate the calling syntax of previous sunae but use sun position instead. 
if nargin <2
    disp('sunae requires at least the lat and lon')
    return
end
if nargin<3
    time = now;
end
[rows,cols] = size(time);
swap = false;
if cols==1 && rows>cols
    time = time';
    swap = true;
end
[rows,cols] = size(lat);
if cols==1 && rows>cols
    lat = lat';
end
[rows,cols] = size(lon);
if cols==1 && rows>cols
    lon = lon';
end
if max(size(lat))==1
    lat = ones(size(time))*lat;
end
if max(size(lon))==1
    lon = ones(size(time))*lon;
end

locs.latitude = lat;
locs.longitude = lon;
locs.altitude = zeros(size(lat));
this_tv = serial2gm(time);
sunp = sun_position(this_tv,locs);

zen = sunp.zenith;
az = sunp.azimuth;
soldst = sunp.radius;
ha = sunp.ha;
dec = sunp.dec;
el = 90-zen;
am = airmass_mol(el);
if swap
    zen=zen';
    az= az';
    soldst = soldst';
    ha = ha';
    dec= dec';
    el= el';
    am = am';
end

return

    function am = airmass_mol(el)
        % am = airmass_mol(el)
        %  elevation given in degrees */
        zr = (pi./180) .* (90.0 - el);
        am =  1.0./(cos(zr) + 0.50572.*(6.07995 + el).^-1.6364);
        am(el<0) = -1;
%         m_ray=1./(cos(sza*pi/180)+0.50572*(96.07995-sza).^(-1.6364)); %Kasten and Young (1989)
        return
        