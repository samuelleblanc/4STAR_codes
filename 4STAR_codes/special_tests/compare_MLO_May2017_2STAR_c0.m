% Checking some c0, and calculating the averages
close all
clear all
fp = 'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
fp_out = 'C:\Users\sleblan2\Research\MLO\2017_May\figs\';

vis_names = {'20170526_VIS_C0_refined_Langley_2STAR_MLO_May2017.dat';...
             '20170527_VIS_C0_refined_Langley_2STAR_MLO_May2017.dat';...
             '20170528_VIS_C0_refined_Langley_2STAR_MLO_May2017.dat';...
             '20170529_VIS_C0_refined_Langley_2STAR_MLO_May2017.dat';...
             '20170530_VIS_C0_refined_Langley_2STAR_MLO_May2017.dat';...
             '20170531_VIS_C0_refined_Langley_2STAR_MLO_May2017am.dat';...
             '20170531_VIS_C0_refined_Langley_2STAR_MLO_May2017pm.dat';...
             '20170601_VIS_C0_refined_Langley_2STAR_MLO_May2017am.dat';...
             '20170601_VIS_C0_refined_Langley_2STAR_MLO_May2017pm.dat';...
             '20170603_VIS_C0_refined_Langley_2STAR_MLO_May2017.dat';...
             '20170604_VIS_C0_refined_Langley_2STAR_MLO_May2017pm.dat';...
             '20170605_VIS_C0_refined_Langley_2STAR_MLO_May2017am.dat';...
             '20170605_VIS_C0_refined_Langley_2STAR_MLO_May2017pm.dat';...
             }
         
supp = {'cloudy';'good';'hazy';'cloudy';'cloudy';'good am';'good pm';'cloudy am';'cloudy pm';...
        'cloudy';'good pm';'good am';'good pm'};
i_avg = [2,6,7,11,12,13];

n = length(vis_names);
c0v = {}; c0rv = {}; c0n = {}; corn = {}; leg = {};

fig = figure; 
plot([350,1000,1700],[0,0,0],'--k');
title('2STAR c0s from calibration date')
hold on;

fig2 = figure;
plot([350,1000,1700],[0,0,0],'--k');
title('2STAR Normalized c0s from calibration date')
hold on;

cm = jet(n);
for i=1:n;
    visfilename = [fp vis_names{i}]
    
    a=importdata(which(visfilename));
    visc0(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
    visc0err(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
    c0v{i} = visc0; c0rv{i} = visc0err;
    
    w_vis = a.data(:,strcmp(lower(a.colheaders),'wavelength'));
    
    leg{i} = [supp{i} '-' vis_names{i}(1:8)];
   
    figure(fig);
    if any(i_avg==i);
    l = plot(w_vis,visc0(i,:),'color',cm(i,:),'linewidth',4);    
    else;
    l = plot(w_vis,visc0(i,:),'color',cm(i,:));
    end;
    p(i) = l;
    
    figure(fig2);
    if any(i_avg==i);
    l2 = plot(w_vis,visc0(i,:)./visc0(1,:).*100.0,'color',cm(i,:),'linewidth',4); 
    else;
    l2 = plot(w_vis,visc0(i,:)./visc0(1,:).*100.0,'color',cm(i,:));
    end;
    
    p2(i) = l2;
end;
figure(fig);
legend(p,leg);
xlabel('Wavelength [nm]');
ylabel('c0');
ylim([0,1450]);

figure(fig2);
legend(p2,leg);
xlabel('Wavelength [nm]');
ylabel('Normalized c0');
ylim([80,120]);

figure;
l = plot(w_vis,visc0);
hold all

legend(l,leg);
xlabel('Wavelength [nm]');
ylabel('c0');
ylim([0,800]);

% Now average the c0s for creating the right c0
%i_avg = [1 6 6 9 10 13 14 16];
%i_avg = [2,6,7,11,12,13];
visc0_avg = mean(visc0(i_avg,:));
visc0_std = std(visc0(i_avg,:));

figure(fig2);
l2 = plot(w_vis,visc0_avg./visc0(1,:).*100.0,'color','black');
grid;
p2(i+1) = l2;
leg{i+1} = 'good - Averages';
legend(p2,leg,'location','northeastoutside');

figure(fig);
l = plot(w_vis,visc0_avg,'color','black');
grid;
p(i+1) = l; ylim([0 1800]); xlim([280,1120]);
leg{i+1} = 'good - Averages';
legend(p,leg,'location','northeastoutside');

% Save the figures
save_fig(fig,[fp_out 'MLO_May2017_2STAR_cal_c0']);
save_fig(fig2,[fp_out 'MLO_May2017_2STAR_cal_c0_relative']);

figure(fig2);
ylim([96 104]);
save_fig(fig2,[fp_out 'MLO_May2017_2STAR_cal_c0_relative_zoom']);

%stophere
% Now save the new averaged c0 for use
days_cell = '';
for i=1:length(i_avg);
    c = char(leg{i_avg(i)});
    days_cell = [days_cell ', ' c(1:4) '-' c(5:6) '-' c(7:8)];
end;
filesuffix='refined_Langley_MLO_May2017_2STAR_averages';
additionalnotes={'Langley at MLO, Data outside 2.0x the STD of 501 nm Langley residuals were screened out. ';...
                 ['Averages of c0 from multiple days including: ' days_cell '. See the list of files below']};
daystr=leg{i_avg(end)}(end-7:end);
visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
%nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);    

vissource_alt=cellstr(char(vis_names{i_avg}));
%nirsource_alt=cellstr(char(nir_names{i_avg}));
vissource = '(SEE Original files for sources)';
%nirsource = '(SEE Original files for sources)';

starsavec0(visfilename, vissource, [additionalnotes; vissource_alt], w_vis, visc0_avg, visc0_std);
%starsavec0(nirfilename, nirsource, [additionalnotes; nirsource_alt], w_nir, nirc0_avg, nirc0_std);

stophere



