function saved_fig_path = Apply_deltac0(fp_starsunmat,deltac0_percent,isflight)
%% Details of the program:
% NAME:
%   Apply_deltac0
%
% PURPOSE:
%  To load a starsun_for_starflag file, plot high altitude aods or any ground based ones, then
%  modify the c0 with a delta
%
% INPUT:
%  fp_starsunmat: full file path to be loaded (starsun.mat format)
%  deltac0_percent: percentage to add or remove from the original c0 (defaults to 2%)
%  isflight: boolean (true or false, defaults to false) if set true, only plots the high altitude 
%
% OUTPUT:
%  fig_names: full file path of the plots outputted
%
% DEPENDENCIES:
%  - version_set.m
%  - make_for_starflag
%
% NEEDED FILES:
%  - starsun_for_starflag.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - original c0 file
%  - optionally the full starsun.mat file for loading spectral data
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames Research Center, 2018-08-02
%                 Ported from Quickapply_newc0
%
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%% define paths and load starsun_for_starflag
[fp fname ext0] = fileparts(fp_starsunmat);
[daystr, filen, datatype, instrumentname]=starfilenames2daystr({fp_starsunmat});
fp = [fp filesep];
file = [fname '_for_starflag' ext0];
if ~exist([fp file]);
    make_for_starflag(fp_starsunmat);
end;

load_sp = true;
load([fp file]);

if nargin<3;
    isflight = false;
elseif nargin<2;
    deltac0_percent = 2.0; %delta percent defaults to 2%
end;

leg = {'380';'452';'500';'620';'865'; '1040';'1215'};
n = length(leg);
wvls = [380,452,500,620,865,1040,1215];
iwvls = [258,347,407,557,869,1095,1200];

%subset
oc0 = c0(iwvls);
nc0 = c0(iwvls).*(1.0+deltac0_percent./100.0);
newc0 = c0.*(1.0+deltac0_percent./100.0);

%% plot out the original aods and their modified versions
figaas = figure('pos',[30 10 800 1000]);
if isflight;
    i = find(Alt>5000.0);
    tit = 'High Alt [>5000m]';
    xtra = '_flight';
else;
    i = find(isfinite(aod_500nm));
    tit = 'All ground based ';
    xtra = '_ground';
end;
cm = hsv(n);
colormap(cm);

setappdata(gcf, 'SubplotDefaultAxesLocation', [0, 0, 1, 1]);
ax1 = subplot(7,1,1);
plot(ax1,t(i),aod_380nm(i),'.','color',cm(1,:).*0.5);
title([instrumentname ' - ' tit ' AODs: ' file],'Interpreter','none');
hold on;grid on; ylabel(['AOD ' leg{1} ' nm']);%ylim([-0.02,0.04]);
plot(t(i),t(i).*0,'-k');datetick;
set(gca,'Position',[0.07 1-(1/7-0.01) .92 1/7-0.03]);
set(gca,'XTickLabel','');

ax2 = subplot(7,1,2);
plot(ax2,t(i),aod_452nm(i),'.','color',cm(2,:).*0.5);
hold on;grid on; ylabel(['AOD ' leg{2} ' nm']);%ylim([-0.02,0.04]);
plot(t(i),t(i).*0,'-k');datetick;
title(['Current c0: ' note{6}],'Interpreter','none')
set(gca,'Position',[0.07 1-(2/7-0.01) .92 1/7-0.03]);
set(gca,'XTickLabel','');

ax3 = subplot(7,1,3);
plot(ax3,t(i),aod_500nm(i),'.','color',cm(3,:).*0.5);
hold on;grid on; ylabel(['AOD ' leg{3} ' nm']);%ylim([-0.02,0.04]);
plot(t(i),t(i).*0,'-k');datetick;
set(gca,'Position',[0.07 1-(3/7-0.01) .92 1/7-0.03]);
title(['delta c0 + ' num2str(deltac0_percent,'%3.1f') '%'],'Interpreter','none')

ax4 = subplot(7,1,4);
plot(ax4,t(i),aod_620nm(i),'.','color',cm(3,:).*0.5);
hold on;grid on; ylabel(['AOD ' leg{4} ' nm']);%ylim([-0.02,0.04]);
plot(t(i),t(i).*0,'-k');datetick;
set(gca,'Position',[0.07 1-(4/7-0.01) .92 1/7-0.02])

ax5 = subplot(7,1,5);
plot(ax5,t(i),aod_865nm(i),'.','color',cm(4,:).*0.5);
hold on;grid on; ylabel(['AOD ' leg{5} ' nm']);%ylim([-0.02,0.04]);
plot(t(i),t(i).*0,'-k');datetick;
set(gca,'Position',[0.07 1-(5/7-0.01) .92 1/7-0.02])

