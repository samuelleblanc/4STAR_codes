function Quickapply_newc0
%% Details of the program:
% NAME:
%   Quickapply_newc0
%
% PURPOSE:
%  To load a starsun_for_starflag file, plot high altitude aods, then
%  modify the c0 for a new file
%
% INPUT:
%  none: must change values within the code
%
% OUTPUT:
%  plots
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - starsun_for_starflag.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - new c0 file
%  - optionally the full starsun.mat file for loading spectral data
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames Research Center, 2017-06-13
%
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%% define paths and load starsun_for_starflag
fp = 'C:\Users\sleblan2\Research\ORACLES\data\v6\';

days = ['824';'825';'827';'830';'831';'902';'904';'906';'908';'910';...
    '912';'914';'918';'920';'924';'925';'927';'929';'930'];

days = ['902';'904';'906';'908'];

%c0f = '20160924_VIS_C0_refined_mix_Langley_airborne_MLO_high_alt_AOD_ORACLES_averages_v1.dat';
%c0f = '20160912_VIS_C0_refined_Langley_averaged_with_high_alt_inflight_ORACLES_notransist.dat';
%c0f = '20160825_VIS_C0_refined_Langley_ORACLES_transit2.dat';
%c0f = '20160823_VIS_C0_refined_Langley_ORACLES_WFF_gnd.dat';
%c0f = '20160824_VIS_C0_refined_Langley_averaged_inflight_Langley_ORACLES_transits.dat';
c0f = '20160831_VIS_C0_refined_Langley_averaged_inflight_Langley_high_alt_ORACLES.dat';
c0f = '20160831_VIS_C0_refined_Langley_averaged_inflight_Langley_early_high_alts_ORACLES.dat';
c0f = '20160904_VIS_C0_refined_Langley_averaged_inflight_high_alts_highRH_ORACLES.dat';
newc0_visfile = [starpaths c0f];

load_sp = true;

