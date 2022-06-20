function dist = geodisth(lat1,lon1,lat2, lon2)
% dist = geodisth(lat1,lon1,lat2, lon2);
% Returns distance in km between any two geographic lat/lon pairs.
% Have to require that either all of these have the same dims, or one pair
% is a constant.
% 
% Haversine formula
% The haversine formula allows the haversine of θ (that is, hav(θ)) to be 
% computed directly from the latitude (represented by φ) and longitude 
% (represented by λ) of the two points:

% WGS-84  a = 6 378 137 m (±2 m) b = 6 356 752.3142 m  	
if (max(size(lat1))~=max(size(lon1)))||(max(size(lat2))~=max(size(lon2)))
    disp('Pairs of lat and lon must match dimensions')
    return
end
if ((max(size(lat1))>1)&&(max(size(lat2))==1))
    lat2 = lat2*ones(size(lat1));
    lon2 = lon2*ones(size(lon1));
elseif ((max(size(lat1))==1)&&(max(size(lat2))>1))
    lat1 = lat1*ones(size(lat2));
    lon1 = lon1*ones(size(lon2));
end    
% if max(abs([lat1, lon1, lat2, lon2]))>(pi)
%     %Then these are probably in degrees so convert to radians
%     lat1 = lat1 *pi/180;
%     lon1 = lon1 *pi/180;
%     lat2 = lat2 *pi/180;
%     lon2 = lon2 *pi/180;
% end

HA = zeros(size(lat1));
HA(:) = sqrt(sind((lat2(:)-lat1(:))./2).^2 + sind((lon2(:)-lon1(:))./2).^2.*cosd(lat1(:)).*cosd(lat2(:)));
HA = asin(HA);
% a = 6378.137; % meters,  semi-major axis
% b = 6356.752; % meters, minor axis
% r = (a+b)./2;
r = 6367.444;
dist = 2.*r.*HA;
return    
  