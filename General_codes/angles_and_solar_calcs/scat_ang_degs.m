function SA = scat_ang_degs(sza, saz, za, az) 
% SA = scat_ang_degs(sza, saz, za, az)
% Returns scattering angle between sun and 4STAR.
% Requires solar zenith and azimuth (SZA, SAZ), 4STAR zen and az (ZA,AZ)
% All angles are in degrees.  
% If angles in radians, convert to degrees or call scat_ang_rads

sza = sza .* pi ./180;
saz = saz .* pi ./180;
za = za .* pi ./180;
az = az .* pi ./180;
if size(sza,1) == 1
   sza = sza';
end
if size(saz,1) == 1
   saz = saz';
end
if size(za,1) == 1
   za = za';
end
if size(az,1) == 1
   az = az';
end

% sun_xyz  = [sin(sza) .* cos(saz), sin(sza) .* sin(saz), cos(sza)];
% sky_xyz  = [sin(za) .* cos(az), sin(za) .* sin(az), cos(za)];
% 
% comps = sun_xyz .* sky_xyz;
% dot = sum(comps,2);
% SA = 180 .* acos(dot)./pi;
SA = 180.*scat_ang_rads(sza,saz,za,az)./pi;