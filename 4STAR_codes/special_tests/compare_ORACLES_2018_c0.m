% Checking some c0, and calculating the averages for ORACLES 2018
%close all
clear all
fp = getnamedpath('starinfo'); %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
fp_out = getnamedpath('ORACLES_plot');
asktosave = 1; %set if ask to save the figures
i_avg = [4,5,6,7,8,9,10];
filesuffix = ['refined_averaged_4STAR_MLO_inflight_highalt_withFebMLO_short'];
label_daystr = '20181015';
i_avg_short = [4,5,6,7,9,10];
%filesuffix = ['refined_averaged_4STAR_MLO_inflight_highalt_withFebMLO_short'];
%label_daystr = '20180921';
%i_avg_short = [4,5,7,8];
%filesuffix = ['refined_averaged_4STAR_MLO_inflight_highalt_withshort_highalt_only'];
%label_daystr = '20181003';
%i_avg_short = [11,11];
filesuffix = ['refined_averaged_4STAR_MLO_inflight_highalt_with_shortspecial'];
label_daystr = '20181005';
i_avg_short = [4,6,7,8,10,11];
filesuffix = ['refined_averaged_4STAR_MLO_inflight_highalt_with_shortspecial'];
label_daystr = '20181007';
i_avg_short = [6,7,9,11];
short_wvl_special_avg = true;

vis_names = {'20180212_VIS_C0_4STAR_refined_averaged_MLO_Feb2018.dat';...
            '20170605_VIS_C0_refined_Langley_MLO_May2017_averages.dat';...
            '20180811_VIS_C0_refined_Langley_4STAR_averaged_with_MLO_2018_Aug_11_12.dat';
            '20180921_4STAR_VIS_C0_refined_flight_langley_am.dat';...
            '20180922_VIS_C0_4STAR_refined_flight_langley_am.dat';...
            '20181005_VIS_C0_4STAR_refined_flight_langley_am.dat';...
            '20180212_VIS_C0_4STAR_refined_averaged_MLO_Feb2018_shortwvl.dat';...
            '20180921_VIS_C0_refined_high_alt_low_m_frompolyfit_RaggedPoint.dat';...
            '20181007_VIS_C0_refined_high_alt_low_m_frompolyfit_ElFarafa.dat';...
            '20181015_VIS_C0_refined_high_alt_low_m_frompolyfit_ElFarafa.dat';...
            '20181003_VIS_C0_refined_high_alt_low_m_frompolyfit_Misamfu.dat'};
        
nir_names = {'20180212_NIR_C0_4STAR_refined_averaged_MLO_Feb2018.dat';...
            '20170605_NIR_C0_refined_Langley_MLO_May2017_averages.dat';...
            '20180811_NIR_C0_refined_Langley_4STAR_averaged_with_MLO_2018_Aug_11_12.dat';
            '20180921_4STAR_NIR_C0_refined_flight_langley_am.dat';...
            '20180922_NIR_C0_4STAR_refined_flight_langley_am.dat';...
            '20181005_NIR_C0_4STAR_refined_flight_langley_am.dat';...
            '20180212_NIR_C0_4STAR_refined_averaged_MLO_Feb2018_shortwvl.dat';...
            '20180921_NIR_C0_refined_high_alt_low_m_frompolyfit_RaggedPoint.dat';...
            '20181007_NIR_C0_refined_high_alt_low_m_frompolyfit_ElFarafa.dat';...
            '20181015_NIR_C0_refined_high_alt_low_m_frompolyfit_ElFarafa.dat';...
            '20181003_NIR_C0_refined_high_alt_low_m_frompolyfit_Misamfu.dat'};
         
supp = {'1 MLO feb 2018';'2 MLO jun 2017';...%'MLO';'MLO';'MLO';'MLO';
        '3 MLO aug 2018';'4 In flight';'5 In flight';'6 In flight';...
        '7 MLO feb 2018 short';'8 High alt';'9 High alt';'10 High alt';'11 High alt'};
    
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
ylim([0,750]);

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
ylim([0,750]);

% Now average the c0s for creating the right c0
visc0_avg = mean(visc0(i_avg,:));
visc0_std = std(visc0(i_avg,:));
nirc0_avg = mean(nirc0(i_avg,:));
nirc0_std = std(nirc0(i_avg,:));

if short_wvl_special_avg;
    iw_short = (1:350);
    visc0_avg(iw_short) = mean(visc0(i_avg_short,iw_short));
    visc0_std(iw_short) = std(visc0(i_avg_short,iw_short));
end;

gdaystr = label_daystr; %vis_names{i_avg(end)}(1:8);

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
save_fig(fig,[fp_out 'ORACLES2018_cal_c0_' gdaystr],asktosave);
save_fig(fig2,[fp_out 'ORACLES2018_cal_c0_relative_' gdaystr],asktosave);

figure(fig2);
ylim([96 104]);
save_fig(fig2,[fp_out 'ORACLES2018_cal_c0_relative_zoom'],asktosave);

fig3 = figure;
ax1 = subplot(3,1,1);
plot(w_vis,visc0_avg,'.-k'); hold on;
plot(w_nir,nirc0_avg.*10.0,'.-k');hold off;
ylabel('c0 (NIR c0 x10)'); ylim([0,800])
title('4STAR C0 saved for good averages from ORACLES 2018')
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
save_fig(fig3,[fp_out 'Oracles2018_cal_c0_avg_' gdaystr],asktosave);

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



