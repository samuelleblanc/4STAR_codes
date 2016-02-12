%plot_AATS_4STAR_compare.m
clear
close all
asktopause=true;

corstr='_corr';
corstr='';
%dateprocstr='20140416';
%dateprocstr='20140428';
%dateprocstr='20140502';
%dateprocstr='20140407';
dateprocstr='20150113';
dateprocstr='20150916';
%dateprocstr='20150114';
%dateprocstr='20130708';
stardir=['D:\data\4STAR\yohei\4star_data\NASA_Ames_roof\' dateprocstr '\'];


%ratlim=[0.018,0.022];

dd='D:\data\4STAR\yohei\4star_data\NASA_Ames_roof\';%'~/AATS/figs/';

%[vis_sun, nir_sun, aats]=staraatscompare_John(dateprocstr)
if ~exist('vis_sun');
    [vis_sun, nir_sun, aats]=staraatscompare(dateprocstr);
end;
vis_sun.t = make_monotonic(vis_sun.t);

figure; plot(serial2hs(aats.t), aats.Elev_pos,'o');
xl = xlim;
UTdechr=timeMatlab_to_UTdechr(vis_sun.t);
UTdechr_AATS=timeMatlab_to_UTdechr(aats.t);
myColorOrder=[0 1 1; 0.6 0.8 1.0; 0 0 1; 0.6 1.0 0.6; 0 1 0; 0.5 0.6 0.0; 1 0 1; 1 0 0; 0.5 0.1 0.7; 0 0 0];

time_to_norm=17;
time_to_norm = xl(2);
UTlim=[16.1 19.7];
% UTlim = xlim;
templim=[10 40];
ratlim=[0.95 1.05];

[nul,inorm] = min(abs(UTdechr-time_to_norm))

for i=1:14;
    rr(:,i)=vis_sun.raterelativeratiotoaats(:,i)./vis_sun.raterelativeratiotoaats(inorm,i);
    legs{i} = sprintf('%2.0f nm \n',1000.*vis_sun.aatsw(i));
end;

vis_sun.raterelativeratiotoaats=rr;

% 0.3535  0.3800  0.4520  0.5005  0.5204  0.6052  0.6751  0.7805  0.8645  0.9410  1.0191  1.2356  1.5585  2.1391

cc = [3:9];
figure; these =  plot(serial2hs(vis_sun.t), (vis_sun.raterelativeratiotoaats(:,cc)),'-');
legend(legs{cc})
title('4STAR/AATS rooftop ratio Sept 8, 2015');
xlabel('time [UT]')
ylabel('4STAR/AATS DN');
xlim(xl);

time_to_norm=17;
ni = interp1(serial2hs(vis_sun.t),[1:length(vis_sun.t)], time_to_norm,'nearest');
nn = vis_sun.rate_nonray(ni,:); vis_sun.nrate = vis_sun.rate_nonray ./(ones([length(vis_sun.t),1])*nn);
na = interp1(serial2hs(aats.t), [1:length(aats.t)],time_to_norm,'nearest');
ns = aats.data_noray(:,na); aats.nrate = aats.data_noray ./(ns*ones([1,length(aats.t)]));

cc = [3:9];
 [visc,nirc,viscrange,nircrange]=starchannelsatAATS(vis_sun.t(1));
 vsun.t = vis_sun.t; vsun.nrate = vis_sun.nrate(:,visc(1:10));
figure; plot(serial2hs(vsun.t), vsun.nrate(:,cc),'-');title('4STAR normalized signal')
figure; plot(serial2hs(aats.t), aats.nrate(cc,:),'.'); title('AATS normalized signal')

figure; plot(vis_sun.m_ray, vsun.nrate(:,cc),'-');title('4STAR normalized signal')
aats.m_ray = interp1(vis_sun.t, vis_sun.m_ray, aats.t);
figure; plot(aats.m_ray, aats.nrate(cc,:),'.'); title('AATS normalized signal')

% all aats channels...
figure; plot(serial2hs(aats.t), aats.nrate,'.'); title('AATS normalized signal')

[ainb, bina] = nearest(vis_sun.t, aats.t);
figure; plot(serial2hs(vsun.t(ainb)), vsun.nrate(ainb,cc)./aats.nrate(cc,bina)','-');title('4STAR/AATS normalized signal')

nsu = read_k8_nsu;
nsu.m_ray = interp1(vis_sun.t, vis_sun.m_ray, nsu.time);
nsu.tau_ray = interp1(vis_sun.w, vis_sun.tau_ray(1,:), nsu.wl./1000);
nsu.tr_ray = tr(nsu.m_ray, nsu.tau_ray);
nsu.nrate = nsu.I./nsu.tr_ray;
nsu.nrate = nsu.nrate ./ (ones([length(nsu.time),1])*max(nsu.nrate));
figure; plot(nsu.time, nsu.nrate, '-'); dynamicDateTicks;


cim_i = interp1(vis_sun.w, [1:length(vis_sun.w)],nsu.wl./1000,'nearest');
vis_sun.t(diff(vis_sun.t)<0) = NaN;
nan_times = isNaN(vis_sun.t); find(nan_times)
vis_sun.t(nan_times) = interp1(find(~nan_times),vis_sun.t(~nan_times),find(nan_times),'linear','extrap');
nsu.time = make_monotonic(nsu.time);
[sinc, cins] = nearest(vis_sun.t, nsu.time); 
figure; these = plot(vis_sun.t(sinc), vis_sun.nrate(sinc,cim_i)./nsu.nrate(cins,:),'-'); dynamicDateTicks

for wi = 1:length(nsu.wl)
 cim_leg{wi} = sprintf('%2.0f nm \n',nsu.wl(wi));
end
legend(cim_leg);
title('4STAR / Cimel channels, 2015-09-16');
[ainc, cina] = nearest(aats.t, nsu.time);
cim_2_aats = [2,2;3,3;4,4;5,7;6,9;7,10;8,11;9,11;10,13];

figure; these = plot(aats.t(ainc), aats.nrate(cim_2_aats(:,2),ainc)./nsu.nrate(cina,cim_2_aats(:,1))','-'); dynamicDateTicks
legend(cim_leg(cim_2_aats(:,1)))

% %Temperature positions
% T_leg = {...
% 1,  'hot detector plate #1'
% 2, 'hot detector plate #2'
% 3,'filter plate #1'
% 4,  'electronics can'
% 5,  'cold detector #1'
% 6,  'cold detector #2'
% 7,  'argus'
% 8,  'hot PCA'
% 9,  'cold PCA'
% 10, 'filter plate #2'
% 11, 'T stat / cool in'
% 12, 'GPS alt. / cool out'
% 13,  'data CPU'
% 14, 'trk CPU'
% 15, 'RH / pwr supply'};
% %
% for w = length(aats.lambda):-1:1
% w = w +1; V_leg(w) = {sprintf('%4.1f nm',1000.*aats.lambda(w))};
% end


%set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
%% load track from day
disp(['loading star.mat file for ' dateprocstr]);
fpp = [stardir dateprocstr 'star' corstr '.mat'];
if ~exist(fpp)
    [fns,pns] = uigetfile(starpaths,'star.mat',[dateprocstr 'star*.mat'])
    fpp = [pns,fns];
end
load(fpp,'track');


%% Save output
fs = [stardir dateprocstr 'startoaats.mat'];
disp(['Saving file to: ' fs])
save(fs,'nir_sun','vis_sun','track','aats','program_version','-v7.3');

stophere

idxwvlvisp=[0 0 1 1 1 1 1 1 1 0 1 1 1];
%UTlim=[22.5 23];%20.1];
%UTlim=[16 21.5];%20.1];
figure(11);
ax1=subplot(3,1,1);
set(gca, 'ColorOrder', myColorOrder, 'NextPlot', 'replacechildren');
h=plot(UTdechr,vis_sun.raterelativeratiotoaats(:,idxwvlvisp==1), '.');
hx = graph2d.constantline(time_to_norm);
changedependvar(hx,'x');
%lstr=setspectrumcolor(h, aats.w);
%lh=legend(h,lstr);
lstr=[];
for i=1:13,
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
ylabel('4STAR/AATS','fontsize',20);
titlestr=sprintf('Ames  %s',dateprocstr);
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
set(gca,'ylim',[0 8],'ytick',[0:2:8]);
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
if asktopause
    OK =menu('continue or exit?','Continue','Exit')
    if OK==2
        return
    end
end
hgsave([dd dateprocstr 'aats4star_temp' corstr]);
saveas(11,[dd dateprocstr 'aats4star_temp' corstr '.png']);
%print([dd dateprocstr 'aats4star_temp' corstr],'-depsc2');
%system(['convert ' dd dateprocstr 'aats4star_temp' corstr '.eps ' dd dateprocstr 'aats4star_temp' corstr '.png']);


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
    ylabel('4STAR [counts/ms]','fontsize',20);
    titlestr=sprintf('Ames  %s',dateprocstr);
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
    ylabel('4STAR [Normalized]','fontsize',20);
    titlestr=sprintf('Ames  %s',dateprocstr);
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
    
    if asktopause
        OK =menu('continue or exit?','Continue','Exit')
        if OK==2
            return
        end
    end
    hgsave([dd dateprocstr 'aats4star_normraw' corstr]);
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
    ylabel('4STAR/AATS','fontsize',20);
    titlestr=sprintf('Ames  %s',dateprocstr);
    title(titlestr,'fontsize',16);
    
    
    axx2=subplot(2,1,2);
    h3=plot(hrs,temp1,'b-');
    set(gca,'ylim',templim);
    ylabel('Temperature (^oC)','fontsize',20);
    xlabel('UT [hr]','fontsize',20);
    linkaxes([axx1 axx2],'x');
    set(lh,'fontsize',16,'location','east');
    
    if asktopause
        OK =menu('continue or exit?','Continue','Exit')
        if OK==2
            return
        end
    end
    hgsave([dd dateprocstr 'aats4star_ratio_timeseries' corstr]);
    saveas(12,[dd dateprocstr 'aats4star_ratio_timeseries' corstr '.png']);
    %print([dd dateprocstr 'aats4star_ratio_timeseries' corstr],'-depsc2');
    %system(['convert ' dd dateprocstr 'aats4star_ratio_timeseries' corstr '.eps ' dd dateprocstr 'aats4star_ratio_timeseries' corstr '.png']);
end;

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
ylabel('4STAR/AATS','fontsize',20);
titlestr=sprintf('Ames  %s',dateprocstr);
title(titlestr,'fontsize',16);
xlabel('UTC [hr]','fontsize',20);
clh=colorbar('vert');
ylabel(clh,'Welldepth');

if asktopause
    OK =menu('continue or exit?','Continue','Exit')
    if OK==2
        return
    end
end
hgsave([dd dateprocstr 'aats_4star_welldepth']);
saveas(13,[dd dateprocstr 'aats_4star_welldepth' '.png']);
%print([dd dateprocstr 'aats4star_welldepth'],'-depsc2');
%system(['convert ' dd dateprocstr 'aats4star_welldepth.eps ' dd dateprocstr 'aats4star_welldepth.png']);

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
ylabel('4STAR/AATS','fontsize',20);
titlestr=sprintf('Ames  %s',dateprocstr);
title(titlestr,'fontsize',16);
%xlabel('UTC [hr]','fontsize',20);
xlabel('Welldepth ratio','fontsize',20);
%clh=colorbar('vert');
%ylabel(clh,'Welldepth','fontsize',20);

if asktopause
    OK =menu('continue or exit?','Continue','Exit')
    if OK==2
        return
    end
end
hgsave([dd dateprocstr 'aats_4star_welldepth_ratio' corstr]);
saveas(14,[dd dateprocstr 'aats_4star_welldepth_ratio' corstr '.png']);
%print([dd dateprocstr 'aats4star_welldepthratio' corstr],'-depsc2');
%system(['convert ' dd dateprocstr 'aats4star_welldepthratio' corstr '.eps ' dd dateprocstr 'aats4star_welldepthratio' corstr '.png']);

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
hleg121=legend('4STAR','Sun  ');
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
titlestr=sprintf('MLO  %s',dateprocstr);
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
titlestr=sprintf('MLO  %s',dateprocstr);
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




