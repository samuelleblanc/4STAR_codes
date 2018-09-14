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
%  many plots showing details of 4STAR
%  fig_names: cell array of file names of the saved pngs
%  powerpoint with the said plots of 4STAR
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
% SL   , 2018/05/08, added automated FOV plotting
% CF   , 2018/08/26, moved Langley towards top, cosmetic changes to output
%        filenames (inserted '_') for readability and consistency with
%        other files
% -------------------------------------------------------------------------

%% function start
version_set('1.2');
%% prepare to save a PowerPoint file
set(groot, 'defaultAxesTickLabelInterpreter','None'); set(groot, 'defaultLegendInterpreter','None');
set(groot, 'defaultAxesTitle','None'); 

pptcontents={}; % pairs of a figure file name and the number of figures per slide
pptcontents0={};

%% Sanitize inputs and get file paths
if nargin<1; % no file path set
    fname_4star = getfullname('4STAR*star.mat','starmat','Choose the 4STAR star.mat file');
    fname_4starsun = getfullname('4STAR*starsun.mat','starsun','Choose starsun file');  
    [p1, f, ext0]=fileparts(fname_4starsun);
elseif nargin<2;
    [p1, f, ext0]=fileparts(fname_4starsun);
    fname_4star = getfullname('4STAR*star.mat','starmat','Choose the 4STAR star.mat file');
%     [ft,pt] = uigetfile2('4STAR*star.mat','Choose the 4STAR star.mat file');
%     fname_4star = [pt ft];
else;
    [p1, f, ext0]=fileparts(fname_4starsun);
end;
p1 = getnamedpath('starimg');
[daystr, filen, datatype, instrumentname]=starfilenames2daystr({fname_4starsun});
savefigure = true;

if nargin <3;
    ppt_fname = fullfile(getnamedpath('starppt'),[daystr '_' instrumentname '_Quicklooks.ppt']);
end;

%% Set up the load path of the files
st = load(fname_4star);
s = load(fname_4starsun);

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
%% prepare for plotting
%********************
t = s.t;
dt = s.t(end)-s.t(1);
if dt>0.2;
    ddt = 0.01;
else;
    ddt = 0.0005;
end;

%% get the track info
if strcmp(instrumentname,'4STARB'); st.track.T2 =st.track.T2+273.15; end;
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
track.Psm(:,1) = (track.Psm(:,1)-0.19).*10.0./1000.0; % to convert V to mbar
track.Psm(:,4) = (track.Psm(:,3)-0.19).*10.0./1000.0; % to convert V to mbar
track.Psm(:,3) = (track.Psm(:,4)-0.19).*10.0./1000.0; % to convert V to mbar
track.RHsm = (track.Psm(:,2)./5.0-0.16)./0.0062; %convert to RH in percent;
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

%% Check if langley is defined
if isfield(s,'langley')||isfield(s,'langley1');
    % run the langley codes and get the figures;
    if isfield(s,'ground')||strcmp(platform,'ground');  xtra = '_ground_langley'; elseif isfield(s,'flight'); xtra = '_flight_langley'; end;
    langley_figs = starLangley_fx_(s,1,p1,xtra);
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

%% Load the flag files and see if gas flags exist
if isfield(s, 'flagfilename');
    disp(['Loading flag file: ' s.flagfilename])
    flag = load(s.flagfilename);
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


%% Set up fields to plot
fld = fields(st);
ifld  = cellfun(@(C) ischar(C) && strcmp(C(1:3),'nir') | strcmp(C(1:3),'tra') | strcmp(C(1:3),'pro'),fld);
fld = {fld{~ifld}};
fld = {fld{strcmp(fld,'vis_sun')},fld{strcmp(fld,'vis_zen')},fld{~strcmp(fld,'vis_sun')&~strcmp(fld,'vis_zen')}}; % sun and then zen on first positions;
fld_marks = '.+>^<vopx';
cls = 'krgbcmy';

%********************
%% Plot the housekeeping data
%********************
% plot altitude and modes
falt = figure;
sso = plot(s.t,s.Alt,[cls(1) fld_marks(1)]); hold on; leg={'vis_sun'}; plo = sso;
for ii = 2:length(fld);
    if length(st.(fld{ii}))>1;
        for jj=1:length(st.(fld{ii})); sso = plot(st.(fld{ii})(jj).t,st.(fld{ii})(jj).Alt,'Marker',fld_marks(ii),'MarkerFaceColor',cls(ii),'MarkerEdgeColor',cls(ii),'MarkerSize',8); end;
    else;
        sso = plot(st.(fld{ii}).t,st.(fld{ii}).Alt,'Marker',fld_marks(ii),'MarkerFaceColor',cls(ii),'MarkerEdgeColor',cls(ii),'MarkerSize',8);
    end;
    leg = [leg; {fld{ii}}];
    plo = [plo sso];
end;
grid on;
ylabel('Altitude [m]'); xlabel('Time'); title([tit ' - Altitude vs. time']);
dynamicDateTicks;
legend(plo,leg,'Interpreter', 'none','Location', 'Best');
fname = fullfile(p1,[instrumentname daystr '_alt']);
fig_names = {[fname '.png']};
save_fig(falt,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];


