%plot_Langleys_all.m: FOR JUNE MLO 2016
% what I want to do in this one: 
%  -- time trace of c0s
%  -- plots for more wavelengths
%  -- all langleys for one wavelength on one plot
%  -- c0 spectra for each day compared to each other
%  -- compare with KORUS starc0.m


% load('c0s_fits_allLangleys_June2016.mat') % all the fits for the langleys, plus important housekeeping like wavelengths (w) and 
clear all
load('c0s_fits_allgoodLangleys_July2016_2-12.mat')
%come up with means of c0s:
for j=1:length(goodlangleys)
    eval(['c0new_all(:,j)=c0new_',goodlangleys{j},'(1,:);']) %2-sigma c0s
    
end
daycolor = {'c'    'r'    'g'    'b'    'k'    'm'    [0.5 0.5 0.5]    [0.2 1 0.8]    [0.9 0.8 0]};
%%%adding c0s between MLO June and November 2016 (cannibalized from
%%%Michal's plotLangleyCompare.m thanks!)
filelistVIS = {'20160823_VIS_C0_refined_Langley_ORACLES_WFF_gnd','20160825_VIS_C0_refined_Langley_ORACLES_transit2_v2','20160910_VIS_C0_refined_Langley_ORACLES2016_gnd'};
filelistNIR = {'20160823_NIR_C0_refined_Langley_ORACLES_WFF_gnd','20160825_NIR_C0_refined_Langley_ORACLES_transit2_v2','20160910_NIR_C0_refined_Langley_ORACLES2016_gnd'};
% 
% % prepare for plotting
% colorlist_ = varycolor(140);
% colorlist  = colorlist_(140:-10:1,:);

%%%mean is JUST of the last MLO set...
c0new_mean=nanmean(c0new_all,2)'; %flip it so its dimensions match the other c0s

for i=1:length(filelistVIS)
    
    tmp = importdata(strcat(starpaths,filelistVIS{:,i},'.dat'));
    wln = tmp.data(:,2);
    lang.(strcat('c0_',filelistVIS{:,i})) = tmp.data(:,3);
    
    tmp = importdata(strcat(starpaths,filelistNIR{:,i},'.dat'));
    wln = tmp.data(:,2);
    lang.(strcat('c0_',filelistNIR{:,i})) = tmp.data(:,3);

    eval(['newORc0s(:,i)=[lang.c0_',filelistVIS{:,i},'; lang.c0_',filelistNIR{:,i},'];'])
    moregoodlangleys{i}=filelistVIS{i}(1:8);
    eval(['c0new_',filelistVIS{i}(1:8),'=[lang.c0_',filelistVIS{:,i},'; lang.c0_',filelistNIR{:,i},']'';'])
end

c0new_all=[c0new_all newORc0s];
goodlangleys=[goodlangleys,moregoodlangleys];

c0new_mean=nanmean(c0new_all,2)'; %flip it so its dimensions match the other c0s
c0new_unc1=2*nanstd(c0new_all,[],2)'; %take the first shot at uncertainty by taking 2-sigma of the variability between the different c0 iterations

%plot all the spectra, one line per Langley
figure;
for j=1:length(goodlangleys)
    eval(['c0new=c0new_',goodlangleys{j},'(1,:);']) %2-sigma c0s
    subplot(2,1,1)
    hold on;
    plot(1000*w(1:length(viscols)),c0new(1:length(viscols)),'-','color',daycolor{j},'linewidth',2)
    subplot(2,1,2)
    hold on;
    plot(1000*w((length(viscols)+1):end),c0new((length(viscols)+1):end),'-','color',daycolor{j},'linewidth',2)
end
subplot(2,1,1); legend(goodlangleys)
set(gca,'fontsize',14); title('C0 VIS'); xlabel('\lambda')
ylim([0 800]); xlim([100 1000])
subplot(2,1,2)
set(gca,'fontsize',14); title('C0 NIR'); xlabel('\lambda')
ylim([0 20])


%a plot just showing the spectrum of the mean
figure; subplot(2,1,1); 
plot(1000*w(1:length(viscols)),c0new_mean(1:length(viscols)),'-','color','k','linewidth',3); hold on
plot(1000*w(1:length(viscols)),c0new_unc1(1:length(viscols)),'--','color','k','linewidth',3)
set(gca,'fontsize',14); title('C0 VIS mean'); xlabel('\lambda')
ylim([0 800]); xlim([100 1000])
subplot(2,1,2)
plot(1000*w((length(viscols)+1):end),c0new_mean((length(viscols)+1):end),'-','color','k','linewidth',3); hold on
plot(1000*w((length(viscols)+1):end),c0new_unc1((length(viscols)+1):end),'--','color','k','linewidth',3)
set(gca,'fontsize',14); title('C0 NIR mean'); xlabel('\lambda')
ylim([0 20])
starsas('c0meanspectrum_MLOtoORACLES2016.fig','plot_Langleys_all.m')
% oldSettings = fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [14 10]);
% print -dpdf c0meanspectrum_072016.pdf



%plot all the spectra NORMALIZED TO MEAN, one line per Langley
figure;
for j=1:length(goodlangleys)
    eval(['c0new=100*(c0new_',goodlangleys{j},'(1,:)-c0new_mean)./c0new_mean;']) %2-sigma c0s.  HERE c0new = *normalized* c0new. Only in this loop.
    subplot(2,1,1)
    hold on;
    plot(1000*w(1:length(viscols)),c0new(1:length(viscols)),'-','color',daycolor{j},'linewidth',2)
    subplot(2,1,2)
    hold on;
    plot(1000*w((length(viscols)+1):end),c0new((length(viscols)+1):end),'-','color',daycolor{j},'linewidth',2)
