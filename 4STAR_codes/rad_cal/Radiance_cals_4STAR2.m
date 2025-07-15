%% PURPOSE:
%   To build the rad_cal.mat file used for further analysis of nonlinear
%   behavior, and to write the sky response funcitons
%   Takes the measurements of the large integrating sphere (HISS) from
%   4STAR and creates the required outputs.
%   Needs update in code to select specific files corresponding to specific
%   lamp numbers
%   Uses old matlab routines to read 4STAR data
%
% CALLING SEQUENCE:
%   hiss_star_cals = Radiance_cals_4STAR2(daystrin)
%
% INPUT:
%   daystrin(optional): string of day to use over default strin, in format yyyymmdd
%
% OUTPUT:
%  - plots of raw counts and standard deviation per lamp number
%  - plots of response functions and standard deviations per lamp number
%  for vis and nir
%  - rad_cals.mat file with calibrated radiances
%
% DEPENDENCIES:
%  - get_hiss.m
%  - save_fig.m
%  - version_set.m
%  - starwrapper.m
%  - select_lab_cal_file.m
%  - t2utch.m : to transfer matlab time to utc hours
%
% NEEDED FILES:
%  - HISS.txt calibrated file
%  - one raw 4STAR data file for each lamp setting, defined by a specific
%  directory structure
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Connor Flynn, PNNL, date unknown
% Modified (v1.0): by Samuel LeBlanc, NASA Ames, Oct 13th, 2014
%          - ported over from old code, included reference to specific
%          files
%          - added version control of this file
% Modified (v1.1): by Samuel LeBlanc, NASA Ames Jan 8th, 2015
%          - update with new calibration date.
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, March 16th, 2015
%          - modified some plotting options, to show NIR response functions
%          more clearly
% Modified (v2.0): by Samuel LeBlanc, NASA Ames, May 6th, 2015
%          - Took out some legacy codes (rd_spc) to match starwrapper style
%          coding
%          - added subfunction select_lab_cal_file for easier tracking of
%          Large sphere lamp number with radiance files
%          - added daystrin argument for selecting a day from command line,
%          - added default hiss file based on date values
% Modified (v2.1): by Samuel LeBlanc, NASA Ames, 2015-11-11
%          - added default for pre-NAAMES plotting
% Modified (v2.2): by Samuel LeBlanc, NASA Ames, 2016-09-29
%          - added control for pre-KORUS data in 2016
% -------------------------------------------------------------------------

%% Start of function
function hiss_star_cals = Radiance_cals_4STAR2(daystrin)
version_set('2.2');

if exist('daystrin','var')
    date = daystrin;
else
    %date='20131121'
    %date='20130506'
    %date='20140624'
    %date='20140716'
    %date='20141024'
    %date = '20150915'
    %date = '20160330'
    date = '20250626'
end
docorrection=false; %do nonlinear correction

