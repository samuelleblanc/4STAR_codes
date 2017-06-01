%plot_AATS_4STAR_compare.m
clear
close all
asktopause=true;
calculate_again=true;

corstr='_corr';
corstr='';
%dateprocstr='20140416';
%dateprocstr='20140428';
%dateprocstr='20140502';
%dateprocstr='20140407';
dateprocstr='20150113';
dateprocstr='20170526';
%dateprocstr='20150114';
%dateprocstr='20130708';
instrumentname = '4STAR'

title0 = 'MLO';

stardir=['C:\Users\sleblan2\Research\4STAR\roof\' dateprocstr '\'];
stardir = 'C:\Users\sleblan2\Research\MLO\2017_May\';

time_to_norm=20.2

UTlim=[16.1 19.7];
templim=[10 40];
ratlim=[0.95 1.05];
%ratlim=[0.018,0.022];

dd='C:\Users\sleblan2\Research\AATS\figs\';%'~/AATS/figs/';
dd = 'C:\Users\sleblan2\Research\MLO\2017_May\figs\';

fs = [stardir dateprocstr instrumentname 'toaats.mat'];
myColorOrder=[0 1 1; 0.6 0.8 1.0; 0 0 1; 0.6 1.0 0.6; 0 1 0; 0.5 0.6 0.0; 1 0 1; 1 0 0; 0.5 0.1 0.7; 0 0 0];

if ~exist(fs)|calculate_again;
    %[vis_sun, nir_sun, aats]=staraatscompare_John(dateprocstr)
    if ~exist('vis_sun');
        [vis_sun, nir_sun, aats]=staraatscompare(dateprocstr);
    end;
    
    [daystr, filen, datatype, instrumentname]=starfilenames2daystr(vis_sun.filename);
    
    UTdechr=timeMatlab_to_UTdechr(vis_sun.t);
    UTdechr_AATS=timeMatlab_to_UTdechr(aats.t);
    [nul,inorm] = min(abs(UTdechr-time_to_norm))
    
    for i=1:14;
        rr(:,i)=vis_sun.raterelativeratiorangetoaats(:,i)./vis_sun.raterelativeratiorangetoaats(inorm,i);
        rar(:,i)=vis_sun.raterelativeratiotoaats(:,i)./vis_sun.raterelativeratiotoaats(inorm,i);
    end;
    
    vis_sun.raterelativeratiorangetoaats=rr;
    vis_sun.raterelativeratiotoaats=rar;
    
    % 0.3535  0.3800  0.4520  0.5005  0.5204  0.6052  0.6751  0.7805  0.8645  0.9410  1.0191  1.2356  1.5585  2.1391
    
    %set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
    if ~strcmp(instrumentname,'2STAR');
        %% load track from day
        disp(['loading star.mat file for ' dateprocstr]);
        fpp = [stardir dateprocstr 'star' corstr '.mat'];
        if ~exist(fpp)
            [fns,pns] = uigetfile2(starpaths,[instrumentname ' star.mat'],['*' instrumentname '*' dateprocstr 'star*.mat'])
            fpp = [pns,fns];
        end
        load(fpp,'track');
        
        %% Save output
        disp(['Saving file to: ' fs])
        save(fs,'nir_sun','vis_sun','track','aats','instrumentname','program_version','-v7.3');
    else;
        %% Save output
        disp(['Saving file to: ' fs])
        save(fs,'nir_sun','vis_sun','aats','instrumentname','program_version','-v7.3');
    end;
else;
    disp(['Loading comparison file name: ' fs])
    load(fs);
    
    [daystr, filen, datatype, instrumentname]=starfilenames2daystr(vis_sun.filename);
    UTdechr=timeMatlab_to_UTdechr(vis_sun.t);
    UTdechr_AATS=timeMatlab_to_UTdechr(aats.t);
end;
%stophere

if ~strcmp(instrumentname,'2STAR');
    idxwvlvisp=[0 0 1 1 1 1 1 1 1 0 1 1 1];
    end_num = 13;
else;
    idxwvlvisp=[0 0 1 1 1 1 1 1 1 1];
    end_num = 10;
end;
%UTlim=[22.5 23];%20.1];
%UTlim=[16 21.5];%20.1];

