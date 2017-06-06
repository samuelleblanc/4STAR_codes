function fig_names = Quicklooks_2STAR(fname_2starsun,ppt_fname);
%% Details of the program:
% NAME:
%   Quicklooks_2STAR
%
% PURPOSE:
%  To generate the 2STAR plots for quicklooks
%
% INPUT:
%  fname_2starsun: (optional) the full path of the 2STAR starsun.mat file
%  ppt_fname: (optional) the full powerpoint file path to ammend the figures.
%
% OUTPUT:
%  many plots showing details of 2STAR
%  fig_names: cell array of file names of the saved pngs
%  powerpoint with the said plots of 2STAR
%
% DEPENDENCIES:
%  - version_set.m
%  - evalstarinfo.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun for 2STAR
%  - starinfo for the flight
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Mauna Loa Observatory, 2017-06-02
%                 based on starbasicplots
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%% Sanitize inputs and get file paths
if nargin<1; % no file path set
    [f1,p1] = uigetfile2('2STAR*starsun.mat','Choose 2STAR starsun file');
    fname_2starsun = [p1 f1];
else;
    [p1, f, ext0]=fileparts(fname_2starsun);
end;
n = nargin

[daystr, filen, datatype, instrumentname]=starfilenames2daystr({fname_2starsun});
savefigure = true;

if nargin <2;
    ppt_fname = fullfile(p1,[daystr '_' instrumentname '_Quicklooks.ppt']);
end;

%% load the files
disp(['Loading 2STAR file: ' fname_2starsun])
s = load(fname_2starsun);

%% set the wavelengths to plot
wvl = [350.0 430.0 450.0 500.0 532.0 601.0 675.0 750.0 875.0 941.0];
nw = length(wvl);
for i=1:nw;
    [nul,ii] = min(abs(s.w.*1000.0-wvl(i)));
    iwvl(i) = ii;
end;

%% Now run through and plot the values
pptcontents={}; % pairs of a figure file name and the number of figures per slide
pptcontents0={};

%plot airmasses
figure(1);
plot(s.t,s.m_aero,'.b');
hold on;
plot(s.t,s.m_ray,'.r');
grid on;
legend({'m\_aero';'m\_ray'}');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Airmass');
title([instrumentname ' - ' daystr ' - airmasses']);
fname = fullfile(p1,[instrumentname daystr '_airmass']);
fig_names = {[fname '.png']};
save_fig(1,fname,0);
pptcontents0=[pptcontents0; {fig_names{1} 4}];

% plot temperatures and pressures
figure(2);
ax = plotyy(s.t,s.Tprecon_C,s.t,s.RHprecon_percent);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
ylabel(ax(2),'RH [%]');
ylabel(ax(1),'Temperature [^\circC]');
title([instrumentname ' - ' daystr ' - Temperature and Pressure']);
fname = fullfile(p1,[instrumentname daystr '_TnP']);
fig_names{2} = [fname '.png'];
save_fig(2,fname,0);
pptcontents0=[pptcontents0; {fig_names{2} 4}];

% plot the orientation (Az El)
figure(3);
ax = plotyy(s.t,s.El_deg,s.t,s.AZ_deg);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
ylabel(ax(2),'Azimuth degrees [^\circ]')
ylabel(ax(1),'Elevation degrees [^\circ]');
title([instrumentname ' - ' daystr ' - Elevation and Azimuth angles']);
fname = fullfile(p1,[instrumentname daystr '_El_Az']);
fig_names{3} = [fname '.png'];
save_fig(3,fname,0);
pptcontents0=[pptcontents0; {fig_names{3} 4}];

% plot the quad signals
figure(4);
ax1 = subplot(211);
plot(s.t,s.QdVtot,'.b');
ylabel('Total Quad voltages [V]');
title([instrumentname ' - ' daystr ' - Quad voltages']);
dynamicDateTicks;grid on;
ax2 = subplot(212);
linkaxes([ax1,ax2],'x')
plot(s.t,s.QdVtb,'+r');hold on;
plot(s.t,s.QdVlr,'xg');
dynamicDateTicks;grid on;
hold off;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Quad voltages [V]'); ylim([-1,1])
legend('Quad top bottom','Quad Left right');
fname = fullfile(p1,[instrumentname daystr '_Quad']);
fig_names{4} = [fname '.png'];
save_fig(4,fname,0);
pptcontents0=[pptcontents0; {fig_names{4} 4}];

