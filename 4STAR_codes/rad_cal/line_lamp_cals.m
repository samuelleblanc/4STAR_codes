function fig_paths = line_lamp_cals(fstarpath)
%% PURPOSE:
%   To quantify the line_lamp_cals and their wavelength representation
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
% Written (v1.0): by Samuel LeBlanc, Santa Cruz, 2022-04-14 
% Modified (v1.0): Added specifications for MLO line lamps
% -------------------------------------------------------------------------
version_set('1.0');
%% Load and prep data
%fp = '\\cloudgazer\data_sunsat\cal_lab_all\data_processed\allstarmats\';
%fstarpath = [fp '4STARB_20220413star.mat'];
%HgAr_filen = 24;
%Kr_filen = 26;

if nargin<1
    fp = 'C:\Users\lebla\Research\4STAR\cal\4STAR_20220414_callab_linelamps\';
    fstarpath = [fp '4STAR_20220414star.mat'];
    HgAr_filen = 21;
    Kr_filen = 20;
end
max_wdiff = 3.5;
max_peak_line_diff = 0.4;
fp = getnamedpath('starfig');

star = load(fstarpath);
s = starwrapper(star.vis_zen,star.nir_zen);

ppt_fname = fullfile(fp,[s.daystr '_' s.instrumentname '_LineLamps']);
fig_paths = {};

%% load from the starinfo file (if exists)
if isfield(s,'HgAr_filen'), HgAr_filen = s.HgAr_filen; end
if isfield(s,'Kr_filen'), Kr_filen = s.Kr_filen; end


%% subset the correct files and lamps timing
f_HgAr = star.vis_zen.filename{find(contains(star.vis_zen.filename,sprintf( '_%03d_',HgAr_filen)))};
f_Kr = star.vis_zen.filename{find(contains(star.vis_zen.filename,sprintf( '_%03d_',Kr_filen)))};

if isfield(s,'t_hg_ar_lamp') %prioritize using the time ranges if present than the filen
    ihg_ar_lamp = s.t>s.t_hg_ar_lamp(1) & s.t<s.t_hg_ar_lamp(2);
else
    ihg_ar_lamp = star.vis_zen.filen==HgAr_filen;
end
if isfield(s,'t_krypton_lamp') %prioritize using the time ranges if present than the filen
    ikrypton_lamp = s.t>s.t_krypton_lamp(1) & s.t<s.t_krypton_lamp(2);
else
    ikrypton_lamp = star.vis_zen.filen==Kr_filen;
end

%% Special fitlering for defined measurement timing.
if length(strsplit(fstarpath,'20220414'))>1
    max_peak_line_diff = 1.4; % seems like 4STAR has larger wavelength difference
    t_light_kr = [datenum(2022,4,14,17,45,38),datenum(2022,4,14,17,47,30)];
    t_dark_kr = [datenum(2022,4,14,17,47,39),datenum(2022,4,14,17,48,33)];
    ikrypton_lamp = star.vis_zen.t>t_light_kr(1) & star.vis_zen.t<t_light_kr(2);
    ikrypton_dark = star.vis_zen.t>t_dark_kr(1) & star.vis_zen.t<t_dark_kr(2);

    star.vis_zen.Str = star.vis_zen.Str.*0 + 2; % reset all the measurements 
    star.nir_zen.Str = star.nir_zen.Str.*0 + 2; % reset all the measurements 
    
    star.vis_zen.Str(ikrypton_lamp) = 2;
    star.vis_zen.Str(ikrypton_dark) = 0; % only dark for a small subset of time
    star.nir_zen.Str(ikrypton_lamp) = 2;
    star.nir_zen.Str(ikrypton_dark) = 0; % only dark for a small subset of time

    t_light_hg = [datenum(2022,4,14,17,54,11),datenum(2022,4,14,17,54,42)];
    t_dark_hg = [datenum(2022,4,14,17,54,47),datenum(2022,4,14,17,55,18)];
    ihg_ar_lamp = star.vis_zen.t>t_light_hg(1) & star.vis_zen.t<t_light_hg(2);
    ihg_ar_dark = star.vis_zen.t>t_dark_hg(1) & star.vis_zen.t<t_dark_hg(2);
    star.vis_zen.Str(ihg_ar_lamp) = 2;
    star.vis_zen.Str(ihg_ar_dark) = 0; % only dark for a small subset of time
    star.nir_zen.Str(ihg_ar_lamp) = 2;
    star.nir_zen.Str(ihg_ar_dark) = 0; % only dark for a small subset of time

end

