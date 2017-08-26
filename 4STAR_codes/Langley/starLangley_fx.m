function fig_names = starLangley_fx(fname_in,savefigure,fig_path,c0_filesuffix)
%% Details of the program:
% NAME:
%   starLangley_fx
%
% PURPOSE:
%  Function to call the processing of langleys for a particular day. Made
%  to mesh better with quicklook processing
%
% INPUT:
%  fname_in: starsun.mat full file path (if none selected, will ask)
%  save_figure: boolean (optional defaults true) if true saves the figures
%  fig_path: path to save the figures
%  c0_filesuffix: string to be used as the suffix for the c0 file saving
%
% OUTPUT:
%  fig_names: full file path of the figures 
%  creates figures and the c0 file at the data_folder in starpaths
%
% DEPENDENCIES:
%  - version_set.m
%  - Langley.m
%  - starpaths.m
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Mauna Loa Observatory, 2017-06-04
%                 based on starLangley
% -------------------------------------------------------------------------

%% function start
version_set('1.0');

%********************
%% set parameters and santize inputs
%********************
stdev_mult=1.8:0.3:3; % screening criteria, as multiples for standard deviation of the rateaero.
col=408; % for screening. this should actually be plural - code to be developed

if nargin<1;
    [file, contents0, savematfile,instrumentname]=startupbusiness('langley','ask',[starpaths 'nul.mat']);
else;
    file = fname_in;
end;
[daystr, filen, datatype, instrumentname]=starfilenames2daystr({file});

if nargin<2;
    savefigure=1;
end;

[p,figp,~,u] = starpaths;
if nargin<3;
    fig_path = figp;
end;
filesuffix = ['refined_langley_' instrumentname];
if nargin>3;
    filesuffix = [filesuffix c0_filesuffix];
end;


%% load files
load(file, 't', 'w', 'rateaero', 'm_aero','AZstep','Lat','Lon','Tst','tau_aero','tau_aero_noscreening','Str');
if ~exist('Tst');
    load(file,'Tprecon_C');
    Tst = Tprecon_C;
end;
AZ_deg_   = AZstep/(-50);
AZ_deg    = mod(AZ_deg_,360); AZ_deg = round(AZ_deg);

if strcmp(instrumentname,'2STAR')
    cols=[16   24   45   60   66   92   113   144   170   193];
    col = 60;
    info_title = '';
elseif strcmp(instrumentname,'4STAR')
    cols=[225   258   347   408   432   539   627   761   869   969  1084  1109  1213  1439  1503]; % added NIR wavelength for plots
    col = 408;
    info_title = ' with FORJ correction';
end;
starinfofile=['starinfo_' daystr(1:8)];
s.dummy = '';
infofnt = str2func(starinfofile);
s = infofnt(s);
if isfield(s,'langley2');
    ans = menu('Which langley to choose?','am','pm');
    if ans==1;
        langley = s.langley1;
        xtra = 'am';
    else;
        langley = s.langley2;
        xtra = 'pm';
    end;
elseif  isfield(s,'langley1');
    langley = s.langley1;
    xtra = 'am';
else;
    langley = s.langley;
    xtra = '';
end;

if isfield(s,'xtra_langleyfilesuffix');
    xtra = [xtra s.xtra_langleyfilesuffix];
end;

filesuffix = [filesuffix xtra];
ok=incl(t,langley);

%% QA filtering
if strcmp(instrumentname,'2STAR');
    ok = ok(m_aero(ok)<=50);
else;
    ok = ok((m_aero(ok)<=50)&(Str(ok)==1)); % ony take the data with shutter open to sun
end;
if length(ok)==0;
    error('No valid airmass found within the Langley ends')
end;

%********************
% generate a new cal
%********************
fig_names = {};
%% Plot lanlgy with various stddevs on the figure
[data0, od0, residual]=Langley(m_aero(ok),rateaero(ok,col),stdev_mult,1);

