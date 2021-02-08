% Checking some c0, and calculating the averages
%close all
clear all
fp = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
if ~isunix;
fp_out = 'C:\Users\sleblan2\Research\ORACLES\plot\';
else;
fp_out = '/nobackup/sleblan2/ORACLES/plot/';
end;
asktosave = 2; %set if ask to save the figures
%i_avg = [1 6 6 9 10 13 14 16];
%i_avg = [1 6 10 16]; % for flights after sept 20, 2016
%i_avg = [1 6 7 8 9 13 14 15]; % for flights after sept. 4th up to and including sept 20.

i_avg = [1 6-4 10-4 16-4];  % for flights after sept 20, 2016
i_avg = [1 6-4 7-4 8-4 9-4 13-4 14-4 15-4]; % for flights after sept. 4th up to and including sept 20.
i_avg = [1 2 7 8]; % for flights on the early part of ORACLES before sept 4th

i_avg = [3 5 9 10 11]; % for testing of inflights and high altitude only for flights after sept. 4th up to and including sept 20.
%filesuffix=['refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_' gdaystr '_ORACLES'];
i_avg = [1 17 18]; % for 'refined_Langley_averaged_inflight_Langley_high_alt_ORACLES' on 20160831
i_avg = [1 7 8 18]; % for 'refined_Langley_averaged_inflight_Langley_early_high_alts_ORACLES'
i_avg = [9 20 21]; % for 20160904 'refined_Langley_averaged_inflight_high_alts_highRH_ORACLES' 
i_avg = [3 9 10 20 21]; % for 20160908 'refined_Langley_averaged_inflight_high_alts_with_Langley_highRH_ORACLES'
i_avg = [24 25 26]; % for 20160920 refined_averaged_inflight_Langley_high_alts_ORACLES
i_avg = [2 6 12 17 23]; % for 20160924 refined_averaged_inflight_Langley_high_alts_transitback_ORACLES
i_avg = [1 3 4 5 6 ]+1; % for only in-flight langleys
filesuffix = ['refined_Langley_averaged_with_high_alt_inflight_ORACLES_notransit'];
filesuffix = ['refined_Langley_averaged_inflight_Langley_ORACLES_transits'];
filesuffix = ['refined_Langley_averaged_inflight_Langley_early_high_alts_ORACLES'];
filesuffix = ['refined_Langley_averaged_inflight_high_alts_highRH_ORACLES'];
filesuffix = ['refined_Langley_averaged_inflight_high_alts_with_Langley_highRH_ORACLES'];
filesuffix = ['refined_averaged_inflight_Langley_high_alts_loglog_lowRH_ORACLES'];
filesuffix = ['refined_averaged_inflight_Langley_high_alts_ORACLES'];
filesuffix = ['refined_averaged_inflight_Langley_high_alts_transitback_ORACLES'];
filesuffix = ['refined_averaged_inflight_Langleys_ORACLES'];
label_daystr = '20160924';

vis_names = {'20161115_VIS_C0_refined_Langley_Nov2016part1.5incl1115_good_mean.dat';...
             '20160825_VIS_C0_refined_Langley_ORACLES_transit2.dat';...
            % '20161110_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
            % '20161111_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
            % '20161112_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
            % '20161113_VIS_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
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
             '20160927_VIS_C0_refined_high_alt_low_m.dat';...
             '20160927_VIS_C0_refined_mix_Langley_airborne_MLO_high_alt_AOD_ORACLES_averages_v1.dat';...
            '20160927_VIS_C0_refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160927_ORACLES.dat';...
            '20160918_VIS_C0_refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160918_ORACLES.dat';...
            '20160904_VIS_C0_refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160904_ORACLES.dat';...
            '20160824_VIS_C0_refined_langley_4STAR.dat';...
            '20160831_VIS_C0_refined_high_alt_low_m.dat';...
            '20160902_VIS_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160904_VIS_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160908_VIS_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160918_VIS_C0_refined_high_alt_low_m_fromBonanza_loglogquad.dat';...
            '20160927_VIS_C0_refined_high_alt_low_m_fromBonanza_loglogquad.dat';...
            '20160920_VIS_C0_refined_langley_4STAR.dat';...
            '20160920_VIS_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160918_VIS_C0_refined_high_alt_low_m_fromBonanza.dat'};
        