% plot temperatures and pressures in the spectrobox
ftnp = figure;
subplot(3,1,[1,2]);
[Ts,tt] = nfsmooth(s.Tprecon_C,60);
[RHs,rr] = nfsmooth(s.RHprecon_percent,60); high_RH = find(RHs>2);
[ax,h1,h2] = plotyy(s.t(tt),Ts,s.t(rr),RHs);
if length(high_RH)>300; 
    set(ax(1),'Color',[1,0.5,0.5]);
    text(ax(2),s.t(1),0.5,'RH > 2% Too high!');
    set(ftnp, 'InvertHardCopy', 'off');
end;

if length(find(nfsmooth(s.Tprecon_C,60)>35.0))>300; 
    set(ax(1),'Color',[1,0.5,0.0]);
    text(ax(1),s.t(1),20,'Temperatures Too high! (larger than 35C)');
    set(ftnp, 'InvertHardCopy', 'off');
end;

if std(nfsmooth(s.Tprecon_C,60))>2.5; 
    set(ax(1),'Color',[1,0.5,0.0]);
    text(ax(1),s.t(1),20,'Temperatures are too variable!','FontSize',18);
    set(ftnp, 'InvertHardCopy', 'off');
end;

dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
set(gca,'xticklabels',[''])
grid on;
[lg,ic] = legend(starfieldname2label('Tprecon'),starfieldname2label('RHprecon'),'Location', 'Best');
for uu=1:length(ic); try; set(ic(uu),'MarkerSize',18);end;end;

