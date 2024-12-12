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
fp = '\\cloudgazer\data_sunsat\cal_lab_all\data_processed\allstarmats\';
f = 'C:\Users\lebla\Research\4STAR\cal\4STARB_20220413_monochomator\';
fstarpath = [f '4STARB_20220413star.mat'];
%HgAr_filen = 24;
%Kr_filen = 26;
%f = 'C:\Users\lebla\Research\4STAR\cal\4STAR_20220413_monochromator\';
%fstarpath = [f '4STAR_20220414star.mat'];
fp = getnamedpath('starfig');

[daystr, filen, datatype,instrumentname]=starfilenames2daystr({fstarpath}, 1);
ppt_fname = fullfile(fp,[daystr '_' instrumentname '_Monochromator']);
fig_paths = {};

star = load(fstarpath);
%% process star.mat
s = starwrapper(star.vis_zen,star.nir_zen);

%% Setup the monochromator log files, wavelength range and the corresponding 4STAR files (should be m_logs in the starinfo
% start_time, log file name, star_wavelength, end_wavelength, order-sorting-filter, grating, slit_width, step_size, dwell time, 4STAR_filenumber, notes
if isfield(s,'m_logs'), m_logs = s.m_logs; end

if strcmp(instrumentname,'4STAR') & ~isfield(s,'m_logs')
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
end

%% set up the filters for each monochromator run and load the monochromator files
ifilt = {};
mono = {};
for ifilenum=1:length(m_logs(:,11))
   ifilt{ifilenum} = star.vis_zen.filen==m_logs{ifilenum,11};
   mono{ifilenum} = load_mono([f m_logs{ifilenum,2}]);
end

%% load the monochromator slit function
HeNe_files = {'HeNe_VNIR1_OS2_0.3_20220413_144217.srf';'HeNe_VNIR1_OS2_0.5_20220413_144756.srf';'HeNe_MC_Cal_SWIR3_20220413_150449.srf'};
fh = [f 'HeNe\'];
mono_slit = [];
mono_grating = {};
mono_srf = {};
mono_nm = {};
mono_center_nm = [];
for ih=1:length(HeNe_files)
    srf = load_srf([fh HeNe_files{ih}]);
    mono_slit(end+1) = srf.slit;
    mono_grating = [mono_grating; {srf.grating}];
    mono_srf = [mono_srf; {srf.srf}];
    mono_nm = [mono_nm; {srf.nm}];
    mono_center_nm(end+1) = srf.center_nm;
    
    figsrf = figure; 
    plot(srf.nm,srf.srf,'.')
    xlabel('Wavelength from center [nm]')
    ylabel('Normalize slit function of Monochromator')
    title(['HeNe laser line at ' num2str(srf.center_nm) ', using grating:' srf.grating ', at slit: ' num2str(srf.slit) ' nm'])
    fn = [fp s.daystr '_monochromator_SRF_' srf.grating '_' num2str(srf.slit)];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(figsrf,fn,0); 
end
for i=1:4-mod(length(HeNe_files),4),if mod(length(HeNe_files),4)>0, fig_paths = [fig_paths;{'' 4}]; end, end

%% Prep some variables to save the good measured peaks vs monochromator 
measured_peaks_vis = [];
measured_peaks_nir = [];
mono_wvl = [];
mono_wvl_vis = [];
mono_wvl_nir = [];
measured_peaks_vis_gaus = [];
measured_peaks_nir_gaus = [];
measured_fwhm_vis_gaus = [];
measured_fwhm_nir_gaus = [];

%% plot out each monochromator file and corresponding spectrometer file
for inum=1:length(m_logs(:,11))
    fig_wv = figure(1+inum*10);
    fig_vis = figure(2+inum*10);
    fig_nir = figure(3+inum*10);
    fig_vis_fwhm = figure(4+inum*10);
    fig_nir_fwhm = figure(5+inum*10);
    mean_rate = [[]]; %mean spectra for each wavelenght step in the monochromator
    labels = {};
    
    isrf = (strcmp(mono_grating,m_logs(inum,6))) & (mono_slit'==m_logs{inum,7});
    mono_srf_used = mono_srf{isrf};
    mono_nm_used = mono_nm{isrf};
    
    cm=hsv(length(mono{inum}.wvs));
    figure(1+inum*10); set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    figure(2+inum*10); set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    figure(3+inum*10); set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    figure(4+inum*10); set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');
    figure(5+inum*10); set(gca, 'ColorOrder', cm, 'NextPlot', 'replacechildren');

    for it = 1:length(mono{inum}.wvs)
       its = s.t>mono{inum}.t_ranges(it,1) & s.t<mono{inum}.t_ranges(it,2);
       mean_rate(end+1,:) = nanmean(s.rate(its,:));
       figure(1+inum*10); plot(s.w,mean_rate(end,:),'DisplayName',num2str(mono{inum}.wvs(it))); 
       if it==1, hold on; end
       figure(2+inum*10); plot(s.w(1:1044),mean_rate(end,1:1044),'DisplayName',num2str(mono{inum}.wvs(it))); 
       if it==1, hold on; end
       figure(3+inum*10); plot(s.w(1045:end),mean_rate(end,1045:end),'DisplayName',num2str(mono{inum}.wvs(it))); 
       if it==1, hold on; end
       
       rate_deconv = deconv_srf(s.w(1:1044).*1000.0,mean_rate(end,1:1044),mono_nm_used,mono_srf_used,mono{inum}.wvs(it));
       % get center and fwhm
       [f1,gof1] = fit(s.w(1:1044)'.*1000.0,rate_deconv','gauss1');
       measured_peaks_vis_gaus(end+1) = f1.b1; 
       measured_fwhm_vis_gaus(end+1) = 2*sqrt(2*log(2)) * (f1.c1/sqrt(2));
       figure(4+inum*10); plot(s.w(1:1044),rate_deconv','DisplayName',num2str(mono{inum}.wvs(it))); %multiplied by the mono srf
       if it==1, hold on; end
       rate_deconv_nir = deconv_srf(s.w(1045:end).*1000.0,mean_rate(end,1045:end),mono_nm_used,mono_srf_used,mono{inum}.wvs(it));
       [f1n,gof1n] = fit(s.w(1045:end)'.*1000.0,rate_deconv_nir','gauss1');
       measured_peaks_nir_gaus(end+1) = f1n.b1; 
       measured_fwhm_nir_gaus(end+1) = 2*sqrt(2*log(2)) * (f1n.c1/sqrt(2));
       figure(5+inum*10); plot(s.w(1045:end),rate_deconv_nir,'DisplayName',num2str(mono{inum}.wvs(it))); %multiplied by the mono srf
       if it==1, hold on; end
       labels = [labels; {num2str(mono{inum}.wvs(it))}]; 
       mono_wvl(end+1) = mono{inum}.wvs(it);
       if mono{inum}.wvs(it)<s.w(1044).*1000.0      
         [m,i] = max(mean_rate(end,1:1044));
         measured_peaks_vis(end+1) = s.w(i).*1000.0;
         measured_peaks_nir(end+1) = NaN;
         mono_wvl_vis(end+1) = mono{inum}.wvs(it);
         mono_wvl_nir(end+1) = NaN;
       else
         [m,i] = max(mean_rate(end,1045:end));
         measured_peaks_vis(end+1) = NaN;
         measured_peaks_nir(end+1) = s.w(1044+i).*1000.0;
         mono_wvl_vis(end+1) = NaN;
         mono_wvl_nir(end+1) = mono{inum}.wvs(it);
       end
    end
    figure(1+inum*10); 
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid on;
    ylim([0.0005,10000.0]);  
    title(['Monochromator ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');

    figure(2+inum*10);
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid on;
    ylim([0.01,10000.0]);  
    title(['VIS - Monochromator ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    
    figure(3+inum*10);
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid on;
    ylim([0.0005,500.0]);  
    title(['NIR - Monochromator ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    
    figure(4+inum*10);
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid on;
    ylim([0.01,10000.0]);  
    title(['VIS - Monochromator Deconvolved ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    
    figure(5+inum*10);
    set(gca, 'YScale', 'log');
    xlabel('Wavelength [nm]');
    ylabel('Count rate [#/ms]');
    grid on;
    ylim([0.0005,500.0]);  
    title(['NIR - Monochromator Deconvolved ' num2str(m_logs{inum,3}) ' to ' num2str(m_logs{inum,4}) ' nm ' datestr(m_logs{inum,1},'THHMMSS') ' by ' s.instrumentname s.daystr])
    colormap(cm);
    lcolorbar(labels','TitleString','\lambda [nm]','fontweight','bold');
    
    
    
    fn = [fp s.instrumentname s.daystr '_monochromator_all_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_wv,fn,0);  
    close(fig_wv);
    
    fn = [fp s.instrumentname s.daystr '_monochromator_VIS_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_vis,fn,0); 
    close(fig_vis);
    
    fn = [fp s.instrumentname s.daystr '_monochromator_NIR_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_nir,fn,0); 
    close(fig_nir);
    
    fn = [fp s.instrumentname s.daystr '_monochromator_VIS_deconvolved_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_vis_fwhm,fn,0); 
    close(fig_vis_fwhm);
    
    fn = [fp s.instrumentname s.daystr '_monochromator_NIR_deconvolved_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_nir_fwhm,fn,0); 
    close(fig_nir_fwhm);
    
    % make the big color patterns
    fig_color = figure('position',[600,300,1200,600]);
    subplot(1,2,1); %vis
    h = pcolor(s.w(1:1044).*1000.0,mono{inum}.wvs(:),mean_rate(:,1:1044)); 
    set(h, 'EdgeColor', 'none'); 
    set(gca,'ColorScale','log');
    colorbar;
    xlabel('Wavelength [nm]');
    ylabel('Monochromator wavelength [nm]');
    title('VIS');
    
    subplot(1,2,2); %nir
    h = pcolor(s.w(1045:end).*1000.0,mono{inum}.wvs(:),mean_rate(:,1045:end)); 
    set(h, 'EdgeColor', 'none'); 
    set(gca,'ColorScale','log');
    xlabel('Wavelength [nm]');
    ylabel('Monochromator wavelength [nm]');
    title('NIR');
    colorbar;
    fn = [fp s.instrumentname s.daystr '_monochromator_pcolor_' num2str(m_logs{inum,3}) '_to_' num2str(m_logs{inum,4}) '_' datestr(m_logs{inum,1},'THHMMSS')];
    fig_paths = [fig_paths;{[fn '.png'] 4}];
    save_fig(fig_color,fn,0);
end

%% look at the difference between the measured peaks and the monochromator output
fig_o = figure('position',[300,300,1000,600]); 
subplot(1,2,1);
plot(mono_wvl_vis,measured_peaks_vis-mono_wvl_vis,'.');hold on;
plot(mono_wvl_vis,mono_wvl_vis*0.0,'--');
legend(['RMSE=' num2str(sqrt(mean(pow2(measured_peaks_vis-mono_wvl_vis))))],'0')
ylabel('measured-monchromator peaks [nm]');
xlabel('Monochromator wavelength [nm]');
title([ s.instrumentname ' ' s.daystr ' VIS - Monochromator to measured peaks']);
colorbar;

subplot(1,2,2);
plot(mono_wvl_nir,measured_peaks_nir-mono_wvl_nir,'.');hold on;
plot(mono_wvl_nir,mono_wvl_nir*0.0,'--');
legend(['RMSE=' num2str(sqrt(mean(pow2(measured_peaks_nir-mono_wvl_nir))))],'0')
ylabel('measured-monchromator peaks [nm]');
xlabel('Monochromator wavelength [nm]');
title([ s.instrumentname ' ' s.daystr ' NIR - Monochromator to measured peaks']);
colorbar;

fn = [fp s.instrumentname s.daystr '_monochromator_peaks_delta'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(fig_o,fn,0); 

%% Plot out the FWHM
ffwhm = figure; 
subplot(1,2,1);
plot(measured_peaks_vis_gaus,measured_fwhm_vis_gaus,'.');
ylabel('measured FWHM [nm]');
xlabel('Monochromator wavelength [nm]');
subplot(1,2,2);
plot(measured_peaks_nir_gaus,measured_fwhm_nir_gaus,'.');
ylabel('measured FWHM [nm]');
xlabel('Monochromator wavelength [nm]');

%********************
%% Generate a new PowerPoint file
%********************
pptcontents={};
pptcontents0 = fig_paths;
% sort out the PowerPoint contents
idx4=[];
for ii=1:size(pptcontents0,1)
    if pptcontents0{ii,2}==1
        pptcontents=[pptcontents; {pptcontents0(ii,1)}];
    elseif pptcontents0{ii,2}==4
        idx4=[idx4 ii];
        if numel(idx4)==4 || ii==size(pptcontents0,1) || pptcontents0{ii+1,2}~=4
            if numel(idx4)>=3
                pptcontents=[pptcontents; {pptcontents0(idx4,1)}];
            else
                pptcontents=[pptcontents; {[pptcontents0(idx4,1);' ';' ']}];
            end;
            idx4=[];
        end
    else
        error('Paste either 1 or 4 figures per slide.');
    end
end
disp(['Saving to power point file: ' ppt_fname '.pptx'])
makepptx(ppt_fname, [s.instrumentname ' - '  s.daystr ' Monochromator run'], pptcontents{:});


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

%% monochromator slt function *.srf loading function
function srf = load_srf(fname)
    d = importdata(fname,' ',11);
    total = trapz(d.data(:,1),d.data(:,2));
    srf.srf = d.data(:,2)  ./ total; %normalize
    
    %find center
    [f1,gof1] = fit(d.data(:,1),d.data(:,2),'gauss1');
    srf.nm = d.data(:,1)-f1.b1; %relative to center
    srf.center_nm = f1.b1;
    
    % metadata
    grt = strsplit(d.textdata{3}); 
    srf.grating = grt{end};
    slt = strsplit(d.textdata{4});
    srf.slit = str2num(slt{end}(1:end-2));
    osf = strsplit(d.textdata{6});
    srf.osf = str2num(osf{end});
end


%% deconvolve the monochromator slit function
function sp = deconv_srf(w_in,rate_in,srf_nm,srf,mono_nm)
% w_in, srf_nm, and mono_nm in nm
% w_in wavelength in from spectro
% srf_nm srf from the mono
% mono_nm single value of the monochromator center point
srf_full = interp1(srf_nm+mono_nm,srf,w_in,'spline',0.0);
[sp,remainder] = deconv(rate_in,interp1(srf_nm,srf,(1:length(rate_in)).*0.1,'linear',0.0));
%sp = rate_in.*srf_full;
end
