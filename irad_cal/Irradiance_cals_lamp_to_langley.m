%% Details of the function:
% NAME:
%   Irradiance_cals_lamp_to_langley
% 
% PURPOSE:
%   create a calibrated irradiance array from combined
%   lamp and langley TOA calibrations to make one modified
%   c0
% CALLING SEQUENCE:
%  function Irradiance_cals_lamp_to_langley(varargin{:})
%
% INPUT:
%  - the function reads vis_park and nir_park files taken in calibration
%  - of sun barrel with either FEL lamp or sphere
% 
% 
% OUTPUT:
%  - c0mod (.dat file): modified TOA spectra based on langley and lamp calib
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%  - save_fig.m : for saving figures
%  - startup.m  : for making nice plots
%  - startupbusiness.m: for uploading/saving files
%
% NEEDED FILES/INPUT:
%  - these are under main data directory
%  - VIS_refined*.dat and NIR_refined*.dat c0 files
%  - FEL lamp number that was used for calibration (e.g. 925/926)
%  - TOA kurucz spectra convolved to 4STAR FWHM: MChKur4star_air_vis.ref/MChKur4star_air_nir.ref
%
% EXAMPLE:
%  - Irradiance_cals_lamp_to_langley(varargin{:})
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MSR), NASA Ames,Aug-26, 2014
% MS, 2014-11-19, added last calibration date and FEL numbers
%                 adjusted to general path names
% -------------------------------------------------------------------------
%% function routine
function Langs_and_lamps = Irradiance_cals_lamp_to_langley(varargin)

% calibration dates and files:
% 2013-11-22: 002.dat   %lamp925
% 2014-06-24: 023.dat   %lamp926
% 2014-07-16: 012.dat   %lamp926
% 2014-10-24: 018.dat   %lamp926

startup_plotting;
[matfolder, figurefolder, askforsourcefolder, author]=starpaths;
dirf = figurefolder;
dir  = matfolder;
% dirf = 'C:\MatlabCodes\figs\'; % directory for saving figures
% dir  = 'C:\MatlabCodes\data\'; % directory for saving output files
plotQA = false;
%%
% load input files
%********************
[sourcefile, contents0, savematfile]=startupbusiness('park', varargin{:});
contents=[];
if isempty(contents0);
    savematfile=[];
    return;
