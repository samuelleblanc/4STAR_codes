function [m_ray, m_aero, m_H2O, m_O3, m_NO2]=airmasses(sza, alt, h)
% [m_ray, m_aero, m_H2O, m_O3, m_NO2]=airmasses(sza, alt, h)
% sza: apparent solar zenith angle in deg
% alt: altitude MSL in meters
% h: altitude (of ozone layer?) in km.
% calculate airmasses, after Kasten and Young (1989), Komhyr (1989) and
% Kasten (1965).
% sza is solar zenith angle.
% alt is altitude in meter. 3397 for MLO, 20 for Ames, according to
% plot_re4_COAST_Oct2011.m. 
% h is altitude of ozone layer in km. plot_re4_COAST_Oct2011.m uses 21.
% Yohei, 2012/05/18, after John Livingston's plot_re4_COAST_Oct2011.m.
% Connor, 2020/07/01, added m_ray_Pickering and m_O3_Rawlins just for
% testing. Both compare well to existing airmasses. 
% control input
if numel(alt)==1;
    alt=repmat(alt, size(sza));
elseif ~isequal(size(alt), size(sza));
    error('alt must be in the same size as sza, or a scalar.');
end;
if nargin<3;
    h=repmat(NaN,size(sza));
elseif numel(h)==1;
    h=repmat(h, size(sza));
elseif ~isequal(size(h), size(sza));
    error('h must be in the same size as sza, or a scalar.');
end;

% calculate airmasses
m_ray=1./(cos(sza*pi/180)+0.50572*(96.07995-sza).^(-1.6364)); %Kasten and Young (1989)
hh = 90-sza;
m_ray_Pickering = 1./sind(hh + 244./(165 +47.*hh.^1.1)); % Pickering 1% higher than Kasten & Young at SZA=88;
m_H2O=1./(cos(sza*pi/180)+0.0548*(92.65-sza).^(-1.452));   %Kasten (1965)
% This is slightly higher than m_ray since the water vapor is near the
% surface after refraction has lengthened the path.
m_aero=m_H2O;
if nargout>=4
    R=6371.229;
    r=alt/1000; % input from 4STAR is expected to be in meter
    m_O3=(R+h)./((R+h).^2-(R+r).^2.*(sin(sza*pi/180)).^2).^0.5;   %Komhyr (1989)
    m_O3_Rawlins = (1-(sind(sza)./(1+(20/6378))).^2).^-0.5; % Schaefer, via Rawlins 1992, 1% higher than Komhyr at SZA=88
    % This is slightly lower than m_ray since the absorption is at high
    % altitude before much refraction has occurred, lengthening the path
    m_NO2=m_O3;
end;
