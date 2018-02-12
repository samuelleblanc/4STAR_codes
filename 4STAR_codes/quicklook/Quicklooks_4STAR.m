function fig_names = Quicklooks_4STAR(fname_4starsun,fname_4star,ppt_fname);
%% Details of the program:
% NAME:
%   Quicklooks_4STAR
%
% PURPOSE:
%  To generate the 4STAR plots for quicklooks
%
% INPUT:
%  fname_4starsun: (optional) the full path of the 4STAR starsun.mat file
%  fname_4star: (optional) the full path of the 4STAR star.mat file
%  ppt_fname: (optional) the full powerpoint file path to ammend the figures.
%
% OUTPUT:
%  many plots showing details of 2STAR
%  fig_names: cell array of file names of the saved pngs
%  powerpoint with the said plots of 2STAR
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun for 4STAR
%  - starinfo for the flight
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Mauna Loa Observatory, 2017-06-05
%                 ported MLOstarbasicplots
%
%
% MODIFIED FROM:
% KORUSstarbasicplots(DAYSTR, PLATFORM, SAVEFIGURE) generates basic plots of
% KORUS 4STAR data for the single day specified by DAYSTR and for the
% PLATFORM. DAYSTR is a string of 8 numbers, such as '20151104'. PLATFORM
% is either 'flight' or 'ground'. The third and optional input, SAVEFIGURE,
% determines whether the figures are saved. This code requires a starinfo
% file (e.g., starinfo20151104.m), with the flight time specified in:
% 'flight': a 1x2 vector that indicates [take-off landing] times.
%
% Example:
%     % create a starsun.mat file unless it already exists.
%     daystr='20151104';
%     allstarmat; % create a star.mat; after this, put the 'flight' [take-off landing] times in starinfo....m, run figure;spvis(daystr,'t','Alt','.');
%     toggle.saveadditionalvariables=0;toggle.savefigure=0;toggle.computeerror=0;toggle.inspectresults=0;toggle.applynonlinearcorr=1;toggle.applytempcorr=0;toggle.dostarflag=0;toggle.doflagging=0;toggle.flagging=0;
%     starsun(fullfile(starpaths, [daystr 'star.mat']),fullfile(starpaths, [daystr 'starsun.mat']), toggle); % create a starsun.mat
%     % generate routine figures.
%     NAAMESstarbasicplots(daystr, 'flight', 1); % a ppt file created and saved; add manually flight notes, pictures, additional figures, etc.
%     NAAMESstarbasicplots(daystr, 'ground', 1); % a ppt file created and saved; add manually pictures, additional figures, etc.
%
% See NAAMESquickplots.m for plots for multiple days, ad hoc analyses, etc. See
% also NAAMES starbasicplots.m and SEstarbasicplots.m.
%
% Yohei, 2015/11/09, being modified from NAAMESstarbasicplots.m. Continuously evolving throughout the campaign.
% MS   , 2016/01/09, modified to accomodate MLO campaign data.
% MS   , 2016/04/06, modified to accomodate KORUS-AQ campaign data.
% MS   , 2016/05/13, added option to read gas_summary if not exist
% MS   , 2016/05/14, added flagging for gases plots
% KP   , 2016/06/29, trying to get this version (modified from KORUS*) to
%        make plots without throwing errors all over the place.  First goal
%        is probably to get rid of the gas plots, since we're currently not
%        running them because they take a long time and the retrievals the
%        first days here are probably not good because of clouds.
% SL   , 2017/05/26, modified for easier plotting with data from MLO May 2017
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%% Sanitize inputs and get file paths
if nargin<1; % no file path set
    [f1,p1] = uigetfile2('4STAR*starsun.mat','Choose 4STAR starsun file');
    fname_4starsun = [p1 f1];
    [ft,pt] = uigetfile2('4STAR*star.mat','Choose the 4STAR star.mat file');
    fname_4star = [pt ft];
elseif nargin<2;
    [p1, f, ext0]=fileparts(fname_4starsun);
    [ft,pt] = uigetfile2('4STAR*star.mat','Choose the 4STAR star.mat file');
    fname_4star = [pt ft];
else;
    [p1, f, ext0]=fileparts(fname_4starsun);
end;

[daystr, filen, datatype, instrumentname]=starfilenames2daystr({fname_4starsun});
savefigure = true;

if nargin <3;
    ppt_fname = fullfile(p1,[daystr '_' instrumentname '_Quicklooks.ppt']);
end;

%% Set up the load path of the files
disp(['Loading 4STAR file: ' fname_4starsun])
s = load(fname_4starsun);
disp(['Loading 4STAR file: ' fname_4star])
st = load(fname_4star);

%********************
%% set parameters and default titles
%********************
if length(unique(s.Lat))<=3;
    platform = 'ground';
else;
    platform = 'flight';
end;

tit = [instrumentname ' - ' daystr];

%********************
% prepare for plotting
%********************
t = s.t;
%% get the track info
track.T=[st.track.T1 st.track.T2 st.track.T3 st.track.T4];
track.P=[st.track.P1 st.track.P2 st.track.P3 st.track.P4];
bl=60/86400;
if numel(st.track.t)<=1;
    track.Tsm=track.T;
    track.Psm=track.P;
else;
    for i=1:4;
        track.Tsm(:,i)=boxxfilt(st.track.t, track.T(:,i), bl);
        track.Psm(:,i)=boxxfilt(st.track.t, track.P(:,i), bl);
    end;