nir_names = {'20161115_NIR_C0_refined_Langley_Nov2016part1.5incl1115_good_mean.dat';...
             '20160825_NIR_C0_refined_Langley_ORACLES_transit2.dat';...
            % '20161110_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
            % '20161111_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
            % '20161112_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
            % '20161113_NIR_C0_refined_Langley_MLO_Nov2016_12to2airmass.dat';...
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
             '20160927_NIR_C0_refined_high_alt_low_m.dat';...
             '20160927_NIR_C0_refined_mix_Langley_airborne_MLO_high_alt_AOD_ORACLES_averages_v1.dat';...
            '20160927_NIR_C0_refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160927_ORACLES.dat';...
            '20160918_NIR_C0_refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160918_ORACLES.dat';...
            '20160904_NIR_C0_refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160904_ORACLES.dat';...
            '20160824_NIR_C0_refined_langley_4STAR.dat';...
            '20160831_NIR_C0_refined_high_alt_low_m.dat';...
            '20160902_NIR_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160904_NIR_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160908_NIR_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160918_NIR_C0_refined_high_alt_low_m_fromBonanza_loglogquad.dat';...
            '20160927_NIR_C0_refined_high_alt_low_m_fromBonanza_loglogquad.dat';...
            '20160920_NIR_C0_refined_langley_4STAR.dat';...
            '20160920_NIR_C0_refined_high_alt_low_m_fromBonanza.dat';...
            '20160918_NIR_C0_refined_high_alt_low_m_fromBonanza.dat'};
         
supp = {'MLO';'inflight';...%'MLO';'MLO';'MLO';'MLO';
    'MLO avg';'inflight';...
        'inflight';'inflight';'inflight';'high alt';'high alt';...
        'high alt';'high alt';'high alt';'high alt';'Averages for all';...
        'ORACLES late';'ORACLES mid';'ORACLES early';'inflight';'high alt';...
        'high alt BON';'high alt BON';'high alt BON';'high alt loglog BON';'high alt loglog BON';...
        'inflight';'high alt BON';'high alt BON'};
n = length(vis_names);
c0v = {}; c0rv = {}; c0n = {}; corn = {}; leg = {};

fig = figure('pos',[200 50 1600 400]); 
plot([350,1000,1700],[0,0,0],'--k');
title('c0s from calibration date')
hold on;

fig2 = figure('pos',[200 450 1600 400]);
plot([350,1000,1700],[0,0,0],'--k');
title('Normalized c0s from calibration date')
hold on;

cm = jet(n);
for i=1:n;
    visfilename = [fp vis_names{i}];
    nirfilename = [fp nir_names{i}];

    try; 
        a=importdata(which(visfilename));
    catch;
        disp(['*** Error unable to load file:' visfilename ' found at :' which(visfilename)])
        continue;
    end;
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
    if any(i_avg==i);
        l = plot(w_vis,visc0(i,:),'color',cm(i,:),'linewidth',4);
         plot(w_nir,nirc0(i,:).*10,'color',cm(i,:),'linewidth',4);
    else;
        l = plot(w_vis,visc0(i,:),'color',cm(i,:));
         plot(w_nir,nirc0(i,:).*10,'color',cm(i,:));
    end;
    p(i) = l;
    
    figure(fig2);
    if any(i_avg==i);
        l2 = plot(w_vis,visc0(i,:)./visc0(1,:).*100.0,'color',cm(i,:),'linewidth',4);
        plot(w_nir,nirc0(i,:)./nirc0(1,:).*100.0,'color',cm(i,:),'linewidth',4);
    else;
        l2 = plot(w_vis,visc0(i,:)./visc0(1,:).*100.0,'color',cm(i,:));
        plot(w_nir,nirc0(i,:)./nirc0(1,:).*100.0,'color',cm(i,:));
    end;
    p2(i) = l2;
    
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
visc0_avg = mean(visc0(i_avg,:));
visc0_std = std(visc0(i_avg,:));
nirc0_avg = mean(nirc0(i_avg,:));
nirc0_std = std(nirc0(i_avg,:));

