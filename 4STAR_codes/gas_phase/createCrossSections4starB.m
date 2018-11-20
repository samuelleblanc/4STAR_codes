% this routine plots convolved cross sections
% for 4STARB,interpolates them on the entire wavelength grid
% and creates cross sections mat file to use in taugases
%------------------------------------------------------------
% MS, 2018-09-28

%read convolved cross section files:

%Vis
no2_vis_220 = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\no2_220K_conv_4starb.xs');
figure;
plot(no2_vis_220.data(:,1),no2_vis_220.data(:,2),'-b');
title('NO_{2}-VIS-220K');

no2_vis_254 = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\no2_254K_conv_4starb.xs');
figure;
plot(no2_vis_254.data(:,1),no2_vis_254.data(:,2),'-b');
title('NO_{2}-VIS-254K');

no2_vis_298 = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\no2_298K_conv_4starb.xs');
figure;
plot(no2_vis_298.data(:,1),no2_vis_298.data(:,2),'-b');
title('NO_{2}-VIS-298K');

% plot both no2 on same figure
figure;
plot(no2_vis_220.data(:,1),no2_vis_220.data(:,2),'-b');hold on;
plot(no2_vis_254.data(:,1),no2_vis_254.data(:,2),'--g');hold on;
plot(no2_vis_298.data(:,1),no2_vis_298.data(:,2),':r');hold off;
legend('NO_{2}-220K','NO_{2}-254K','NO_{2}-298K');

o3_vis = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\o3_223K_conv_4starb.xs');
figure;
plot(o3_vis.data(:,1),o3_vis.data(:,2),'-b');
title('O_{3}-VIS-223K');

o2_vis = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\o2_1013mbar_conv_4starb.xs');
figure;
plot(o2_vis.data(:,1),o2_vis.data(:,2),'-b');
title('O_{2}-VIS-1013mbar');

o4_vis = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\o4_296K_conv_4starb_vis.xs');
figure;
plot(o4_vis.data(:,1),o4_vis.data(:,2),'-b');
title('O_{2}-VIS-296K');

hcho_vis = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\hcho_293K_conv_4starb.xs');
figure;
plot(hcho_vis.data(:,1),hcho_vis.data(:,2),'-b');
title('HCHO-VIS-293K');

% H2O
h2o_vis_1013mbar_294K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_1013mbar_294K_conv_4starb.xs');
h2o_vis_0902mbar_289K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_902mbar_289K_conv_4starb.xs');
h2o_vis_0802mbar_285K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_802mbar_285K_conv_4starb.xs');
h2o_vis_0710mbar_279K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_710mbar_279K_conv_4starb.xs');
h2o_vis_0628mbar_273K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_628mbar_273K_conv_4starb.xs');
h2o_vis_0554mbar_267K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_554mbar_267K_conv_4starb.xs');
h2o_vis_0487mbar_261K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_487mbar_261K_conv_4starb.xs');
h2o_vis_0426mbar_254K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_426mbar_254K_conv_4starb.xs');
h2o_vis_0372mbar_248K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_372mbar_248K_conv_4starb.xs');
h2o_vis_0324mbar_241K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_324mbar_241K_conv_4starb.xs');
h2o_vis_0281mbar_235K = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\h20_281mbar_235K_conv_4starb.xs');

figure;
plot(h2o_vis_1013mbar_294K.data(:,1),h2o_vis_1013mbar_294K.data(:,2),'-b');hold on;
plot(h2o_vis_0902mbar_289K.data(:,1),h2o_vis_0902mbar_289K.data(:,2),'--g');hold on;
plot(h2o_vis_0802mbar_285K.data(:,1),h2o_vis_0802mbar_285K.data(:,2),'--y');hold on;
plot(h2o_vis_0710mbar_279K.data(:,1),h2o_vis_0710mbar_279K.data(:,2),':c');hold on;
plot(h2o_vis_0628mbar_273K.data(:,1),h2o_vis_0628mbar_273K.data(:,2),':m');hold on;
plot(h2o_vis_0628mbar_273K.data(:,1),h2o_vis_0554mbar_267K.data(:,2),'.k');hold on;
legend('1013mbar-294K','902mbar-289K','802mbar-285K','710mbar-279K','628mbar-273K','554mbar-267K');
title('H_{2}O');

%Nir
ch4_nir = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\ch4_1013mbar_conv_4starb_nir.xs');
figure;
plot(ch4_nir.data(:,1),ch4_nir.data(:,2),'-b');
title('CH_{4}-NIR');

co2_nir = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\co2_1013mbar_conv_4starb_nir.xs');
figure;
plot(co2_nir.data(:,1),co2_nir.data(:,2),'-b');
title('CO_{2}-NIR');