%% Select data to look at
[p,nm_HgAr,ex] = fileparts(f_HgAr);
mean_spectra_hgar = nanmean(s.rate(ihg_ar_lamp,:));
[p,nm_Kr,ex] = fileparts(f_Kr);
mean_spectra_krypton = nanmean(s.rate(ikrypton_lamp,:));

fig_ar = figure;
plot(s.w,s.rate(ihg_ar_lamp,:));hold on;
plot(s.w,mean_spectra_hgar,'-k','LineWidth',2);
set(gca, 'YScale', 'log');
xlabel('Wavelength [nm]');
ylabel('Count rate [#/ms]');
title(['Hg(Ar) lamp spectrum measure by ' s.instrumentname s.daystr])
fn = [fp s.instrumentname s.daystr '_HgAr_spectra'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(fig_ar,fn,0);

fig_kr = figure;
plot(s.w,s.rate(ikrypton_lamp,:));hold on;
plot(s.w,mean_spectra_krypton,'-k','LineWidth',2);
set(gca, 'YScale', 'log');
xlabel('Wavelength [nm]');
ylabel('Count rate [#/ms]');
title(['Krypton lamp spectrum measure by ' s.instrumentname s.daystr])
fn = [fp s.instrumentname s.daystr '_Kr_spectra'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(fig_kr,fn,0);


%% peak selection
pw = peakfinder(mean_spectra_hgar,0.3,0.08,1,false,false);
pw_hires = peakfinder(mean_spectra_hgar,0.3,0.08,1,false,true);
w_high = interp1(1:length(s.w),s.w',pw_hires); %interpolated peaks from the spectra

pw_kr = peakfinder(mean_spectra_krypton,0.3,0.08,1,false,false);
pw_kr_hires = peakfinder(mean_spectra_krypton,0.3,0.08,1,false,true);
w_high_kr = interp1(1:length(s.w),s.w',pw_kr_hires); %interpolated peaks from the spectra

%% add Hg-Ar peaks
% found the values at: https://pdf.directindustry.com/pdf/micro-controle-spectra-physics/pencil-style-calibration-lamps/7436-137160.html
%peaks_HgAr = [253.65,265.65,284.8, 296.73,302.15,313.16,334.15,365.01,404.66,435.84,546.08,576.96,579.07,615.0, 696.54,...
%              706.72,714.70,727.29,738.40,750.39,763.51,772.38,794.82,811.53,826.45,842.47,852.14,866.80,912.30,922.50,...
%              1014.0,1357.0,1692.0,1707.3,1711.0];
peaks_HgAr = [184.9,187.1,194.2,253.65,265.4,284.8,302.2,312.57,313.15,313.18,320.8,326.4,345.2,365.02,404.66,435.84,546.07,576.96,579.07,615.0,...
              1014.0,1357.0,1692.0,1707.3,1711.0];
peaks_krypton = [427.4,432.0,435.5,457.7,461.9,465.9,473.9,476.6,483.2,557.0,587.1,758.74,760.15,769.45,785.48,805.95,810.44,811.29,819.0,...
                 826.32,829.81,850.9,877.7,975.2,1363.4,1442.7,1523.9,1533.4,1678.51,1689.04];
peaks_argon = [294.3,415.9,420.1,427.7,476.5,488.0,696.54,738.40,750.39,751.47,763.51,772.38,772.42,794.82,801.48,811.53,826.45,840.82,842.46,...
               912.3,922.4,965.8,1047.1,1331.3,1336.7,1371.8,1694.0];
peaks_HgNe = [253.65,296.73,302.15,312.57,313.15,313.18,365.02,404.66,435.84,546.07,576.96,579.07,614.31,638.30,640.11,640.22,650.65,703.24,1013.98,...
              1128.74,1357.02,1367.35,1529.58,1688.15,1692.02,1694.20,1707.28,1710.99,1732.94,1813.04,1970.02];
peaks_Xenon = [];
peaks_Neon = [];


%% match peaks to nearest line from the lamps
[wpeaks_Hg,wlines_Hg] = match_peaks(w_high,peaks_HgAr,max_wdiff);
[wpeaks_Ar,wlines_Ar] = match_peaks(w_high,peaks_argon,max_wdiff);
[wpeaks_Kr,wlines_Kr] = match_peaks(w_high_kr,peaks_krypton,max_wdiff);

%% plot spectra
figsh = figure; 
plot(s.w,mean_spectra_hgar); hold on; plot(s.w(pw),mean_spectra_hgar(pw),'ro');
for pp=peaks_HgAr, xline(pp/1000.0,'b'); end
for pp=peaks_argon, xline(pp/1000.0,'r'); end
title(['Hg(Ar) line lamp - ' nm_HgAr],'Interpreter','None');
xlabel('Wavelength [micron]');
ylabel('Intensity');
fn = [fp s.instrumentname s.daystr '_HgAr_linelamp_spectra'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(figsh,fn,0);

figsk = figure; 
plot(s.w,mean_spectra_krypton); hold on; plot(s.w(pw_kr),mean_spectra_krypton(pw_kr),'ro');
for pp=peaks_krypton, xline(pp/1000.0,'b'); end
title(['Krypton line lamp - ' nm_Kr],'Interpreter','None');
xlabel('Wavelength [micron]');
ylabel('Intensity');
fn = [fp s.instrumentname s.daystr '_Kr_linelamp_spectra'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(figsk,fn,0);

%% plot 1:1 of peaks
figo = figure; 
plot(wpeaks_Hg,wlines_Hg,'.'); 
hold on; 
plot(wpeaks_Ar,wlines_Ar,'.'); 
plot(wpeaks_Kr,wlines_Kr,'.'); 
plot([300,1700],[300,1700],'--');
legend('Hg','Ar','Kr','1:1')
xlabel('Measured peak Wavelength [nm]');
ylabel('Peak line lamp Wavelength [nm]');
fn = [fp s.instrumentname s.daystr '_peakvspeak_linelamp_HgAr_Kr'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(figo,fn,0);

%% plot differences of measured vs. expected peaks
figd = figure;
plot(wpeaks_Hg,wpeaks_Hg-wlines_Hg,'.'); hold on;
plot(wpeaks_Ar,wpeaks_Ar-wlines_Ar,'.');
plot(wpeaks_Kr,wpeaks_Kr-wlines_Kr,'.');
plot([300,1700],[0,0],'--');

rmse_Hg = sqrt(mean(power(wpeaks_Hg-wlines_Hg,2)));
rmse_Ar = sqrt(mean(power(wpeaks_Ar-wlines_Ar,2)));
rmse_Kr = sqrt(mean(power(wpeaks_Kr-wlines_Kr,2)));

legend('Hg, RMSE='+string(rmse_Hg),'Ar, RMSE='+string(rmse_Ar),'Kr, RMSE='+string(rmse_Kr),'0');
xlabel('Wavelength [nm]')
ylabel('Differences in peak wavelength [nm]')
tit = split(nm_HgAr,'_');
title(['Peak fitting accruracy for - ' tit{1} ' - ' tit{2}]);
fn = [fp s.instrumentname s.daystr '_peakaccuracy'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(figd,fn,0);

%% Run through the peaks and its surrounding to fit and find the center
% build a new spectral array for each of the peaks 
spectras = [repmat(mean_spectra_hgar,length(wpeaks_Hg),1);repmat(mean_spectra_hgar,length(wpeaks_Ar),1);repmat(mean_spectra_krypton,length(wpeaks_Kr),1)];
peaks = [wpeaks_Hg,wpeaks_Ar,wpeaks_Kr];
peak_names = {'Hg(Ar)','Hg(Ar)','Kr'};
peaks_inames = [wpeaks_Hg.*0+1,wpeaks_Ar.*0+2,wpeaks_Kr.*0+3];
lines = [wlines_Hg,wlines_Ar,wlines_Kr];
lines_names = {'Hg','Ar','Kr'};
lines_inames = [wlines_Hg.*0+1,wlines_Ar.*0+2,wlines_Kr.*0+3];

wvl_range = 7.0 ; %Range of wavelength to fit +/-
wavelength = s.w.*1000.0;
fitted_peak = [];
FWHM = [];
a1 = [];
b1 = [];
c1 = [];
not_use = [];
for ip = 1:length(peaks)
    looping = true;
    wvl_range = 7.0 ; %Range of wavelength to fit +/-
    while looping
        [nul,ikk] = min(abs(wavelength-peaks(ip)));
        [nul,ikm] = min(abs(wavelength-(peaks(ip)-wvl_range)));
        [nul,ikp] = min(abs(wavelength-(peaks(ip)+wvl_range)));
        spec_to_fit = spectras(ip,ikm:ikp);
        wave_to_fit = wavelength(ikm:ikp);
        try
            [f1,gof1] = fit(wave_to_fit',spec_to_fit','gauss1');
        catch
            f1.b1 = 0.0; 
        end
        if abs(f1.b1-lines(ip))>2.0
            wvl_range = wvl_range - 2.0;
        else
            looping = false;
        end
        fitted_peak(ip) = f1.b1;
        FWHM(ip) = 2*sqrt(2*log(2)) * (f1.c1/sqrt(2));
        a1(ip) = f1.a1;
        b1(ip) = f1.b1;
        c1(ip) = f1.c1;
        if wvl_range<0
            fitted_peak(ip) = nan;
            FWHM(ip) = nan;
            a1(ip) = nan;
            b1(ip) = nan;
            c1(ip) = nan;
            looping = false;
        end
    end
    figsp = figure;
    plot(wave_to_fit,spec_to_fit,'.-k');
    hold on;
    plot(f1);
    xline(lines(ip),'g','LineWidth',2);
    legend('Measurement',['gaussian fit, FWHM=' num2str(FWHM(ip)) ' nm'],[lines_names{lines_inames(ip)} '-line lamp'],'Location','southeast');
    title(['Peak at ' num2str(lines(ip)) ' nm from ' peak_names{peaks_inames(ip)} ' lamp']);
    xlabel('Wavelength [nm]');
    ylabel('Radiance count rate [#/ms]');
    lm = get(gca,'xlim');
    for ppl=peaks_HgAr, if ppl>lm(1) & ppl<lm(2), xline(ppl,'b','DisplayName','other Hg-line'); end, end
    for ppl=peaks_argon, if ppl>lm(1) & ppl<lm(2), xline(ppl,'r','DisplayName','other Ar-line'); end, end
    for ppl=peaks_krypton, if ppl>lm(1) & ppl<lm(2), xline(ppl,'c','DisplayName','other Kr-line'); end, end
    hold off;
    
    pp = menu('Use this line?','yes','no');
    if pp>1
        % don't use this line
        not_use(end+1) = ip;
        title(['** Not used **' 'Peak at ' num2str(lines(ip)) ' nm from ' peak_names{peaks_inames(ip)} ' lamp']);
        
        fn = [fp s.instrumentname s.daystr '_peakfit_FWHM_' num2str(lines(ip)) 'nm_BAD'];
        fig_paths = [fig_paths;{[fn '.png'] 4}];    
        save_fig(figsp,fn,0);
    else
        fn = [fp s.instrumentname s.daystr '_peakfit_FWHM_' num2str(lines(ip)) 'nm'];
        fig_paths = [fig_paths;{[fn '.png'] 4}];    
        save_fig(figsp,fn,0);
    end
end

if length(not_use)>0
    for ip=flip(not_use) %go from end to start
        peaks(ip) = [];
        lines(ip) = [];
        fitted_peak(ip) = [];
        FWHM(ip) = [];
        a1(ip) = [];
        b1(ip) = [];
        c1(ip) = [];
    end
end

%% replot differences with fitted peaks
figure; 
plot(lines,fitted_peak-lines,'.'); hold on;
plot([350,1700],[0,0],'--');
xlabel('Wavelength [nm]')
ylabel('Difference in peak calculations (fitted peaks - line value)')

%% plot the FWHM per line lamp

% interpolate the FWHM into a spline fit
[linee,ilines] = unique(lines);
visfwh = interp1(linee/1000.0,FWHM(ilines),s.w(1:1044),'makima');
nirfwh = interp1(linee/1000.0,FWHM(ilines),s.w(1045:end),'makima');

[old_visw, old_nirw, old_visfwhm, old_nirfwhm]=starwavelengths(s.t,s.instrumentname);

fwh = figure; 
plot(lines,FWHM,'.'); hold on;
plot(s.w(1:1044).*1000.0,visfwh,'-b');
plot(s.w(1045:end).*1000.0,nirfwh,'-r');

plot(old_visw.*1000.0,old_visfwhm.*1000,'--b');
plot(old_nirw.*1000.0,old_nirfwhm,'--r');

legend('fit to measurement','VIS spline','NIR spline','Previous VIS','Previous NIR')
xlabel('Wavelength [nm]');
ylabel('FWHM from gaussian fit [nm]');
title([s.instrumentname ' - ' s.daystr ' FWHM calculations from Hg(Ar) and Kr']);
grid on;
ylim([0,12]);
fn = [fp s.instrumentname s.daystr '_FWHM'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(fwh,fn,0);




%% calculate the nominal pixel to wavelength arrangement

% for vis
ipixels = 0:1043;
fitted_i= interp1(s.w(1:1044)',ipixels,fitted_peak./1000.0);
ft = fittype('C0+C1*p+C2*p.^2+C3*p.^3','independent','p');
flt_i = isfinite(fitted_i) & abs(fitted_peak-lines)<max_peak_line_diff; 
if strcmp(s.instrumentname,'4STAR')
    Cns = [171.855 0.81143 -1.98521e-6 -1.58185e-8]; % from manufacture
elseif strcmp(s.instrumentname,'4STARB')
    Cns = [171.7 0.81254 -1.55568e-6 -1.59216e-8]; % from manufacture
end
mdl = fit(fitted_i(flt_i)',fitted_peak(flt_i)',ft,'start',Cns);

% run through better fitting
delta = polyfit(lines(flt_i),ft(mdl.C0,mdl.C1,mdl.C2,mdl.C3,fitted_i(flt_i))-lines(flt_i),1);
epsilon = 0.1; %search for an RMSE below this value

rmse = @(x,y) sqrt(mean(power(x-y,2)))
c0 = mdl.C0-delta(2);
c1 = mdl.C1-delta(1);
c2 = mdl.C2;
c3 = mdl.C3;

fvis = figure; 
plot(lines(flt_i),ft(mdl.C0,mdl.C1,mdl.C2,mdl.C3,fitted_i(flt_i))-lines(flt_i),'.'); 
hold on; yline(0,'--');
plot(lines(flt_i),ft(c0,c1,c2,c3,fitted_i(flt_i))-lines(flt_i),'.');
rr = rmse(ft(c0,c1,c2,c3,fitted_i(flt_i)),lines(flt_i));
xlabel('Wavelength [nm]');
ylabel('Difference in fitted peaks and new walvength coeffiecient [nm]')
title([s.instrumentname ' - ' s.daystr ' Vis wavelength pixel registration']);
grid on;
legend('Original','0 line',['C0=' num2str(c0) newline 'C1=' num2str(c1) newline 'C2=' num2str(c2) newline 'C3=' num2str(c3)]);

fn = [fp s.instrumentname s.daystr '_vis_wavelength'];
fig_paths = [fig_paths;{[fn '.png'] 1}];
save_fig(fvis,fn,0);


%% for nir
if false
    ipixels = 0:511;
    fitted_i= interp1(s.w(1045:end)',ipixels,fitted_peak./1000.0);
    ft = fittype('C0+C1*p+C2*p.^2+C3*p.^3+C4*p.^4','independent','p');
    flt_in = isfinite(fitted_i) & abs(fitted_peak-lines)<0.4;
    Cn = [1700.28, -1.17334, -0.000655055, 7.06199E-07,-1.14153E-09];
    mdl = fit(fitted_i(flt_in)',fitted_peak(flt_in)',ft,'start',Cn);

    % run through better fitting
    delta = polyfit(lines(flt_in),ft(mdl.C0,mdl.C1,mdl.C2,mdl.C3,fitted_i(flt_in))-lines(flt_in),1);
    epsilon = 0.1; %search for an RMSE below this value

    rmse = @(x,y) sqrt(mean(power(x-y,2)))
    c0 = mdl.C0-delta(2);
    c1 = mdl.C1-delta(1);
    c2 = mdl.C2;
    c3 = mdl.C3;

    fnir = figure; 
    plot(lines(flt_in),ft(mdl.C0,mdl.C1,mdl.C2,mdl.C3,fitted_i(flt_in))-lines(flt_in),'.'); 
    hold on; yline(0,'--');
    plot(lines(flt_in),ft(c0,c1,c2*1.02,c3*1.001,fitted_i(flt_in))-lines(flt_in),'.');
    rmse(ft(c0,c1,c2,c3,fitted_i(flt_in)),lines(flt_in));
    xlabel('Wavelength [nm]');
    ylabel('Difference in fitted peaks and new walvength coeffiecient [nm]')
    title([s.instrumentname ' - ' s.daystr ' NIR wavelength pixel registration']);
    grid on;

    fn = [fp s.instrumentname s.daystr '_nir_wavelength'];
    fig_paths = [fig_paths;{[fn '.png'] 1}];
    save_fig(fnir,fn,0);
end
% nirw = polyval(flip(Cn),pn);
% nirw=flip(nirw)/1000;


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
makepptx(ppt_fname, [s.instrumentname ' - '  s.daystr ' Cal Lab Line lamps'], pptcontents{:});
end

function [wpeaks,wlines] = match_peaks(wpeak,lamp_peaks,max_wdiff)
% Function that pulls out the peaks from peak selected and nearest line
% lamp, which is not overlapping with its neighbor

wpeaks = []; % for the peaks to keep
wlines = []; % for the lines to keep

for ww=wpeak
     [wm,im] = min(abs(ww*1000.0-lamp_peaks));
     if wm<max_wdiff & any((lamp_peaks(1:end ~=im)-lamp_peaks(im))<max_wdiff)
        wpeaks(end+1) = ww*1000.0;
        wlines(end+1) = lamp_peaks(im);
     end
end
end