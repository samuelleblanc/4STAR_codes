function [m_ray, m_aero, m_H2O, m_O3, m_NO2]=airmasses(sza, alt, h)

% calculate airmasses, after Kasten and Young (1989), Komhyr (1989) and
% Kasten (1965).
% sza is solar zenith angle.
% alt is altitude in meter. 3397 for MLO, 20 for Ames, according to
% plot_re4_COAST_Oct2011.m. 
% h is altitude of ozone layer in km. plot_re4_COAST_Oct2011.m uses 21.
% Yohei, 2012/05/18, after John Livingston's plot_re4_COAST_Oct2011.m.
% MS edit test

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
m_H2O=1./(cos(sza*pi/180)+0.0548*(92.65-sza).^(-1.452));   %Kasten (1965)
m_aero=m_H2O;
if nargout>=4
    R=6371.229;
    r=alt/1000; % input from 4STAR is expected to be in meter
    m_O3=(R+h)./((R+h).^2-(R+r).^2.*(sin(sza*pi/180)).^2).^0.5;   %Komhyr (1989)
    m_NO2=m_O3;
end;
