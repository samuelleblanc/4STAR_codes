% combine FWHM from multiple line lamps
% for 4STARB onlye
instrumentname = '4STARB';

% load from 20220507 line lamps at MLO (copied data from figure _FWHM.fig
FWHM_0507 = [2.1984    2.3354    2.4978    2.9574    6.2355    2.3810    2.0475    2.0733    2.3004    3.1588    6.6477    3.4447    3.0676    2.4418    2.2829    2.9631    3.6744 4.5048 5.249];
FWHM_0507_wv = [ 0.3650    0.4047    0.4358    0.5461    1.0140    0.6965    0.7635    0.7724    0.7948    0.8265    0.9123    0.5570    0.5871    0.7695    0.7855    0.8190    0.8509 0.8777 1.524].*1.0e+03;

% load from 20220414 line lamps at Cal lab (copied from figure)
FWHM_0413 = [2.1748    2.2832    2.8822    6.0148    2.1820    2.0361    1.9944    2.3554    5.5200    7.8111    3.3245    2.9129    2.2007    2.6618    2.7816    3.4887    4.2028 8.5791    7.6757    5.4903];
FWHM_0413_wv = [0.3650    0.4047    0.5461    1.0140    0.6965    0.7384    0.7635    0.7948    0.9123    0.9658    0.5570    0.5871    0.7855    0.8060    0.8190    0.8509    0.8777 0.9752    0.9752    1.3634] .*1.0e+03;

[visw, nirw] = starwavelengths(datenum(2022,5,7,1,0,0),instrumentname);
vis_nm = visw.*1000.0;
nir_nm = nirw.*1000.0;

%loop through and get averages or unique points
FWHMs = [FWHM_0507,FWHM_0413];
FWHMs_wv = [FWHM_0507_wv,FWHM_0413_wv]; 

[FWHM_wv,ia,idx] = unique(FWHMs_wv,'stable');
FWHM  = accumarray(idx,FWHMs,[],@mean); 


fwhm_nir = interp1(FWHM_wv,FWHM,nir_nm,'makima');
fwhm_vis = interp1(FWHM_wv,FWHM,vis_nm,'makima');

fig = figure; 
plot(FWHM_wv,FWHM,'s');
hold on;
plot(vis_nm,fwhm_vis,'--b');
plot(nir_nm,fwhm_nir,'--r');
xlabel('Wavelength [nm]')
ylabel('FWHM [nm]')
title([instrumentname ' - 20220507 - FWHM combination'])
legend('Points from average [20220507 and 20220412]','VIS makima fit','NIR makima fit');
grid on;
save_fig(fig,[getnamedpath('starfig') instrumentname '_combined_FWHM_20220507_20220412_fit']);

fp = getnamedpath('stardat');
fname = [fp instrumentname '_FWHM_combinedlinelamps_20220507.mat'];
disp(['Saving FWHM fit to: ' fname])
save(fname,'fwhm_vis','fwhm_nir','vis_nm','nir_nm');