figure(20);
ax1 = subplot(1,1,1);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.raterelativeratiorangetoaats(:,idxwvlvisp==1), '.');
hx = graph2d.constantline(time_to_norm);
changedependvar(hx,'x');
lstr=[]; lstrc={};
for i=1:end_num; %:-1:1,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        lstrc = {lstrc{:},sprintf('%6.1f',1000*aats.w(i))};
    end
end
colormap(myColorOrder(1:length(lstr),:));
lcolorbar(lstrc)
%lh=legend(lstr,'location','bestoutside');
%set(lh,'fontsize',16,'location','east');
ylim([0.92 1.05]);
%xlim(UTlim);
set(gca,'fontsize',16);
grid on;
ylabel([instrumentname '/AATS'],'fontsize',20);
titlestr=sprintf([title0 ' %s range of wvl rates/V normalized at %2.1f h'],dateprocstr,time_to_norm);
title(titlestr);
save_fig(20,[dd dateprocstr '_aatsto' instrumentname '_normalizedratio_wvlrange']);

figure(19);
ax1 = subplot(1,1,1);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.');
hx = graph2d.constantline(time_to_norm);
changedependvar(hx,'x');
lstr=[]; lstrc={};
for i=1:end_num; %:-1:1,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        lstrc = {lstrc{:},sprintf('%6.1f',1000*aats.w(i))};
    end
end
colormap(myColorOrder(1:length(lstr),:));
lcolorbar(lstrc)
%lh=legend(lstr,'location','bestoutside');
%set(lh,'fontsize',16,'location','east');
ylim([0.92 1.05]);
%xlim(UTlim);
set(gca,'fontsize',16);
grid on;
ylabel([instrumentname '/AATS'],'fontsize',20);
titlestr=sprintf([title0 ' %s single wvl rates/V normalized at %2.1f h'],dateprocstr,time_to_norm);
title(titlestr);
save_fig(19,[dd dateprocstr '_aatsto' instrumentname '_normalizedratio']);


figure(21);
ax1 = subplot(1,1,1);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.dtau_aero(:,idxwvlvisp==1), '.');
hx = graph2d.constantline(time_to_norm);
changedependvar(hx,'x');
lstr=[]; lstrc={};
for i=1:end_num;
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        lstrc = {lstrc{:},sprintf('%6.1f',1000*aats.w(i))};
    end
end
colormap(myColorOrder(1:length(lstr),:));
lcolorbar(lstrc)
%lh=legend(lstr,'location','bestoutside');
%set(lh,'fontsize',16,'location','east');
%ylim([0.92 1.05]);
%xlim(UTlim);
set(gca,'fontsize',16);
grid on;
ylabel([instrumentname '-AATS'],'fontsize',20);
titlestr=sprintf([title0 ' %s tau difference'],dateprocstr);
title(titlestr);
save_fig(21,[dd dateprocstr '_aatsto' instrumentname '_dtau']);

figure(22);
ax1 = subplot(1,1,1);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.trratio(:,idxwvlvisp==1), '.');
lstr=[]; lstrc={};
for i=1:end_num;
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        lstrc = {lstrc{:},sprintf('%6.1f',1000*aats.w(i))};
    end
end
colormap(myColorOrder(1:length(lstr),:));
lcolorbar(lstrc)
%lh=legend(lstr,'location','bestoutside');
%set(lh,'fontsize',16,'location','east');
ylim([0.92 1.05]);
%xlim(UTlim);
set(gca,'fontsize',16);
grid on;
ylabel([instrumentname '/AATS'],'fontsize',20);
titlestr=sprintf([title0 ' %s Ratio of transmittances'],dateprocstr);
title(titlestr);
save_fig(22,[dd dateprocstr '_aatsto' instrumentname '_ratiotr']);


%% figure with ratios and airmasses and temperature
figure(11);
ax1=subplot(3,1,1);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.');
hx = graph2d.constantline(time_to_norm);
changedependvar(hx,'x');
%lstr=setspectrumcolor(h, aats.w);
%lh=legend(h,lstr);
lstr=[];
for i=1:end_num,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
    end
