function F925 = get_irad_F925
%%
% reads data from F926 lamp manufacturer (given by calLab)
% wavelength, in [nm]
F925.nm  =[250:10:400 450 500 555 600 654.6 700 800 900 1050 1150 1200 ...
    1300 1540 1600 1700 2000 2100 2300 2400 2500];
% spectral irradiance, in [W/cm2 nm]
F925.irad = 1e-5.*[1.806e-3 3.203e-3 5.299e-3 8.343e-3 1.26e-2 1.832e-2 2.585e-2 ...
    3.544e-2 4.732e-2 6.197e-2 7.956e-2 1.001e-1 1.237e-1 1.505e-1 1.818e-1 2.164e-1 ...
    4.368e-1 7.236e-1 1.075 1.353 1.665 1.878 2.178 2.289 2.173 2.008 1.909 1.713 1.274 ...
    1.177 1.031 6.932e-1 6.076e-1 4.721e-1 4.149e-1 3.569e-1];

figure; plot(F925.nm, F925.irad,'-k.');xlabel('wavelength');ylabel('F925 lamp Irradiance [W/cm^{2} nm]');
%%
% [rad,lamp] = planck_tungsten_fit(F925.nm,F925.irad, [min(F925.nm):5:max(F925.nm)])

%%
return