end
subplot(2,1,1); legend(goodlangleys)
set(gca,'fontsize',14); title('C0 VIS normalized to 6-Langley mean (in %)'); xlabel('\lambda')
ylim([-30 30]); 
xlim([100 1000])
subplot(2,1,2)
set(gca,'fontsize',14); title('C0 NIR normalized to 6-Langley mean (in %)'); xlabel('\lambda')
ylim([-100 100])
starsas('c0spectra_normalizedtoMLOmean_MLOtoORACLES2016.fig','plot_Langleys_all.m')
oldSettings = fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [14 9]);
print -dpdf c0spectra_normalizedtoMLOmean_MLOtoORACLES2016.pdf

%plot THE DIFFERENCE between all the spectra versus the mean spectrum, one line per Langley
figure;
for j=1:length(goodlangleys)
    eval(['c0new=(c0new_',goodlangleys{j},'(1,:)-c0new_mean);']) %2-sigma c0s.  HERE c0new = *normalized* c0new. Only in this loop.
    subplot(2,1,1)
    hold on;
    plot(1000*w(1:length(viscols)),c0new(1:length(viscols)),'-','color',daycolor{j},'linewidth',2)
    subplot(2,1,2)
    hold on;
    plot(1000*w((length(viscols)+1):end),c0new((length(viscols)+1):end),'-','color',daycolor{j},'linewidth',2)
end
subplot(2,1,1); legend(goodlangleys)
set(gca,'fontsize',14); title('C0 VIS difference from 9-Langley mean'); xlabel('\lambda')
ylim([-10 10]); 
xlim([100 1000])
subplot(2,1,2)
set(gca,'fontsize',14); title('C0 NIR difference from 9-Langley mean'); xlabel('\lambda')
% ylim([-100 100])

starsas('c0spectra_differencefrommean_MLOtoORACLES2016.fig','plot_Langleys_all.m')
% oldSettings = fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [14 10]);
% print -dpdf c0spectra_differencefrommean_072016.pdf




%plot all the Langleys (airmass v counts), one color per Langley, one
%subplot per wavelength
% figure; 
% for j=1:length(goodlangleys)
%     eval(['c0new=c0new_',goodlangleys{j},'(1,:);']) %2-sigma c0s
%     eval(['slope=-slope_',goodlangleys{j},'(1,:);']) %NB: switched the negative sign here.
%     eval(['rateaero=rateaero_',goodlangleys{j},';']) %count rate, for the bin i (= at wavelength w(cols(i)) (y axis of scatter)-- *** the saved variables above
%     eval(['m_aero=m_aero_',goodlangleys{j},';']) %airmass (x axis of scatter)
%     
%     for i=1:length(cols)
%     disp([num2str(1000*w(cols(i))),' nm'])
%     subplot(3,5,i); hold on;
%         h=plot(m_aero,log(rateaero(:,cols(i))),'.','color',daycolor{j},'linestyle','none');
%         set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%         plot(0:15,((0:15).*slope(:,cols(i))+log(c0new(:,cols(i)))),'-','color',daycolor{j},'linewidth',2);
%         set(gca,'fontsize',14);
%         title([num2str(1000*w(cols(i))),' nm']); xlabel('airmass'); ylabel('count rate')
%     end
% end
% legend(goodlangleys)
% starsas('Langleys_all072016_multiwavelength.fig','plot_Langleys_all.m')
% % oldSettings = fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [14 10]);
% % print -dpdf Langleys_all072016_multiwavelength.pdf

markershapeses={'.','x','+','^','v','>','<','s','d','p'};


figure; 
colornum=1;
markernum=1;
for i=1:length(cols)
    for j=1:length(goodlangleys)
        eval(['c0new_timeseries_',num2str(floor(1000*w(cols(i)))),'(j)=c0new_',goodlangleys{j},'(1,cols(i));'])
        eval(['c0new_timeseries(j)=c0new_',goodlangleys{j},'(1,cols(i));'])
    end
    plot(c0new_timeseries,'marker',markershapeses{markernum},'color',daycolor{colornum},'linewidth',2); hold on;
    if colornum==(length(daycolor))
        colornum=1;
    else colornum=colornum+1;
    end    
    if markernum==(length(markershapeses))
        markernum=1;
    else markernum=markernum+1;
    end
end
set(gca,'fontsize',14)
legend('353.3nm', '380.0nm', '451.7nm', '500.7nm', '519.9nm', '605.3nm', '675.2nm', '780.6nm', '864.6nm', '941.4nm', '1019.9nm', '1064.2nm', '1235.8nm', '1558.7nm', '1640.3nm')
ax=gca;
set(ax,'XTick',[1:1:length(goodlangleys)]);
xlim([0.7 10.8])
set(ax,'XTickLabel',{'0630','0702AM','0702PM','0703','0704','0705','0823','0825','0910'})
starsas('c0timeseries_Langleys_2016_bywavelength.fig','plot_Langleys_all.m')
% oldSettings = fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [14 10]);
% print -dpdf c0timeseries_Langleys_all072016_bywavelength.pdf


% visfilename=fullfile(starpaths, 'June2016_VIS_C0_mean.dat');
% nirfilename=fullfile(starpaths, 'June2016_NIR_C0_mean.dat');
% source='MLOJune2016';
% additionalnotes='Based on mean of c0s from 20160630, 20160702 (AM+PM), 20160703, 20160704, 20160705.  C0err=2*stdev the variability within these 6 langleys.';
%         starsavec0(visfilename, source, additionalnotes, w(viscols), c0new_mean(viscols), c0new_unc1(:,viscols));
%         starsavec0(nirfilename, source, additionalnotes, w(nircols), c0new_mean(nircols), c0new_unc1(:,nircols));