end
lh=legend(lstr);
set(lh,'fontsize',16,'location','east');
ylim([0.92 1.05]);
xlim(UTlim);
%datetick('x','keeplimits')
%ggla;
set(gca,'fontsize',16);
grid on;
%set(h([1 2 10:13]),'markersize',1,'visible','off');
ylabel([instrumentname '/AATS'],'fontsize',20);
titlestr=sprintf([title0 ' %s'],dateprocstr);
title(titlestr,'fontsize',16);
%
% ax2=subplot(3,1,2)
% h2=plot(vis_sun.t,vis_sun.AZ_deg,'b.')
% datetick('x','keeplimits')
% %ggla;
% set(gca,'fontsize',16)
% grid on;
% ylabel('4STAR Azimuth [deg]','fontsize',16)
ax3=subplot(3,1,2);
h2=plot(UTdechr,vis_sun.m_aero,'r.');
hold on;
h2=plot(UTdechr,vis_sun.m_ray,'g.');
set(gca,'ylim',[0 15],'ytick',[0:2:15]);
set(gca,'fontsize',16);
grid on;
xlim(UTlim);
ylabel('Airmass','fontsize',20);
hleg3=legend('maero','mray ');
set(hleg3,'fontsize',14);
%xlabel('UT [hr]','fontsize',20);
%linkaxes([ax1 ax2 ax3],'x')

ax4=subplot(3,1,3);
hrs=timeMatlab_to_UTdechr(track.t);
%temp=boxxfilt();
bl=60/86400;
temp1=boxxfilt(track.t,track.T1,bl);
h3=plot(hrs,temp1,'b-');
set(gca,'ylim',[15 40],'ytick',[15:5:40]);
ylabel('Temperature (^oC)','fontsize',20);
xlabel('UT [hr]','fontsize',20);
linkaxes([ax1 ax3 ax4],'x');

set(gcf, 'Units', 'pixels', 'Position', [0, 0, 1300, 900], 'PaperUnits', 'Inches', 'PaperSize', [10.5, 7.25])

save_fig(11,[dd dateprocstr 'aats4star_temp' corstr]);

%%
%% plot the raw counts from the AATS and 4STAR
%%
if 0 ;
    figure;
    % the 4STAR data
    axx1=subplot(2,1,1);
    set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
    h=plot(UTdechr_AATS,aats.starvisrate(:,idxwvlvisp==1), '.');
    %lstr=setspectrumcolor(h, aats.w);
    %lh=legend(h,lstr);
    lstr=[];
    for i=1:13,
        if idxwvlvisp(i)==1,
            lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        end
    end
    lh=legend(lstr);
    set(lh,'fontsize',16,'location','best');
    %ylim([0.94 1.02]);
    xlim(UTlim);
    %datetick('x','keeplimits')
    %ggla;
    set(gca,'fontsize',16);
    grid on;
    %set(h([1 2 10:13]),'markersize',1,'visible','off');
    ylabel([instrumentname ' [counts/ms]'],'fontsize',20);
    titlestr=sprintf([title0 ' %s'],dateprocstr);
    title(titlestr,'fontsize',16);
    
    %% Now for the aats data
    axx2=subplot(2,1,2);
    set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
    h=plot(UTdechr_AATS,aats.data(:,idxwvlvisp==1), '.');
    lstr=[];
    for i=1:13,
        if idxwvlvisp(i)==1,
            lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        end
    end
    lh=legend(lstr);
    set(lh,'fontsize',16,'location','best');
    %ylim([0.94 1.02]);
    xlim(UTlim);
    set(gca,'fontsize',16);
    grid on;
    %set(h([1 2 10:13]),'markersize',1,'visible','off');
    ylabel('AATS [Volts]','fontsize',20);
    %titlestr=sprintf('Ames  %s',dateprocstr);
    %title(titlestr,'fontsize',16);
    xlabel('UT [hr]','fontsize',20);
    linkaxes([axx1 axx2],'x');
    
    if asktopause
        OK =menu('continue or exit?','Continue','Exit')
        if OK==2
            return
        end
    end
    hgsave([dd dateprocstr 'aats4star_raw' corstr]);
end;

