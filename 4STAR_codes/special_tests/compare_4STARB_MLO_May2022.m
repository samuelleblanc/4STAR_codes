% Checking some c0, and calculating the averages for MLO May 2022
%close all
clear all
fp = starpaths; %'C:\Users\sleblan2\Research\4STAR_codes\data_folder\';
instrumentname = '4STAR';
if ~isunix
fp_out = 'C:\Users\lebla\Research\MLO\2022_May\';
else
fp_out = '/nobackup/sleblan2/ORACLES/plot/';
end
asktosave = 1; %set if ask to save the figures
i_avg = [2,3,4,5,6,7,8];
filesuffix = [instrumentname '_refined_averaged_good_MLO_May2022'];
label_daystr = '20220514';
fignames = [instrumentname '_MLO_May2022'];


vis_names = {['20220508_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day2.dat'];...
             ['20220508_VIS_C0_' instrumentname '_refined_ground_langley_pmMLO_May2022_Day2.dat'];...
             ['20220509_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day3.dat'];...
             ['20220510_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day4.dat'];...
             ['20220511_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day5.dat'];...
             ['20220512_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day6.dat'];...
             ['20220513_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day7.dat'];...
             ['20220514_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day8.dat'];...
             ['20220515_VIS_C0_' instrumentname '_refined_ground_langley_amMLO_May2022_Day9.dat'];...
             ['20220508_VIS_C0_' instrumentname '_AODmatch_toAERONET_fromMauna_Loa.dat'];...
             ['20220509_VIS_C0_' instrumentname '_AODmatch_toAERONET_fromMauna_Loa.dat'];...
             ['20220511_VIS_C0_' instrumentname '_AODmatch_toAERONET_fromMauna_Loa.dat'];...
             ['20220513_VIS_C0_' instrumentname '_AODmatch_toAERONET_fromMauna_Loa.dat'];...
             ['20220514_VIS_C0_' instrumentname '_AODmatch_toAERONET_fromMauna_Loa.dat'];...
             ['20220515_VIS_C0_' instrumentname '_AODmatch_toAERONET_fromMauna_Loa.dat'];...
             ['20220429_VIS_C0_' instrumentname '_AODmatch_toAERONET_fromNASA_Ames.dat']};
        
nir_names = {};
for n=vis_names, nir_names = [nir_names;{strrep(n,'VIS','NIR')}]; end
nir_names = nir_names{1};
         
supp = {'MLO marginal';'MLO pm good';'MLO good';'MLO good';...
        'MLO good';'MLO good';'MLO good';'MLO good';...
        'MLO marginal';...
        'MLO AERONET';'MLO AERONET';'MLO AERONET';...
        'MLO AERONET';'MLO AERONET';'MLO AERONET';...
        'Ames AERONET'};
    
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
rm_i = [];

cm = jet(n);
for i=1:n
    visfilename = [which(vis_names{i})];
    nirfilename = [which(nir_names{i})];

    try
        a=importdata(which(visfilename));
    catch e
        disp(['*** Error unable to load file:' visfilename ' found at :' which(visfilename)])
        rm_i(end+1) = i;
        continue;
    end
    if ~isstruct(a)
        a = readtable(which(visfilename),'CommentStyle','%','ReadVariableNames',true);
        visc0(i,:) = a.C0;
        visc0err(i,:) = a.C0err;
        w_vis = a.Wavelength;
    else
        visc0(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
        visc0err(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
        w_vis = a.data(:,strcmp(lower(a.colheaders),'wavelength'));
    end
    c0v{i} = visc0; c0rv{i} = visc0err;
    
    b=importdata(which(nirfilename));
    if ~isstruct(b)
        b = readtable(which(nirfilename),'CommentStyle','%','ReadVariableNames',true);
        nirc0(i,:) = b.C0;
        nirc0err(i,:) = b.C0err;
        w_nir = b.Wavelength;
    else
        nirc0(i,:)=b.data(:,strcmp(lower(b.colheaders), 'c0'))';
        nirc0err(i,:)=b.data(:,strcmp(lower(b.colheaders), 'c0err'))';
        w_nir = b.data(:,strcmp(lower(b.colheaders),'wavelength'));
    end
    c0n{i} = nirc0; c0rn{i} = nirc0err;
    leg{i} = [supp{i} '-' vis_names{i}(1:8)];
    
    if strcmp(supp{i},'NAAMES 3') % special case for flipped 4STARB c0 file of NIR
        w_nir = flipud(w_nir);
        %nirc0(i,:) = flipud(nirc0(i,:));
        %nirc0err(i,:) = flipud(nirc0err(i,:));
    end
   
    figure(fig);
    if any(i_avg==i)
        l = plot(w_vis,visc0(i,:),'color',cm(i,:),'linewidth',4);
         plot(w_nir,nirc0(i,:).*10,'color',cm(i,:),'linewidth',4);
    else
        l = plot(w_vis,visc0(i,:),'color',cm(i,:));
         plot(w_nir,nirc0(i,:).*10,'color',cm(i,:));
    end
    p(i) = l;
    
    figure(fig2);
    if any(i_avg==i)
        l2 = plot(w_vis,visc0(i,:)./visc0(1,:).*100.0,'color',cm(i,:),'linewidth',4);
        plot(w_nir,nirc0(i,:)./nirc0(1,:).*100.0,'color',cm(i,:),'linewidth',4);
    else
        l2 = plot(w_vis,visc0(i,:)./visc0(1,:).*100.0,'color',cm(i,:));
        plot(w_nir,nirc0(i,:)./nirc0(1,:).*100.0,'color',cm(i,:));
    end
    p2(i) = l2;
    
end
for j=flip(rm_i)
   p(j) = [];
   leg(j) = [];
   p2(j) = [];
end
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
k = i+1-length(rm_i);
p2(k) = l2;
leg{k} = ['Averages with ' gdaystr];
legend(p2,leg,'location','northeastoutside');

figure(fig);
l = plot(w_vis,visc0_avg,'color','black');
plot(w_nir,nirc0_avg.*10.0,'color','black');
grid;
p(k) = l;
leg{k} = ['Averages with ' gdaystr];
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
title(['4STARB C0 saved for good averages from ' fignames])
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
additionalnotes={'Langley at MLO outside 1.8x the STD of 501 nm Langley residuals were screened out. ';...
                 'Including only the good days at MLO';...
                 ['Averages of c0 from multiple days including: ' days_cell '. See the list of files below']};
daystr=label_daystr; %leg{i_avg(end)}(end-7:end);
visfilename=fullfile(getnamedpath('stardat'), [daystr '_VIS_C0_' filesuffix '.dat']);
nirfilename=fullfile(getnamedpath('stardat'), [daystr '_NIR_C0_' filesuffix '.dat']);    

vissource_alt=cellstr(char(vis_names{i_avg}));
nirsource_alt=cellstr(char(nir_names{i_avg}));
vissource = '(SEE Original files for sources)';
nirsource = '(SEE Original files for sources)';

starsavec0(visfilename, vissource, [additionalnotes; vissource_alt], w_vis, visc0_avg, visc0_std);
starsavec0(nirfilename, nirsource, [additionalnotes; nirsource_alt], w_nir, nirc0_avg, nirc0_std);

disp(['Printing c0 file to :' visfilename])



