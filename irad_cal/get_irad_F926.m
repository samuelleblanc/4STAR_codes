function F926 = get_irad_F926
%%
% reads data from F926 lamp manufacturer (given by calLab)
% wavelength, in [nm]
F926.nm  =[250:10:400 450 500 555 600 654.6 700 800 900 1050 1150 1200 ...
    1300 1540 1600 1700 2000 2100 2300 2400 2500];
% spectral irradiance, in [W/cm2 nm]
F926.irad = 1e-5.*[1.797e-3 3.188e-3 5.277e-3 8.310e-3 1.255e-2 1.828e-2 2.582e-2 ...
    3.539e-2 4.725e-2 6.191e-2 7.949e-2 1.000e-1 1.237e-1 1.503e-1 1.815e-1 2.162e-1 ...
    4.364e-1 7.231e-1 1.071 1.350 1.658 1.872 2.171 2.280 2.164 1.998 1.902 1.707 1.268 ...
    1.171 1.026 6.898e-1 6.053e-1 4.696e-1 4.128e-1 3.551e-1];

figure; plot(F926.nm, F926.irad,'-k.');xlabel('wavelength');ylabel('F926 lamp Irradiance [W/cm^{2} nm]');
%%
% [rad,lamp] = planck_tungsten_fit(F925.nm,F925.irad, [min(F925.nm):5:max(F925.nm)])

%%
return