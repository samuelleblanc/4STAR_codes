% interpolate 4STAR-A FWHM values to 4STARB
%------------------------------------------
% MS, 2018-09-28
%------------------------------------------

% load 4STARB wavelengths files
starb_vis_wln = load(which('visLambda_4starb_short.txt'));
starb_nir_wln = load(which('nirLambda_4starb_short.txt'));

% load corresponding 4STAR-A FWHM files
stara_vis_fwhm = load(which('visFWHM_short.slf'));
stara_nir_fwhm = load(which('nirFWHM_short.slf'));

% create 4STAR-B FWHM by interpolation
starb_vis_fwhm = interp1(stara_vis_fwhm(:,1),stara_vis_fwhm(:,2),starb_vis_wln,'linear','extrap');
starb_nir_fwhm = interp1(stara_nir_fwhm(:,1),stara_nir_fwhm(:,2),starb_nir_wln);

% save 4STARB FWHM to file
visfwhm = [starb_vis_wln, starb_vis_fwhm];
nirfwhm = [starb_nir_wln, starb_nir_fwhm];
save('visFWHM_4starb_short.slf','visfwhm','-ascii');
save('nirFWHM_4starb_short.slf','nirfwhm','-ascii');



