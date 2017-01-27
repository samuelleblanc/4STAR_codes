%clear all; plot_Langleys_timeseries_all.m: FOR JUNE MLO through Nov MLO 2016
% what I want to do in this one: 
%  -- c0 spectra for each day compared to each other, including the
%  intermediate transit langleys and stuff.
%modified from: plot_Langleys_all.m


% load('c0s_fits_allLangleys_June2016.mat') % all the fits for the langleys, plus important housekeeping like wavelengths (w) and 
% clear all
mlo1=load('c0s_fits_allgoodLangleys_July2016_1.8-12.mat');
mlo2=load('c0s_Langleysalldata_Nov2016_1.8-12_all.mat');
%come up with means of c0s:
for j=1:length(mlo1.goodlangleys)
    eval(['c0new_all(:,j)=mlo1.c0new_',mlo1.goodlangleys{j},'(1,:);']) %2-sigma c0s
    
end
daycolor = {'c'    'r'    'g'    'b'    'k'    'm'    [0.5 0.5 0.5]    [0.2 1 0.8]    [0.9 0.8 0] [0.5 1 0] [1 0.5 0.2] [0 0.7 0.9] [0.2 0.5 0.7] };
%%%adding c0s between MLO June and November 2016 (cannibalized from
%%%Michal's plotLangleyCompare.m thanks!)
filelistVIS = {'20160823_VIS_C0_refined_Langley_ORACLES_WFF_gnd','20160825_VIS_C0_refined_Langley_ORACLES_transit2_v2','20160910_VIS_C0_refined_Langley_ORACLES2016_gnd'};
filelistNIR = {'20160823_NIR_C0_refined_Langley_ORACLES_WFF_gnd','20160825_NIR_C0_refined_Langley_ORACLES_transit2_v2','20160910_NIR_C0_refined_Langley_ORACLES2016_gnd'};
% 
% % prepare for plotting
% colorlist_ = varycolor(140);
% colorlist  = colorlist_(140:-10:1,:);
goodlangleys=mlo1.goodlangleys;
%%%mean is JUST of the last MLO set...
c0new_mean=nanmean(c0new_all,2)'; %flip it so its dimensions match the other c0s
if exist('filelistVIS')
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

end

beforesize=size(c0new_all,2); %because this is stupid.
for j=(beforesize+1):(beforesize+length(mlo2.goodlangleys))
    eval(['c0new_all(:,j)=mlo2.c0new_',mlo2.goodlangleys{(j-beforesize)},'(1,:);']) %2-sigma c0s
    disp(['j=',num2str(j)])
    disp(mlo2.goodlangleys{(j-beforesize)})
    disp(j-(beforesize))
end

goodlangleys=[goodlangleys,mlo2.goodlangleys];

%NB: now c0new_mean is going to be the average from November MLO, the
%10th-13th (4 langleys; before it went all weird).  We will do a second one from the
%15th-17th (5 langleys, AM+PMs) just to see.
c0new_mean=nanmean(c0new_all(:,10:13),2); %flip it so its dimensions match the other c0s
c0new_unc1=2*nanstd(c0new_all(:,10:13),[],2); %take the first shot at uncertainty by taking 2-sigma of the variability between the different c0 iterations

%
c0new_mean11MLO2=nanmean(c0new_all(:,[15:16,19]),2); %flip it so its dimensions match the other c0s
c0new_unc111MLO2=2*nanstd(c0new_all(:,[15:16,19]),[],2); %take the first shot at uncertainty by taking 2-sigma of the variability between the different c0 iterations
%July MLO trip average
c0new_meanJul=nanmean(c0new_all(:,1:6),2); %flip it so its dimensions match the other c0s
c0new_unc1Jul=2*nanstd(c0new_all(:,1:6),[],2); %take the first shot at uncertainty by taking 2-sigma of the variability between the different c0 iterations


markershapeses={'.','x','+','^','v','>','<','s','d','p'};

cols=mlo1.cols;
w=mlo1.w; %these should be the same for both mlos...


figure; %%%%NORMALIZED FIGURE
colornum=1;
markernum=1;
for i=1:length(cols)
    for j=1:size(c0new_all,2)
        eval(['c0new_timeseries_',num2str(floor(1000*w(cols(i)))),'(j)=c0new_all(cols(i),j);'])
        eval(['c0new_timeseries(j)=c0new_all(cols(i),j);'])
    end
     plot(c0new_timeseries./c0new_mean(cols(i)),'marker',markershapeses{markernum},'color',daycolor{colornum},'linewidth',2); hold on;
%    plot(c0new_timeseries,'marker',markershapeses{markernum},'color',daycolor{colornum},'linewidth',2); hold on;
    if colornum==(length(daycolor))
        colornum=1;
    else colornum=colornum+1;
    end    
    if markernum==(length(markershapeses))
        markernum=1;
    else markernum=markernum+1;
    end
%     errorbar(20.5,c0new_mean(cols(i)),c0new_unc1(cols(i)),'marker','s','color','k','markerfacecolor',daycolor{colornum},'markersize',10) %%FOR REAL VALUES
%     plot(20.5,c0new_mean(cols(i)),'marker','s','color','k','markerfacecolor',daycolor{colornum},'markersize',10) %%FOR PERCENTAGES
%     plot(21.5,c0new_mean11MLO2(cols(i)),'marker','+','color','k','markerfacecolor',daycolor{colornum},'markersize',10) %%FOR PERCENTAGES
end
set(gca,'fontsize',14)
legend('353.3nm', '380.0nm', '451.7nm', '500.7nm', '519.9nm', '605.3nm', '675.2nm', '780.6nm', '864.6nm', '941.4nm', '1019.9nm', '1064.2nm', '1235.8nm', '1558.7nm', '1640.3nm')
ax=gca;
set(ax,'XTick',[1:1:length(goodlangleys)]);
%  title('c0 timeseries, 2016')
 title('c0 timeseries normalized to November mean, first half')
xlim([0.7 21.8])
ylim([0.9 1.1])
grid on
% set(ax,'XTickLabel',{'0630','0702AM','0702PM','0703','0704','0705','0823','0825','0910','1110','1111','1112','1113','1114','1115AM','1115PM','1116AM','1116PM','1117'})%,'Nov(mean,1)','Nov(mean,2)'})
set(ax,'XTickLabel',{'0702AM','0702PM','0703','0704','0705','0707','0823','0825','0910','1110','1111','1112','1113','1114','1115AM','1115PM','1116AM','1116PM','1117'})%,'Nov(mean,1)','Nov(mean,2)'})
%starsas('c0timeseries_Langleys_June-Nov2016_bywavelength.fig','plot_Langleys_all.m')
% oldSettings = fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [14 10]);
% print -dpdf c0timeseries_Langleys_all2016_bywavelength.pdf


