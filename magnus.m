%% PURPOSE:
%   Converts relative humidity to number density
%
% CALLING SEQUENCE:
%   h2o=magnus(RH,T)
%
% INPUT:
%  - RH: Relative humidity
%  - T: temperature in Celsius
% 
% OUTPUT:
%  - number density of water vapor (#/cm^3)
%
% DEPENDENCIES:
%  none
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, Fairbanks, Alaska, Sep-22, 2014, adapted from idl
%
% -------------------------------------------------------------------------

%% Start of function
function h2o=magnus(relh,tk);

%uses Magnus Teton approximation to convert water vapor RH% to #/cm3
t=tk-273.15;
% Magnus-Teton approximation for saturation vapor pressure (in hPa)

mt    = 10.0.^((7.5.*t)./(t+237.3)+0.7858); %temperature (t)in Celsius  --> saturation vapor pressure
ph2o  = relh./100.*mt;         % actual water vapor pressure
%get number density of water (#/cm3)
rstar = 8.314;                 % J/mol/K
Na    = 6.02297.*10^23.;       % molecules/mol
h2o=(ph2o.*100.)./(rstar.*tk); % mol/m3
h2o=h2o.*Na./1.0e6;            % #/cm3

return; %,h2o
%end          