ax2 = subplot(3,1,3);
linkaxes([ax(1),ax(2),ax2],'x');
plot(ax2,s.t,s.Tbox_C,'.','color', 	[0.5,0.5,0.5]); hold on;
plot(ax2,s.t,nfsmooth(s.Tbox_C,60),'.g');
grid on;
dynamicDateTicks;
xlabel('UTC time');
xlim(ax(1),[s.t(1)- ddt s.t(end)+ ddt]); xlim(ax(2),[s.t(1)-ddt s.t(end)+ddt]);
ylim(ax(1),[10,40]); ylim(ax2,[-10;50]);set(ax(1),'ytick',[10,15,20,25,30,35,40]);
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
ylabel(ax(2),'RH [%], smoothed over 60s');
ylabel(ax(1),'Temperature [^\circC], smoothed over 60s');
ylabel(ax2,'T [^\circC]');
[lg,ic] = legend(['raw ' starfieldname2label('Tbox')],['smoothed over 60s ' starfieldname2label('Tbox')],'Location', 'Best');
for uu=1:length(ic); try; set(ic(uu),'MarkerSize',18);end;end;
title(ax(1),[instrumentname ' - ' daystr ' - Temperature and Pressure (precon) in spectrometer box']);
fname = fullfile(p1,[instrumentname daystr '_TnP']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(ftnp,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

%% plot the can temperatures and pressures (smoothed)
% T from track
ii={'T'};
ysm=track.([ii{:} 'sm']);
figtp = figure;
plot(st.track.t, ysm, '.');
dynamicDateTicks;
[lh,ic]=legend(starfieldname2label([ii{:} '1']),starfieldname2label([ii{:} '2']),starfieldname2label([ii{:} '3']),starfieldname2label([ii{:} '4']),'Location','Best');
for uu=1:length(ic); try; set(ic(uu),'MarkerSize',18);end;end;
grid on;
ylabel([ii{:} ', smoothed over ' num2str(bl*86400) ' s']);
title([tit ' - Temperature (head)'])
fname = fullfile(p1,[instrumentname daystr '_track_' ii{:}]);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figtp,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

% P from track
figtpp = figure;
ii = {'P'};
[ax,h1,h2] = plotyy(st.track.t,track.Psm(:,1),st.track.t,track.RHsm);
hold on; plot(ax(1),st.track.t,track.Psm(:,3),'g.');plot(ax(1),st.track.t,track.Psm(:,4),'k.');
set(ax(1),'YLim',[-Inf,Inf]); set(ax(1),'ytick',linspace(min(min(track.Psm(:,[1 3 4]))),max(max(track.Psm(:,[1 3 4]))),5));
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
[lh,ic]=legend(starfieldname2label([ii{:} '1']),starfieldname2label([ii{:} '3']),starfieldname2label([ii{:} '4']),'Location','Best');
for uu=1:length(ic); try; set(ic(uu),'MarkerSize',18);end;end;
grid on;
xlabel('UTC time');
xlim(ax(1),[st.track.t(1)-ddt st.track.t(end)+ddt]);xlim(ax(2),[st.track.t(1)-ddt st.track.t(end)+ddt]);
ylabel(ax(2),['Relative Humidity [%]' ', smoothed over ' num2str(bl*86400) ' s'])
ylabel(ax(1),['Pressure [mb]' ', smoothed over ' num2str(bl*86400) ' s']);
pos1 = get(ax(1), 'Position');pos2 = get(ax(2), 'Position');
set(ax(1), 'Position', [pos1(1) pos1(2) pos1(3)-0.08 pos1(4)]);
set(ax(2), 'Position', [pos2(1) pos2(2) pos2(3)-0.08 pos2(4)]);
title([instrumentname ' - ' daystr ' - Pressures and RH (head)']);
fname = fullfile(p1,[instrumentname daystr '_track_P']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figtpp,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

%plot airmasses
hsk = figure;
plot(s.t,real(s.m_aero),'.b');
hold on;
plot(s.t,s.m_ray,'.r');
grid on;
legend({'m\_aero';'m\_ray'}','Location', 'Best','Interpreter','latex');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-ddt s.t(end)+ddt]);
ylabel('Airmass');
title([instrumentname ' - ' daystr ' - airmasses']);
fname = fullfile(p1,[instrumentname '_' daystr '_airmass']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(hsk,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

%********************
%% plot tracking details
%********************
% plot the solar angles
ftrk = figure;
plot(s.t,s.sza,'o');
hold on;
plot(s.t,s.sunaz,'+r');
plot(s.t,s.sunel,'xg');
dynamicDateTicks;
grid on;
xlabel('UTC time');xlim([s.t(1)-ddt s.t(end)+ddt]);
ylabel('Degrees [^\circ]')
legend('SZA','Sun Az','Sun El');
title([instrumentname ' - ' daystr ' - Solar Angles']);
fname = fullfile(p1,[instrumentname '_' daystr '_solarangles']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(ftrk,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

% plot the quad signals
fqd = figure;
ax1 = subplot(211);
plot(s.t,s.QdVtot,'.b');
ylabel('Total Quad voltages [V]');
title([instrumentname ' - ' daystr ' - Quad voltages']);
dynamicDateTicks;grid on;
ax2 = subplot(212);
linkaxes([ax1,ax2],'x');
plot(s.t,s.QdVtb./s.QdVtot,'+r');hold on;
plot(s.t,s.QdVlr./s.QdVtot,'xg');
dynamicDateTicks;grid on;
hold off;
xlabel('UTC time');xlim([s.t(1)-ddt s.t(end)+ddt]);
ylabel('Quad voltages ratio'); ylim([-1,1])
ylim([-0.6,0.6])
legend('Quad top bottom / Total','Quad Left right / Total');
fname = fullfile(p1,[instrumentname '_' daystr '_Quad']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(fqd,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

% plot the orientation (Az El)
fazel = figure;
[ax,h1,h2] = plotyy(s.t,s.El_deg,s.t,s.AZ_deg);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
grid on;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-ddt s.t(end)+ddt]);xlim(ax(2),[s.t(1)-ddt s.t(end)+ddt]);
ylabel(ax(2),'Azimuth degrees [^\circ]')
ylabel(ax(1),'Elevation degrees [^\circ]');
pos1 = get(ax(1), 'Position');pos2 = get(ax(2), 'Position');
set(ax(1), 'Position', [pos1(1) pos1(2) pos1(3)-0.08 pos1(4)]);
set(ax(2), 'Position', [pos2(1) pos2(2) pos2(3)-0.08 pos2(4)]);
title([instrumentname ' - ' daystr ' - Elevation and Azimuth angles']);
fname = fullfile(p1,[instrumentname '_' daystr '_El_Az']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(fazel,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

%********************
%% plot ambient data
%********************
% plot ambient Tst and Pst
figts = figure;
ax = plotyy(s.t,s.Tst,s.t,s.Pst);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
grid on;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-ddt s.t(end)+ddt]);xlim(ax(2),[s.t(1)-ddt s.t(end)+ddt]);
ylabel(ax(2),'Pst [hPa]');
ylabel(ax(1),'Tst [^\circC]');
title([instrumentname ' - ' daystr ' - Temperature and Pressure St']);
pos1 = get(ax(1), 'Position');pos2 = get(ax(2), 'Position');
set(ax(1), 'Position', [pos1(1) pos1(2) pos1(3)-0.08 pos1(4)]);
set(ax(2), 'Position', [pos2(1) pos2(2) pos2(3)-0.08 pos2(4)]);
fname = fullfile(p1,[instrumentname daystr '_Tst_Pst']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figts,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

% plot pitch and roll
figpr = figure;
[ax,h1,h2] = plotyy(s.t,s.pitch,s.t,s.roll);
dynamicDateTicks(ax(1));dynamicDateTicks(ax(2));
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
grid on;
xlabel('UTC time');
xlim(ax(1),[s.t(1)-ddt s.t(end)+ddt]);xlim(ax(2),[s.t(1)-ddt s.t(end)+ddt]);
pos1 = get(ax(1), 'Position');pos2 = get(ax(2), 'Position');
set(ax(1), 'Position', [pos1(1) pos1(2) pos1(3)-0.08 pos1(4)]);
set(ax(2), 'Position', [pos2(1) pos2(2) pos2(3)-0.08 pos2(4)]);
ylabel(ax(2),'Roll [^\circ]','Interpreter','tex');
ylabel(ax(1),'Pitch [^\circ]','Interpreter','tex');
title([instrumentname ' - ' daystr ' - Pitch and Roll']);
fname = fullfile(p1,[instrumentname '_' daystr '_Pitch_Roll']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figpr,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

% altitude
falt = figure;
plot(s.t,s.Alt,'.');
dynamicDateTicks;
grid on;
xlabel('UTC time');
xlim([s.t(1)-ddt s.t(end)+ddt]);
ylabel('Altitude [m]');
title([instrumentname ' - ' daystr ' - Altitude']);
fname = fullfile(p1,[instrumentname '_' daystr '_alt']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(falt,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

%********************
%% map flight path and airmasses
%********************
%if false;
if isequal(platform, 'flight');
    % flight track map
    figm = figure;
    ss = scatter(st.vis_sun.Lon,st.vis_sun.Lat,4,st.vis_sun.t,'.'); plo = ss;
    leg = {'vis_sun'};
    hold on;

    for ii = 2:length(fld);
        if length(st.(fld{ii}))>1;
            for jj=1:length(st.(fld{ii}));
                sso = scatter(st.(fld{ii})(jj).Lon,st.(fld{ii})(jj).Lat,8,st.(fld{ii})(jj).t,'MarkerEdgeColor',cls(ii),'Marker',fld_marks(ii),'Sizedata',12);
            end;
        else;
            %if isequal(lower(fld{ii}(5:end)),'sun'); continue, end;
            sso = scatter(st.(fld{ii}).Lon,st.(fld{ii}).Lat,8,st.(fld{ii}).t,'MarkerEdgeColor',cls(ii),'Marker',fld_marks(ii),'Sizedata',12);
        end;
        leg = [leg; {fld{ii}}];
        plo = [plo sso];
    end;
    xlabel('Longitude [^\circ]')
    ylabel('Latitude [^\circ]');
    grid on;
    title([tit ' - flight track map']);
    ch=colorbarlabeled('UTC');
    datetick(ch, 'y','keeplimits');
    legend(plo,leg,'Interpreter', 'none');
    fname = fullfile(p1,[instrumentname '_' daystr '_map']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(figm,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 1}];
    
    
    % Longitude vs. time
    figlt = figure;
    sso = plot(st.vis_sun.t,st.vis_sun.Lon,[cls(1) fld_marks(1)]); hold on; leg={'vis_sun'}; plo = [sso];
    for ii = 2:length(fld);
        if length(st.(fld{ii}))>1;
            for jj=1:length(st.(fld{ii})); sso = plot(st.(fld{ii})(jj).t,st.(fld{ii})(jj).Lon,'Marker',fld_marks(ii),'MarkerFaceColor',cls(ii),'MarkerEdgeColor',cls(ii),'MarkerSize',8); end;
        else;
            sso = plot(st.(fld{ii}).t,st.(fld{ii}).Lon,'Marker',fld_marks(ii),'MarkerFaceColor',cls(ii),'MarkerEdgeColor',cls(ii),'MarkerSize',8);
        end;
        leg = [leg; {fld{ii}}];
        plo = [plo sso];
    end;
    grid on;
    ylabel('Longitude [^\circ]'); xlabel('Time'); title([tit ' - Longitude vs. time']);
    dynamicDateTicks;
    legend(plo,leg,'Interpreter', 'none');
    fname = fullfile(p1,[instrumentname '_' daystr '_lon_vs_time']);
    fig_names = {[fname '.png']};
    save_fig(figlt,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 4}];
    

    % Latitude vs. time
    figlat = figure;
    sso = plot(st.vis_sun.t,st.vis_sun.Lat,[cls(1) fld_marks(1)]); hold on; leg={'vis_sun'}; plo = sso;
    for ii = 2:length(fld);
        if length(st.(fld{ii}))>1;
            for jj=1:length(st.(fld{ii})); sso = plot(st.(fld{ii})(jj).t,st.(fld{ii})(jj).Lat,'Marker',fld_marks(ii),'MarkerFaceColor',cls(ii),'MarkerEdgeColor',cls(ii),'MarkerSize',8); end;
        else;
            sso = plot(st.(fld{ii}).t,st.(fld{ii}).Lat,'Marker',fld_marks(ii),'MarkerFaceColor',cls(ii),'MarkerEdgeColor',cls(ii),'MarkerSize',8);
        end;
        leg = [leg; {fld{ii}}];
        plo = [plo sso];
    end;
    grid on;
    ylabel('Latitude [^\circ]'); xlabel('Time'); title([tit ' - Latitude vs. time']);
    dynamicDateTicks;
    legend(plo,leg,'Interpreter', 'none');
    fname = fullfile(p1,[instrumentname '_' daystr '_lat_vs_time']);
    fig_names = {[fname '.png']};
    save_fig(figlat,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 4}];
    
    
    % Mode Latitude vs. altitude (colored by time)
    figaltlat = figure;
    ss = scatter(st.vis_sun.Lat,st.vis_sun.Alt,4,st.vis_sun.t,'.'); plo = ss;
    leg = {'vis_sun'};
    hold on;

    for ii = 2:length(fld);
        if length(st.(fld{ii}))>1;
            for jj=1:length(st.(fld{ii}));
                sso = scatter(st.(fld{ii})(jj).Lat,st.(fld{ii})(jj).Alt,8,st.(fld{ii})(jj).t,'MarkerEdgeColor',cls(ii),'Marker',fld_marks(ii),'Sizedata',12);
            end;
        else;
            %if isequal(lower(fld{ii}(5:end)),'sun'); continue, end;
            sso = scatter(st.(fld{ii}).Lat,st.(fld{ii}).Alt,8,st.(fld{ii}).t,'MarkerEdgeColor',cls(ii),'Marker',fld_marks(ii),'Sizedata',12);
        end;
        leg = [leg; {fld{ii}}];
        plo = [plo sso];
    end;
    xlabel('Latitude [^\circ]')
    ylabel('Altitude [m]');
    grid on;
    title([tit ' - Altitude vs Latitude by modes']);
    ch=colorbarlabeled('UTC');
    datetick(ch, 'y','keeplimits');
    legend(plo,leg,'Interpreter', 'none');
    fname = fullfile(p1,[instrumentname '_' daystr '_alt_vs_lat']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(figaltlat,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 4}];

    
    % Mode Latitude vs. altitude (colored by time)
    figaltlon = figure;
    ss = scatter(st.vis_sun.Lon,st.vis_sun.Alt,4,st.vis_sun.t,'.'); plo = ss;
    leg = {'vis_sun'};
    hold on;

    for ii = 2:length(fld);
        if length(st.(fld{ii}))>1;
            for jj=1:length(st.(fld{ii}));
                sso = scatter(st.(fld{ii})(jj).Lon,st.(fld{ii})(jj).Alt,8,st.(fld{ii})(jj).t,'MarkerEdgeColor',cls(ii),'Marker',fld_marks(ii),'Sizedata',12);
            end;
        else;
            %if isequal(lower(fld{ii}(5:end)),'sun'); continue, end;
            sso = scatter(st.(fld{ii}).Lon,st.(fld{ii}).Alt,8,st.(fld{ii}).t,'MarkerEdgeColor',cls(ii),'Marker',fld_marks(ii),'Sizedata',12);
        end;
        leg = [leg; {fld{ii}}];
        plo = [plo sso];
    end;
    xlabel('Longitude [^\circ]')
    ylabel('Altitude [m]');
    grid on;
    title([tit ' - Altitude vs Latitude by modes']);
    ch=colorbarlabeled('UTC');
    datetick(ch, 'y','keeplimits');
    legend(plo,leg,'Interpreter', 'none');
    fname = fullfile(p1,[instrumentname '_' daystr '_alt_vs_lon']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(figaltlon,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 4}];
else;
    pptcontents0=[pptcontents0; {' ' 4}];
end;
%end;


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
xlim(ax(1),[s.t(1)-ddt s.t(end)+ddt]);xlim(ax(2),[s.t(1)-ddt s.t(end)+ddt]);
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
fname = fullfile(p1,[instrumentname '_' daystr '_vis_sats_parks_Tint']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figp,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

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
xlim(ax(1),[s.t(1)-ddt s.t(end)+ddt]);xlim(ax(2),[s.t(1)-ddt s.t(end)+ddt]);
ylabel(ax(2),'NIR Integration time [ms]')
ylabel(ax(1),['Raw at ' num2str(s.w(iw).*1000.0,'%4.1f') ' nm [counts]']);
title([instrumentname ' - ' daystr ' - NIR Raw counts, parks, saturation, Tint' ]);
pos1 = get(ax(1), 'Position');pos2 = get(ax(2), 'Position');
set(ax(1), 'Position', [pos1(1) pos1(2) pos1(3)-0.03 pos1(4)]);
set(ax(2), 'Position', [pos2(1) pos2(2) pos2(3)-0.03 pos2(4)]);
if any(s.sat_time==1);
    legend('Raw','parked','Shuttered','removed','saturated','Tint');
else;
    a = legend('Raw','parked','Shuttered','removed','Tint');
    lpos = get(a,'Position');
    text(lpos(2),lpos(1),'No saturation','Units','normalized');
end;
fname = fullfile(p1,[instrumentname '_' daystr '_nir_sats_parks_Tint']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(figp,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

%pptcontents0=[pptcontents0; {' ' 4}];
%pptcontents0=[pptcontents0; {' ' 4}];

%********************
%% plot the darks
%********************

%pptcontents0=[pptcontents0; {' ' 4}];
%pptcontents0=[pptcontents0; {' ' 4}];
fdrkv = figure;
[ax,h1,h2] = plotyy(st.track.t,st.track.T_spec_uvis,s.t,s.dark(:,400));
ylabel(ax(2),'Darks VIS 500 nm');
ylabel(ax(1),'VIS temp [°C]');
ylim(ax(1),[-5,5]); set(ax(1),'ytick',[-5,-2.5,0,2.5,5]);
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
dynamicDateTicks;
title([instrumentname ' - VIS darks and temperature']);
fname = fullfile(p1,[instrumentname '_' daystr '_vis_dark_T']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(fdrkv,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

fdrkn = figure;
[ax,h1,h2] = plotyy(st.track.t,st.track.T_spec_nir,s.t,s.dark(:,1200));
ylabel(ax(2),'Darks NIR 1213 nm');
ylabel(ax(1),'NIR temp [°C]');
ylim(ax(1),[0,30]); set(ax(1),'ytick',[0,10,20,30,40,50]);
set(h1,'linestyle','none','marker','.'); set(h2,'linestyle','none','marker','.');
dynamicDateTicks;
title([instrumentname ' - NIR darks and temperature']);
fname = fullfile(p1,[instrumentname '_' daystr '_nir_dark_T']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(fdrkn,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

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
xlim([s.t(1)-ddt s.t(end)+ddt]);
title([tit ' - VIS Raw counts' ]);
grid on;
labels = strread(num2str(wvlv.*1000.0,'%5.0f'),'%s');
for ij=nw+1:nw+length(iwvln), labels{ij} = '.'; end;
colormap(cm);
if license('test','Mapping_Toolbox')||~isempty(which('lcolorbar')); % check if the mapping toolbox exists
   lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
end
fname = fullfile(p1,[instrumentname '_' daystr '_visraw']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(frv,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];

% plot the raw nir
frnir = figure; nw = length(iwvln);
cm=hsv(nw+length(iwvlv));
set(gca, 'ColorOrder', cm(length(iwvlv)+1:end,:), 'NextPlot', 'replacechildren')
plot(s.t,s.raw(:,iwvln),'.');
dynamicDateTicks;
xlabel('UTC time');
ylabel('Raw [counts]');
xlim([s.t(1)-ddt s.t(end)+ddt]);
title([instrumentname ' - ' daystr ' - NIR Raw counts' ]);
grid on;
labels = {};
for ij=1:length(iwvlv), labels{ij} = '.'; end;
lbl_tmp = strread(num2str(wvln.*1000.0,'%5.0f'),'%s');
labels = {labels{:},lbl_tmp{:}}';
colormap(cm);
if license('test','Mapping_Toolbox'); % check if the mapping toolbox exists
   lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
end
fname = fullfile(p1,[instrumentname '_' daystr '_nirraw']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(frnir,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 4}];
%pptcontents0=[pptcontents0; {' ' 4}];0
%pptcontents0=[pptcontents0; {' ' 4}];

% plot the raw carpet
frcar = figure('pos',[100,100,1000,800]);
colormap(parula);
imagesc(s.t,s.w.*1000.0,s.raw');
dynamicDateTicks;
xlabel('UTC time');xlim([s.t(1)-ddt s.t(end)+ddt]);
ylabel('Wavelength [nm]'); 
axis('xy');
iswl = linspace(min(s.w),max(s.w),length(s.w));
labls = [];
for jj =200:200:1600;
    [nul,imin] = min(abs(iswl.*1000.0-jj));
    labls = [labls;sprintf('%4.0f',s.w(imin).*1000.0)];
end;
yticklabels(labls);
title([instrumentname ' - ' daystr ' - All Raw counts' ]);
cb = colorbarlabeled('Raw counts');
fname = fullfile(p1,[instrumentname '_' daystr '_rawcarpet']);
fig_names = [fig_names,{[fname '.png']}];
save_fig(frcar,fname,0);
pptcontents0=[pptcontents0; {fig_names{end} 1}];


%% tau_aero plotting
try;
    s.tau_aero(s.tau_aero(:,400)>3,:) = NaN;
    tau_aero_mod = 'yes';
catch
    tau_aero_mod = 'no';
end;
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
    xlim([s.t(1)-ddt s.t(end)+ddt]);
    title([tit ' - VIS AOD (no screening)' ]);
    grid on;
    labels = strread(num2str(wvlv.*1000.0,'%5.0f'),'%s');
    for ij=nw+1:nw+length(iwvln), labels{ij} = '.'; end;
    colormap(cm);
if license('test','Mapping_Toolbox'); % check if the mapping toolbox exists
   lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
end
    fname = fullfile(p1,[instrumentname '_' daystr '_vis_tau_aero_noscreening']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(faodv,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 1}];
    
    % plot the tau_aero_noscreening nir
    faodni = figure; nw = length(iwvln);
    cm=hsv(nw+length(iwvlv));
    set(gca, 'ColorOrder', cm(length(iwvlv)+1:end,:), 'NextPlot', 'replacechildren')
    plot(s.t,s.tau_aero_noscreening(:,iwvln),'.');
    dynamicDateTicks;
    xlabel('UTC time');
    ylabel('tau_aero_noscreening');
    xlim([s.t(1)-ddt s.t(end)+ddt]);
    title([instrumentname ' - ' daystr ' - NIR AOD (no screening)' ]);
    grid on;
    labels = {};
    for ij=1:length(iwvlv), labels{ij} = '.'; end;
    lbl_tmp = strread(num2str(wvln.*1000.0,'%5.0f'),'%s');
    labels = {labels{:},lbl_tmp{:}}';
    colormap(cm);
if license('test','Mapping_Toolbox'); % check if the mapping toolbox exists
   lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
end
    fname = fullfile(p1,[instrumentname '_' daystr '_nir_tau_aero_noscreening']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(faodni,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 1}];
else;
    pptcontents0=[pptcontents0; {' ' 1}];
    pptcontents0=[pptcontents0; {' ' 1}];
end; %tau_aero_noscreening


% plot the tau_aero
if exist('tau_aero');
    % plot the tau_aero vis;
    faodv_fl = figure;
    nw = length(iwvlv);
    cm=hsv(nw+length(iwvln));
    set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
    plot(s.t,s.tau_aero(:,iwvlv),'.');
    dynamicDateTicks;
    xlabel('UTC time');
    ylabel('tau_aero');
    if max(s.tau_aero(:,iwvlv))<1.2; tma = max(max(s.tau_aero(:,iwvlv)))*1.05; else tma=1.2; end;
    ylim([0.0,tma]);
    xlim([s.t(1)-ddt s.t(end)+ddt]);
    title([tit ' - VIS AOD' ]);
    grid on;
    labels = strread(num2str(wvlv.*1000.0,'%5.0f'),'%s');
    for ij=nw+1:nw+length(iwvln), labels{ij} = '.'; end;
    colormap(cm);
if license('test','Mapping_Toolbox'); % check if the mapping toolbox exists
   lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
end
    fname = fullfile(p1,[instrumentname '_' daystr '_vis_tau_aero']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(faodv_fl,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 1}];
    
    % plot the tau_aero_noscreening nir
    faodni = figure; nw = length(iwvln);
    cm=hsv(nw+length(iwvlv));
    set(gca, 'ColorOrder', cm(length(iwvlv)+1:end,:), 'NextPlot', 'replacechildren')
    plot(s.t,s.tau_aero(:,iwvln),'.');
    dynamicDateTicks;
    xlabel('UTC time');
    ylabel('tau_aero');
    xlim([s.t(1)-ddt s.t(end)+ddt]);
    title([instrumentname ' - ' daystr ' - NIR AOD' ]);
    grid on;
    labels = {};
    for ij=1:length(iwvlv), labels{ij} = '.'; end;
    lbl_tmp = strread(num2str(wvln.*1000.0,'%5.0f'),'%s');
    labels = {labels{:},lbl_tmp{:}}';
    colormap(cm);
if license('test','Mapping_Toolbox'); % check if the mapping toolbox exists
   lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
end
    fname = fullfile(p1,[instrumentname '_' daystr '_nir_tau_aero']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(faodni,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 1}];
    
    %% Now plot maps of AOD for flight data
    if isequal(platform, 'flight');
        % flight track map
        [nul,i500] = min(abs(s.w-0.5));
        figma = figure;
        ss = scatter(s.Lon,s.Lat,8,s.tau_aero(:,i500),'o');
        hold on;
        utch = t2utch(s.t);
        t_low = min(utch); t_high = max(utch); nt =floor((t_high-t_low)/0.25);
        times_15min = linspace(floor(t_low),t_high,nt);
        for q=1:nt;
            [nul,iq] = min(abs(utch-times_15min(q)));
            plot(s.Lon(iq),s.Lat(iq),'k+');
            text(s.Lon(iq),s.Lat(iq),num2str(times_15min(q),4));
        end;
        xlabel('Longitude [^\circ]')
        ylabel('Latitude [^\circ]');
        grid on;
        title([tit ' - AOD flight track map']);
        ch=colorbarlabeled('AOD  500 nm');
        fname = fullfile(p1,[instrumentname '_' daystr '_map_aod']);
        fig_names = [fig_names,{[fname '.png']}];
        save_fig(figma,fname,0);
        pptcontents0=[pptcontents0; {fig_names{end} 1}];

         % flight track map
        [nul,i500] = min(abs(s.w-0.5));[nul,i470] = min(abs(s.w-0.47));[nul,i865] = min(abs(s.w-0.865));
        figloaltaod = figure;
        ang=sca2angstrom(s.tau_aero(:,[i470 i865]), s.w([i470 i865]));
        ss = scatter(s.Lon,s.Alt,(s.tau_aero(:,i500)+0.15).*30.0,ang,'o'); 
        hold on;
        for q=1:nt;
            [nul,iq] = min(abs(utch-times_15min(q)));
            plot(s.Lon(iq),double(s.Alt(iq)),'k+');
            text(s.Lon(iq),double(s.Alt(iq)),num2str(times_15min(q),4));
        end;
        ss1 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.02+0.15).*30.0); 
        ss2 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.1+0.15).*30.0); 
        ss3 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.2+0.15).*30.0); 
        ss4 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.4+0.15).*30.0); 
        legend([ss1,ss2,ss3,ss4],[{'AOD_{500} 0.02'},{'AOD_{500} 0.1'},{'AOD_{500} 0.2'},{'AOD_{500} 0.4'}]);
        xlabel('Longitude [^\circ]')
        ylabel('Altitude [m]');
        grid on;
        title([tit ' - flight altitude vs. longitude, by angstrom']);
        ch=colorbarlabeled('Angstrom');
        fname = fullfile(p1,[instrumentname '_' daystr '_lon_alt_ang']);
        fig_names = [fig_names,{[fname '.png']}];
        save_fig(figloaltaod,fname,0);
        pptcontents0=[pptcontents0; {fig_names{end} 1}];
        
        % flight track map
        figlaaltaod = figure;
        ss = scatter(s.Lat,s.Alt,(s.tau_aero(:,i500)+0.15).*30.0,ang,'o'); 
        hold on;
        for q=1:nt;
            [nul,iq] = min(abs(utch-times_15min(q)));
            plot(s.Lat(iq),double(s.Alt(iq)),'k+');
            text(s.Lat(iq),double(s.Alt(iq)),num2str(times_15min(q),4));
        end;
        ss1 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.02+0.15).*30.0); 
        ss2 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.1+0.15).*30.0); 
        ss3 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.2+0.15).*30.0); 
        ss4 = plot([NaN NaN],[NaN NaN],'ko','MarkerSize',(0.4+0.15).*30.0); 
        legend([ss1,ss2,ss3,ss4],[{'AOD_{500} 0.02'},{'AOD_{500} 0.1'},{'AOD_{500} 0.2'},{'AOD_{500} 0.4'}]);
        xlabel('Latitude [^\circ]')
        ylabel('Altitude [m]');
        grid on;
        title([tit ' - flight altitude vs. latitude, by angstrom']);
        ch=colorbarlabeled('Angstrom');
        fname = fullfile(p1,[instrumentname '_' daystr '_lat_alt_ang']);
        fig_names = [fig_names,{[fname '.png']}];
        save_fig(figlaaltaod,fname,0);
        pptcontents0=[pptcontents0; {fig_names{end} 1}];
    end;
else
    pptcontents0=[pptcontents0; {' ' 1}];
    pptcontents0=[pptcontents0; {' ' 1}];
end; %tau_aero_noscreening


% ******************
%% Plot sampled spectra of AOD to see spectral behavior
% ******************
if exist('tau_aero');
    fspaod = figure;
    nl = 15;
    cm=hsv(nl);
    set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren')
    plot(s.w.*1000.0,s.tau_aero(1,:),'.'); hold on;
    labels = {}; labels{1} = datestr(s.t(1),'HH:MM');
    ji = find(isfinite(s.tau_aero(:,400)));
    for i=2:nl;
        ik = ji(floor(length(ji)./nl.*i));
        plot(s.w.*1000.0,s.tau_aero(ik,:),'.');
        labels{i} = datestr(s.t(ik),'HH:MM');
    end;
    xlabel('Wavelenght [nm]'); xlim([350,1700]);
    ylabel('tau_aero','Interpreter','None');
    title([daystr ' - Spectra of AOD'])
    colormap(cm)
    lcolorbar(labels,'TitleString','UTC [H]')
    fname = fullfile(p1,[instrumentname daystr '_spectra_aod']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(fspaod,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 1}];


    fspcar = figure('pos',[100,100,1000,800]);
    colormap(parula);
    s.tau_aero(find(s.tau_aero<-0.1)) = NaN;
    imagesc(s.t,s.w.*1000.0,s.tau_aero');
    dynamicDateTicks;
    xlabel('UTC time');xlim([s.t(1)-ddt s.t(end)+ddt]);
    ylabel('Wavelength [nm]');
    axis('xy');
    yticklabels(labls);
    title([instrumentname ' - ' daystr ' - tau_aero spectra' ]);
    cb = colorbarlabeled('tau_aero');
    fname = fullfile(p1,[instrumentname daystr '_spectra_aod_carpet']);
    fig_names = [fig_names,{[fname '.png']}];
    save_fig(fspcar,fname,0);
    pptcontents0=[pptcontents0; {fig_names{end} 1}];

end;




%********************
%% plot gas retrievals results
%********************

% water vapor

if exist('cwv2plot')&&isavar('vars');
    
    % apply flags
    cwv2plot(flagCWV==1) = NaN;
    
    figure;
    [h,filename]=spsun(daystr, 't', cwv2plot, '.', vars.Alt1e4{:}, mods{:}, ...
        'cols', colslist{k,2}, 'ylabel', 'CWV [g/cm2]', ...
        'filename', ['star' daystr platform 'cwvtseries' colslist{k,1}]);
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
end;


% O3

if exist('o32plot')&&isavar('vars');
    
    % apply flags
    o32plot(flagO3==1) = NaN;
    
    figure;
    [h,filename]=spsun(daystr, 't', o32plot, '.', vars.Alt1e4{:}, mods{:}, ...
        'cols', colslist{k,2}, 'ylabel', 'O3 [DU]', ...
        'filename', ['star' daystr platform 'o3tseries' colslist{k,1}]);
    pptcontents0=[pptcontents0; {fullfile(figurefolder, [filename '.png']) 1}];
end;

% NO2

if exist('no22plot')&&isavar('vars');
    
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
if exist('tau_aero_scaled')&&isavar('vars');
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
%% plot spectra in comparison with AATS-14
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

%% Check a delta c0
if isfield(s,'ground');  isflight = false; elseif isfield(s,'flight'); isflight = true; else; isflight = false; end;
deltac0_figs = Apply_deltac0(fname_4starsun,+2.0,isflight);
pptcontents0=[pptcontents0; {deltac0_figs{1} 1}];
pptcontents0=[pptcontents0; {deltac0_figs{2} 1}];
pptcontents0=[pptcontents0; {deltac0_figs{3} 1}];
deltac0_figs = Apply_deltac0(fname_4starsun,-2.0,isflight);
pptcontents0=[pptcontents0; {deltac0_figs{1} 1}];
pptcontents0=[pptcontents0; {deltac0_figs{2} 1}];
pptcontents0=[pptcontents0; {deltac0_figs{3} 1}];


%% Check if dirty/clean time period was done, if so plot them
if isfield(s,'dirty') & isfield(s,'clean');
    [sdirty,sclean,sdiff,saved_fig_path] = stardirty(daystr,fname_4star,false);
    pptcontents0=[pptcontents0; {saved_fig_path{1} 1}];
    pptcontents0=[pptcontents0; {saved_fig_path{2} 1}];
end;

%% Check if FOVs were created, if so, plot them
if isfield(st,'vis_fovp') | isfield(st,'vis_fova');
    fov_figs = plot_FOVs(fname_4star);
    for jj=1:length(fov_figs);
        pptcontents0=[pptcontents0; {fov_figs{jj} 4}];
    end;
    for jo=1:mod(length(fov_figs),4);
        pptcontents0=[pptcontents0; {' ' 4}];
    end;
end;

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
    makeppt(ppt_fname, [instrumentname ' - '  daystr ' ' platform], pptcontents{:});
end;