ax6 = subplot(7,1,6);
plot(ax6,t(i),aod_1040nm(i),'.','color',cm(5,:).*0.5);
hold on;grid on; ylabel(['AOD ' leg{6} ' nm']);%ylim([-0.02,0.04]);
plot(t(i),t(i).*0,'-k');datetick;
set(gca,'Position',[0.07 1-(6/7-0.01) .92 1/7-0.02])

ax7 = subplot(7,1,7);
u = plot(ax7,t(i),aod_1215nm(i),'.','color',cm(6,:).*0.5);
hold on;grid on; ylabel(['AOD ' leg{7} ' nm']);%ylim([-0.02,0.04]);
plot(t(i),t(i).*0,'-k');datetick;
set(gca,'Position',[0.07 1-(7/7-0.01) .92 1/7-0.02])

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7],'x');

plot(ax1,t(i),calc_new_aod(aod_380nm(i),m_aero(i),oc0(1),nc0(1)),'.','color',cm(1,:));
plot(ax2,t(i),calc_new_aod(aod_452nm(i),m_aero(i),oc0(2),nc0(2)),'.','color',cm(2,:));
plot(ax3,t(i),calc_new_aod(aod_500nm(i),m_aero(i),oc0(3),nc0(3)),'.','color',cm(3,:));
plot(ax4,t(i),calc_new_aod(aod_620nm(i),m_aero(i),oc0(4),nc0(4)),'.','color',cm(4,:));
plot(ax5,t(i),calc_new_aod(aod_865nm(i),m_aero(i),oc0(5),nc0(5)),'.','color',cm(5,:));
plot(ax6,t(i),calc_new_aod(aod_1040nm(i),m_aero(i),oc0(6),nc0(6)),'.','color',cm(6,:));
v = plot(ax7,t(i),calc_new_aod(aod_1215nm(i),m_aero(i),oc0(7),nc0(7)),'.','color',cm(7,:));

try;
    legend([u,v],'Original','Modified c0');
catch;
    disp(['No points for day:' days(i,:)])
end;
%set(gcf,'pos',[10 10 600 1500])
fname = fullfile(fp,[instrumentname daystr '_AODwith_deltac0_' num2str(deltac0_percent,'%03.1f') '_time']);
save_fig(figaas,fname,0);
saved_fig_path = [fname '.png'];

%% Now redo the multi plot panel but for vs. airmass
figm = figure('pos',[500 10 800 1000]);

setappdata(gcf, 'SubplotDefaultAxesLocation', [0, 0, 1, 1]);
ax1 = subplot(7,1,1);
plot(ax1,m_aero(i),aod_380nm(i),'.','color',cm(1,:).*0.5);
title([instrumentname ' - ' tit ' AODs: ' file],'Interpreter','none');
hold on;grid on; ylim([-0.02,0.04]);ylabel(['AOD ' leg{1} ' nm']);
set(gca,'Position',[0.07 1-(1/7-0.01) .92 1/7-0.03]);
set(gca,'XTickLabel','');

ax2 = subplot(7,1,2);
plot(ax2,m_aero(i),aod_452nm(i),'.','color',cm(2,:).*0.5);
hold on;grid on; ylim([-0.02,0.04]);ylabel(['AOD ' leg{2} ' nm']);
title(['Current c0: ' note{6}],'Interpreter','none')
set(gca,'Position',[0.07 1-(2/7-0.01) .92 1/7-0.03]);
set(gca,'XTickLabel','');

ax3 = subplot(7,1,3);
plot(ax3,m_aero(i),aod_500nm(i),'.','color',cm(3,:).*0.5);
hold on;grid on; ylim([-0.02,0.04]);ylabel(['AOD ' leg{3} ' nm']);
set(gca,'Position',[0.07 1-(3/7-0.01) .92 1/7-0.03]);
title(['delta c0 + ' num2str(deltac0_percent,'%3.1f') '%'],'Interpreter','none')

ax4 = subplot(7,1,4);
plot(ax4,m_aero(i),aod_620nm(i),'.','color',cm(3,:).*0.5);
hold on;grid on; ylim([-0.02,0.04]);ylabel(['AOD ' leg{4} ' nm']);
set(gca,'Position',[0.07 1-(4/7-0.01) .92 1/7-0.02])

ax5 = subplot(7,1,5);
plot(ax5,m_aero(i),aod_865nm(i),'.','color',cm(4,:).*0.5);
hold on;grid on; ylim([-0.02,0.04]);ylabel(['AOD ' leg{5} ' nm']);
set(gca,'Position',[0.07 1-(5/7-0.01) .92 1/7-0.02])

