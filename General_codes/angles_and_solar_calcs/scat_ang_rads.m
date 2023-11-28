function SA = scat_ang_rads(sza, saz, za, az) 
% SA = scat_ang_rads(sza, saz, za, az)
% Returns scattering angle between sun and sky.
% Requires solar zenith and azimuth (SZA, SAZ), sky zen and az (ZA,AZ)
% All angles in radians
% If angles in degrees, convert to radians or call scat_ang_degs


% if any(sza>(pi) | saz>(2*pi) |za>(pi) |az>(2*pi))
%    % Then these angles are in degrees
%    sza = sza *pi/180;
%    saz = saz *pi/180;
%    za = za *pi/180;
%    az = az *pi/180;   
% end
if size(za,1)==1
sun_xyz  = [sin(sza) .* sin(saz); sin(sza) .* cos(saz); cos(sza)];
sky_xyz  = [sin(za) .* sin(az); sin(za) .* cos(az); cos(za)];
comps = sun_xyz .* sky_xyz;
dot = sum(comps,1);
else
sun_xyz  = [sin(sza) .* sin(saz), sin(sza) .* cos(saz), cos(sza)];
sky_xyz  = [sin(za) .* sin(az), sin(za) .* cos(az), cos(za)];
comps = sun_xyz .* sky_xyz;
dot = sum(comps,2);

end
SA = acos(dot);