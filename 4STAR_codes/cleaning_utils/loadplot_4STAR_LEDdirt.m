%loadplot_4STAR_LEDdirt.m

warning('For use on John''s computer only')

% JML August 2013

clear
close all

flag_spectral_movie='yes';
flag_spectral_movie_bkgd_subt='yes';

datestr_4STAR=['20130807';'20130809';'20130813';'20130815';'20130818';'20130820';'20130826';'20130827';...
    '20130901';'20130903';'20130905';'20130908';'20130910';'20130912';'20130915';'20130917';'20130920';...
    '20130922';'20130929';'20130930';'20140227'];
%    [...............................2013..............................] [..........2014...........]  
%       Aug7  9 13 15 18 20 26 27 Sep01 03 05 08 10 12 15 17 20 22 29 30 Feb22
idateproc=[0  0  0  0  0  0  0  0     0  0  0  0  0  0  0  0  0  0  0  0     1];
direc_4STARdata='c:\johnmatlab\4STAR\data\';
filenamein=[datestr_4STAR(idateproc==1,:) 'LEDFORJstar.mat'];
filemat_4STAR=[direc_4STARdata filenamein];

load(filemat_4STAR);

cross_sections=load(fullfile(starpaths, 'cross_sections_uv_vis_swir_all.mat'));
wvlnm_xsect_VIS=cross_sections.wln(1:1044);

[yy mm dd hh mm ss]=datevec(vis_forj.t);
UTdechr=hh+mm/60.+ss/3600;
hhmmss= fix(10000*hh+100*mm+ss);

% vis_forj = 
% 
%              t: [1320x1 double]
%            raw: [1320x1044 double]
%            Str: [1320x1 double]
%             Md: [1320x1 double]
%             Zn: [1320x1 double]
%            Lat: [1320x1 double]
%            Lon: [1320x1 double]
%            Alt: [1320x1 double]
%         Headng: [1320x1 double]
%          pitch: [1320x1 double]
%           roll: [1320x1 double]
%            Tst: [1320x1 double]
%            Pst: [1320x1 double]
%             RH: [1320x1 double]
%         AZstep: [1320x1 double]
%         Elstep: [1320x1 double]
%         AZ_deg: [1320x1 double]
%         El_deg: [1320x1 double]
%          QdVlr: [1320x1 double]
%          QdVtb: [1320x1 double]
%         QdVtot: [1320x1 double]
%         AZcorr: [1320x1 double]
%         ELcorr: [1320x1 double]
%           Tbox: [1320x1 double]
%        Tprecon: [1320x1 double]
%       RHprecon: [1320x1 double]
%       Vdettemp: [1320x1 double]
%           Tint: [1320x1 double]
%            AVG: [1320x1 double]
%         header: {1x9 cell}
%     row_labels: {[1x7481 char]}
%       filename: {'C:\johnmatlab\4STAR\raw\2013_08_07_4STAR_LEDFORJ\20130807_039_VIS_FORJ.dat'}
%          filen: [1320x1 double]
%           note: 'Consolidated on 2013-08-08 04:26:56 using allstarmat.m.'

switch datestr_4STAR(idateproc==1,:)
    case '20130807'
        idxdirty=[5 118]; %8/7
        idxclean=[396 480]; %8/7
    case '20130809'
        idxdirty=[550 760]; %8/9
        idxclean=[1781 1799]; %8/9
    case '20130813'
        idxdirty=[310 359]; 
        idxclean=[530 630]; 
    case '20130815'
        idxdirty=[300 360]; %8/15
        idxclean=[610 760]; %8/15
    case '20130818'
        idxdirty=[10 220]; %8/18
        idxclean=[505 600]; %8/18
    case '20130820'
        idxdirty=[200 287]; %8/18
        idxclean=[1220 1320]; %8/18
    case '20130826'
        idxdirty=[300 520]; %8/26
        idxclean=[1160 1303]; %8/26 be careful...must stop at 1303
    case '20130827'
        idxdirty=[300 505]; %8/27
        idxclean=[1100 1300]; %8/27
    case '20130901'
        idxdirty=[]; %
        idxclean=[]; %
    case '20130903'
        idxdirty=[250 310]; %9/03
        idxclean=[750 913]; %9/03
    case '20130905'
        idxdirty=[500 690]; %9/05
        idxclean=[1150 1320]; %9/05
    case '20130908'
        idxdirty=[]; %
        idxclean=[]; %
    case '20130910'
        idxdirty=[]; %
        idxclean=[]; %
    case '20130912'
        idxdirty=[]; %
        idxclean=[]; %
    case '20130915'
        idxdirty=[350 495]; %9/15
        idxclean=[562 588]; %9/15
    case '20130917'
        idxdirty=[3400 3745]; %9/17
        idxclean=[3751 3856]; %9/17
    case '20130920'
        idxdirty=[1700 1897]; %9/20
        idxclean=[1902 2007]; %9/20
    case '20130922'
        idxdirty=[650 803]; %9/22
        idxclean=[809 837]; %9/22
    case '20130929'
        idxdirty=[50 219]; %9/29
        idxclean=[478 630]; %9/29
    case '20130930'
        idxdirty=[]; %
        idxclean=[]; %
    case '20140227'
        idxdirty=[1500 1600]; %
        idxclean=[1500 1600]; %        