%%
%% plot the raw counts from the AATS and 4STAR
%%
if 0;
    figure;
    % the 4STAR data
    axx1=subplot(2,1,1);
    set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
    for j=1:13;
        aats.norm_star(:,j)=aats.starvisrate(:,j)./aats.starvisrate(15000,j);
    end;
    h=plot(UTdechr_AATS,aats.norm_star(:,idxwvlvisp==1), '.');
    %lstr=setspectrumcolor(h, aats.w);
    %lh=legend(h,lstr);
    lstr=[];
    for i=1:13,
        if idxwvlvisp(i)==1,
            lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        end
    end
    lh=legend(lstr);
    set(lh,'fontsize',16,'location','best');
    ylim([0.34 1.02]);
    xlim(UTlim);
    %datetick('x','keeplimits')
    %ggla;
    set(gca,'fontsize',16);
    grid on;
    %set(h([1 2 10:13]),'markersize',1,'visible','off');
    ylabel([instrumentname ' [Normalized]'],'fontsize',20);
    titlestr=sprintf([title0 ' %s'],dateprocstr);
    title(titlestr,'fontsize',16);
    
    %% Now for the aats data
    axx2=subplot(2,1,2);
    set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
    
    for j=1:13,
        aats.norm_data(:,j)=aats.data(:,j)./aats.data(15000,j);
    end;
    h=plot(UTdechr_AATS,aats.norm_data(:,idxwvlvisp==1), '.');
    lstr=[];
    for i=1:13,
        if idxwvlvisp(i)==1,
            lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        end
    end
    %lh=legend(lstr);
    %set(lh,'fontsize',16,'location','best');
    ylim([0.34 1.02]);
    xlim(UTlim);
    set(gca,'fontsize',16);
    grid on;
    %set(h([1 2 10:13]),'markersize',1,'visible','off');
    ylabel('AATS [Normalized]','fontsize',20);
    %titlestr=sprintf('Ames  %s',dateprocstr);
    %title(titlestr,'fontsize',16);
    xlabel('UT [hr]','fontsize',20);
    linkaxes([axx1 axx2],'x');
    save_fig(gcf(),[dd dateprocstr 'aats4star_normraw' corstr]);
end;


%%
%% plot ratio of the AATS and 4STAR time series with legend outside compared to temperature (T1)
%%
if 1;
    figure(12);
    % the 4STAR data
    axx1=subplot(2,1,1);
    set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
    %for j=1:13,
    %  for i=1:size(vis_sun.m_aero);
    %  vis_sun.rate_rel_aats_by_m(i,j)=vis_sun.raterelativeratiotoaats(i,j)/vis_sun.m_aero(i);
    %  end;
    %end;
    
    h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.','MarkerSize',10);
    
    %h2=plot(UTdechr,vis_sun.m_aero,'r.');
    
    %lstr=setspectrumcolor(h, aats.w);
    %lh=legend(h,lstr);
    lstr=[];
    for i=1:13,
        if idxwvlvisp(i)==1,
            lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
        end
    end
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 11.5, 7.25], 'PaperUnits', 'Inches', 'PaperSize', [11.5, 7.25])
    lh=legend(lstr);
    %set(lh,'fontsize',16,'location','eastoutside');
    ylim(ratlim);
    xlim(UTlim);
    set(gca,'fontsize',16);
    grid on;
    %set(h([1 2 10:13]),'markersize',1,'visible','off');
    ylabel([instrumentname '/AATS'],'fontsize',20);
    titlestr=sprintf([title0 ' %s'],dateprocstr);
    title(titlestr,'fontsize',16);
    
    
    axx2=subplot(2,1,2);
    h3=plot(hrs,temp1,'b-');
    set(gca,'ylim',templim);
    ylabel('Temperature (^oC)','fontsize',20);
    xlabel('UT [hr]','fontsize',20);
    linkaxes([axx1 axx2],'x');
    set(lh,'fontsize',16,'location','east');
    
    save_fig(12,[dd dateprocstr 'aats4star_ratio_timeseries' corstr]);
end;


stophere
%
%plot the scatter plots with the color of the points indicating the well depth of the pixel
%
figure(13);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
ji=true;
sym=['+','o','*','.','X','s','d','^','V','>','<','p','h'];

for j=1:size(idxwvlvisp,2);
    if idxwvlvisp(j)==1;
        h=scatter(UTdechr, vis_sun.raterelativeratiotoaats(:,j),j*3,vis_sun.welldepth(:,j),'fill');
        if ji;
            hold on;
            ji=false;
        end;
    end;
end;
hold off;
%h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.');
%lstr=setspectrumcolor(h, aats.w);
%lh=legend(h,lstr);
lstr=[];
for i=1:13,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
    end