for jd=1:length(days);
    file = ['4STAR_20160' days(jd,:) 'starsun_for_starflag.mat'];
    
    load([fp file]);
    
    leg = {'380';'452';'500';'620';'865'; '1040';'1215'};
    n = length(leg);
    wvls = [380,452,500,620,865,1040,1215];
    iwvls = [258,347,407,557,869,1095,1200];
    
    %% load up the new c0 and subselect;
    a = importdata(newc0_visfile);
    new_visc0=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
    b = importdata(strrep(newc0_visfile,'_VIS_','_NIR_'));
    new_nirc0=b.data(:,strcmp(lower(b.colheaders), 'c0'))';
    newc0 = [new_visc0 new_nirc0];
    
    %subset
    nc0 = newc0(iwvls);
    oc0 = c0(iwvls);
    
    %% plot out the original aods
    % figa = figure;
    %
    % cm = hsv(n);
    % colormap(cm);
    % plot(t,aod_380nm,'.','color',cm(1,:)); hold on;
    % plot(t,aod_452nm,'.','color',cm(2,:));
    % plot(t,aod_500nm,'.','color',cm(3,:));
    % plot(t,aod_620nm,'.','color',cm(4,:));
    % plot(t,aod_865nm,'.','color',cm(5,:));
    % plot(t,aod_1040nm,'.','color',cm(6,:));
    % plot(t,aod_1215nm,'.','color',cm(7,:));
    % dynamicDateTicks;
    % hold off;
    % grid on;
    % title(['Original AODs in file: ' file]);
    % ylabel('AOD');
    % xlabel('UTC');
    % lcolorbar(leg','TitleString','\lambda [nm]','fontweight','bold');
    
    %% plot out the original aods and the modified c0s on single plot
    % figaa = figure;
    % i = find(Alt>5000.0);
    % cm = hsv(n);
    % colormap(cm);
    % plot(t(i),aod_380nm(i),'.','color',cm(1,:).*0.5); hold on;
    % plot(t(i),aod_452nm(i),'.','color',cm(2,:).*0.5);
    % plot(t(i),aod_500nm(i),'.','color',cm(3,:).*0.5);
    % plot(t(i),aod_620nm(i),'.','color',cm(4,:).*0.5);
    % plot(t(i),aod_865nm(i),'.','color',cm(5,:).*0.5);
    % plot(t(i),aod_1040nm(i),'.','color',cm(6,:).*0.5);
    % u = plot(t(i),aod_1215nm(i),'.','color',cm(7,:).*0.5);
    % v = plot(t(i),aod_1215nm(i).*NaN,'+','color',cm(8,:));
    %
    % dynamicDateTicks;
    % %hold off;
    % legend([u,v],'Original','Modified c0');
    % grid on; ylim([-0.03,0.05])
    % title(['High Alt [>5000m] AODs: ' file]);
    % ylabel('AOD');
    % xlabel('UTC');
    % lcolorbar(leg','TitleString','\lambda [nm]','fontweight','bold');
    %
    % figure(figaa); hold on;
    % plot(t(i),calc_new_aod(aod_380nm(i),m_aero(i),oc0(1),nc0(1)),'+','color',cm(1,:));
    % plot(t(i),calc_new_aod(aod_452nm(i),m_aero(i),oc0(2),nc0(2)),'+','color',cm(2,:));
    % plot(t(i),calc_new_aod(aod_500nm(i),m_aero(i),oc0(3),nc0(3)),'+','color',cm(3,:));
    % plot(t(i),calc_new_aod(aod_620nm(i),m_aero(i),oc0(4),nc0(4)),'+','color',cm(4,:));
    % plot(t(i),calc_new_aod(aod_865nm(i),m_aero(i),oc0(5),nc0(5)),'+','color',cm(5,:));
    % plot(t(i),calc_new_aod(aod_1040nm(i),m_aero(i),oc0(6),nc0(6)),'+','color',cm(6,:));
    % plot(t(i),calc_new_aod(aod_1215nm(i),m_aero(i),oc0(7),nc0(7)),'+','color',cm(7,:));
    
    
    
    %% plot out the original aods and their modified versions
    figaas = figure('pos',[30 10 800 1100]);
    i = find(Alt>5000.0);
    cm = hsv(n);
    colormap(cm);
    
    setappdata(gcf, 'SubplotDefaultAxesLocation', [0, 0, 1, 1]);
    ax1 = subplot(7,1,1);
    plot(ax1,t(i),aod_380nm(i),'.','color',cm(1,:).*0.5);
    title(['High Alt [>5000m] AODs: ' file],'Interpreter','none');
    hold on;grid on; ylim([-0.02,0.03]);ylabel(['AOD ' leg{1} ' nm']);
    plot(t(i),t(i).*0,'-k');datetick;
    set(gca,'Position',[0.07 1-(1/7-0.01) .92 1/7-0.03]);
    set(gca,'XTickLabel','');
    
    ax2 = subplot(7,1,2);
    plot(ax2,t(i),aod_452nm(i),'.','color',cm(2,:).*0.5);
    hold on;grid on; ylim([-0.02,0.03]);ylabel(['AOD ' leg{2} ' nm']);
    plot(t(i),t(i).*0,'-k');datetick;
    title(['Previous: ' note{6}],'Interpreter','none')
    set(gca,'Position',[0.07 1-(2/7-0.01) .92 1/7-0.03]);
    set(gca,'XTickLabel','');
    
    ax3 = subplot(7,1,3);
    plot(ax3,t(i),aod_500nm(i),'.','color',cm(3,:).*0.5);
    hold on;grid on; ylim([-0.02,0.03]);ylabel(['AOD ' leg{3} ' nm']);
    plot(t(i),t(i).*0,'-k');datetick;
    set(gca,'Position',[0.07 1-(3/7-0.01) .92 1/7-0.03]);
    title(['New: ' c0f],'Interpreter','none')
    
    ax4 = subplot(7,1,4);
    plot(ax4,t(i),aod_620nm(i),'.','color',cm(3,:).*0.5);
    hold on;grid on; ylim([-0.02,0.03]);ylabel(['AOD ' leg{4} ' nm']);
    plot(t(i),t(i).*0,'-k');datetick;
    set(gca,'Position',[0.07 1-(4/7-0.01) .92 1/7-0.02])
    
    ax5 = subplot(7,1,5);
    plot(ax5,t(i),aod_865nm(i),'.','color',cm(4,:).*0.5);
    hold on;grid on; ylim([-0.02,0.03]);ylabel(['AOD ' leg{5} ' nm']);
    plot(t(i),t(i).*0,'-k');datetick;
    set(gca,'Position',[0.07 1-(5/7-0.01) .92 1/7-0.02])
    
    ax6 = subplot(7,1,6);
    plot(ax6,t(i),aod_1040nm(i),'.','color',cm(5,:).*0.5);
    hold on;grid on; ylim([-0.02,0.03]);ylabel(['AOD ' leg{6} ' nm']);
    plot(t(i),t(i).*0,'-k');datetick;
    set(gca,'Position',[0.07 1-(6/7-0.01) .92 1/7-0.02])
    
    ax7 = subplot(7,1,7);
    u = plot(ax7,t(i),aod_1215nm(i),'.','color',cm(6,:).*0.5);
    hold on;grid on; ylim([-0.02,0.03]);ylabel(['AOD ' leg{7} ' nm']);
    plot(t(i),t(i).*0,'-k');datetick;
    set(gca,'Position',[0.07 1-(7/7-0.01) .92 1/7-0.02])
    
    linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7],'x');
    
    %dynamicDateTicks;
    %hold off;
    %
    %title(['High Alt [>5000m] AODs: ' file]);
    
    %xlabel('UTC');
    %lcolorbar(leg','TitleString','\lambda [nm]','fontweight','bold');
    
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
    
    if load_sp;
        try;
            files = ['4STAR_20160' days(jd,:) 'starsun.mat'];            
            s = load([fp files],'t','tau_aero_noscreening','c0','w','Alt','m_aero');
        catch;
            disp(['No spectra able to plot: ' days(jd,:)])
            continue;
        end;
        
        figs = figure;
        sp_num = 6;
        ii = [1:length(s.t)];
        ii = ii(s.Alt>5000.0);
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
        title([days(jd,:) ' - High alt AOD spectra' ],'fontweight','bold');
        grid on;
        colormap(cm);
        lcolorbar(labels','TitleString','UTC time','fontweight','bold');
        hold off;
        
    end;
    
end; % loop over days
return


function aod_new = calc_new_aod(aod,m,old_c0,new_c0)
%s.tau_aero_noscreening=real(-log(s.rateaero./repmat(s.c0,pp,1))./repmat(s.m_aero,1,qq));

r = exp(aod.*m.*-1.0);
rr = r.*old_c0;

aod_new = real(-log(rr./new_c0))./m;

return