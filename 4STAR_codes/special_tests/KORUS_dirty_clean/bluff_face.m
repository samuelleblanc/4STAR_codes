function [SA, area_norm]  = bluff_face(za, az) 
% Computes the bluff facing angle of the 4STAR optic relative to Az=0
% in order to determine the projected normal area facing the wind
% could potentially scale this with a snell-law like reflectivity to
% account for lower sticking ability at glancing angle.


if any(za>(pi) |az>(2*pi))
   % Then these angles are in degrees
   za = double(za) *pi/180.0;
   az = double(az) *pi/180.0;   
end
if size(za,1) ==1
    za = za';
end
if size(az,1) ==1
    az = double(az)';
end

sun_xyz  = ones(size(az))*[0, 1, 0];
sky_xyz  = [sin(za) .* sin(az), sin(za) .* cos(az), cos(za)];
comps = sun_xyz .* sky_xyz;
dot = sum(comps,2);

SA = acos(dot);
area_norm = (cos(SA)>0).*dot.^2;
return