end

%Search raw signal data for location,value of short and long wvl max and short wvl min
for i=1:length(UTdechr),
    [smax300400(i),idxmax]=max(vis_forj.raw(i,300:400));
    imaxp300400(i)=idxmax+299;
    [smin300400(i),idxmin]=min(vis_forj.raw(i,300:400));
    iminp300400(i)=idxmin+299;
    [smax500600(i),idxmax]=max(vis_forj.raw(i,500:600));
    imaxp500600(i)=idxmax+499;
end

figure(201)
ax1=subplot(2,1,1);
plot([1:length(UTdechr)],imaxp300400,'r.')
hold on
plot([1:length(UTdechr)],iminp300400,'b.')
plot([1:length(UTdechr)],imaxp500600,'g.')
set(gca,'fontsize',14)
grid on
%xlabel('Record Number','fontsize',14)
ylabel('Pixel Index','fontsize',14)
title(filenamein,'fontsize',14)
ax2=subplot(2,1,2);
plot([1:length(UTdechr)],smax300400,'r.')
hold on
plot([1:length(UTdechr)],smin300400,'b.')
plot([1:length(UTdechr)],smax500600,'g.')
set(gca,'fontsize',14)
grid on
xlabel('Record Number','fontsize',14)
ylabel('Signal','fontsize',14)
linkaxes([ax1 ax2],'x')

wvl_nm=1000*[0.4518 0.5008 0.6753 0.7806 0.8645];
pixidx=[346 407 626 760 868];
idxwvl=pixidx+1;
legstr=[];
for i=1:length(wvl_nm),
    legstr=[legstr;sprintf('%5.1f',wvl_nm(i))];
end
figure(101)
plot(UTdechr,vis_forj.raw(:,idxwvl),'.')
hold on
ylimval=get(gca,'ylim')
plot([UTdechr(idxdirty(1)) UTdechr(idxdirty(1))],[ylimval(1) ylimval(2)],'k--')
plot([UTdechr(idxdirty(2)) UTdechr(idxdirty(2))],[ylimval(1) ylimval(2)],'k--')
plot([UTdechr(idxclean(1)) UTdechr(idxclean(1))],[ylimval(1) ylimval(2)],'k--')
plot([UTdechr(idxclean(2)) UTdechr(idxclean(2))],[ylimval(1) ylimval(2)],'k--')
grid on
set(gca,'fontsize',16)
ylabel('Detector counts','fontsize',20)
xlabel('UT [hr]','fontsize',20)
hleg=legend(legstr);
set(hleg,'fontsize',14)
title(datestr_4STAR(idateproc==1,:))

idxpixspec=[300:10:400];
legstr102=[];
for i=1:length(idxpixspec),
    legstr102=[legstr102;sprintf('%3d',idxpixspec(i))];
end
figure(102)
plot(UTdechr,vis_forj.raw(:,idxpixspec),'.')
hold on
ylimval=get(gca,'ylim')
plot([UTdechr(idxdirty(1)) UTdechr(idxdirty(1))],[ylimval(1) ylimval(2)],'k--')
plot([UTdechr(idxdirty(2)) UTdechr(idxdirty(2))],[ylimval(1) ylimval(2)],'k--')
plot([UTdechr(idxclean(1)) UTdechr(idxclean(1))],[ylimval(1) ylimval(2)],'k--')
plot([UTdechr(idxclean(2)) UTdechr(idxclean(2))],[ylimval(1) ylimval(2)],'k--')
grid on
set(gca,'fontsize',16)
ylabel('Detector counts for selected pixels','fontsize',20)
xlabel('UT [hr]','fontsize',20)
hleg=legend(legstr102);
set(hleg,'fontsize',14)
title(datestr_4STAR(idateproc==1,:))