% plot the solar angles
figure(5);
plot(s.t,s.sza,'o');
hold on;
plot(s.t,s.sunaz,'+r');
plot(s.t,s.sunel,'xg');
dynamicDateTicks;
grid on;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Degrees [^\circ]')
legend('SZA','Sun Az','Sun El');
title([instrumentname ' - ' daystr ' - Solar Angles']);
fname = fullfile(p1,[instrumentname daystr '_solarangles']);
fig_names{5} = [fname '.png'];
save_fig(5,fname,0);
pptcontents0=[pptcontents0; {fig_names{5} 4}];

% plot raw signal at one wavelength with parks and saturations, with Tint
figure(6);
[ax,h1,h2] = plotyy(s.t,s.raw(:,45),s.t,s.Tint);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on;
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
hold on;
plot(s.t(s.Md==0),s.raw(s.Md==0,45),'dc','markersize',4);
plot(s.t(isnan(s.rate(:,45))),s.raw(isnan(s.rate(:,45)),45),'or');
plot(s.t(s.sat_time==1),s.raw(s.sat_time==1,45),'sy','markersize',4);
hold off;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
ylabel(ax(2),'Integration time [ms]')
ylabel(ax(1),['Raw at ' num2str(s.w(45).*1000.0,'%4.1f') ' nm [counts]']);
title([instrumentname ' - ' daystr ' - Raw counts, parks, saturation, Tint' ]);
if any(s.sat_time==1);
    legend('Raw','parked','removed','saturated','Tint');
else;
    a = legend('Raw','parked','removed','Tint');
    lpos = get(a,'Position');
    text(lpos(2),lpos(1),'No saturation','Units','normalized');
end;
fname = fullfile(p1,[instrumentname daystr '_sats_parks_Tint']);
fig_names{6} = [fname '.png'];
save_fig(6,fname,0);
pptcontents0=[pptcontents0; {fig_names{6} 4}];
pptcontents0=[pptcontents0; {' ' 4}];
pptcontents0=[pptcontents0; {' ' 4}];

% plot the raw
figure(7);
cm=hsv(nw);
set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
plot(s.t,s.raw(:,iwvl),'.');
dynamicDateTicks;
xlabel('UTC time');
ylabel('Raw [counts]');
xlim([s.t(1)-0.01 s.t(end)+0.01]);
title([instrumentname ' - ' daystr ' - Raw counts' ]);
grid on;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile(p1,[instrumentname daystr '_raw']);
fig_names{7} = [fname '.png'];
save_fig(7,fname,0);
pptcontents0=[pptcontents0; {fig_names{7} 4}];

% plot the raw
figure(8);
colormap(parula);
imagesc(s.t,s.w.*1000.0,s.raw');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Wavelength [nm]');
title([instrumentname ' - ' daystr ' - Raw counts' ]);
cb = colorbarlabeled('Raw counts');
fname = fullfile(p1,[instrumentname daystr '_rawcarpet']);
fig_names{8} = [fname '.png'];
save_fig(8,fname,0);
pptcontents0=[pptcontents0; {fig_names{8} 4}];

% plot the darks
figure(9);
cm=hsv(nw);
set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
plot(s.t,s.dark(:,iwvl),'.');
dynamicDateTicks;
xlabel('UTC time');
ylabel('Dark [counts]');
xlim([s.t(1)-0.01 s.t(end)+0.01]);
title([instrumentname ' - ' daystr ' - Dark counts' ]);
grid on;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile(p1,[instrumentname daystr '_darks']);
fig_names{9} = [fname '.png'];
save_fig(9,fname,0);
pptcontents0=[pptcontents0; {fig_names{9} 4}];
pptcontents0=[pptcontents0; {' ' 4}];

% plot the rate
figure(10);
cm=hsv(nw);
set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
plot(s.t,s.rate(:,iwvl),'.');
dynamicDateTicks;
xlabel('UTC time');
ylabel('Rate [counts/ms]');
xlim([s.t(1)-0.01 s.t(end)+0.01]);
title([instrumentname ' - ' daystr ' - Rate' ]);
grid on;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile(p1,[instrumentname daystr '_rate']);
fig_names{10} = [fname '.png'];
save_fig(10,fname,0);
pptcontents0=[pptcontents0; {fig_names{10} 4}];