if savefigure;
    ylabel(['Count Rate (/ms) for Aerosols, ' num2str(w(col)*1000, '%4.1f') ' nm']);
    title([instrumentname ' - ' daystr xtra info_title])
    starsas([instrumentname daystr xtra '_Langleyplot_stdevs_zoom.fig, starLangley_fx.m'],u,fig_path);
    fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra '_Langleyplot_stdevs_zoom.png'])}];
    xlim([0,20]);
    if strcmp(instrumentname,'4STAR');
        ylim([520,740]);
    elseif strcmp(instrumentname,'2STAR');
        ylim([950,1250]);
    end;
    starsas([instrumentname daystr xtra '_Langleyplot_stdevs.fig, starLangley_fx.m'],u,fig_path);
    fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra '_Langleyplot_stdevs.png'])}];
end;

%% Plot the one langley for each stdev on seperate figures
for k=1:numel(stdev_mult);
    ok2=ok(isfinite(residual(:,k))==1);
    [c0new(k,:), od(k,:), residual2, h]=Langley(m_aero(ok2),rateaero(ok2,:), [], cols(4));
    %lstr=setspectrumcolor(h(:,1), w(cols));
    %lstr=setspectrumcolor(h(:,2), w(cols));
    hold on;
    h0=plot(m_aero(ok), rateaero(ok,cols(4)), '.','color',[.5 .5 .5]);
    chi=get(gca,'children');
    set(gca,'children',flipud(chi));
    ylabel(['Count Rate (/ms) for Aerosols, ' num2str(w(col)*1000, '%4.1f') ' nm']);
    starttstr=datestr(langley(1), 31);
    stoptstr=datestr(langley(2), 13);
    title([instrumentname ' ' starttstr ' - ' stoptstr ', STDx' num2str(stdev_mult(k), '%0.1f')]);
    if savefigure;
        starsas([instrumentname daystr xtra 'rateaerovairmass' num2str(stdev_mult(k), '%0.1f') 'xSTD.fig, starLangley_fx.m'],u,fig_path);
        fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra 'rateaerovairmass' num2str(stdev_mult(k), '%0.1f') 'xSTD.png'])}];
    end;
end;

%% plot langley at multiple wavelengths.
fig = figure;
cm = hsv(length(cols));
colormap(cm);
hm = semilogy(m_aero(ok),rateaero(ok,cols(1))./c0new(1,cols(1)).*NaN,'.');hold on;
for ii=1:length(cols);
    hm = semilogy(m_aero(ok),rateaero(ok,cols(ii))./c0new(1,cols(ii)),'.','color',cm(ii,:));
    hl = plot([0 max(m_aero(ok))],[c0new(1,cols(ii))' exp(log(c0new(1,cols(ii)))'-od(1,cols(ii))'*max(m_aero(ok)))]./c0new(1,cols(ii)),...
        '-','color',cm(ii,:));
    
end;
chi=get(gca,'children');
set(gca,'children',flipud(chi));
ylim([0.7,1]);
set(gca,'ytick',[0.6,0.7,0.8,0.9,1.0]);
xlim([0,20]);
labels = strread(num2str(w(cols)*1000.0,'%5.0f'),'%s');
try;
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
catch;
legend(labels);
end;

title([instrumentname ' multi-wavelength ' daystr xtra ' :'  starttstr ' - ' stoptstr]);
ylabel('Aerosol Count Rate normalized by c0')
xlabel('Airmass factor')
grid();

if savefigure;
    starsas([instrumentname daystr xtra '_Langleyplot_multiwavelength_normalized.fig, starLangley_fx.m'],u,fig_path);
    fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra '_Langleyplot_multiwavelength_normalized.png'])}];
end;

% only vis
fig = figure;
cm = hsv(length(cols));
colormap(cm);
hm = semilogy(m_aero(ok),rateaero(ok,cols(1))./c0new(1,cols(1)).*NaN,'.');hold on;
for ii=1:10;
    hm = semilogy(m_aero(ok),rateaero(ok,cols(ii))./c0new(1,cols(ii)),'.','color',cm(ii,:));
    hl = plot([0 max(m_aero(ok))],[c0new(1,cols(ii))' exp(log(c0new(1,cols(ii)))'-od(1,cols(ii))'*max(m_aero(ok)))]./c0new(1,cols(ii)),...
        '-','color',cm(ii,:));
    
end;
chi=get(gca,'children');
set(gca,'children',flipud(chi));
ylim([0.7,1]);
set(gca,'ytick',[0.6,0.7,0.8,0.9,1.0]);
xlim([0,20]);
labels = strread(num2str(w(cols)*1000.0,'%5.0f'),'%s');
for ij=11:length(cols), labels{ij} = '.'; end;
try;
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
catch;
legend(labels);
end;

title([instrumentname ' VIS ' daystr xtra ' :'  starttstr ' - ' stoptstr]);
ylabel('Aerosol Count Rate normalized by c0')
xlabel('Airmass factor')
grid();

if savefigure;
    starsas([instrumentname daystr xtra '_Langleyplot_vis_multiwavelength_normalized.fig, starLangley_fx.m'],u,fig_path);
    fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra '_Langleyplot_vis_multiwavelength_normalized.png'])}];
