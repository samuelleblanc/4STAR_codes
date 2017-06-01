% Checking some c0, and calculating the averages
close all
clear all
fp = 'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
fp_out = 'C:\Users\sleblan2\Research\ORACLES\plot\';

vis_names = {'20160825_VIS_C0_refined_Langley_ORACLES_transit2.dat';...
             '20161110_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161111_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161112_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161113_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161115_VIS_C0_refined_Langley_Nov2016part1.5incl1115_good_mean.dat';...
             '20160908_VIS_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160912_VIS_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160918_VIS_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160924_VIS_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160902_VIS_C0_refined_high_alt_low_m.dat';...
             '20160904_VIS_C0_refined_high_alt_low_m.dat';...
             '20160908_VIS_C0_refined_high_alt_low_m.dat';...
             '20160912_VIS_C0_refined_high_alt_low_m.dat';...
             '20160918_VIS_C0_refined_high_alt_low_m.dat';...
             '20160927_VIS_C0_refined_high_alt_low_m.dat'};
        
nir_names = {'20160825_NIR_C0_refined_Langley_ORACLES_transit2.dat';...
             '20161110_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161111_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161112_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161113_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
             '20161115_NIR_C0_refined_Langley_Nov2016part1.5incl1115_good_mean.dat';...
             '20160908_NIR_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160912_NIR_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160918_NIR_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160924_NIR_C0_refined_Langley_airborne_ORACLES_v1.dat';...
             '20160902_NIR_C0_refined_high_alt_low_m.dat';...
             '20160904_NIR_C0_refined_high_alt_low_m.dat';...
             '20160908_NIR_C0_refined_high_alt_low_m.dat';...
             '20160912_NIR_C0_refined_high_alt_low_m.dat';...
             '20160918_NIR_C0_refined_high_alt_low_m.dat';...
             '20160927_NIR_C0_refined_high_alt_low_m.dat'};
         
supp = {'inflight';'MLO';'MLO';'MLO';'MLO';'MLO avg';'inflight';...
        'inflight';'inflight';'inflight';'high alt';'high alt';...
        'high alt';'high alt';'high alt';'high alt'};
n = length(vis_names);
c0v = {}; c0rv = {}; c0n = {}; corn = {}; leg = {};

fig = figure; 
plot([350,1000,1700],[0,0,0],'--k');
title('c0s from calibration date')
hold on;

fig2 = figure;
plot([350,1000,1700],[0,0,0],'--k');
title('Normalized c0s from calibration date')
hold on;

cm = jet(n);
for i=1:n;
    visfilename = [fp vis_names{i}]
    nirfilename = [fp nir_names{i}]
    
    a=importdata(which(visfilename));
    visc0(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
    visc0err(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
    c0v{i} = visc0; c0rv{i} = visc0err;
    
    b=importdata(which(nirfilename));
    nirc0(i,:)=b.data(:,strcmp(lower(b.colheaders), 'c0'))';
    nirc0err(i,:)=b.data(:,strcmp(lower(b.colheaders), 'c0err'))';
    c0n{i} = nirc0; c0rn{i} = nirc0err;
    
    w_vis = a.data(:,strcmp(lower(a.colheaders),'wavelength'));
    w_nir = b.data(:,strcmp(lower(b.colheaders),'wavelength'));
    
    leg{i} = [supp{i} '-' vis_names{i}(1:8)];
   
    figure(fig);
    l = plot(w_vis,visc0(i,:),'color',cm(i,:));
    p(i) = l;
    plot(w_nir,nirc0(i,:).*10,'color',cm(i,:));
    
    figure(fig2);
    l2 = plot(w_vis,visc0(i,:)./visc0(1,:).*100.0,'color',cm(i,:));
    p2(i) = l2;
    plot(w_nir,nirc0(i,:)./nirc0(1,:).*100.0,'color',cm(i,:));
    
end;
figure(fig);
legend(p,leg);
xlabel('Wavelength [nm]');
ylabel('c0 (NIR c0 x10)');
ylim([0,650]);

figure(fig2);
legend(p2,leg);
xlabel('Wavelength [nm]');
ylabel('Normalized c0');
ylim([80,120]);

figure;
l = plot(w_vis,visc0);
hold all
plot(w_nir,nirc0.*10);

legend(l,leg);
xlabel('Wavelength [nm]');
ylabel('c0');
ylim([0,650]);

% Now average the c0s for creating the right c0
i_avg = [1 6 6 9 10 13 14 16];
visc0_avg = mean(visc0(i_avg,:));
visc0_std = std(visc0(i_avg,:));
nirc0_avg = mean(nirc0(i_avg,:));
nirc0_std = std(nirc0(i_avg,:));

figure(fig2);
l2 = plot(w_vis,visc0_avg./visc0(1,:).*100.0,'color','black');
plot(w_nir,nirc0_avg./nirc0(1,:).*100.0,'color','black');
grid;
p2(i+1) = l2;
leg{i+1} = 'Averages';
legend(p2,leg);

figure(fig);
l = plot(w_vis,visc0_avg,'color','black');
plot(w_nir,nirc0_avg.*10.0,'color','black');
grid;
p(i+1) = l;
leg{i+1} = 'Averages';
legend(p,leg);

% Save the figures
save_fig(fig,[fp_out 'ORACLES_cal_c0.fig']);
save_fig(fig2,[fp_out 'ORACLES_cal_c0_relative.fig']);

% Now save the new averaged c0 for use
days_cell = '';
for i=1:length(i_avg);
    c = char(leg{i_avg(i)});
    days_cell = [days_cell ', ' c(1:4) '-' c(5:6) '-' c(7:8)];
end;
filesuffix='refined_mix_Langley_airborne_MLO_high_alt_AOD_ORACLES_averages_v1';
additionalnotes={'Langley at MLO and airborne Data outside 2.0x the STD of 501 nm Langley residuals were screened out. ';...
                 'Including high Altitude rate spectra, matched to splined stratospheric AOD measured at MLO.';...
                 ['Averages of c0 from multiple days including: ' days_cell '. See the list of files below']};
daystr=leg{i_avg(end)}(end-7:end);
visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);    

vissource_alt=cellstr(char(vis_names{i_avg}));
nirsource_alt=cellstr(char(nir_names{i_avg}));
vissource = '(SEE Original files for sources)';
nirsource = '(SEE Original files for sources)';

starsavec0(visfilename, vissource, [additionalnotes; vissource_alt], w_vis, visc0_avg, visc0_std);
starsavec0(nirfilename, nirsource, [additionalnotes; nirsource_alt], w_nir, nirc0_avg, nirc0_std);

stophere


