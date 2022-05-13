% combine FWHM from multiple line lamps
% for 4STAR


% load from 20220507 line lamps at MLO (copied data from figure _FWHM.fig
FWHM_0507 = [2.1859    2.1333    2.1332    2.5536    6.0952    5.1308    2.3884    2.8933    4.3691    3.5051    2.3238    2.5783    2.3900    2.9224    3.9791    4.1186    5.3549 5.9493    5.2386];
FWHM_0507_wv = [0.3650    0.4047    0.4047    0.5461    1.0140    1.3570    0.7635    0.7724    0.5570    0.5871    0.7601    0.7695    0.7855    0.8190    0.8509    0.8777    1.3634 1.4427    1.5239].*1.0e+03;

% load from 20220414 line lamps at Cal lab (copied from figure)
FWHM_0414 = [4.2216    2.1314    2.1244    2.3210    6.2804    2.1175    2.0856    2.0221    2.1143    2.4023    2.7423    2.7919    2.8587    5.2165    5.7346    3.1779    2.7251 2.4784    2.2710    2.8310    3.5286    4.0324    9.0284    9.9827    5.3676    5.8676    5.2590];
FWHM_0414_wv = [0.3022    0.3650    0.4047    0.4358    1.0140    0.6965    0.7384    0.7635    0.7724    0.7948    0.8015    0.8115    0.8265    0.9123    1.0471    0.5570    0.5871  0.7695    0.7855    0.8190    0.8509    0.8777    0.9752    0.9752    1.3634    1.4427    1.5239] .*1.0e+03;

[visw, nirw] = starwavelengths(datenum(2022,5,7,1,0,0),'4STAR');
vis_nm = visw.*1000.0;
nir_nm = nirw.*1000.0;

%loop through and get averages or unique points
FWHMs = [FWHM_0507,FWHM_0414];
FWHMs_wv = [FWHM_0507_wv,FWHM_0414_wv]; 

[FWHM_wv,ia,idx] = unique(FWHMs_wv,'stable');
FWHM  = accumarray(idx,FWHMs,[],@mean); 


fwhm_nir = interp1(FWHM_wv,FWHM,nir_nm,'makima');
fwhm_vis = interp1(FWHM_wv,FWHM,vis_nm,'makima');

figure; 
plot(FWHM_wv,FWHM,'s');
hold on;
plot(vis_nm,fwhm_vis,'--b');
plot(nir_nm,fwhm_nir,'--r');
xlabel('Wavelength [nm]')
ylabel('FWHM [nm]')
title('4STAR - 20220507 - FWHM combination')
legend('Points from average [20220507 and 20220414]','VIS makima fit','NIR makima fit');

fp = getnamedpath('stardat');
fname = [fp '4STAR_FWHM_combinedlinelamps_20220507.mat'];
disp(['Saving FWHM fit to: ' fname])
save(fname,'fwhm_vis','fwhm_nir','vis_nm','nir_nm');