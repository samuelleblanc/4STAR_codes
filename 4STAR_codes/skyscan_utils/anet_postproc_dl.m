function [lv, tests] = anet_postproc_dl(anetaip)
% [lv, tetss]  = anet_postproc_dl(anetaip)
% The resulting data level and tests are returned as structs lv and tests
% lv includes results for fields psd, ssa, pct_sphericity, 
% Apply post-processing criteria from Holben PDF to sky scans output file.
% returns a data level of 1, 1.5, and 2.0
% Due to requirement for duplicated measurements only ALM can ever be
% assigned level 2.  
% Modified test on sky error to include relaxed criterion for WL > 900nm
% In order to produce different levels for different products, we need to
% know whether the symmetry test passed or not.  All products require the
% symmetry test to pass to be level 2, but the SSA, n, and k additionally
% require tau_440 >= .4;  Right now anetaip doesn't include enough info for
% us to determine this.
% So, we can check whether the retrieval railed, and the sky errors were
% small enough to determine whether to demote to lev 1 (failing those
% conditions) but knowing about the symmetry test we can't assign lv 2 to
% any of the products unless tau_440 > .4.  

% This is a bit tricky because we only have the output of anetaip available
% and not the radiances themselves so we can't assess the test of symmetry. 
% Thus we rely on whether or not the preproc data level was 1.5 (no symmetry test)
% or 2.0 (passed symmetry test) 
% Have to consider a "failed" symmetry tests as distinct from N/A PPL case

% Find the level tag in the output filename (which derives from the input
% file)
lv_i = findstr(anetaip.output_fname,'.output'); 
lv_in = sscanf(anetaip.output_fname(lv_i+[-2 -1]),'%f')./10;
lv.lv_in = lv_in;
lv.ssa = lv_in;
if isfield(anetaip,'sky_test') && anetaip.sky_test>=2
    lv.psd = 2; lv.pct_sphericity = 2;
else
    lv.psd = lv_in;
    lv.pct_sphericity = lv_in;
end
railed = all(anetaip.refractive_index_real_r>= 1.59)||all(anetaip.refractive_index_real_r <= 1.34)||...
   all(anetaip.refractive_index_imaginary_r>= 0.49)||all(anetaip.refractive_index_imaginary_r <= 0.00051);
if railed
    lv.ssa = 1.0;
end
tests.railed = railed;
% Check tau_aero(440) > 0.4
% tau_aero = star.tau_aero(star.Str==1 & star.Zn == 0,star.aeronetcols);
tau_aero = anetaip.ext_total;
% Compute angstrom from the pair of measurements closest to 440 nm
% Then evaluate tau at 440 exactly, just in case it wasn't a measured point
[~,tau_ii] = sort(abs(anetaip.Wavelength -.44)); 
tau_ang = ang_exp(tau_aero(tau_ii(1)), tau_aero(tau_ii(2)),...
    anetaip.Wavelength(tau_ii(1)), anetaip.Wavelength(tau_ii(2)));
tests.ang_exp = tau_ang; 
tests.tau_440 = ang_coef(tau_aero(tau_ii(1)), tau_ang, anetaip.Wavelength(tau_ii(1)),0.44);

% I'm only going to enforce the sky residual error requirement on
% wavelengths < 900 nm.

X = tests.tau_440;
Y = 0;
if tests.tau_440>0 && tests.tau_440<.2
    Y = 5;
elseif tests.tau_440>=0.2 && tests.tau_440<1.5
    Y = -1.09.*X.^2 + 4.07.*X + 4.33;
elseif tests.tau_440>=1.5
    Y = 8;
end
tests.sky_error_limit = Y;
tests.sky_error_pass = all(anetaip.sky_error(anetaip.Wavelength<.9) < Y)&&all(anetaip.sky_error(anetaip.Wavelength>.9) < 1.5.*Y);
tests.sky_error_fail = any(anetaip.sky_error(anetaip.Wavelength<.9) > 3.*Y);
if tests.sky_error_pass == true;
    lv.ssa = min([2,lv.ssa]); lv.psd = min([2,lv.psd]); 
else % Demote to lv 1.5 at most
    lv.ssa = min([1.5,lv.ssa]); lv.psd = min([1.5,lv.psd]);
end    
% If any sky_error was really large, >3Y, then demote to lv 1
if tests.sky_error_fail == true;
    lv.ssa = min([1,lv.ssa]); lv.psd = min([1,lv.psd]);
end

tests.sphericity_tau_gt_pt4 = tests.tau_440>=0.4;
tests.sphericity_ang_gt_1p2 = tests.ang_exp>1.2;
if tests.sphericity_tau_gt_pt4 && tests.sphericity_ang_gt_1p2
    lv.pct_sphericity = min([2,lv.pct_sphericity]);
else
    lv.pct_sphericity = min([1.5,lv.pct_sphericity]);
end
% if railed
%    error('Retrieval went to rail!')
% end
% if ~tests.sky_error_pass
%   error('Retrieval had high sky errors!')
% end
% anetaip.lv_out = lv; anetaip.tests = tests;

return