end;

% only nir
fig = figure;
cm = hsv(length(cols));
colormap(cm);
hm = semilogy(m_aero(ok),rateaero(ok,cols(1))./c0new(1,cols(1)).*NaN,'.');hold on;
for ii=11:length(cols);
    hm = semilogy(m_aero(ok),rateaero(ok,cols(ii))./c0new(1,cols(ii)),'.','color',cm(ii,:));
    hl = plot([0 max(m_aero(ok))],[c0new(1,cols(ii))' exp(log(c0new(1,cols(ii)))'-od(1,cols(ii))'*max(m_aero(ok)))]./c0new(1,cols(ii)),...
        '-','color',cm(ii,:));
    
end;
chi=get(gca,'children');
set(gca,'children',flipud(chi));
ylim([0.7,1]);
set(gca,'ytick',[0.6,0.7,0.8,0.9,1.0]);
xlim([0,20]);
labels = strread(num2str(w(cols)*1000.0,'%5.0f'),'%s');
for ij=1:10, labels{ij} = '.'; end;
try;
lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
catch;
legend(labels)
end;
title([instrumentname ' NIR multi-wavelength ' daystr xtra ' :'  starttstr ' - ' stoptstr]);
ylabel('Aerosol Count Rate normalized by c0')
xlabel('Airmass factor')
grid();

if savefigure;
    starsas([instrumentname daystr xtra '_Langleyplot_nir_multiwavelength_normalized.fig, starLangley_fx.m'],u,fig_path);
    fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra '_Langleyplot_nir_multiwavelength_normalized.png'])}];
end;

%% plot Lat/Lon with Az_deg
for k=1;
    figure;
    h2=scatter(Lon(ok), Lat(ok),6,AZ_deg(ok),'filled');
    colorbar;
    ch=colorbarlabeled('AZdeg');
    xlabel('Longitude','FontSize',14);
    ylabel('Latitude','FontSize',14);
    set(gca,'FontSize',14);
    set(gca,'XTick',[-163:0.5:-159]); set(gca,'XTickLabel',[-163:0.5:-159]);
    starttstr=datestr(langley(1), 31);
    stoptstr=datestr(langley(2), 13);
    grid on;
    title([instrumentname ' ' starttstr ' - ' stoptstr xtra ', Screened STDx' num2str(stdev_mult(k), '%0.1f')]);
    if savefigure;
        starsas([instrumentname daystr xtra 'latlonvaz' num2str(stdev_mult(k), '%0.1f') 'xSTD.fig, starLangley_fx.m'],u,fig_path);
        fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra 'latlonvaz' num2str(stdev_mult(k), '%0.1f') 'xSTD.png'])}];
    end;
end;
% plot 500 nm count rate with Tst
for k=1;
    figure;
    h2=scatter(m_aero(ok), rateaero(ok,cols(4)),6,Tst(ok),'filled');
    colorbar;
    ch=colorbarlabeled('Tst');
    xlabel('aerosol Airmass','FontSize',14);
    ylabel(['Count Rate (/ms) for Aerosols, ' num2str(w(col)*1000, '%4.1f') ' nm'],'FontSize',14);
    set(gca,'FontSize',14);
    set(gca,'XTick',[0:2:14]); set(gca,'XTickLabel',[0:2:14]);
    starttstr=datestr(langley(1), 31);
    stoptstr=datestr(langley(2), 13);
    grid on;
    title([instrumentname ' ' starttstr ' - ' stoptstr xtra ', Screened STDx' num2str(stdev_mult(k), '%0.1f')]);
    if savefigure;
        starsas([instrumentname daystr xtra 'rateaerovairmass_tst' num2str(stdev_mult(k), '%0.1f') 'xSTD.fig, starLangley_fx.m'],u,fig_path);
        fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra 'rateaerovairmass_tst' num2str(stdev_mult(k), '%0.1f') 'xSTD.png'])}];
    end;