end;
clear i;


%load(fps, 't', 'w', 'Alt', 'aerosolcols', 'viscols', 'nircols', ...
%    'tau_aero', 'tau_aero_noscreening', 'raw', 'm_aero', 'QdVlr', 'QdVtb', 'QdVtot','cwv','gas'); % sun data and nav data associated with them
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(s.t);
c=[visc(1:10) nirc(11:13)+1044];
colslist={'' c 1:13
    'VISonly' visc(3:9) 3:9
    'NIRonly' nirc(11:13)+1044 11:13};
iwvl = c; iwvlv = visc(1:10); iwvln = nirc(11:13)+1044;
wvl = s.w(iwvl); wvlv = s.w(iwvlv); wvln = s.w(iwvln); 

%% prepare the gas 'gas'/'cwv' does not exist in starsun
if isfield(s,'gas')
    cwv2plot  =s.cwv.cwv940m1;
    o32plot   =s.gas.o3.o3DU;
    no22plot  =s.gas.no2.no2_molec_cm2;
elseif exist([instrumentname daystr,'_gas_summary.mat'],'file')==2 %if the gas mat file exists...
    gas   = load(strcat(gasfile_path,daystr{:},'_gas_summary.mat'));
    cwv2plot =gas.cwv;
    o32plot  =gas.o3DU;
    no22plot =gas.no2_molec_cm2;
else;
    disp('No gas data found. Skipping...') %otherwise just skip it if we haven't run gas retrievals
end;

%% filter the gas fields to plot
% read starinfo files

disp(['on day:' daystr])
infofile_ = ['starinfo_' daystr '.m'];
infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
try
    s = infofnt(s);
catch
    eval([infofile_(1:end-2),'(s)']);
end

%% Load the flag filea and see if gas flags exist
if isfield(s, 'flagfilename');
    disp(['Loading flag file: ' s.flagfilename])
    flagO3 = load(s.flagfilename);
    % read flags
    flag  = flag.manual_flags.screen;
else;
    flag = zeros(length(s.t),1);
end;

if isfield(s, 'flagfilenameO3');
    disp(['Loading flag file: ' s.flagfilenameO3])
    flagO3 = load(s.flagfilenameO3);
    % read flags
    flagO3  = flagO3.manual_flags.screen;
else
    % don't flag
    flagO3   = zeros(length(s.t),1);
end

if isfield(s,'flagfilenameCWV');
    disp(['Loading flag file: ' s.flagfilenameCWV])
    flagCWV = load(s.flagfilenameCWV);
    flagCWV = flagCWV.manual_flags.screen;
else;
    flagCWV  = zeros(length(s.t),1);
end;

flagNO2  = ones(length(s.t),1);% flag all-bad calibration


%% read auxiliary data from starinfo and select rows
if isequal(platform, 'flight');
    if ~isfield(s,'flight');
        error(['Specify flight time period in starinfo_' daystr '.m.']);
    end;
    tlim=s.flight;
elseif isequal(platform, 'ground');
    if isfield(s,'flight');
        tlim=NaN(size(s.flight,1)+1,2);
        tlim(1,1)=t(1);
        tlim(end,2)=t(end);
        tlim(1:end-1,2)=s.flight(:,1);
        tlim(2:end,1)=s.flight(:,2);
    else
        tlim=t([1 end])';
    end;
    if ~isfield(s,'groundcomparison');
        s.groundcomparison=tlim;
    end;
end;

%% prepare to save a PowerPoint file
pptcontents={}; % pairs of a figure file name and the number of figures per slide
pptcontents0={};