end
lh=legend(lstr);
set(lh,'fontsize',14,'location','SouthEast');
ylim([0.94 1.02]);
xlim(UTlim);
%datetick('x','keeplimits')
%ggla;
set(gca,'fontsize',16);
grid on;
%set(h([1 2 10:13]),'markersize',1,'visible','off');
ylabel([instrumentname '/AATS'],'fontsize',20);
titlestr=sprintf([title0 ' %s'],dateprocstr);
title(titlestr,'fontsize',16);
xlabel('UTC [hr]','fontsize',20);
clh=colorbar('vert');
ylabel(clh,'Welldepth');
save_fig(13,[dd dateprocstr 'aats_4star_welldepth']);
%
%plot the scatter plots with the color of the points indicating the well depth of the pixel
%
figure(14);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
ji=true;
sym=['+','o','*','.','X','s','d','^','V','>','<','p','h'];

[v imin]=min(abs(UTdechr-UTlim(1)));
[v imax]=min(abs(UTdechr-UTlim(2)));

for j=1:size(idxwvlvisp,2);
    if idxwvlvisp(j)==1;
        h=scatter(vis_sun.welldepth(imin:imax,j), vis_sun.raterelativeratiotoaats(imin:imax,j),j*5,'fill');
        if ji;
            hold on;
            ji=false;
        end;
    end;
end;
hold off;
%h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.');
%lstr=setspectrumcolor(h, aats.w);
%lh=legend(h,lstr);
lstr=[];
for i=1:13,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
    end
end
lh=legend(lstr);
set(lh,'fontsize',14,'location','SouthEast');
ylim([0.94 1.02]);
xlim([0.0 0.6]);
%xlim(UTlim);
%datetick('x','keeplimits')
%ggla;
set(gca,'fontsize',16);
grid on;
%set(h([1 2 10:13]),'markersize',1,'visible','off');
ylabel([instrumentname '/AATS'],'fontsize',20);
titlestr=sprintf([title0 ' %s'],dateprocstr);
title(titlestr,'fontsize',16);
%xlabel('UTC [hr]','fontsize',20);
xlabel('Welldepth ratio','fontsize',20);
%clh=colorbar('vert');
%ylabel(clh,'Welldepth','fontsize',20);
save_fig(14,[dd dateprocstr 'aats_4star_welldepth_ratio' corstr]);

stophere
%linkaxes([ax1 ax3],'x')

%plot instrument pointing and solar ephemeris
elevdiff_4STARsun=vis_sun.El_deg-vis_sun.sunel;
azdiff_4STARsun=vis_sun.AZ_deg-vis_sun.sunaz;
figure(121)
bx1=subplot(2,1,1);
plot(UTdechr,vis_sun.El_deg,'b.')
hold on
plot(UTdechr,vis_sun.sunel,'r-','linewidth',2)
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
hleg121=legend('4STAR','Sun  ');
set(hleg121,'fontsize',16)
ylabel('Elevation [deg]','fontsize',20)
title(dateprocstr,'fontsize',16)
bx2=subplot(2,1,2);
plot(UTdechr,elevdiff_4STARsun,'b.')
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
ylabel('Elev diff: 4STAR-sun [deg]','fontsize',20)
xlabel('UT [hr]','fontsize',20)
linkaxes([bx1 bx2],'x')

iaz=find(vis_sun.AZ_deg>0);
figure(122)
ax1=subplot(2,1,1);
plot(UTdechr(iaz),vis_sun.AZ_deg(iaz),'b.')
hold on
plot(UTdechr,vis_sun.sunaz,'r-','linewidth',2)
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
hleg121=legend(instrumentname,'Sun  ');
set(hleg121,'fontsize',16)
ylabel('Azimuth [deg]','fontsize',20)
title(dateprocstr,'fontsize',16)
ax2=subplot(2,1,2);
plot(UTdechr(iaz),azdiff_4STARsun(iaz),'b.')
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
ylabel('Az diff: 4STAR-sun [deg]','fontsize',20)
xlabel('UT [hr]','fontsize',20)
linkaxes([ax1 ax2],'x')
%%
figure(401)
ax1=subplot(3,1,1)
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.');
%lstr=setspectrumcolor(h, aats.w);
%lh=legend(h,lstr);
lstr=[];
for i=1:13,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
    end