figure(103)
%subplot(2,1,1)
plot([1:length(UTdechr)],vis_forj.raw(:,idxwvl),'.')
hold on
ylimval=get(gca,'ylim')
plot([idxdirty(1) idxdirty(1)],[ylimval(1) ylimval(2)],'k--')
plot([idxdirty(2) idxdirty(2)],[ylimval(1) ylimval(2)],'k--')
plot([idxclean(1) idxclean(1)],[ylimval(1) ylimval(2)],'k--')
plot([idxclean(2) idxclean(2)],[ylimval(1) ylimval(2)],'k--')
grid on
set(gca,'fontsize',16)
ylabel('Detector counts','fontsize',20)
xlabel('Record Number','fontsize',20)
hleg=legend(legstr);
set(hleg,'fontsize',14)
title(datestr_4STAR(idateproc==1,:))

%stophere153

%calculate mean,sd before and after cleaning
meansignal_dirty=mean(vis_forj.raw(idxdirty(1):idxdirty(2),:),1);
sdsignal_dirty=std(vis_forj.raw(idxdirty(1):idxdirty(2),:),0,1);
meansignal_clean=mean(vis_forj.raw(idxclean(1):idxclean(2),:),1);
sdsignal_clean=std(vis_forj.raw(idxclean(1):idxclean(2),:),0,1);
ratio_dirty_to_clean=meansignal_dirty./meansignal_clean;
relsd_dirty=sdsignal_dirty./meansignal_dirty;
relsd_clean=sdsignal_clean./meansignal_clean;

figure(104)
ax1=subplot(2,1,1);
plot([0:1043],meansignal_dirty,'r.')
hold on
plot([0:1043],meansignal_clean,'b.')
grid on
set(gca,'fontsize',16)
ylabel('Mean signal','fontsize',20)
hleg=legend('before cleaning','after cleaning ');
set(hleg,'fontsize',14)
ax2=subplot(2,1,2);
plot([0:1043],ratio_dirty_to_clean,'.')
grid on
set(gca,'fontsize',16)
ylabel('Signal ratio: dirty to clean','fontsize',20)
xlabel('pixel','fontsize',20)
linkaxes([ax1 ax2],'x')

figure(106)
ax1=subplot(3,1,1);
plot([0:1043],meansignal_dirty,'r.')
hold on
plot([0:1043],meansignal_clean,'b.')
grid on
set(gca,'fontsize',16)
set(gca,'xlim',[0 1000]);
ylabel('Mean signal','fontsize',20)
hleg=legend('before cleaning','after cleaning ');
set(hleg,'fontsize',14)
ax2=subplot(3,1,2);
plot([0:1043],sdsignal_dirty,'r.')
hold on
plot([0:1043],sdsignal_clean,'b.')
grid on
set(gca,'fontsize',16)
set(gca,'xlim',[0 1000]);
ylabel('absolute sd','fontsize',20)
ax3=subplot(3,1,3);
plot([0:1043],relsd_dirty,'r.')
hold on
plot([0:1043],relsd_clean,'b.')
grid on
set(gca,'fontsize',16)
set(gca,'xlim',[0 1000],'ylim',[0 0.08]);
ylabel('relative sd','fontsize',20)
xlabel('pixel','fontsize',20)
linkaxes([ax1 ax2 ax3],'x')


wvlplim=[400 850];
ratiolim=[0.97 1.02];
dratio=0.01;
figure(107)
ax1=subplot(2,1,1);
plot(wvlnm_xsect_VIS,meansignal_dirty,'r.')
hold on
plot(wvlnm_xsect_VIS,meansignal_clean,'b.')
grid on
set(gca,'fontsize',16)
set(gca,'xlim',wvlplim)
ylabel('Mean signal [counts]','fontsize',20)
hleg=legend('before window cleaning','after window cleaning ');
set(hleg,'fontsize',16)
title(filenamein,'fontsize',14)
ax2=subplot(2,1,2);
plot(wvlnm_xsect_VIS,ratio_dirty_to_clean,'.')
hold on
plot(wvlplim,[1 1],'g-','linewidth',3)
grid on
set(gca,'fontsize',16)
set(gca,'xlim',wvlplim)
set(gca,'ylim',ratiolim,'ytick',[ratiolim(1):dratio:ratiolim(2)])
ylabel('Signal ratio: dirty to clean','fontsize',20)
xlabel('Wavelength [nm]','fontsize',20)
linkaxes([ax1 ax2],'x')

