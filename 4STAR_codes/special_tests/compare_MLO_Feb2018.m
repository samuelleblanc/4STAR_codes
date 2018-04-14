% Checking some c0, and calculating the averages for ORACLES 2017
%close all
clear all
fp = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
if ~isunix;
fp_out = 'C:\Users\sleblanc\Research\MLO\2018_Febuary\';
else;
fp_out = '/nobackup/sleblan2/ORACLES/plot/';
end;
asktosave = 1; %set if ask to save the figures
i_avg = [1,2,3,4]+1;
filesuffix = ['4STAR_refined_averaged_MLO_Feb2018'];
label_daystr = '20180212';
fignames = 'MLO_Feb2018';

vis_names = {'20170905_VIS_C0_refined_averaged_MLO_inflightsubset_polyfit_withBonanza_specialshortwvl.dat';...
            '20180209_VIS_C0_refined_langley_4STARam_MLOFeb2018_day5_.dat';...
            '20180210_VIS_C0_refined_langley_4STARam_MLOFeb2018_day6.dat';...
            '20180211_VIS_C0_refined_langley_4STARam_MLOFeb2018_day7.dat';...
            '20180212_VIS_C0_refined_langley_4STARam_MLOFeb2018_day8.dat';...
            '20180207_VIS_C0_refined_langley_4STARam_MLOFeb2018_day3_.dat';...
            '20180208_VIS_C0_refined_langley_4STARam_MLOFeb2018_day4_.dat';...
            '20180215_VIS_C0_refined_langley_4STARam_MLOFeb2018_day11.dat';...
            '20170815_VIS_C0_refined_averaged_MLO_inflightsubset_polyfit.dat';...
            '20171206_VIS_C0_refined_averaged_ames_roof_and_ORACLES2017.dat'};
        
nir_names = {'20170905_NIR_C0_refined_averaged_MLO_inflightsubset_polyfit_withBonanza_specialshortwvl.dat';...
            '20180209_NIR_C0_refined_langley_4STARam_MLOFeb2018_day5_.dat';...
            '20180210_NIR_C0_refined_langley_4STARam_MLOFeb2018_day6.dat';...
            '20180211_NIR_C0_refined_langley_4STARam_MLOFeb2018_day7.dat';...
            '20180212_NIR_C0_refined_langley_4STARam_MLOFeb2018_day8.dat';...
            '20180207_NIR_C0_refined_langley_4STARam_MLOFeb2018_day3_.dat';...
            '20180208_NIR_C0_refined_langley_4STARam_MLOFeb2018_day4_.dat';...
            '20180215_NIR_C0_refined_langley_4STARam_MLOFeb2018_day11.dat';...
            '20170815_NIR_C0_refined_averaged_MLO_inflightsubset_polyfit.dat';...
            '20171206_NIR_C0_refined_averaged_ames_roof_and_ORACLES2017.dat'};
         
supp = {'ORACLES best';'MLO good';'MLO good';'MLO good';'MLO good';...
        'MLO bad';'MLO marginal';'MLO marginal';...
        'ORACLES avg';'Ames roof average'};
    
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
save_fig(fig,[fp_out fignames '_cal_c0_' gdaystr],asktosave);
save_fig(fig2,[fp_out fignames '_cal_c0_relative_' gdaystr],asktosave);

figure(fig2);
ylim([96 104]);
save_fig(fig2,[fp_out fignames '_cal_c0_relative_zoom'],asktosave);

fig3 = figure;
ax1 = subplot(3,1,1);
plot(w_vis,visc0_avg,'.-k'); hold on;
plot(w_nir,nirc0_avg.*10.0,'.-k');hold off;
ylabel('c0 (NIR c0 x10)'); ylim([0,800])
title(['4STAR C0 saved for good averages from ' fignames])
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
save_fig(fig3,[fp_out fignames '_cal_c0_avg_' gdaystr],asktosave);

% Now save the new averaged c0 for use
days_cell = '';
for i=1:length(i_avg);
    c = char(leg{i_avg(i)});
    days_cell = [days_cell ', ' c(1:4) '-' c(5:6) '-' c(7:8)];
end;
%filesuffix=['refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_' gdaystr '_ORACLES'];
additionalnotes={'Langley at MLO outside of 1.8x the STD of 501 nm Langley residuals were screened out. ';...
                 'c0 from best days at MLO';...
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