gdaystr = vis_names{i_avg(end)}(1:8);

figure(fig2);
l2 = plot(w_vis,visc0_avg./visc0(1,:).*100.0,'color','black');
plot(w_nir,nirc0_avg./nirc0(1,:).*100.0,'color','black');
grid;
p2(i+1) = l2;
leg{i+1} = ['Averages with ' gdaystr];
legend(p2,leg,'location','northeastoutside');

figure(fig);
l = plot(w_vis,visc0_avg,'color','black');
plot(w_nir,nirc0_avg.*10.0,'color','black');
grid;
p(i+1) = l;
leg{i+1} = ['Averages with ' gdaystr];
legend(p,leg,'location','northeastoutside');

% Save the figures
save_fig(fig,[fp_out 'ORACLES_cal_c0_' gdaystr],asktosave);
save_fig(fig2,[fp_out 'ORACLES_cal_c0_relative_' gdaystr],asktosave);

figure(fig2);
ylim([96 104]);
save_fig(fig2,[fp_out 'ORACLES2016_cal_c0_relative_zoom'],asktosave);

fig3 = figure;
ax1 = subplot(3,1,1);
plot(w_vis,visc0_avg,'.-k'); hold on;
plot(w_nir,nirc0_avg.*10.0,'.-k');hold off;
ylabel('c0 (NIR c0 x10)'); ylim([0,800])
title('4STAR C0 saved for good averages from ORACLES 2016')
ax2 = subplot(3,1,2);

plot(w_vis,visc0_std./visc0_avg.*100.0,'.-k'); hold on;
plot(w_nir,nirc0_std./nirc0_avg.*100.0,'.-k');hold off;
ylabel('Relative std of c0 [%]');ylim([0,20]);
ax3 = subplot(3,1,3);
title('zoomed')
plot(w_vis,visc0_std./visc0_avg.*100.0,'.-k'); hold on;
plot(w_nir,nirc0_std./nirc0_avg.*100.0,'.-k');hold off;
ylabel('Relative std of c0 [%]');ylim([0,1]); grid;

linkaxes([ax1,ax2,ax3],'x');
xlabel('Wavelength [nm]'); 
save_fig(fig3,[fp_out 'Oracles2016_cal_c0_avg_' gdaystr],asktosave);

% Now save the new averaged c0 for use
days_cell = '';
for i=1:length(i_avg);
    c = char(leg{i_avg(i)});
    days_cell = [days_cell ', ' c(1:4) '-' c(5:6) '-' c(7:8)];
end;
%filesuffix=['refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_' gdaystr '_ORACLES'];
additionalnotes={'Langley at MLO and airborne Data outside 2.0x the STD of 501 nm Langley residuals were screened out. ';...
                 'Including high Altitude rate spectra, matched to splined stratospheric AOD measured at MLO.';...
                 ['Averages of c0 from multiple days including: ' days_cell '. See the list of files below']};
daystr=label_daystr; %leg{i_avg(end)}(end-7:end);
visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);    

vissource_alt=cellstr(char(vis_names{i_avg}));
nirsource_alt=cellstr(char(nir_names{i_avg}));
vissource = '(SEE Original files for sources)';
nirsource = '(SEE Original files for sources)';

starsavec0(visfilename, vissource, [additionalnotes; vissource_alt], w_vis, visc0_avg, visc0_std);
starsavec0(nirfilename, nirsource, [additionalnotes; nirsource_alt], w_nir, nirc0_avg, nirc0_std);

disp(['Printing c0 file to :' visfilename])