ax6 = subplot(7,1,6);
plot(ax6,m_aero(i),aod_1040nm(i),'.','color',cm(5,:).*0.5);
hold on;grid on; ylim([-0.02,0.04]);ylabel(['AOD ' leg{6} ' nm']);
set(gca,'Position',[0.07 1-(6/7-0.01) .92 1/7-0.02])

ax7 = subplot(7,1,7);
u = plot(ax7,m_aero(i),aod_1215nm(i),'.','color',cm(6,:).*0.5);
hold on;grid on; ylim([-0.02,0.04]);ylabel(['AOD ' leg{7} ' nm']);
set(gca,'Position',[0.07 1-(7/7-0.01) .92 1/7-0.02])

linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7],'x');

plot(ax1,m_aero(i),calc_new_aod(aod_380nm(i),m_aero(i),oc0(1),nc0(1)),'.','color',cm(1,:));
plot(ax2,m_aero(i),calc_new_aod(aod_452nm(i),m_aero(i),oc0(2),nc0(2)),'.','color',cm(2,:));
plot(ax3,m_aero(i),calc_new_aod(aod_500nm(i),m_aero(i),oc0(3),nc0(3)),'.','color',cm(3,:));
plot(ax4,m_aero(i),calc_new_aod(aod_620nm(i),m_aero(i),oc0(4),nc0(4)),'.','color',cm(4,:));
plot(ax5,m_aero(i),calc_new_aod(aod_865nm(i),m_aero(i),oc0(5),nc0(5)),'.','color',cm(5,:));
plot(ax6,m_aero(i),calc_new_aod(aod_1040nm(i),m_aero(i),oc0(6),nc0(6)),'.','color',cm(6,:));
v = plot(ax7,m_aero(i),calc_new_aod(aod_1215nm(i),m_aero(i),oc0(7),nc0(7)),'.','color',cm(7,:));

try;
    legend([u,v],'Original','Modified c0');
catch;
    disp(['No points for day:' days(i,:)])
end;
fname = fullfile(fp,[instrumentname daystr '_AODwith_deltac0_' num2str(deltac0_percent,'%03.1f') '_airmass']);
save_fig(figm,fname,0);
saved_fig_path =[{saved_fig_path}; {[fname '.png']}];

if load_sp;
    try;
        s = load(fp_starsunmat,'t','tau_aero_noscreening','c0','w','Alt','m_aero');
    catch;
        disp(['No spectra able to plot: '])
    end;
    
    figs = figure;
    sp_num = 6;
    ii = [1:length(s.t)];
    if isflight; 
        ii = ii(s.Alt>5000.0);
    else;
        ii = ii;
    end;
    if ~any(ii);
        ntot = length(s.t);
        ii = [1:ntot];
    else;
        ntot = length(s.t(ii));
    end;
    inum = floor(linspace(20,ntot,sp_num));
    cm=hsv(sp_num);
    set(gca, 'ColorOrder', cm*0.5, 'NextPlot', 'replacechildren');
    plot(s.w.*1000.0,s.tau_aero_noscreening(ii(inum),:),'-');
    hold on;
    %set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    for j=1:sp_num;
        plot(s.w.*1000.0,calc_new_aod(s.tau_aero_noscreening(ii(inum(j)),:),s.m_aero(ii(inum(j))),s.c0,newc0),'-','color',cm(j,:));
    end;
    xlim([300,1700]); ylim([0.001,0.2]);
    set(gca,'xscale','log','yscale','log');
    set(gca,'XTick',[300 400 500 600 700 800 900 1000, 1100 1400 1600]);
    hold on;labels = {datestr(s.t(ii(inum(1))),'HH:MM:SS')};
    for i=2:sp_num;
        %   plot(s.w.*1000.0,s.tau_aero_noscreening(ii(inum(i)),:),'-');
        labels = [labels;{datestr(s.t(ii(inum(i))),'HH:MM:SS')}];
    end;
    xlabel('Wavelength [nm]');
    ylabel('AOD');
    title([daystr ' - ' tit ' AOD spectra' ],'fontweight','bold');
    grid on;
    colormap(cm);
    try;
        lcolorbar(labels','TitleString','UTC time','fontweight','bold');
    catch;
        legend(labels);
    end;
    hold off;
    
    fname = fullfile(fp,[instrumentname daystr '_AODwith_deltac0_' num2str(deltac0_percent,'%03.1f') '_spectra']);
    save_fig(figs,fname,0);
    saved_fig_path =[saved_fig_path; {[fname '.png']}];
end;




return


function aod_new = calc_new_aod(aod,m,old_c0,new_c0)
%s.tau_aero_noscreening=real(-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq));

r = exp(aod.*m.*-1.0);
rr = r.*old_c0;

aod_new = real(-log(rr./new_c0))./m;

return