end;
% plot 500 nm count rate with Az_deg
for k=1;
    figure;
    h1=scatter(m_aero(ok), rateaero(ok,cols(4)),6,AZ_deg(ok),'filled');
    colorbar;
    ch=colorbarlabeled('AZdeg');
    xlabel('aerosol Airmass','FontSize',14);
    ylabel(['Count Rate (/ms) for Aerosols, ' num2str(w(col)*1000, '%4.1f') ' nm'],'FontSize',14);
    set(gca,'FontSize',14);
    set(gca,'XTick',[0:2:16]); set(gca,'XTickLabel',[0:2:16]);
    starttstr=datestr(langley(1), 31);
    stoptstr=datestr(langley(2), 13);
    y = rateaero(ok,cols(4));
    ylim([min(y(:)) max([max(y(:)) data0])]);
    grid on;
    title([instrumentname ' ' starttstr ' - ' stoptstr xtra ', Screened STDx' num2str(stdev_mult(k), '%0.1f')]);
    if savefigure;
        starsas([instrumentname daystr xtra 'rateaerovairmass_az' num2str(stdev_mult(k), '%0.1f') 'xSTD.fig, starLangley_fx.m'],u,fig_path);
        fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra 'rateaerovairmass_az' num2str(stdev_mult(k), '%0.1f') 'xSTD.png'])}];
    end;
end;

%********************
% estimate unc
%********************
unc=3.0/100; % 3.0% this if for the range of min-max values due to changing aerosol in the scene and temperature effect
c0unc=c0new.*unc';

%********************
% save new c0
%********************
if ~strcmp(instrumentname, '2STAR');
    viscols=(1:1044)';
    nircols=1044+(1:512)';
else;
    viscols=(1:256)';
    nircols=(256:256)';
end;

%% plot out the c0 spectra
figure;
plot(w(viscols), c0new(k,viscols),'.');
ylabel('C0');
xlabel('Wavelength [\mum]');
set(gca,'FontSize',14);
grid on;
title([instrumentname ' derived C0: ' starttstr ' - ' stoptstr xtra]);
if savefigure;
    starsas([instrumentname daystr xtra 'c0_spectravis.fig, starLangley_fx.m'],u,fig_path);
    fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra 'c0_spectravis.png'])}];
end;

if ~strcmp(instrumentname,'2STAR');
    figure;
    plot(w(nircols), c0new(k,nircols),'.');
    ylabel('C0');
    xlabel('Wavelength [\mum]');
    set(gca,'FontSize',14);
    grid on;
    title([instrumentname ' derived C0 ' xtra ': ' starttstr ' - ' stoptstr xtra]);
    if savefigure;
        starsas([instrumentname daystr xtra 'c0_spectranir.fig, starLangley_fx.m'],u,fig_path);
        fig_names = [fig_names;{fullfile(fig_path, [instrumentname daystr xtra 'c0_spectranir.png'])}];
    end;
end;

k=1; % select one of the multiple screening criteria (stdev_mult), or NaN (see below).
c0unc = real(c0unc(k,:));
if isnumeric(k) && k>=1; % save results from the screening/regression above
    %c0unc=NaN(size(w)); % put NaN for uncertainty - to be updated later
    c0unc = real(c0unc(k,:));
    additionalnotes=['Data outside ' num2str(stdev_mult(k), '%0.1f') 'x the STD of 501 nm Langley residuals were screened out. For instrument:' instrumentname];
    source=file;
end;

visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
try;
    starsavec0(visfilename, source, additionalnotes, w(viscols), c0new(k,viscols), c0unc(:,viscols));
catch
    warning(['c0 file :' visfilename ' already exists'])
end;
if ~strcmp(instrumentname,'2STAR');
    nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);
    try;
    starsavec0(nirfilename, source, additionalnotes, w(nircols), c0new(k,nircols), c0unc(:,nircols));
    catch;
        warning(['c0 file :' nirfilename ' already exists'])
    end;
end;

% be sure to modify starc0.m so that starsun.m will read the new c0 files.
return