%filewrite=[direc_4STARdata '0807LEDwindowcleandata.mat'];
%save(filewrite) wvlnm_xsect_VIS meansignal_dirty meansignal_clean,ratio_dirty_to_clean)

%%
if strcmp(flag_spectral_movie,'yes')
    secpause=0.01;
    %idxtimelim=[10 100];
    %idxtimelim=[1 length(UTdechr)];
    idxtimelim=[1500 1600];
%     timeuse=find(UTdechr>=22.5 & UTdechr<=(22+39/60));
%     idxtimelim=[timeuse(1) timeuse(end)];
    ivltime=1;%1;
    jpixplt=[300:400];%[1:1044];%[300:400];%[1:1044];
    figure(203)
    for iobs=idxtimelim(1):ivltime:idxtimelim(2),
        subplot(2,1,1)
        hold off
        plot(jpixplt,vis_forj.raw(iobs,jpixplt),'.')
        hold on
        plot(jpixplt,meansignal_dirty(jpixplt),'rx')
        set(gca,'xlim',[jpixplt(1) jpixplt(end)]);
        set(gca,'ylim',[0 inf])
        grid on
        xlabel('Pixel','FontSize',14);
        ylabel('Signal (counts)','FontSize',14)
        set(gca,'FontSize',14)
        title(sprintf('date:%s   rec:%4d   UT:%7.3f  %6i',datestr_4STAR(idateproc==1,:),iobs,UTdechr(iobs),hhmmss(iobs)),'fontsize',14);
        subplot(2,1,2)
        hold off
        plot(jpixplt,100*(vis_forj.raw(iobs,jpixplt)-meansignal_dirty(jpixplt))./vis_forj.raw(iobs,jpixplt),'.')
        set(gca,'xlim',[jpixplt(1) jpixplt(end)]);
        set(gca,'ylim',[-2 2],'ytick',[-2:1:2])
        grid on
        xlabel('Pixel','FontSize',14);
        ylabel('Relative diff (pct)','FontSize',14)
        set(gca,'FontSize',14)
        if secpause<0
            pause
        else
            pause(secpause)
        end
    end
end

%%
if strcmp(flag_spectral_movie_bkgd_subt,'yes')
    secpause=0.01;
    %idxtimelim=[10 100];
    idxtimelim=[1 length(UTdechr)];
    idxtimelim=[1500 length(UTdechr)];
    timeuse=find(UTdechr>=22.5 & UTdechr<=(22+39/60));
    idxtimelim=[timeuse(1) timeuse(end)];
    ivltime=1;%1;
    jpixplt=[300:400];%[1:1044];%[300:400];%[1:1044];
    jrecmean=find(UTdechr>=22.515&UTdechr<=22.52);
    meansignal_new=mean(vis_forj.raw(jrecmean,:),1);
    sdsignal_new=std(vis_forj.raw(jrecmean,:),0,1);
    relsd_new=sdsignal_new./meansignal_new;
    
    figure(303)
    for iobs=idxtimelim(1):ivltime:idxtimelim(2),
        subplot(2,1,1)
        hold off
        plot(jpixplt,vis_forj.raw(iobs,jpixplt)-meansignal_new(jpixplt),'.')
        set(gca,'xlim',[jpixplt(1) jpixplt(end)]);
        set(gca,'ylim',[-350 300])
        grid on
        xlabel('Pixel','FontSize',14);
        ylabel('Signal - mean (counts)','FontSize',14)
        set(gca,'FontSize',14)
        title(sprintf('date:%s   rec:%4d   UT:%7.3f  %6i',datestr_4STAR(idateproc==1,:),iobs,UTdechr(iobs),hhmmss(iobs)),'fontsize',14);
        subplot(2,1,2)
        hold off
        plot(jpixplt,100*(vis_forj.raw(iobs,jpixplt)-meansignal_new(jpixplt))./vis_forj.raw(iobs,jpixplt),'.')
        set(gca,'xlim',[jpixplt(1) jpixplt(end)]);
        set(gca,'ylim',[-10 10])
        grid on
        xlabel('Pixel','FontSize',14);
        ylabel('Relative diff (pct)','FontSize',14)
        set(gca,'FontSize',14)
        if secpause<0
            pause
        else
            pause(secpause)
        end
    end
end