pname_callab = getnamedpath('cal_rad');
if ~exist(pname_callab)
    pname=uigetdir('C:\','Find folder for calibration files');
else
    disp(['Using default cal folder:' pname_callab])
    pname = pname_callab
    %['C:\Users\sleblan2\Research\4STAR\cal\' date]
end

%% Get instrument used from the available files
file_list = dir([pname filesep '*.dat']);
[sourcefile, ext, daystr,filen,instrumentname]=starsource([file_list(1).folder filesep file_list(1).name]);
if ~strcmp(date,daystr) 
    disp(['***Date string(' date ') does not match folder (' daystr '), using folder values ***'])
    date=daystr
end

%% get sphere radiance file
if date(1:4)=='2014'|date(1:4)=='2015';
    hiss = get_hiss('C:\Users\sleblan2\Research\4STAR\cal\spheres\HISS\20140606091700HISS.txt');
elseif date(1:4)=='2013';
    hiss = get_hiss('C:\Users\sleblan2\Research\4STAR\cal\spheres\HISS\20130605124300HISS.txt');
elseif date(1:4)=='2016';
    hiss = get_hiss('C:\Users\sleblan2\Research\4STAR\cal\spheres\HISS\20160121125700HISS.txt');
else
    hiss = get_hiss;
end;

%% Setup variables
lamps = [12,11,10,9,6,3,2,1];
vis_mean = []; vis_std = []; nir_mean = []; nir_std = [];
M_vis = []; S_vis = 0; M_nir = []; S_nir = 0;
k = 0;


%% Loop through each lamps
for ll = lamps
    k = k+1;
    lamp_str = ['Lamps_',sprintf('%d',ll)];
    [date fnum pp] = select_lab_cal_file(date,ll,instrumentname);
    if length(fnum)<1, 
        cal.(lamp_str).vis.mean_resp = NaN(1044,1);
        cal.(lamp_str).nir.mean_resp = NaN(512,1);
        continue
    end
    %% load the files
    disp(strcat('Getting lamp #',num2str(ll)))
    
    nir.fname = [instrumentname '_' date,'_',fnum,'_NIR_',pp,'.dat'];
    vis.fname = [instrumentname '_' date,'_',fnum,'_VIS_',pp,'.dat'];
    if exist([pname,filesep,lamp_str], 'dir')ana
        fnames = {[pname,filesep,lamp_str,filesep,nir.fname];[pname,filesep,lamp_str,filesep,vis.fname]};
    else
        fnames = {[pname,filesep,nir.fname];[pname,filesep,vis.fname]};
    end
    [sourcefile, contents0, savematfile]=startupbusiness('', fnames,['.' filesep 'tempmatdata.mat']);
    load(sourcefile,contents0{:},'program_version');
    if exist('vis_zen')>0;
        vis_park=vis_zen; nir_park=nir_zen;
    end;    
    
    %% add variables and make adjustments common among all data types. Also
    % combine the two structures.
    tog.applynonlinearcorr = docorrection;
    tog.verbose = false;
    tog.applytempcorr = false;
    tog.computeerror = false;
    s=starwrapper(vis_park, nir_park,tog);%'applytempcorr',false,'verbose',false,'applynonlinearcorr',docorrection);
    note = s.note;
    s.utc = t2utch(s.t);
    s.toggle
    
    shut = s.Str==0;
    shut(2:end)= shut(1:end-1)&shut(2:end); shut(1:end-1) = shut(1:end-1)&shut(2:end);
    sun = s.Str==1;
    sun(2:end) = sun(1:end-1)&sun(2:end); sun(1:end-1) = sun(1:end-1)&sun(2:end);
    sky = s.Str==2;
    sky(2:end) = sky(1:end-1)&sky(2:end); sky(1:end-1) = sky(1:end-1)&sky(2:end);
    
    %% start plotting of time traces of counts
    figure(5);clf;
    set(5,'Position',[50 200 1400 800])
    sb(1) = subplot(2,1,1);
    plot(s.utc(shut), sum(s.dark(shut,1:1044)./repmat(s.visTint(shut),[1,1044]),2), 'kx')
    hold all;
    plot(s.utc(shut), sum(s.dark(shut,1045:end)./repmat(s.nirTint(shut),[1,512]),2)*10,'+','color',[0.5,0.5,0.5])
    plot(s.utc(sun), sum(s.rate(sun,1:1044),2), 'rx')
    plot(s.utc(sun), sum(s.rate(sun,1045:end),2)*10, '+','color',[1.0,0.5,0.5])
    plot(s.utc(sky), sum(s.rate(sky,1:1044),2), 'bx')
    plot(s.utc(sky), sum(s.rate(sky,1045:end),2)*10, '+','color',[0.5,0.5,1.0])
    hold off
    ylabel('sum(rate)')
    legend('VIS shutter','NIR shutter*10','VIS sun','NIR sun*10','VIS sky','NIR sky*10')
    title([instrumentname ' ' lamp_str, ': ',vis.fname],'interp','none');
    sb(2) = subplot(2,1,2);
    plot(s.utc(shut), s.visTint(shut), 'kx')
    hold all;
    plot(s.utc(shut), s.nirTint(shut)/10.0, '+','color',[0.5,0.5,0.5])
    plot(s.utc(sun), s.visTint(sun), 'rx')
    plot(s.utc(sun), s.nirTint(sun)/10.0,  '+','color',[1.0,0.5,0.5])
    plot(s.utc(sky), s.visTint(sky), 'bx')
    plot(s.utc(sky), s.nirTint(sky)/10.0, '+','color',[0.5,0.5,1.0])
    hold off;
    ylabel('ms')
    xlabel('UTC [H]')
    legend('VIS shutter','NIR shutter/10','VIS sun','NIR sun/10','VIS sky','NIR sky/10')
    linkaxes(sb,'x')
    
    ff=[pname filesep instrumentname '_' date '_counts_' lamp_str];
    save_fig(5,ff,false);
    
    %% prepare response functions for plotting
    vis_tints = unique(s.visTint);
    for vs = length(vis_tints):-1:1
        if sum(s.visTint(shut)==vis_tints(vs))<5||sum(s.visTint(sky)==vis_tints(vs))<5
            vis_tints(vs) = [];
        end
    end
    nir_tints = unique(s.nirTint);
    for ns = length(nir_tints):-1:1
        if sum(s.nirTint(shut)==nir_tints(ns))<5||sum(s.nirTint(sky)==nir_tints(ns))<5
            nir_tints(ns) = [];
        end
    end
    
    
    %% build rate counts an response functions from raw counts
    vis.nm = s.w(1:1044)*1000.0; vis.time = s.t;
    nir.nm = s.w(1045:end)*1000.0; nir.time = s.t;
    for vs = length(vis_tints):-1:1
        cal.(lamp_str).vis.t_ms(vs) = vis_tints(vs);
        cal.(lamp_str).vis.dark(vs,:) = mean(s.dark(s.visTint==vis_tints(vs),1:1044));
        cal.(lamp_str).vis.light(vs,:) = mean(s.raw(sky&s.visTint==vis_tints(vs),1:1044));
        if any(sky&s.visTint==vis_tints(vs)&~s.sat_time)
            cal.(lamp_str).vis.rate(vs,:) = mean(s.rate(sky&s.visTint==vis_tints(vs)&~s.sat_time,1:1044));
        else
            cal.(lamp_str).vis.rate(vs,:) = mean(s.rate(sky&s.visTint==vis_tints(vs),1:1044))+NaN;
        end
        cal.(lamp_str).vis.rad = interp1(hiss.nm,hiss.(['lamps_',num2str(ll)]), vis.nm,'linear');
        cal.(lamp_str).vis.resp(vs,:) = cal.(lamp_str).vis.rate(vs,:)./cal.(lamp_str).vis.rad;
    end
    for ns = length(nir_tints):-1:1
        cal.(lamp_str).nir.t_ms(ns) = nir_tints(ns);
        cal.(lamp_str).nir.dark(ns,:) = mean(s.dark(s.nirTint==nir_tints(vs),1045:end));
        cal.(lamp_str).nir.light(ns,:)= mean(s.raw(sky&s.nirTint==nir_tints(vs),1045:end));
        if any(sky&s.nirTint==nir_tints(vs)&~s.sat_time)
            cal.(lamp_str).nir.rate(ns,:) = mean(s.rate(sky&s.nirTint==nir_tints(vs)&~s.sat_time,1045:end));
        else
            cal.(lamp_str).nir.rate(ns,:) = mean(s.rate(sky&s.nirTint==nir_tints(vs)&~s.sat_time,1045:end))+NaN;
        end
        cal.(lamp_str).nir.rad = interp1(hiss.nm,hiss.(['lamps_',num2str(ll)]), nir.nm,'linear');
        cal.(lamp_str).nir.resp(ns,:) = cal.(lamp_str).nir.rate(ns,:)./cal.(lamp_str).nir.rad;
    end
    
    cal.(lamp_str).vis.mean_resp = nanmean(cal.(lamp_str).vis.resp);
    cal.(lamp_str).vis.std_resp = nanstd(cal.(lamp_str).vis.resp);
    cal.(lamp_str).nir.mean_resp = nanmean(cal.(lamp_str).nir.resp);
    cal.(lamp_str).nir.std_resp = nanstd(cal.(lamp_str).nir.resp);
    if isempty(vis_mean)
        vis_mean = cal.(lamp_str).vis.mean_resp;
        vis_std = cal.(lamp_str).vis.mean_resp.^2;
        nir_mean = cal.(lamp_str).nir.mean_resp;
        nir_std = cal.(lamp_str).nir.mean_resp.^2;
        M_vis = cal.(lamp_str).vis.mean_resp;
        S_vis = 0;
        M_nir = cal.(lamp_str).nir.mean_resp;
        S_nir = 0;
    else
        M_vis_ = M_vis;
        M_vis = M_vis + (cal.(lamp_str).vis.mean_resp-M_vis)./k;
        S_vis = S_vis +(cal.(lamp_str).vis.mean_resp-M_vis).*(cal.(lamp_str).vis.mean_resp-M_vis_);
        Std_vis = sqrt(S_vis./(k-1));
        M_nir_ = M_nir;
        M_nir = M_nir + (cal.(lamp_str).nir.mean_resp-M_nir)./k;
        S_nir = S_nir +(cal.(lamp_str).nir.mean_resp-M_nir).*(cal.(lamp_str).nir.mean_resp-M_nir_);
        Std_nir = sqrt(S_nir./(k-1));
        
        vis_mean = vis_mean + cal.(lamp_str).vis.mean_resp;
        vis_std = vis_std + cal.(lamp_str).vis.mean_resp.^2;
        nir_mean = nir_mean + cal.(lamp_str).nir.mean_resp;
        nir_std = nir_std + cal.(lamp_str).nir.mean_resp.^2;
    end
    
    %% plot of response functions
    figure(6);clf;
    set(6,'Position',[50 200 1400 800])
    linkaxes(sb,'off');
    subplot(3,1,1);
    plot(vis.nm, cal.(lamp_str).vis.resp,'-');
    title([instrumentname ' ' lamp_str, ': ',vis.fname],'interp','none');
    ylabel('resp');
    xlabel('wavelength [nm]')
    legend(num2str(vis_tints,' %d ms'), 'location','northwest');
    hold('on');
    plot(vis.nm, cal.(lamp_str).vis.mean_resp, '.k-');
    hold('off');
    
    subplot(3,1,2);
    plot(nir.nm, cal.(lamp_str).nir.resp,'-');
    legend(num2str(nir_tints,' %d ms'), 'location','northwest')
    hold('on');
    plot(nir.nm, cal.(lamp_str).nir.mean_resp, '.k-');
    hold('off');
    title([instrumentname ' ' lamp_str, ': ',nir.fname],'interp','none');
    ylabel('resp');
    
    subplot(3,1,3);
    plot(vis.nm, 100.*cal.(lamp_str).vis.std_resp./cal.(lamp_str).vis.mean_resp,'b-',...
        nir.nm, 100.*cal.(lamp_str).nir.std_resp./cal.(lamp_str).nir.mean_resp,'r-')
    title([instrumentname ' Relative STD of responsivity: ',lamp_str],'interp','none');
    ylim([0,5]);
    ylabel('%');
    grid;
    xlabel('wavelength [nm]')
    
    ff=[pname filesep instrumentname '_'  date '_responses_' lamp_str];
    save_fig(6,ff,false);
    
end
vis_mean = vis_mean./length(lamps);
vis_std = sqrt(vis_std./length(lamps));
nir_mean = nir_mean./length(lamps);
nir_std = sqrt(nir_std./length(lamps));

% figure; plot(vis.nm, 100.*vis_std/vis_mean,'b-',...
%     nir.nm, 100.*nir_std./nir_mean,'r-')
% title(['Relative STD of responsivity: ',lamp_str],'interp','none');
% ylabel('%');
% xlabel('wavelength [nm]')

%%
figure(10);
set(10,'Position',[50 200 1400 800])
subplot(2,1,1);
%lines = plot(vis.nm, [mean(cal.Lamps_12.vis.resp);mean(cal.Lamps_9.vis.resp);mean(cal.Lamps_6.vis.resp);...
%    mean(cal.Lamps_3.vis.resp);mean(cal.Lamps_2.vis.resp);mean(cal.Lamps_1.vis.resp)],'-');
lines= plot(vis.nm, cal.Lamps_12.vis.mean_resp, ...
    vis.nm, cal.Lamps_9.vis.mean_resp, ...
    vis.nm, cal.Lamps_6.vis.mean_resp, ...
    vis.nm, cal.Lamps_3.vis.mean_resp, ...
    vis.nm, cal.Lamps_2.vis.mean_resp, ...
    vis.nm, cal.Lamps_1.vis.mean_resp,'-');
%colorbar;
try
    recolor(lines,[12,9,6,3,2,1]);
catch
    disp('error in recolor of lines')    
end
title([instrumentname ' ' lamp_str, ': ',vis.fname],'interp','none');
ylabel('resp');
xlabel('wavelength [nm]')
legend(num2str(lamps',' %d lamps'), 'location','northwest');
hold('on');
plot(vis.nm, vis_mean, '.');
hold('off');

subplot(2,1,2);
%lines = plot(nir.nm, [mean(cal.Lamps_12.nir.resp);mean(cal.Lamps_9.nir.resp);mean(cal.Lamps_6.nir.resp);...
%    mean(cal.Lamps_3.nir.resp);mean(cal.Lamps_2.nir.resp);mean(cal.Lamps_1.nir.resp)],'-');
lines= plot(nir.nm, cal.Lamps_12.nir.mean_resp, ...
    nir.nm, cal.Lamps_9.nir.mean_resp, ...
    nir.nm, cal.Lamps_6.nir.mean_resp, ...
    nir.nm, cal.Lamps_3.nir.mean_resp, ...
    nir.nm, cal.Lamps_2.nir.mean_resp, ...
    nir.nm, cal.Lamps_1.nir.mean_resp,'-');
%colorbar;
try
    recolor(lines,[12,9,6,3,2,1]);
catch
    disp('error in recolor of nir lines')
end
legend(num2str(lamps',' %d lamps'), 'location','northwest');
hold('on');
plot(nir.nm, nir_mean, '.');
hold('off');
title([instrumentname ' ' lamp_str, ': ',nir.fname],'interp','none');
ylabel('resp');
xlabel('wavelength [nm]')

ff=[pname filesep instrumentname '_' date '_responses'];
save_fig(10,ff,true);

%% prepare for saving
if docorrection
    corstr='_corr';
else
    corstr='';
end

fname=[pname filesep instrumentname '_' date '_rad_cal' corstr];
save(fname)
disp(['saved to ' fname '.mat'])
disp('Now stopping program')
return
