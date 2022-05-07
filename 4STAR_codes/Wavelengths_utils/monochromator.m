%function fig_paths = monochromator(fstarpath)
%% PURPOSE:
%   To quantify the off-center band and wavelenth calibration from the monochromator test and their wavelength representation
%
% INPUT:
%   fstarpath: the full path of the star.mat file
%
% OUTPUT:
%  - plots of mean rate with peaks
%
% DEPENDENCIES:
%  - starwrapper
%  - peakfinder
%
% NEEDED FILES:
%  - 
%
% EXAMPLE:
%
% MODIFICATION HISTORY:
% Written (v1.0): by Samuel LeBlanc, Hilo Hawaii, 2022-05-06 
% Modified (v1.0): 
% -------------------------------------------------------------------------
version_set('1.0');
%% Load and prep data
%fp = '\\cloudgazer\data_sunsat\cal_lab_all\data_processed\allstarmats\';
%fstarpath = [fp '4STARB_20220413star.mat'];
%HgAr_filen = 24;
%Kr_filen = 26;
f = 'C:\Users\lebla\Research\4STAR\cal\4STAR_20220413_monochromator\';
fstarpath = [f '4STAR_20220414star.mat'];
fp = getnamedpath('starfig');

[daystr, filen, datatype,instrumentname]=starfilenames2daystr({fstarpath}, 1);
ppt_fname = fullfile(fp,[daystr '_' instrumentname '_Monochromator']);
fig_paths = {};

%% Setup the monochromator log files, wavelength range and the corresponding 4STAR files
% start_time, log file name, star_wavelength, end_wavelength, order-sorting-filter, grating, slit_width, step_size, dwell time, 4STAR_filenumber, notes
if strcmp(instrumentname,'4STAR')
    m_logs = {datenum(2022,04,14,0,29,40) 'IWG1-20220414-0028.slog' 1400    1750    5   'swir'  0.5 3.0 10  4   2   '2.33';
              datenum(2022,04,14,0,34,30) 'IWG1-20220414-0034.slog'  950    1500    4   'swir'  0.5 3.0 10  4   3   '3.67';
              datenum(2022,04,14,0,43,20) 'IWG1-20220414-0041.slog'  200    360     12  'vnir'  0.5 1.5 10  4   4   '1.07';
              datenum(2022,04,14,0,48,00) 'IWG1-20220414-0047.slog'	 350	600     1	'vnir'	0.5	1.5	10	4	6	'1.67';
              datenum(2022,04,14,0,52,10) 'IWG1-20220414-0051.slog'	 350	600     1	'vnir'	0.5	1.5	10	4	7	'1.67';
              datenum(2022,04,14,0,52,10) 'IWG1-20220414-0051.slog'  350	600     1	'vnir'	0.5	1.5	10	4	7	'1.67';
              datenum(2022,04,14,0,55,30) 'IWG1-20220414-0055.slog'	 500	800     2	'vnir'	0.5	1.5	10	4	8	'2';
              datenum(2022,04,14,0,59,10) 'IWG1-20220414-0058.slog'	 700	1100	3	'vnir'	0.5	1.5	10	4	9	'dim 900+nm, maybe bad grating efficiency?';
              datenum(2022,04,14,1,38,50) 'IWG1-20220414-0138.slog'	 950	1200	4	'swir'	0.5	3	5	4	15	'repeat on swir after almost walking it off the table';
              datenum(2022,04,14,1,46,20) 'IWG1-20220414-0145.slog'	 350	600     1	'vnir'	0.5	1.5	5	4	16	'3.33';
              datenum(2022,04,14,2,04,00) 'IWG1-20220414-0202.slog'	 350	600     1	'vnir'	0.5	1.5	5	4	18	'picked up rotate 180 reset, higher signals';
              datenum(2022,04,14,2,04,00) 'IWG1-20220414-0202.slog'  350	600     1	'vnir'	0.5	1.5	5	4	18	'picked up rotate azimuth'};
elseif strcmp(instrumentname,'4STARB')
    m_logs = {};
end

s = load(fstarpath);

%% set up the filters for each monochromator run and load the monochromator files
ifilt = {};
mono = {};
for ifilenum=1:length(m_logs(:,11))
   ifilt{ifilenum} = s.vis_zen.filen==m_logs{ifilenum,11};
   mono{ifilenum} = load_mono([f m_logs{ifilenum,2}]);
end

%% process star.mat
s = starwrapper(s.vis_zen,s.nir_zen);

%% plot out each monochromator file and corresponding spectromoeter file
for inum=1:length(m_logs(:,11))
    fig_wv = figure;
    fig_vis = figure;
    fig_nir = figure;
    mean_rate = [[]]; %mean spectra for each wavelenght step in the monochromator
    labels = {};
    
    cm=hsv(length(mono{inum}.wvs));
    fig_wv; set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    fig_vis; set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    fig_nir; set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    for it = 1:length(mono{inum}.wvs)
       its = s.t>mono{inum}.t_ranges(it,1) & s.t<mono{inum}.t_ranges(it,2);
       mean_rate(end+1,:) = nanmean(s.rate(its,:));
       fig_wv; plot(s.w,mean_rate(end,:),'DisplayName',num2str(mono{inum}.wvs(it)),'Parent',fig_wv); hold on;
       fig_vis; plot(s.w(1:1044),mean_rate(end,1:1044),'DisplayName',num2str(mono{inum}.wvs(it)),'Parent',fig_vis); hold on;
       fig_nir; plot(s.w(1045:end),mean_rate(end,1045:end),'DisplayName',num2str(mono{inum}.wvs(it)),'Parent',fig_nir); hold on;
       labels = [labels; {num2str(mono{inum}.wvs(it))}]; 
    end
    fig_wv; 
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid;
    ylim([0.0005,10000.0]);  
    title(['Monochromator ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

    fig_vis;
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid;
    ylim([0.0005,10000.0]);  
    title(['VIS - Monochromator ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    
    fig_nir;
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid;
    ylim([0.0005,10000.0]);  
    title(['NIR - Monochromator ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    
    fn = [fp s.instrumentname s.daystr '_monochromator_all_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_wv,fn,0);  
    
    fn = [fp s.instrumentname s.daystr '_monochromator_VIS_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_vis,fn,0); 
    
    fn = [fp s.instrumentname s.daystr '_monochromator_NIR_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_nir,fn,0); 
    
    fig_paths = [fig_paths;{'' 4}];
end



%% monochromator *.slog loading function
function mono = load_mono(fname)
    slog = importdata(fname);
    
    %time
    mono.t = datenum(slog.textdata(:,2),'yyyy-mm-ddTHH:MM:SS.FFF'); %extract time
    
    %wavelength
    mono.wv = cellfun(@str2num,slog.textdata(:,3),'un',0); % extract the wavelength
    idx = cellfun(@isempty,mono.wv);
    mono.wv(idx) = {NaN};
    mono.wv = cell2mat(mono.wv);

    %order sorting filter and diffraction grating
    mono.osf = cell2mat(cellfun(@str2num,slog.textdata(:,4),'un',0));
    mono.grating = cell2mat(slog.textdata(:,5));
    
    % get start and end for each wavelenght range
    uu = unique(mono.wv(isfinite(mono.wv)));
    mono.wvs = [];
    mono.t_ranges = [[]];
    for i=1:length(uu)
        mono.wvs(end+1) = uu(i);
        iu = mono.wv==uu(i);
        mono.t_ranges(end+1,:) = [min(mono.t(iu)); max(mono.t(iu))];
    end
end