o4_nir = importdata('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\o4_296K_conv_4starb_nir.xs');
figure;
plot(o4_nir.data(:,1),o4_nir.data(:,2),'-b');
title('O_{4}-NIR');


%interpolate

%load 4strab wavelength
Loschmidt=2.686763e19;             % molec/cm3*atm
cs.wln_4starb = load('C:\Users\msegalro\matlab\4STAR_codes\data_folder\cross_section_data\all_wln_4starb.txt');
% interp vis
cs.no2_vis_220K_interp = interp1(no2_vis_220.data(:,1),no2_vis_220.data(:,2),cs.wln_4starb,'nearest','extrap')*Loschmidt;
cs.no2_vis_254K_interp = interp1(no2_vis_254.data(:,1),no2_vis_254.data(:,2),cs.wln_4starb,'nearest','extrap')*Loschmidt;
cs.no2_vis_298K_interp = interp1(no2_vis_298.data(:,1),no2_vis_298.data(:,2),cs.wln_4starb,'nearest','extrap')*Loschmidt;
cs.o3_vis_223K_interp = interp1(o3_vis.data(:,1),o3_vis.data(:,2),cs.wln_4starb,'nearest','extrap')*Loschmidt;
cs.o4_vis_296K_interp = interp1(o4_vis.data(:,1),o4_vis.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.o2_vis_1013mbar_interp = interp1(o2_vis.data(:,1),o2_vis.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.hcho_vis_293K_interp = interp1(hcho_vis.data(:,1),hcho_vis.data(:,2),cs.wln_4starb,'nearest','extrap')*Loschmidt;
cs.h2o_vis_1013mbar_294K_interp = interp1(h2o_vis_1013mbar_294K.data(:,1),h2o_vis_1013mbar_294K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0902mbar_289K_interp = interp1(h2o_vis_0902mbar_289K.data(:,1),h2o_vis_0902mbar_289K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0802mbar_285K_interp = interp1(h2o_vis_0802mbar_285K.data(:,1),h2o_vis_0802mbar_285K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0710mbar_279K_interp = interp1(h2o_vis_0710mbar_279K.data(:,1),h2o_vis_0710mbar_279K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0628mbar_273K_interp = interp1(h2o_vis_0628mbar_273K.data(:,1),h2o_vis_0628mbar_273K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0554mbar_267K_interp = interp1(h2o_vis_0554mbar_267K.data(:,1),h2o_vis_0554mbar_267K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0487mbar_261K_interp = interp1(h2o_vis_0487mbar_261K.data(:,1),h2o_vis_0487mbar_261K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0426mbar_254K_interp = interp1(h2o_vis_0426mbar_254K.data(:,1),h2o_vis_0426mbar_254K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0372mbar_248K_interp = interp1(h2o_vis_0372mbar_248K.data(:,1),h2o_vis_0372mbar_248K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0324mbar_241K_interp = interp1(h2o_vis_0324mbar_241K.data(:,1),h2o_vis_0324mbar_241K.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.h2o_vis_0281mbar_235K_interp = interp1(h2o_vis_0281mbar_235K.data(:,1),h2o_vis_0281mbar_235K.data(:,2),cs.wln_4starb,'nearest','extrap');

% interp nir
cs.ch4_nir_1013mbar_interp = interp1(ch4_nir.data(:,1),ch4_nir.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.co2_nir_1013mbar_interp = interp1(co2_nir.data(:,1),co2_nir.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.o4_nir_296K_interp      = interp1(o4_nir.data(:,1),o4_nir.data(:,2),cs.wln_4starb,'nearest','extrap');
cs.o4all = cs.o4_vis_296K_interp + cs.o4_nir_296K_interp;
figure;
plot(cs.wln_4starb,cs.o4_vis_296K_interp,'-b');hold on; 
plot(cs.wln_4starb,cs.o4_nir_296K_interp,'--g');hold on;
plot(cs.wln_4starb,cs.o4all,':r');hold off;
legend('vis','nir','all');title('O_{4} convolved cross sections');

save('cross_sections_4starb.mat','-struct','cs','-mat');% this is in data folder


%% some additional plotting
% for comparing with 4STAR-A
cs=load(which( 'cross_sections_4starb.mat'));
cross_sections=load(which( 'cross_sections_uv_vis_swir_all.mat'));
figure;plot(cross_sections.wln,cross_sections.o3,'-b');hold on; plot(cs.wln_4starb,cs.o3_vis_223K_interp,'--g');legend('4STAR-A','4STAR-B');title('O_{3} convolved cross sections');
figure;plot(cross_sections.wln,cross_sections.no2,'-b');hold on; plot(cs.wln_4starb,cs.no2_vis_220K_interp,'--g');legend('4STAR-A','4STAR-B');title('NO_{2} convolved cross sections');