end
lh=legend(lstr);
set(lh,'fontsize',16,'location','best');
ylim([0.94 1.02])
xlim(UTlim)
set(gca,'fontsize',16)
grid on;
ylabel('4STAR/AATS','fontsize',20);
titlestr=sprintf([title0 ' %s'],dateprocstr);
%plot instrument pointing and solar ephemeris
elevdiff_4STARsun=vis_sun.El_deg-vis_sun.sunel;
azdiff_4STARsun=vis_sun.AZ_deg-vis_sun.sunaz;
ax2=subplot(3,1,2);
plot(UTdechr,vis_sun.El_deg,'b.')
hold on
plot(UTdechr,vis_sun.sunel,'r-','linewidth',2)
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
hleg121=legend('4STAR','Sun  ');
set(hleg121,'fontsize',16)
ylabel('Elev [deg]','fontsize',20)
title(dateprocstr,'fontsize',16)
ax3=subplot(3,1,3);
plot(UTdechr,elevdiff_4STARsun,'b.')
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
ylabel('El dif: 4*-sun [deg]','fontsize',20)
xlabel('UT [hr]','fontsize',20)
linkaxes([ax1 ax2 ax3],'x')

%%

%%
UTlim=[16 20];%20.1];
figure(402)
ax1=subplot(4,1,1)
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.');
%lstr=setspectrumcolor(h, aats.w);
%lh=legend(h,lstr);
lstr=[];
for i=1:13,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
    end
end
lh=legend(lstr);
set(lh,'fontsize',12,'location','best');
%ylim([0.94 1.02])
xlim(UTlim)
set(gca,'fontsize',16)
grid on;
ylabel('4STAR/AATS','fontsize',16);
titlestr=sprintf([title0 ' %s'],dateprocstr);
title(titlestr,'fontsize',16)
%plot instrument pointing and solar ephemeris
elevdiff_4STARsun=vis_sun.El_deg-vis_sun.sunel;
azdiff_4STARsun=vis_sun.AZ_deg-vis_sun.sunaz;
ax2=subplot(4,1,2);
plot(UTdechr,vis_sun.El_deg,'b.')
hold on
plot(UTdechr,vis_sun.sunel,'r-','linewidth',2)
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
hleg121=legend('4STAR','Sun  ');
set(hleg121,'fontsize',16)
ylabel('Elev [deg]','fontsize',16)
title(dateprocstr,'fontsize',16)
iaz=find(vis_sun.AZ_deg>0);
ax3=subplot(4,1,3);
plot(UTdechr(iaz),vis_sun.AZ_deg(iaz),'b.')
hold on
plot(UTdechr,vis_sun.sunaz,'r-','linewidth',2)
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
hleg121=legend('4STAR','Sun  ');
set(hleg121,'fontsize',16)
ylabel('Az [deg]','fontsize',16)
ax4=subplot(4,1,4);
plot(UTdechr,elevdiff_4STARsun,'b.')
hold on
plot(UTdechr(iaz),azdiff_4STARsun(iaz),'r.')
set(gca,'fontsize',16)
set(gca,'xlim',UTlim)
grid on
h4024=legend('elev','azim');
set(h4024,'fontsize',16)
ylabel('Diff: 4STR-sun [deg]','fontsize',16)
xlabel('UT [hr]','fontsize',20)
linkaxes([ax1 ax2 ax3 ax4],'x')

%%

stopherenow

figure(100)
plot(UTdechr,vis_sun.Tbox_C,'b.')
hold on
plot(UTdechr,vis_sun.Tprecon_C,'r.')
set(gca,'fontsize',16)
grid on
hleg100=legend('Tbox   ','Tprecon');
set(hleg100,'fontsize',14)
ylim([0 25])
xlabel('UT [hr]','fontsize',20)
ylabel('Temperature [deg C]','fontsize',20)
title(dateprocstr,'fontsize',16)

idxaats=vis_sun.c(2,:);
%vis_sun.rate
figure
plot(vis_sun.rate(:,idxaats(4:9))/2^16,(vis_sun.raterelativeratiotoaats(:,4:9)),'.');
set(gca,'fontsize',16)
grid on

%plot AOD vs time
figure(311)
ax1=subplot(2,1,1)
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.tau_aero_noscreening(:,idxwvlvisp==1),'.');
lstr=[];
for i=1:13,
    if idxwvlvisp(i)==1,
        lstr=[lstr;sprintf('%6.1f',1000*aats.w(i))];
    end
end
lh=legend(lstr);
set(lh,'fontsize',16,'location','best');
%ylim([0.94 1.02])
xlim(UTlim)
%datetick('x','keeplimits')
%ggla;
set(gca,'fontsize',16)
grid on;




