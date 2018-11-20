function [lv, tests] = anet_postproc_dl(anetaip, star)
% [lv, tests] = anet_postproc_dl(anetaip)

% Apply post-processing criteria from Holben PDF to sky scans output file.
% returns a data level of 1, 1.5, and 2.0
% Due to requirement for duplicated measurements only ALM can ever be
% assigned level 2.  
% Modified test on sky error to include relaxed criterion for WL > 900nm
lv = 1.5;
railed = all(anetaip.refractive_index_real_r>= 1.59)||all(anetaip.refractive_index_real_r <= 1.34)||...
   all(anetaip.refractive_index_imaginary_r>= 0.49)||all(anetaip.refractive_index_real_r <= 0.00051);

% Check tau_aero(440) > 0.4
% tau_aero = star.tau_aero(star.Str==1 & star.Zn == 0,star.aeronetcols);
tau_aero = anetaip.ext_total;
[~,tau_ii] = sort(abs(anetaip.Wavelength -.44));
tau_ang = ang_exp(tau_aero(tau_ii(1)), tau_aero(tau_ii(2)),...
    anetaip.Wavelength(tau_ii(1)), anetaip.Wavelength(tau_ii(2)));
tests.ang_exp = tau_ang; 
tests.tau_440 = ang_coef(tau_aero(tau_ii(1)), tau_ang, anetaip.Wavelength(tau_ii(1)),0.44);

% I'm only going to enforce the sky residual error requirement on
% wavelengths < 900 nm.
X = tests.tau_440;
Y = -1.09.*X.^2 + 4.07.*X + 4.33;
tests.sky_error_limit = Y;
tests.sky_error_pass = all(anetaip.sky_error(anetaip.Wavelength<.9) < Y)&&all(anetaip.sky_error(anetaip.Wavelength>.9) < 1.5.*Y);
tests.sky_error_fail = any(anetaip.sky_error(anetaip.Wavelength<.9) > 2.*Y);
if tests.sky_error_pass == true;
    lv = 2;
end

% if railed
%    error('Retrieval went to rail!')
% end
% if ~tests.sky_error_pass
%   error('Retrieval had high sky errors!')
% end

return