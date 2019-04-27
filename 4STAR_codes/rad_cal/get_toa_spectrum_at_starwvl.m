function sol_toa = get_toa_spectrum_at_starwvl(t,f,instrumentname);
%% Details of the program:
% NAME:
%   get_toa_spectrum_at_starwvl
%
% PURPOSE:
%  Build the reference spectrum covolved to nSTAR's wavelength dependence
%  Using Gueymard's solar output, with sun-earth distance applied and the
%  a fwhm gaussian from 4STAR.
%
% CALLING SEQUENCE:
%   sol_toa = get_toa_spectrum_at_starwvl(s)
%
% INPUT:
%  t: time
%  f: sun-earth distance factor
%  instrumentname: the name of the instrument.
%
% OUTPUT:
%  sol_toa: Solar output, convolved to 4STAR's wavelength dependence,
%  W/m^2/nm
%
% DEPENDENCIES:
%  - version_set.m
%  - gueymard_ESR.m
%  - starwavelengths.m
%  - conv
%
% NEEDED FILES:
%  - starwavelengths.m required files (4STAR FWHM) 
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, CA, April 23rd, 2019
% -------------------------------------------------------------------------

%% codes
version_set('v1.0')

guey_ESR = gueymard_ESR;
sol_toa_full = guey_ESR(:,3).*f;
[visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(t,instrumentname);
w = [visw,nirw];
g_w = guey_ESR(:,1)./1000.0;

sol_toa = interp1(g_w,sol_toa_full,w);

fwhm = [visfwhm,nirfwhm./1000.0];
fwhm_e=interp1(w(~isnan(fwhm)),fwhm(~isnan(fwhm)),w,'pchip','extrap');

for i=1:length(w);
    gauss = normpdf(g_w,w(i),fwhm_e(i)/2.35);
    gauss = gauss./sum(gauss);
    sol_toa(i) = gauss'*sol_toa_full;    
end;

return