%% Plot the housekeeping data
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
[ax,h1,h2] = plotyy(s.t,nfsmooth(s.Tprecon_C,60),s.t,nfsmooth(s.RHprecon_percent,60));
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on; hold on;
plot(ax(1),s.t,s.Tbox_C,'.r');
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]); xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
ylabel(ax(2),'RH [%]');
ylabel(ax(1),'Temperature [^\circC]');
legend(starfieldname2label('Tprecon'),starfieldname2label('Tbox'),starfieldname2label('RHprecon'));
title([instrumentname ' - ' daystr ' - Temperature and Pressure (precon)']);
fname = fullfile(p1,[instrumentname daystr '_TnP']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(2,fname,0);
pptcontents0=[pptcontents0; {fig_names{2} 4}];

% plot the can temperatures and pressures (smoothed)
% T&P from track
for ii={'T' 'P'};
    ysm=track.([ii{:} 'sm']);
    figtp = figure;
    plot(st.track.t, ysm, '.');
    dynamicDateTicks;
    lh=legend(starfieldname2label([ii{:} '1']),starfieldname2label([ii{:} '2']),starfieldname2label([ii{:} '3']),starfieldname2label([ii{:} '4']),'Location','Best');
    grid on;
    ylabel([ii{:} ', smoothed over ' num2str(bl*86400) ' s']);
    if strcmp(ii{:},'T'); title([tit ' - Temperature (head)']), else title([tit ' - Pressures (head)']), end;
    
    fname = fullfile(p1,[instrumentname daystr '_track_' ii{:}]);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(figtp,fname,0);
    pptcontents0=[pptcontents0; {fig_names{3} 4}];
end;
clear ii;

%% plot tracking details
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
fig_names = [fig_names,{[fname '.png']}];
save_fig(5,fname,0);
pptcontents0=[pptcontents0; {fig_names{4} 4}];

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
fig_names = [fig_names,{[fname '.png']}];
save_fig(4,fname,0);
pptcontents0=[pptcontents0; {fig_names{5} 4}];

% plot the orientation (Az El)
figure(3);
[ax,h1,h2] = plotyy(s.t,s.El_deg,s.t,s.AZ_deg);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
grid on;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
ylabel(ax(2),'Azimuth degrees [^\circ]')
ylabel(ax(1),'Elevation degrees [^\circ]');
title([instrumentname ' - ' daystr ' - Elevation and Azimuth angles']);
fname = fullfile(p1,[instrumentname daystr '_El_Az']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(3,fname,0);
pptcontents0=[pptcontents0; {fig_names{6} 4}];

% plot ambient Tst and Pst
figts = figure;
ax = plotyy(s.t,s.Tst,s.t,s.Pst);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
ylabel(ax(2),'Pst [hPa]');
ylabel(ax(1),'Tst [^\circC]');
title([instrumentname ' - ' daystr ' - Temperature and Pressure St']);
fname = fullfile(p1,[instrumentname daystr '_Tst_Pst']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figts,fname,0);
pptcontents0=[pptcontents0; {fig_names{7} 4}];

%********************
%% map flight path and airmasses
%********************
if isequal(platform, 'flight');
    % flight track map
    figm = figure;
    ss = scatter(st.vis_sun.Lon,st.vis_sun.Lat,4,st.vis_sun.t,'marker','.');
    leg = {'vis_sun'};
    fld = fields(st);
    fld_marks = '.+>^<vopx';
    for ii = 1:length(fld);
        if isequal(lower(fld{ii}(1:3)),'vis');
            %if isequal(lower(fld{ii}(5:end)),'sun'); continue, end;
            sso = scatter(st.(fld{ii}).Lon,st.(fld{ii}).Lat,4,st.(fld{ii}).t,'marker',fld_marks(ii));
            leg = [leg; {fld{ii}}];
        end;
    end;
    xlabel('Longitude [^\circ]')
    ylabel('Latitude [^\circ]');
    title([tit ' - flight track map']);    
    ch=colorbarlabeled('UTC');
    datetick(ch, 'y','keeplimits');
    legend(leg);
    fname = fullfile(p1,[instrumentname daystr '_map']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(figm,fname,0);
    pptcontents0=[pptcontents0; {fig_names{8} 1}];
    
    
    
    % altitude
    %...
    % longitude and altitude
    % ...
    % latitude and altitude
    % ...
end;

%********************
%% Start plotting the raw signals
%********************

% plot raw signal at one wavelength with parks and saturations, with Tint
figp = figure;
iw = 400;
[ax,h1,h2] = plotyy(s.t,s.raw(:,iw),s.t,s.visTint);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on;
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
hold on;
plot(s.t(s.Md==0),s.raw(s.Md==0,iw),'dc','markersize',4);
plot(s.t(s.Str==0),s.raw(s.Str==0,iw),'xm','markersize',4);
plot(s.t(isnan(s.rate(:,iw))),s.raw(isnan(s.rate(:,iw)),iw),'or');
plot(s.t(s.sat_time==1),s.raw(s.sat_time==1,iw),'sy','markersize',4);
hold off;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
ylabel(ax(2),'VIS Integration time [ms]')
ylabel(ax(1),['Raw at ' num2str(s.w(iw).*1000.0,'%4.1f') ' nm [counts]']);
title([instrumentname ' - ' daystr ' - Vis Raw counts, parks, saturation, Tint' ]);
if any(s.sat_time==1);
    legend('Raw','parked','Shuttered','removed','saturated','Tint');
else;
    a = legend('Raw','parked','Shuttered','removed','Tint');
    lpos = get(a,'Position');
    text(lpos(2),lpos(1),'No saturation','Units','normalized');
end;
fname = fullfile(p1,[instrumentname daystr '_vis_sats_parks_Tint']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figp,fname,0);
pptcontents0=[pptcontents0; {fig_names{9} 4}];

figp = figure;
iw = 1100;
[ax,h1,h2] = plotyy(s.t,s.raw(:,iw),s.t,s.nirTint);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on;
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
hold on;
plot(s.t(s.Md==0),s.raw(s.Md==0,iw),'dc','markersize',4);
plot(s.t(s.Str==0),s.raw(s.Str==0,iw),'xm','markersize',4);
plot(s.t(isnan(s.rate(:,iw))),s.raw(isnan(s.rate(:,iw)),iw),'or');
plot(s.t(s.sat_time==1),s.raw(s.sat_time==1,iw),'sy','markersize',4);
hold off;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-0.01 s.t(end)+0.01]);xlim(ax(2),[s.t(1)-0.01 s.t(end)+0.01]);
ylabel(ax(2),'NIR Integration time [ms]')
ylabel(ax(1),['Raw at ' num2str(s.w(iw).*1000.0,'%4.1f') ' nm [counts]']);
title([instrumentname ' - ' daystr ' - NIR Raw counts, parks, saturation, Tint' ]);
if any(s.sat_time==1);
    legend('Raw','parked','Shuttered','removed','saturated','Tint');
else;
    a = legend('Raw','parked','Shuttered','removed','Tint');
    lpos = get(a,'Position');
    text(lpos(2),lpos(1),'No saturation','Units','normalized');
end;
fname = fullfile(p1,[instrumentname daystr '_nir_sats_parks_Tint']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figp,fname,0);
pptcontents0=[pptcontents0; {fig_names{10} 4}];

pptcontents0=[pptcontents0; {' ' 4}];
pptcontents0=[pptcontents0; {' ' 4}];


%********************
%% plot the data
%********************
% plot the raw vis
frv = figure;
nw = length(iwvlv);
cm=hsv(nw+length(iwvln));
set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
plot(s.t,s.raw(:,iwvlv),'.');
dynamicDateTicks;
xlabel('UTC time');
ylabel('Raw [counts]');
xlim([s.t(1)-0.01 s.t(end)+0.01]);
title([tit ' - VIS Raw counts' ]);
grid on;
labels = strread(num2str(wvlv.*1000.0,'%5.0f'),'%s');
for ij=nw+1:nw+length(iwvln), labels{ij} = '.'; end;
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile(p1,[instrumentname daystr '_visraw']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(frv,fname,0);
pptcontents0=[pptcontents0; {fig_names{11} 4}];

% plot the raw nir
figure(12); nw = length(iwvln)
cm=hsv(nw+length(iwvlv));
set(gca, 'ColorOrder', cm(length(iwvlv)+1:end,:), 'NextPlot', 'replacechildren')
plot(s.t,s.raw(:,iwvln),'.');
dynamicDateTicks;
xlabel('UTC time');
ylabel('Raw [counts]');
xlim([s.t(1)-0.01 s.t(end)+0.01]);
title([instrumentname ' - ' daystr ' - NIR Raw counts' ]);
grid on;
labels = {};
for ij=1:length(iwvlv), labels{ij} = '.'; end;
lbl_tmp = strread(num2str(wvln.*1000.0,'%5.0f'),'%s');
labels = {labels{:},lbl_tmp{:}}';
colormap(cm);
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
fname = fullfile(p1,[instrumentname daystr '_nirraw']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(12,fname,0); 
pptcontents0=[pptcontents0; {fig_names{12} 4}];

% plot the raw carpet
figure(13);
colormap(parula);
imagesc(s.t,s.w.*1000.0,s.raw');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-0.01 s.t(end)+0.01]);
ylabel('Wavelength [nm]');
title([instrumentname ' - ' daystr ' - Raw counts' ]);
cb = colorbarlabeled('Raw counts');
fname = fullfile(p1,[instrumentname daystr '_rawcarpet']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(13,fname,0);
pptcontents0=[pptcontents0; {fig_names{13} 4}];

pptcontents0=[pptcontents0; {' ' 4}];

%% tau_aero plotting
tau_aero = s.tau_aero;
tau_aero_noscreening = s.tau_aero_noscreening;

% tau aero noscreening

if exist('tau_aero_noscreening');
    % plot the tau_aero_noscreening vis
    faodv = figure;
    nw = length(iwvlv);
    cm=hsv(nw+length(iwvln));
    set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
    plot(s.t,s.tau_aero_noscreening(:,iwvlv),'.');
    dynamicDateTicks;
    xlabel('UTC time');
    ylabel('tau_aero_noscreening');
    xlim([s.t(1)-0.01 s.t(end)+0.01]);
    title([tit ' - VIS AOD (no screening)' ]);
    grid on;    
    labels = strread(num2str(wvlv.*1000.0,'%5.0f'),'%s');
    for ij=nw+1:nw+length(iwvln), labels{ij} = '.'; end;
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    fname = fullfile(p1,[instrumentname daystr '_vis_tau_aero_noscreening']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(faodv,fname,0);
    pptcontents0=[pptcontents0; {fig_names{14} 4}];

    % plot the tau_aero_noscreening nir
    faodni = figure; nw = length(iwvln)
    cm=hsv(nw+length(iwvlv));
    set(gca, 'ColorOrder', cm(length(iwvlv)+1:end,:), 'NextPlot', 'replacechildren')
    plot(s.t,s.tau_aero_noscreening(:,iwvln),'.');
    dynamicDateTicks;
    xlabel('UTC time');
    ylabel('tau_aero_noscreening');
    xlim([s.t(1)-0.01 s.t(end)+0.01]);
    title([instrumentname ' - ' daystr ' - NIR AOD (no screening)' ]);
    grid on;
    labels = {};
    for ij=1:length(iwvlv), labels{ij} = '.'; end;
    lbl_tmp = strread(num2str(wvln.*1000.0,'%5.0f'),'%s');
    labels = {labels{:},lbl_tmp{:}}';
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    fname = fullfile(p1,[instrumentname daystr '_nir_tau_aero_noscreening']);
    fig_names{15} = [fname '.png'];
    save_fig(faodni,fname,0); 
    pptcontents0=[pptcontents0; {fig_names{15} 4}];
else; 
    pptcontents0=[pptcontents0; {' ' 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
end; %tau_aero_noscreening


% plot the tau_aero
if exist('tau_aero');
    % plot the tau_aero vis
    faodv_fl = figure;
    nw = length(iwvlv);
    cm=hsv(nw+length(iwvln));
    set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
    plot(s.t,s.tau_aero(:,iwvlv),'.');
    dynamicDateTicks;
    xlabel('UTC time');
    ylabel('tau_aero');
    xlim([s.t(1)-0.01 s.t(end)+0.01]);
    title([tit ' - VIS AOD' ]);
    grid on;
    labels = strread(num2str(wvlv.*1000.0,'%5.0f'),'%s');
    for ij=nw+1:nw+length(iwvln), labels{ij} = '.'; end;
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    fname = fullfile(p1,[instrumentname daystr '_vis_tau_aero']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(faodv_fl,fname,0);
    pptcontents0=[pptcontents0; {fig_names{16} 4}];

    % plot the tau_aero_noscreening nir
    faodni = figure; nw = length(iwvln)
    cm=hsv(nw+length(iwvlv));
    set(gca, 'ColorOrder', cm(length(iwvlv)+1:end,:), 'NextPlot', 'replacechildren')
    plot(s.t,s.tau_aero(:,iwvln),'.');
    dynamicDateTicks;
    xlabel('UTC time');
    ylabel('tau_aero');
    xlim([s.t(1)-0.01 s.t(end)+0.01]);
    title([instrumentname ' - ' daystr ' - NIR AOD' ]);
    grid on;
    labels = {};
    for ij=1:length(iwvlv), labels{ij} = '.'; end;
    lbl_tmp = strread(num2str(wvln.*1000.0,'%5.0f'),'%s');
    labels = {labels{:},lbl_tmp{:}}';
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    fname = fullfile(p1,[instrumentname daystr '_nir_tau_aero']);
    fig_names{17} = [fname '.png'];
    save_fig(faodni,fname,0); 
    pptcontents0=[pptcontents0; {fig_names{17} 4}];
else
    pptcontents0=[pptcontents0; {' ' 4}];
    pptcontents0=[pptcontents0; {' ' 4}];
end; %tau_aero_noscreening


% water vapor

if exist('cwv2plot');
    
    % apply flags
    cwv2plot(flagCWV==1) = NaN;
    
    figure;
    [h,filename]=spsun(daystr, 't', cwv2plot, '.', vars.Alt1e4{:}, mods{:}, ...
        'cols', colslist{k,2}, 'ylabel', 'CWV [g/cm2]', ...
        'filename', ['star' daystr platform 'cwvtseries' colslist{k,1}]);
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
end;


% O3

if exist('o32plot');
    
    % apply flags
    o32plot(flagO3==1) = NaN;
    
    figure;
    [h,filename]=spsun(daystr, 't', o32plot, '.', vars.Alt1e4{:}, mods{:}, ...
        'cols', colslist{k,2}, 'ylabel', 'O3 [DU]', ...
        'filename', ['star' daystr platform 'o3tseries' colslist{k,1}]);
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
end;

% NO2

if exist('no22plot');
    
    % apply flags
    o32plot(flagO3==1) = NaN;
    
    figure;
    [h,filename]=spsun(daystr, 't', no22plot, '.', vars.Alt1e4{:}, mods{:}, ...
        'cols', colslist{k,2}, 'ylabel', 'NO2 [DU]', ...
        'filename', ['star' daystr platform 'no2tseries' colslist{k,1}]);
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
end;


% tau aero after correction based on AATS
if ~exist('tau_aero_scaled') && exist(fullfile(starpaths, ['star' daystr 'c0corrfactor.dat']))==2;
    c0corrfactor=load(fullfile(starpaths, ['star' daystr 'c0corrfactor.dat']));
    tau_aero_scaled=tau_aero+(1./m_aero)*log(c0corrfactor);
end;
if exist('tau_aero_scaled');
    for k=1:size(colslist,1); % for multiple sets of wavelengths
        figure;
        [h,filename]=spsun(daystr, 't', tau_aero_scaled, '.', vars.Alt1e5{:}, mods{:}, ...
            'cols', colslist{k,2}, 'ylabel', 'tau_aero_scaled', ...
            'filename', ['star' daystr platform 'tau_aero_scaledtseries' colslist{k,1}]);
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
    end;
end;

% zenith radiance time series
starzenfile=fullfile(starpaths, [daystr 'starzen.mat']);
if exist(starzenfile);
    load(starzenfile, 'Alt');
    figure;
    [h,filename]=spzen(daystr, 't', 'rad', '.', 't', Alt/100, mods{:}, ...
        'cols', c, ...
        'filename', ['star' daystr platform 'zenradtseries']);
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
else
    warning([starzenfile ' does not exist. No zenith radiance plot is created.']);
end;

%********************
% plot spectra in comparison with AATS-14
%********************
if isequal(platform, 'ground') && exist(fullfile(starpaths, [daystr 'aats.mat']))==2;
    [both, ~, aats]=staraatscompare(daystr);
    both.rows=incl(both.t, tlim);
    % 4STAR AATS time-series comparison, wavelength by wavelength
    for ii=[1:9 11:13];
        figure;
        if isfield(both, 'tau_aero') & isfield(both, 'dtau_aero');
            ph=plot(both.t(both.rows),both.tau_aero(both.rows,c(ii)), '.', ...
                aats.t,aats.tau_aero(ii,:), '.', ...
                both.t(both.rows), both.dtau_aero(both.rows,ii), '.', ...
                both.t(both.rows), both.trratio(both.rows,ii)-1, '.');
            vali=find(isfinite(both.dtau_aero(both.rows,ii))==true);
            xlim(both.t(both.rows(vali([1 end])))'+[-1 1]*60/86400);
            hold on
            plot(xlim, [0 0], '-k');
            ystr='tau aero, \Deltatau aero, Tr Ratio';
            yl=ylim;
            ylim([min([max([yl(1) -.1]) -0.1]) max([min([yl(2) .1]) 0.1])]*3.5);
            set(gca,'ytick',[-0.5:0.1:-0.2 -0.1:0.01:0.1 0.2:0.1:0.5]);
            lh=legend(ph, ['4STAR ' num2str(both.w(c(ii))*1000, '%0.2f') ' nm'],...
                ['AATS ' num2str(aats.w(ii)*1000, '%0.2f') ' nm'], ...
                '4STAR-AATS', ...
                'Transmittance Ratio, 4STAR/AATS, -1');
        elseif isfield(both, 'tau_aero_noscreening');
            ph=plot(both.t(both.rows),both.tau_aero_noscreening(both.rows,c(ii)), '.', ...
                aats.t,aats.tau_aero(ii,:), '.', ...
                both.t(both.rows), both.dtau_aero(both.rows,ii), '.');
            xl=xlim;
            xlim([max([xl(1) floor(t(1))]) min([xl(2) floor(t(end))])])
            ystr='tau aero noscreening';
            yl=ylim;
            ylim([max([yl(1) 0]) min([yl(2) 0.5])]);
            lh=legend(ph, ['4STAR ' num2str(both.w(c(ii))*1000, '%0.2f') ' nm'],['AATS ' num2str(aats.w(ii)*1000, '%0.2f') ' nm']);
        else; % no longer used; for record keeping
            ph=plot(both.t(both.rows),both.tau_aero_noscreening(both.rows,c(ii)), '.b', ...
                both.t(both.rows),both.tau_aero_noscreening(both.rows,c(ii))-repmat(tau_aero_ref(c(ii)),size(both.rows)), '.b', ...
                aats.t,aats.tau_aero(ii,:), '.');
            set(ph(1),'color',[0.5 0.5 0.5]);
            set(ph(end),'color',[0 0.5 0],'markersize',12);
            xl=xlim;
            xlim([max([xl(1) floor(t(1))]) min([xl(2) floor(t(end))])])
            ystr='tau aero noscreening';
            yl=ylim;
            ylim([max([yl(1) 0]) min([yl(2) 0.5])]);
            lh=legend(ph, ['4STAR ' num2str(both.w(c(ii))*1000, '%0.2f') ' nm'],['AATS ' num2str(aats.w(ii)*1000, '%0.2f') ' nm']);
        end;
        ggla;
        grid on;
        dateticky('x','keeplimits');
        xlabel('Time');
        ylabel(ystr);
        title(daystr);
        set(lh,'fontsize',12,'location','best');
        filename=['star' daystr 'AATS' ystr(regexp(ystr,'\w')) '_' num2str(aats.w(ii)*1000, '%0.0f') 'nm'];
        if savefigure;
            starsas([filename '.fig, ' mfilename '.m'])
        end;
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}];
    end
    
    % time series of the delta tau_aero at all overlapping wavelengths
    if isfield(both, 'tau_aero') & isfield(both, 'dtau_aero');
        for k=1:size(colslist,1); % for multiple sets of wavelengths
            cols=colslist{k,3};
            figure;
            ph=plot(both.t(both.rows), both.dtau_aero(both.rows,cols), '.');
            vali=find(any(isfinite(both.dtau_aero(both.rows,cols)),2)==true);
            xlim(both.t(both.rows(vali([1 end])))'+[-1 1]*60/86400);
            hold on
            plot(xlim, [0 0], '-k');
            ystr='\Deltatau aero, 4STAR-AATS';
            ylabel(ystr);
            ylim([-0.1 0.1]);
            yl=ylim;
            ylim([min([max([yl(1) -1]) -0.1]) max([min([yl(2) 1]) 0.1])]);
            set(gca,'ytick',[-0.5:0.1:-0.2 -0.1:0.01:0.1 0.2:0.1:0.5]);
            ggla;
            grid on;
            dateticky('x','keeplimits');
            xlabel('Time');
            title(daystr);
            lstr=setspectrumcolor(ph, aats.w(cols));
            lh=legend(ph,lstr);
            set(lh,'fontsize',12,'location','best');
            filename=['star' daystr 'AATS' ystr(regexp(ystr,'\w')) colslist{k,1}];
            if savefigure;
                starsas([filename '.fig, ' mfilename '.m'])
            end;
            pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
        end;
    end;
    
    % transmittance ratio, 4STAR/AATS, against wavelengths
    if ~exist('groundcomparison');
        rows=incl(both.t, groundcomparison);
        % extrapolate to non-AATS wavelengths
        aatsgoodviscols=[2:7 9];
        aatsgoodnircols=[11 13]; % "You should ignore AATS 1.2 um." says Phil, Aug. 13, 2013.
        %         visc0corrfactor=interp1(aats.w(aatsgoodviscols), nanmean(both.trratio(rows,aatsgoodviscols),1), w, 'cubic');
        %         [p,S] = polyfit(log(aats.w(aatsgoodviscols)),nanmean(both.trratio(rows,aatsgoodviscols),1),2);
        [p,S] = polyfit(log(aats.w(aatsgoodviscols)),nanmedian(both.trratio(rows,aatsgoodviscols),1),2);
        visc0corrfactor=polyval(p,log(w));
        %         nirc0corrfactor=interp1(aats.w(aatsgoodnircols), nanmean(both.trratio(rows,aatsgoodnircols),1), w, 'cubic');
        %         [p,S] = polyfit(log(aats.w(aatsgoodnircols)),nanmean(both.trratio(rows,aatsgoodnircols),1),2);
        [p,S] = polyfit(log(aats.w(aatsgoodnircols)),nanmedian(both.trratio(rows,aatsgoodnircols),1),2);
        nirc0corrfactor=polyval(p,log(w));
        c0corrfactor=[visc0corrfactor(1:1044) nirc0corrfactor(1044+(1:512))];
        save(fullfile(starpaths, ['star' daystr 'c0corrfactor.dat']), 'c0corrfactor', '-ascii'); !!! format and locate this line better
        tau_aero_scaled=tau_aero+(1./m_aero)*log(c0corrfactor);
        % plot tr ratio
        figure;
        %         sh=semilogx(aats.w(1:13), both.trratio(rows,:), 'c.', ...
        %             w, c0corrfactor, '.m', ...
        %             w([1 end]), [1 1], '-k');
        %         set(sh(1:end-2),'markersize',24);
        xxs=repmat(aats.w(1:13),size(rows));
        yys=both.trratio(rows,:);
        ccs=24*ones(size(both.trratio(rows,:)));
        sss=repmat(both.t(rows),1,size(both.trratio,2));
        sh=scatter(xxs(:), yys(:), ccs(:), sss(:));
        ch=colorbarlabeled('UTC');
        datetick(ch,'y','keeplimits');
        hold on;
        plot(w, c0corrfactor, '.m', ...
            w([1 end]), [1 1], '-k');
        gglwa;
        grid on;
        ylim([0.8 1.2]);
        xlabel('Wavelength (nm)');
        ylabel('Tr. Ratio, 4STAR/AATS');
        title([daystr ' ' datestr(groundcomparison(1), 13) ' - ' datestr(groundcomparison(end), 13)]);
        filename=['star' daystr datestr(groundcomparison(1), 'HHMMSS') datestr(groundcomparison(end), 'HHMMSS') 'AATStrratio'];
        if savefigure;
            starsas([filename '.fig, ' mfilename '.m'])
        end;
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
        % plot spectra
        figure;
        h=starplotspectrum(w, nanmean(tau_aero(rows,:),1), aerosolcols, viscols, nircols);
        set(h, 'color',[.5 .5 .5]);
        hold on;
        hcorr=starplotspectrum(w, nanmean(tau_aero_scaled(rows,:),1), aerosolcols, viscols, nircols);
        %         set(gca,'yscale','linear');
        gglwa;
        ylim([0.01 1]);
        grid on;
        xlabel('Wavelength (nm)');
        ylabel('Optical Depth');
        title([daystr ' ' datestr(groundcomparison(1), 13) ' - ' datestr(groundcomparison(end), 13)]);
        filename=['star' daystr datestr(groundcomparison(1), 'HHMMSS') datestr(groundcomparison(end), 'HHMMSS') 'tau_aero_scaledspectra'];
        if savefigure;
            starsas([filename '.fig, ' mfilename '.m'])
        end;
        pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
    end;
    
    % % %     % spectra, average
    % % %     figure;
    % % %     ok=both.rowscomparison;
    % % %     aats.ok=interp1(aats.t,1:numel(aats.t),both.t(ok),'nearest');
    % % %     aats.ok=unique(aats.ok(isfinite(aats.ok)));
    % % %     h=starplotspectrum(w, nanmean(both.tau_aero(ok,:)), aerosolcols, viscols, nircols);
    % % %     hold on;
    % % %     ah=plot(aats.w, nanmean(aats.tau_aero(:,aats.ok)'), '.', 'markersize',12,'color', [0 0.5 0]);
    % % %     % starttstr=datestr(tlim(1),13);
    % % %     % stoptstr=datestr(tlim(2),13);
    % % %     ylabel('Optical Depth');
    % % %     % title([refdaystr ' on the ground ' starttstr ' - ' stoptstr]);
    % % %     title([daystr ' MLO']);
    % % %     % lh=legend([h(2) h2(2) ah], 'TCAP winter cal', 'high alt subtracted', 'AATS-14');
    % % %     % set(lh,'fontsize',12,'location','best');
    % % %     if savefigure;
    % % %         %     starsas(['star' daystr datestr(tlim(1),'HHMMSS') datestr(tlim(2),'HHMMSS') 'ground_tau_aero.fig, SEquickplots.m'])
    % % %         starsas(['star' daystr 'ground_tau_aero.fig, SEquickplots.m'])
    % % %     end;
    % % %
    % % %     % spectra, individual
    % % %     figure;
    % % %     ok=both.rowscomparison;
    % % %     aats.ok=interp1(aats.t,1:numel(aats.t),both.t(ok),'nearest');
    % % %     aats.ok=unique(aats.ok(isfinite(aats.ok)));
    % % %     h=starplotspectrum(w, both.tau_aero(ok,:), aerosolcols, viscols, nircols);
    % % %     hold on;
    % % %     ah=plot(aats.w, aats.tau_aero(:,aats.ok)', '.', 'markersize',12,'color', [0 0.5 0]);
    % % %     % starttstr=datestr(tlim(1),13);
    % % %     % stoptstr=datestr(tlim(2),13);
    % % %     ylabel('Optical Depth');
    % % %     % title([refdaystr ' on the ground ' starttstr ' - ' stoptstr]);
    % % %     title([daystr ' MLO']);
    % % %     lh=legend([h(2) h2(2) ah], 'TCAP winter cal', 'high alt subtracted', 'AATS-14');
    % % %     set(lh,'fontsize',12,'location','best');
    % % %     if savefigure;
    % % %         starsas(['star' daystr datestr(tlim(1),'HHMMSS') datestr(tlim(2),'HHMMSS') 'ground_tau_aero.fig, SEquickplots.m'])
    % % %     end;
    
    %     % 4STAR/AATS ratio (not normalized) v. airmass
    %     figure;
    %     cols=find(isfinite(both.c(2,:))==1);
    %     ph=plot(both.m_aero, both.rateratiotoaats(:,cols), '.');
    %     xlabel('Aerosol Airmass Factor');
    %     ylabel('4STAR/AATS');
    %     ggla;
    %     grid on;
    %     lstr=setspectrumcolor(ph, both.w(both.c(2,cols)));
    %     title(daystr);
    %     lh=legend(ph,lstr);
    %     set(lh,'fontsize',12,'location','best');
    %     if savefigure;
    %         starsas(['star' daystr 'rateratiotoAATSvm_aero'  '.fig, SEquickplots.m'])
    %         pause(3);
    %     end;
    %     set(ph([1 2 10:end]), 'visible','off','markersize',1);
    %     set(lh,'fontsize',12,'location','best');
    %     if savefigure;
    %         starsas(['star' daystr 'rateratiotoAATSvm_aero' 'VISonly.fig, SEquickplots.m'])
    %         pause(3);
    %     end;
    %     ylim([0 2]);
    %     set(ph([1 2 10:end]), 'visible','on','markersize',6);
    %     set(ph([1:10]), 'visible','off','markersize',1);
    %     set(lh,'fontsize',12,'location','best');
    %     if savefigure;
    %         starsas(['star' daystr 'rateratiotoAATSvm_aero' 'NIRonly.fig, SEquickplots.m'])
    %         pause(3);
    %     end;
    %
    %     % 4STAR/AATS ratio normalized v. airmass
    %     figure;
    %     cols=find(isfinite(both.c(2,:))==1);
    %     ph=plot(both.m_aero, both.raterelativeratiotoaats(:,cols), '.');
    %     hold on;
    %     plot(xlim, [1 1], '-k');
    %     xlabel('Aerosol Airmass Factor');
    %     ylabel(['4STAR/AATS, ' datestr(both.t(both.noonrow),13) '=1']);
    %     ylim([0.96 1.04]);
    %     ggla;
    %     grid on;
    %     lstr=setspectrumcolor(ph, both.w(both.c(2,cols)));
    %     title(daystr);
    %     lh=legend(ph,lstr);
    %     set(lh,'fontsize',12,'location','best');
    %     if savefigure;
    %         starsas(['star' daystr 'raterelativeratiotoAATSvm_aero'  '.fig, SEquickplots.m'])
    %         pause(3);
    %     end;
    %     ylim([0.94 1.02])
    %     set(ph([1 2 10:end]), 'visible','off','markersize',1);
    %     set(lh,'fontsize',12,'location','best');
    %     if savefigure;
    %         starsas(['star' daystr 'raterelativeratiotoAATSvm_aero' 'VISonly.fig, SEquickplots.m'])
    %         pause(3);
    %     end;
    %     set(ph([1 2 10:end]), 'visible','on','markersize',6);
    %     set(ph([1:10]), 'visible','off','markersize',1);
    %     set(lh,'fontsize',12,'location','best');
    %     if savefigure;
    %         starsas(['star' daystr 'raterelativeratiotoAATSvm_aero' 'NIRonly.fig, SEquickplots.m'])
    %         pause(3);
    %     end;
end;

%********************
% plot FOV carpet
%********************
% % % v=who('-file', fullfile(starpaths, [daystr 'star.mat'])); % list all variables in the star.mat (not starsun.mat)
% % % datatypelist={'vis_fova' 'nir_fova' 'vis_fovp' 'nir_fovp'};
% % % existingfigures=get(0,'children');
% % % for dtli=1:numel(datatypelist);
% % %     datatype=datatypelist{dtli};
% % %     if any(ismember(v, datatype)); % check if any FOV was taken
% % %         load(fullfile(starpaths, [daystr 'star.mat']), datatype); % load the variable of the specific datatype
% % %         eval(['v2=' datatype ';']);
% % %         for i=1:numel(v2); % go through each set of FOV test
% % %             if ~isempty(v2(i).t) && ~isempty(incl(nanmean(v2(i).t(1)),tlim)); % see if there is actually a data point
% % %                 ins = FOV_scan(v2(i)); % run Connor's code
% % %                 existingfigures2=get(0,'children');
% % %                 newfigures=setxor(existingfigures,existingfigures2); % identify new figures
% % %                 for nn=1:numel(newfigures);
% % %                     figure(newfigures(nn));
% % %                     [~,filename0,~]=fileparts(v2(i).filename{:});
% % %                     filename=['star' filename0 'figure' num2str(nn)];
% % %                     if savefigure;
% % %                         starsas([filename '.fig, ' mfilename '.m'])
% % %                     end;
% % %                     pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 4}]; % prepare to save the figures in the PowerPoint file to be created
% % %                     clear filename0 filename;
% % %                 end;
% % %                 for nn=1:ceil(numel(newfigures)/4)*4-numel(newfigures); % feed the ppt file with blank, so the next set of FOV plots go to a new page
% % %                     pptcontents0=[pptcontents0; {' ' 4}];
% % %                 end;
% % %                 existingfigures=existingfigures2;
% % %                 clear existingfigures2;
% % %             end;
% % %         end;
% % %     end;
% % % end;

%********************
% Generate a new PowerPoint file
%********************
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
    makeppt(ppt_fname, [daystr ' ' platform], pptcontents{:});
end;