end;
load(sourcefile,contents0{:});
%%
% define t that corresponds to refined c0
t = vis_park.t(1);
date =  datestr(vis_park.t(1),'yyyymmdd');
% load the relevant refined c0
[visc0, nirc0, visnote, nirnote, vislstr, nirlstr, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(t);

%
V = datevec(nir_park.t);
%
time = V(:,4)*100+V(:,5)+V(:,6)./60;% UTC
shut = nir_park.Str==0;
sun  = nir_park.Str==1;
sky  = nir_park.Str==2;

% exclude edges shut, sun, sky
    shut(2:end)= shut(1:end-1)&shut(2:end); shut(1:end-1) = shut(1:end-1)&shut(2:end);
    sun(2:end) = sun(1:end-1)&sun(2:end); sun(1:end-1) = sun(1:end-1)&sun(2:end);
    sky(2:end) = sky(1:end-1)&sky(2:end); sky(1:end-1) = sky(1:end-1)&sky(2:end);
%-----------------------------
figure; sb(1) = subplot(2,1,1);
plot(time(shut), sum(vis_park.raw(shut,:),2)./vis_park.Tint(shut),'kx',...
     time(sun),  sum(vis_park.raw(sun,:),2)./vis_park.Tint(sun), 'r.',time(sky), sum(vis_park.raw(sky,:),2)./vis_park.Tint(sky),'bx');
ylabel('sum(cts)')
legend('shut','red sun','blue sky','location','South');
sb(2) = subplot(2,1,2);
plot(time(shut), vis_park.Tint(shut),'kx',time(sun), vis_park.Tint(sun),'r.',...
    time(sky), vis_park.Tint(sky), 'bx');
ylabel('ms')
legend('shut','sun','sky')
linkaxes(sb,'x')
%-------------------------------
%%
% select good data to analyze:
menu('Click OK when suitable range of points are selected.','OK')
xl = xlim;
% load wavelength:
vis.nm = load(fullfile(starpaths,'visLambda.txt')); Langs_and_lamps.vis.nm = vis.nm;
nir.nm = load(fullfile(starpaths,'nirLambda.txt')); Langs_and_lamps.nir.nm = nir.nm;

% load FEL lamp irradiance data / HISS radiance data
  FEL = input('type in FEL lamp number (0 for radiance data input)','s');
  if isempty(FEL)
      FEL='926';
  elseif strcmp(FEL,'0')
      % load radiance data!!!TBD
  end
  if strcmp(FEL,'925')
    FEL = get_irad_F925;
  elseif strcmp(FEL,'926')
    FEL = get_irad_F926;
  end
%%
% find signal/dark times
A = sun&time>xl(1)&time<xl(2);
B = shut&time>xl(1)&time<xl(2);
% vis/nir
vis.dark = (mean(vis_park.raw(B,:)));
vis.light =(mean(vis_park.raw(A,:)));
vis.sig = vis.light - vis.dark;
nir.dark = (mean(nir_park.raw(B,:)));
nir.light =(mean(nir_park.raw(A,:)));
nir.sig = nir.light - nir.dark;
% calculate rate
vis.rate = vis.sig /mean(vis_park.Tint(A));
nir.rate = fliplr(nir.sig /mean(nir_park.Tint(A)));
% calculate responsivity
% FEL lamp
FELvis = planck_tungsten_fit(FEL.nm,FEL.irad, vis.nm');
FELnir = planck_tungsten_fit(FEL.nm,FEL.irad, nir.nm');
% IS
% vis.rad_9_lamps = interp1(hiss.nm,hiss.lamps_9, vis.nm,'linear');

% calculate 4STAR lamp responsivity
vis.FEL_irad = FELvis.Irad;
vis.STARresp = vis.rate./vis.FEL_irad;
nir.FEL_irad = FELnir.Irad;
nir.STARresp = nir.rate./nir.FEL_irad;
% adjust for edge spectral ranges
vis.STARresp(vis.nm<300) = NaN;
vis.STARresp(vis.nm>994) = NaN;
nir.STARresp(nir.nm<950) = NaN;
nir.STARresp(nir.nm>1703) = NaN;

% save variables into struct
Langs_and_lamps.vis.FEL_irad = vis.FEL_irad;
Langs_and_lamps.nir.FEL_irad = nir.FEL_irad;
Langs_and_lamps.vis.FELstar_rate = vis.rate;
Langs_and_lamps.nir.FELstar_rate = nir.rate;
Langs_and_lamps.vis.FELstar_resp = vis.STARresp;
Langs_and_lamps.nir.FELstar_resp = nir.STARresp;

%%
figure;plot(vis.nm, vis.rate,'b-', nir.nm, nir.rate,'r-');
title({'Dark-subtracted count rate from FEL lamp test'},'interp','none');
xlabel('wavelength [nm]');
ylabel('DN/ms');
legend('vis','nir');
grid('on');zoom('on');
%%
figure;plot(vis.nm, vis.STARresp,'b-', nir.nm, nir.STARresp,'r-');
title({'4STAR Responsivity from FEL lamp test'},'interp','none');
xlabel('wavelength [nm]');
ylabel('DN/ms/(W/m^2/um/sr)');
legend('vis','nir');
grid('on');zoom('on');

%%
%% scale c0 by kurucz TOA

% import MODTRAN solar spectrum (kurucz)
kurvis = importdata(fullfile(starpaths,'MChKur4star_air_vis.ref'));%kur2star_vis.ref
kur.visnm     = kurvis.data(:,1);
kur.visIrad   = kurvis.data(:,2);
kur.visInterp = interp1(kur.visnm, kur.visIrad, vis.nm,'pchip','extrap');
kurnir = importdata(fullfile(starpaths,'MChKur4star_air_nir.ref'));%kur2star_nir.ref
kur.nirnm     = kurnir.data(:,1);
kur.nirIrad   = kurnir.data(:,2);
kur.nirInterp = interp1(kur.nirnm, kur.nirIrad, nir.nm,'pchip','extrap');
% plot conv kurucz4star
figure;plot(vis.nm,kur.visInterp,'-b');hold on;plot(nir.nm,kur.nirInterp,'-r');hold on;
axis([300 1700 0 2.2]);xlabel('wavelength [nm]');ylabel('Irradiance [W/m2/nm]');title('kurucz interpolated to 4STAR');
% --------------------------------------------------------------------------
Langs_and_lamps.vis.lang_resp = visc0'./kur.visInterp; Langs_and_lamps.nir.lang_resp = nirc0'./kur.nirInterp;
Langs_and_lamps.vis.lang_resp(vis.nm<300) = NaN;
Langs_and_lamps.vis.lang_resp(vis.nm>994) = NaN;
Langs_and_lamps.nir.lang_resp(nir.nm<950) = NaN;
Langs_and_lamps.nir.lang_resp(nir.nm>1703)= NaN;

%% calculate S ratio [Kindle et al., 2000]
% response ratios
vis.Sratio = (Langs_and_lamps.vis.lang_resp)./(Langs_and_lamps.vis.FELstar_resp'); Langs_and_lamps.vis.Sratio = vis.Sratio;
nir.Sratio = (Langs_and_lamps.nir.lang_resp)./(Langs_and_lamps.nir.FELstar_resp'); Langs_and_lamps.nir.Sratio = nir.Sratio;
%%
%% choose scaling wavelength using MODTRAN and avoid abs regions
MODTRANcalc = load(fullfile(starpaths,'MODTRANcalc.mat'));
vis.scaleaeroidx = MODTRANcalc.aeroind(1:1044);    % 372 wavelengths
nir.scaleaeroidx = MODTRANcalc.aeroind(1045:1556); % 206 wavelengths
%
% load water vapor cross section
% watervis = importdata('C:\Users\msegalro\PostDoc\Ames\DOAS\H2OconTest\xs\H2O_1013mbar273K_vis.xs');
% waternir = importdata('C:\Users\msegalro\PostDoc\Ames\DOAS\H2OconTest\xs\H2O_1013mbar273K_nir.xs');
% aerosol index at 400 nm
% select wavelengths regions to exclude
nm_340 = interp1(vis.nm,[1:length(vis.nm)],340.0, 'nearest');
nm_400 = interp1(vis.nm,[1:length(vis.nm)],400.0, 'nearest');
nm_620 = interp1(vis.nm,[1:length(vis.nm)],620.6, 'nearest');
nm_635 = interp1(vis.nm,[1:length(vis.nm)],635.0, 'nearest');
nm_685 = interp1(vis.nm,[1:length(vis.nm)],684.8, 'nearest');
nm_694 = interp1(vis.nm,[1:length(vis.nm)],694.9, 'nearest');
nm_750 = interp1(vis.nm,[1:length(vis.nm)],750.1, 'nearest');
nm_780 = interp1(vis.nm,[1:length(vis.nm)],780.6, 'nearest');
nm_741 = interp1(vis.nm,[1:length(vis.nm)],741.5, 'nearest');
nm_1555 = interp1(nir.nm,[1:length(nir.nm)],1567, 'nearest');
nm_1630 = interp1(nir.nm,[1:length(nir.nm)],1629, 'nearest');
%o4wln   = find(nir.nm<=nir.nm(nm_1630)&nir.nm>=nir.nm(nm_1555)); 
co2wln  = find(nir.nm<=nir.nm(nm_1630)&nir.nm>=nir.nm(nm_1555)); 

% omit these regions from being used in scaling
vis.scaleaeroidx(1:nm_400)      = 0;
vis.scaleaeroidx(565)           = 0; %626.2 nm
vis.scaleaeroidx(572)           = 0; %631.7 nm
vis.scaleaeroidx(nm_685:nm_741) = 0; %631.7 nm
% vis.scaleaeroidx(nm_620:nm_635) = 0;
% vis.scaleaeroidx_expand = vis.scaleaeroidx;
% vis.scaleaeroidx_expand(nm_340:nm_400) = 1;
% vis.scaleaeroidx_expand(nm_620:nm_635) = 0;

% calculate and plot normalize responsivities for better display (not used in calc)
% % normalize langley response
[vis.lang_resp_norm vis.lang_resp_mu vis.lang_resp_rng] = featureNormalizeRange(Langs_and_lamps.vis.lang_resp);
[nir.lang_resp_norm nir.lang_resp_mu nir.lang_resp_rng] = featureNormalizeRange(Langs_and_lamps.nir.lang_resp);
%
% % normalize lamp response
[vis.lamp_resp_norm vis.lamp_resp_mu vis.lamp_resp_rng] = featureNormalizeRange(Langs_and_lamps.vis.FELstar_resp);
[nir.lamp_resp_norm nir.lamp_resp_mu nir.lamp_resp_rng] = featureNormalizeRange(Langs_and_lamps.nir.FELstar_resp);
% % %

% vis
figure(10);
ax(1)=subplot(1,2,1);
plot(vis.nm,vis.lang_resp_norm,'-b');hold on;plot(vis.nm,vis.lamp_resp_norm,'--r');hold on;
plot(vis.nm(vis.scaleaeroidx==1),vis.lang_resp_norm(vis.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
xlabel('wavelength');ylabel('normalized responsivity');legend('Langley responsivity','Lamp responsivity','MODTRAN "good" scaling wavelength');
xlim([300 1000]);ylim([-0.8 0.6]);
title([date 'vis-park.dat']);
% nir
ax(2)=subplot(1,2,2);
plot(nir.nm,nir.lang_resp_norm,'-b');hold on;plot(nir.nm,nir.lamp_resp_norm,'--r');hold on;
plot(nir.nm(nir.scaleaeroidx==1),nir.lang_resp_norm(nir.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
xlabel('wavelength');ylabel('normalized responsivity');legend('Langley responsivity','Lamp responsivity','MODTRAN "good" scaling wavelength');
xlim([900 1700]);ylim([-0.8 0.6]);
title([date 'nir-park.dat']);
fi=[dirf date '_star_responsivity'];
save_fig(10,fi,true);


vis.SratioAvgMod = nanmean(vis.Sratio(vis.scaleaeroidx==1)); Langs_and_lamps.vis.SratioAvgMod = vis.SratioAvgMod;
vis.SratioStdMod = nanstd (vis.Sratio(vis.scaleaeroidx==1)); Langs_and_lamps.vis.SratioStdMod = vis.SratioStdMod;
nir.SratioAvgMod = nanmean(nir.Sratio(nir.scaleaeroidx==1)); Langs_and_lamps.nir.SratioAvgMod = nir.SratioAvgMod;
nir.SratioStdMod = nanstd (nir.Sratio(nir.scaleaeroidx==1)); Langs_and_lamps.nir.SratioStdMod = nir.SratioStdMod;

% scale lamp2lang
vis.scaledLamp2LangMod    = (Langs_and_lamps.vis.FELstar_resp*vis.SratioAvgMod)   .*kur.visInterp';   % in rate units
nir.scaledLamp2LangMod    = (Langs_and_lamps.nir.FELstar_resp*nir.SratioAvgMod)   .*kur.nirInterp';   % in rate units

% combine lamp and Langley into one array
% don't include lamp 620-635 range:
vis.scaleaeroidx(nm_620:nm_635) = 0;
vis.LangLampCombMod = visc0;
vis.LangLampCombMod(vis.scaleaeroidx==0) = vis.scaledLamp2LangMod(vis.scaleaeroidx==0);
nir.LangLampCombMod = nirc0;
nir.LangLampCombMod(nir.scaleaeroidx==0) = nir.scaledLamp2LangMod(nir.scaleaeroidx==0);

% save combined langley with scaled lamp at CO2 region
nir.LangLampCombMod(co2wln) = nir.scaledLamp2LangMod(co2wln);


% plot combined Langley-lamp
% vis
figure(11);
ax(1)=subplot(121);
plot(vis.nm,vis.scaledLamp2LangMod,'-y');hold on;plot(vis.nm,visc0,'--b');hold on;
plot(vis.nm,vis.LangLampCombMod,':r');hold on;
plot(vis.nm(vis.scaleaeroidx==1),visc0(vis.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
xlabel('wavelength');axis([300 1000 0 700]);ylabel('counts');
legend('scaled lamp','vis c0','combined Langley','pixels used in scaling');
title([date 'vis-park.dat']);
% nir
ax(2)=subplot(122);
plot(nir.nm,nir.scaledLamp2LangMod,'-y');hold on;plot(nir.nm,nirc0,'--b');hold on;
plot(nir.nm,nir.LangLampCombMod,':r');hold on;
plot(nir.nm(nir.scaleaeroidx==1),nirc0(nir.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
xlabel('wavelength');axis([950 1700 0 15]);ylabel('counts');
legend('scaled lamp','nir c0','combined Langley','pixels used in scaling');
title([date 'vis-park.dat']);
fi=[dirf date '_scaled_langley'];
save_fig(11,fi,true);

%% write scaled c0 to file
header=['Wavelength [nm]' '   ' 'original c0 (counts): ' '   ' 'lamp-scaled c0' '   ' visnote];
fi=[dir date '_scaled_langley'];
fl=[fi '.dat'];
disp(['writing to ascii file: ' fl])
dlmwrite(fl,header,'delimiter','');
nm = [vis.nm;nir.nm];
c0 = [visc0';nirc0'];
lampc0 = [vis.LangLampCombMod';nir.LangLampCombMod'];
dat=[nm,c0,lampc0];
dlmwrite(fl,dat,'-append','delimiter','\t','precision',7);
%%
%% save c0 to mat file
disp(['saving to mat file: ' fi])
save(fi, 'nm', 'c0', 'lampc0');
%%

%% save Langs_and_Lamps struct for each date
fd=[dir date '_Langs_and_Lamps'];
disp(['saving to mat file: ' fd])
save(fd, 'Langs_and_lamps');
%%
if plotQA
%%
% plot differences:
% vis
figure;
plot(vis.nm,((vis.scaledLamp2LangMod-visc0)./visc0)*100,'-y', 'linewidth',2);hold on;
plot(vis.nm,((vis.LangLampCombMod   -visc0)./visc0)*100,':r','linewidth',2);hold on;
xlabel('wavelength');ylabel('difference [%]');legend('scaled lamp - c0','combined Langley - c0');axis([300 1000 -8 25]);
% nir
figure;
plot(nir.nm,((nir.scaledLamp2LangMod-nirc0)./nirc0)*100,'-y', 'linewidth',2);hold on;
plot(nir.nm,((nir.LangLampCombMod   -nirc0)./nirc0)*100,':r','linewidth',2);hold on;
xlabel('wavelength');ylabel('difference [%]');legend('scaled lamp - c0','combined Langley - c0');axis([1000 1700 -5 80]);

% plot S response ratios
figure; plot(vis.nm,vis.Sratio,'.b');hold on;plot(nir.nm,nir.Sratio,'.r');
hold on; plot(vis.nm(vis.scaleaeroidx==1),vis.Sratio(vis.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
hold on; plot(nir.nm(nir.scaleaeroidx==1),nir.Sratio(nir.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
xlabel('wavelength [nm]');ylabel('langley/lamp Sratio');legend('vis ratio','nir ratio','scaling wavelengths');
%axis([300 1700 -2 2]);

% plot Langleys
figure; plot(vis.nm,visc0,'.b');hold on;plot(nir.nm,nirc0,'.r');
hold on; plot(vis.nm(vis.scaleaeroidx==1),visc0(vis.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
hold on; plot(nir.nm(nir.scaleaeroidx==1),nirc0(nir.scaleaeroidx==1),'.','color',[0.5 0.5 0.5]);
xlabel('wavelength [nm]');ylabel('c0 (counts');legend('vis c0','nir c0','scaling wavelengths');
axis([300 1700 0 700]);
end

%%


return