figure; %%%ABSOLUTE VALUES FIGURE
colornum=1;
markernum=1;
for i=1:length(cols)
    for j=1:size(c0new_all,2)
        eval(['c0new_timeseries_',num2str(floor(1000*w(cols(i)))),'(j)=c0new_all(cols(i),j);'])
        eval(['c0new_timeseries(j)=c0new_all(cols(i),j);'])
    end
%      plot(c0new_timeseries./c0new_mean(cols(i)),'marker',markershapeses{markernum},'color',daycolor{colornum},'linewidth',2); hold on;
   plot(c0new_timeseries,'marker',markershapeses{markernum},'color',daycolor{colornum},'linewidth',2); hold on;
    if colornum==(length(daycolor))
        colornum=1;
    else colornum=colornum+1;
    end    
    if markernum==(length(markershapeses))
        markernum=1;
    else markernum=markernum+1;
    end
%     errorbar(20.5,c0new_mean(cols(i)),c0new_unc1(cols(i)),'marker','s','color','k','markerfacecolor',daycolor{colornum},'markersize',10) %%FOR REAL VALUES
%     plot(20.5,c0new_mean(cols(i)),'marker','s','color','k','markerfacecolor',daycolor{colornum},'markersize',10) %%FOR PERCENTAGES
%     plot(21.5,c0new_mean11MLO2(cols(i)),'marker','+','color','k','markerfacecolor',daycolor{colornum},'markersize',10) %%FOR PERCENTAGES
end
set(gca,'fontsize',14)
legend('353.3nm', '380.0nm', '451.7nm', '500.7nm', '519.9nm', '605.3nm', '675.2nm', '780.6nm', '864.6nm', '941.4nm', '1019.9nm', '1064.2nm', '1235.8nm', '1558.7nm', '1640.3nm')
ax=gca;
set(ax,'XTick',[1:1:length(goodlangleys)]);
%  title('c0 timeseries, 2016')
 title('c0 timeseries')
xlim([0.7 21.8])
grid on
% set(ax,'XTickLabel',{'0630','0702AM','0702PM','0703','0704','0705','0823','0825','0910','1110','1111','1112','1113','1114','1115AM','1115PM','1116AM','1116PM','1117'})%,'Nov(mean,1)','Nov(mean,2)'})
set(ax,'XTickLabel',{'0702AM','0702PM','0703','0704','0705','0707','0823','0825','0910','1110','1111','1112','1113','1114','1115AM','1115PM','1116AM','1116PM','1117'})%,'Nov(mean,1)','Nov(mean,2)'})
starsas('c0timeseries_Langleys_June-Nov2016_final_bywavelength.fig','plot_Langleys_timeseries_all.m')
oldSettings = fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [21 13]);
print -dpdf c0timeseries_Langleys_all2016_final_bywavelength.pdf



viscols=1:1044;
            nircols=1044+(1:512);
source='MLONov2016';
% visfilename=fullfile(starpaths, 'Nov2016part1_good_VIS_C0_mean.dat');
% nirfilename=fullfile(starpaths, 'Nov2016part1_good_NIR_C0_mean.dat');
% additionalnotes='Based on mean of the c0s from 20161110, 20161111, 20161112, and 20161113, which was before the weird drop and spectro issues we saw.  C0err=2*stdev the variability within these 4 langleys.';
%         starsavec0(visfilename, source, additionalnotes, w(viscols), c0new_mean(viscols)', c0new_unc1(:,viscols));
%         starsavec0(nirfilename, source, additionalnotes, w(nircols), c0new_mean(nircols)', c0new_unc1(:,nircols));

%         visfilename=fullfile(starpaths, 'Nov2016part2_nogood_VIS_C0_mean.dat');
%         nirfilename=fullfile(starpaths, 'Nov2016part2_nogood_NIR_C0_mean.dat');
% additionalnotes='Based on mean of the c0s from 20161115AM, 20161115PM, and 20161117, which was after the weirdness started on the 14th, and excludes the 16th, where both AM and PM had VIS issues.  C0err=2*stdev the variability within these 3 langleys.';
%         starsavec0(visfilename, source, additionalnotes, w(viscols), c0new_mean11MLO2(viscols), c0new_unc111MLO2(:,viscols));
%         starsavec0(nirfilename, source, additionalnotes, w(nircols), c0new_mean11MLO2(nircols), c0new_unc111MLO2(:,nircols));