% plot the rate
figure(11);
colormap(parula);
imagesc(s.t,s.w.*1000.0,s.rate');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Wavelength [nm]');
title([instrumentname ' - ' daystr ' - Rate' ]);
cb = colorbarlabeled('Rate [counts/ms]');
fname = fullfile(p1,[instrumentname daystr '_ratecarpet']);
fig_names{11} = [fname '.png'];
save_fig(11,fname,0);
pptcontents0=[pptcontents0; {fig_names{11} 4}];

% plot the rateaero
figure(12);
cm=hsv(nw);
set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
plot(s.t,s.rateaero(:,iwvl),'.');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Rateaero [counts/ms]');ylim([0 1850]);
title([instrumentname ' - ' daystr ' - Rate for aerosol' ]);
grid on;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile(p1,[instrumentname daystr '_rateaero']);
fig_names{12} = [fname '.png'];
save_fig(12,fname,0);
pptcontents0=[pptcontents0; {fig_names{12} 4}];

% plot the rateaero
figure(13);
colormap(parula);
imagesc(s.t,s.w.*1000.0,s.rateaero',[0 1850]);
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Wavelength [nm]');
title([instrumentname ' - ' daystr ' - Rate for aerosol' ]);
cb = colorbarlabeled('Rateaero [counts/ms]');
fname = fullfile(p1,[instrumentname daystr '_rateaerocarpet']);
fig_names{13} = [fname '.png'];
save_fig(13,fname,0);
pptcontents0=[pptcontents0; {fig_names{13} 4}];

% plot the tau at one wvl and the flagged values
if isfield(s,'flags');
    figure(14);
    [ax,h1,h2] = plotyy(s.t,s.tau_aero_noscreening(:,45),s.t,s.rawrelstd);
    dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
    grid on;
    set(h1,'linestyle','none','marker','.','color','k');
    set(h2,'linestyle','none','marker','.');
    flfields = fields(s.flags); 
    flfields(strncmp(flfields, 't', 1)) = [];flfields(strncmp(flfields, 'flagfile',1)) = [];
    cm=hsv(length(flfields));
    set(ax(1), 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    labels = {'all points'};hold(ax(1),'all'); %hold on;
    markers = ['o';'+';'x';'d';'s';'^';'<';'>';'v';'*'];ms=6;
    for i=1:length(flfields);
        fla = s.flags.(flfields{i});
        if length(fla)>0;
            if any(fla);
                plot(ax(1),s.t(fla),s.tau_aero_noscreening(fla,45),markers(i),'markersize',ms);alpha(0.1);
                labels = [labels,{['flag - ' flfields{i}]}]; ms=ms+1.5;
            end;
        end
    end;
    labels = [labels,{'rawrelstd'}];
    hold off;
    xlabel('UTC time');xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);
    xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
    ylabel(ax(2),'Raw relative Std dev');ylim(ax(2),[0.0,0.02]);
    set(ax(2),'Ytick',[0,0.005,0.01,0.015,0.02]);
    ylabel(ax(1),['AOD at ' num2str(s.w(45).*1000.0,'%4.1f') ' nm']);
    title([instrumentname ' - ' daystr ' - AOD flags and rawrelstdev' ]);
    colormap([[0 0 1]; cm(1:length(labels)-1,:)]);
    legend(labels{:},'position','BestOutside');%lcolorbar(labels,'TitleString','\lambda [nm]','fontweight','bold');
    fname = fullfile(p1,[instrumentname daystr '_tau_flags']);
    fig_names{14} = [fname '.png'];
    save_fig(14,fname,0);
else;
    figure(14);
    plot(s.t,s.rawrelstd,'.');
    grid on; dynamicDateTicks;
    xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
    ylabel('Raw relative Std dev');ylim([0,0.02]);
    title([instrumentname ' - ' daystr ' - Raw relative std dev.' ]);
    fname = fullfile(p1,[instrumentname daystr '_flags']);
    fig_names{14} = [fname '.png'];
    save_fig(14,fname,0); 
end;
pptcontents0=[pptcontents0; {fig_names{14} 1}];


% plot the tau_aero
figure(15);
cm=hsv(nw);
set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
plot(s.t,s.tau_aero_noscreening(:,iwvl)','.');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('AOD');ylim([min(nanmin(s.tau_aero_noscreening(:,iwvl))) max(nanmax(s.tau_aero_noscreening(:,iwvl)))]);
title([instrumentname ' - ' daystr ' - AOD' ],'fontweight','bold');
grid on;
labels = strread(num2str(wvl,'%5.0f'),'%s');
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile(p1,[instrumentname daystr '_tau']);
fig_names{15} = [fname '.png'];
save_fig(15,fname,0);
pptcontents0=[pptcontents0; {fig_names{15} 1}];

% plot the tau_aero carpet
figure(16);
colormap(parula);
aod_mean = nanmean(s.tau_aero_noscreening(:,45));
if aod_mean>0.05;
    aod_rg = [-0.05 0.2];
else;
    aod_rg = [-0.05 0.05];
end;
imagesc(s.t,s.w.*1000.0,s.tau_aero_noscreening',aod_rg);
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Wavelength [nm]');
title([instrumentname ' - ' daystr ' - AOD' ],'fontweight','bold');
cb = colorbarlabeled('AOD');
fname = fullfile(p1,[instrumentname daystr '_tauocarpet']);
fig_names{16} = [fname '.png'];
save_fig(16,fname,0);
pptcontents0=[pptcontents0; {fig_names{16} 1}];

% plot the aod spectra at a few times
figure(17);
sp_num = 15;
if isfield(s,'flags');
    ii = [1:length(s.t)];
    ii = ii(~s.flags.bad_aod);
    if ~any(ii);
        ntot = length(s.t);
        ii = [1:ntot];
    else;
        ntot = length(s.t(~s.flags.bad_aod));
    end;
else;
    ntot = length(s.t);
    ii = [1:ntot];
end;
inum = floor(linspace(20,ntot,sp_num));
cm=jet(sp_num);
set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
plot(s.w.*1000.0,s.tau_aero_noscreening(ii(inum),:),'-');
xlim([300,1200]); ylim([0.004,0.5]);
set(gca,'xscale','log','yscale','log');
set(gca,'XTick',[300 400 500 600 700 800 900 1000, 1100]);
hold on;labels = {datestr(s.t(ii(inum(1))),'HH:MM:SS')};
for i=2:sp_num;
%   plot(s.w.*1000.0,s.tau_aero_noscreening(ii(inum(i)),:),'-'); 
   labels = [labels;{datestr(s.t(ii(inum(i))),'HH:MM:SS')}];
end; 
xlabel('Wavelegnth [nm]');
ylabel('AOD');
title([instrumentname ' - ' daystr ' - AOD spectra' ],'fontweight','bold');
grid on;
colormap(cm);
lcolorbar(labels','TitleString','UTC time','fontweight','bold');
hold off;
fname = fullfile(p1,[instrumentname daystr '_tauspectra']);
fig_names{17} = [fname '.png'];
save_fig(17,fname,0);
pptcontents0=[pptcontents0; {fig_names{17} 1}];


%% Check if langley is defined
if isfield(s,'langley')|isfield(s,'langley1');
    % run the langley codes and get the figures;
    langley_figs = starLangley_fx(fname_2starsun,1,p1,'_MLO_May2017');
    pptcontents0=[pptcontents0; {langley_figs{1} 1}];
    pptcontents0=[pptcontents0; {langley_figs{2} 4}];
    pptcontents0=[pptcontents0; {langley_figs{3} 4}];
    pptcontents0=[pptcontents0; {langley_figs{4} 4}];
    pptcontents0=[pptcontents0; {langley_figs{5} 1}];
    pptcontents0=[pptcontents0; {langley_figs{6} 1}];
    pptcontents0=[pptcontents0; {langley_figs{9} 4}];
    pptcontents0=[pptcontents0; {langley_figs{10} 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
    pptcontents0=[pptcontents0; {langley_figs{end} 1}];
end;

if savefigure;
    % sort out the PowerPoint contents
    idx4=[];
    for ii=1:size(pptcontents0,1);
        if pptcontents0{ii,2}==1;
            pptcontents=[pptcontents; {pptcontents0(ii,1)}];
        elseif pptcontents0{ii,2}==4;
            idx4=[idx4 ii];
            if numel(idx4)==4 || ii==size(pptcontents0,1) || pptcontents0{ii+1,2}~=4;
                if numel(idx4)>=3;
                    pptcontents=[pptcontents; {pptcontents0(idx4,1)}];
                else
                    pptcontents=[pptcontents; {[pptcontents0(idx4,1);' ';' ']}];
                end;
                idx4=[];
            end;
        else
            error('Paste either 1 or 4 figures per slide.');
        end;
    end;
    makeppt(ppt_fname, [daystr ' ' instrumentname], pptcontents{:});
end;


return