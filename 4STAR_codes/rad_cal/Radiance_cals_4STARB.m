%% PURPOSE:
%   To build the rad_cal.mat file used for further analysis of nonlinear
%   behavior, and to write the sky response funcitons
%   Takes the measurements of the large integrating sphere (HISS) from
%   4STAR and creates the required outputs.
%   Needs update in code to select specific files corresponding to specific
%   lamp numbers
%   Uses old matlab routines to read 4STARB data
%
% CALLING SEQUENCE:
%   hiss_star_cals = Radiance_cals_4STARB
%
% INPUT:
%   none
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
%  - rd_spc_TCAP_v2.m (with subcall to rd_spc_raw_tcap_v2.m)
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
% Modified (v1.3): by Samuel LeBlanc
% Modified (v1.4): by Samuel LeBlanc
%                  ported over from 4STAR, to use with 4STARB data
% -------------------------------------------------------------------------

%% Start of function
function hiss_star_cals = Radiance_cals_4STARB
version_set('1.4');

date = '20170620';
date = '20171102';

docorrection=false; %false;

%% Legacy codes
% nir = rd_spc_TCAP_v2([pname,'20120920_003_NIR_park.dat']);
% vis = rd_spc_TCAP_v2([pname,'20120920_003_VIS_park.dat']);
% Page 3 of 7 from the lab book, scaling integation time.

% Seems like what I'll need to do is first screen for dark and light
% Then perhaps compute dark/ms over time.  Interpolate to nearest time,
% compute dark for integration time setting.
%%
%%pname = 'D:\case_studies\radiation_cals\2013_11_20.SASZe1_4STAR.NASA_Ames.Flynn\';
pname=uigetdir(getnamedpath('rad_cal_dir'),'Find root folder for calibration files for 4STARB');
hiss = get_hiss;
%% Maybe _003_ all just messing around, bracketing performance for different
% settigs, etc.
% nir = rd_spc_TCAP_v2([pname,'20120920_003_NIR_park.dat']);
% vis = rd_spc_TCAP_v2([pname,'20120920_003_VIS_park.dat']);
% Let's try 004...
% lamp = 'Lamps_12';
% nir = rd_spc_TCAP_v2([pname,lamp,filesep,'20131121_009_NIR_park.dat']);
% vis = rd_spc_TCAP_v2([pname,lamp,filesep,'20131121_009_VIS_park.dat']);
%
% %%
% V = datevec(nir.time);
% %%
% roytime = V(:,4)*100+V(:,5)+V(:,6)./60;
% shut = nir.t.shutter==0;
% shut(2:end)= shut(1:end-1)&shut(2:end), shut(1:end-1) = shut(1:end-1)&shut(2:end);
%
% sun = nir.t.shutter==1;
% sun(2:end) = sun(1:end-1)&sun(2:end); sun(1:end-1) = sun(1:end-1)&sun(2:end);
%
% sky = nir.t.shutter==2;
% sky(2:end) = sky(1:end-1)&sky(2:end); sky(1:end-1) = sky(1:end-1)&sky(2:end);
% figure; sb(1) = subplot(2,1,1);
% plot(roytime(shut), sum(vis.spectra(shut,:),2)./vis.t.t_ms(shut),'kx',...
%     roytime(sun), sum(vis.spectra(sun,:),2)./vis.t.t_ms(sun), 'r.',roytime(sky), sum(vis.spectra(sky,:),2)./vis.t.t_ms(sky),'bx');
% ylabel('sum(cts)')
% legend('shut','red sun','blue sky')
% sb(2) = subplot(2,1,2);
% plot(roytime(shut), vis.t.t_ms(shut),'kx',roytime(sun), vis.t.t_ms(sun),'r.',...
%     roytime(sky), vis.t.t_ms(sky), 'bx');
% ylabel('ms')
% legend('shut','sun','sky')
% linkaxes(sb,'x')
% %%
%
% vis.dark_4ms_12lamps = (mean(vis.spectra(shut&vis.t.t_ms==4,:)));
% vis.light_4ms_12lamps =(mean(vis.spectra(sky&vis.t.t_ms==4,:)));
% vis.sig_4ms_12lamps = vis.light_4ms_12lamps - vis.dark_4ms_12lamps;
% vis.rate_4ms_12lamps = vis.sig_4ms_12lamps /4;
% vis.rad_12lamps = interp1(hiss.nm,hiss.lamps_12, vis.nm,'linear');
% vis.resp_4ms_12lamps = vis.rate_4ms_12lamps./vis.rad_12lamps;
%
% vis.dark_6ms_12lamps = (mean(vis.spectra(shut&vis.t.t_ms==6,:)));
% vis.light_6ms_12lamps =(mean(vis.spectra(sky&vis.t.t_ms==6,:)));
% vis.sig_6ms_12lamps = vis.light_6ms_12lamps - vis.dark_6ms_12lamps;
% vis.rate_6ms_12lamps = vis.sig_6ms_12lamps /6;
% vis.rad_12lamps = interp1(hiss.nm,hiss.lamps_12, vis.nm,'linear');
% vis.resp_6ms_12lamps = vis.rate_6ms_12lamps./vis.rad_12lamps;
%
% vis.dark_8ms_12lamps = (mean(vis.spectra(shut&vis.t.t_ms==8,:)));
% vis.light_8ms_12lamps =(mean(vis.spectra(sky&vis.t.t_ms==8,:)));
% vis.sig_8ms_12lamps = vis.light_8ms_12lamps - vis.dark_8ms_12lamps;
% vis.rate_8ms_12lamps = vis.sig_8ms_12lamps /8;
% vis.rad_12lamps = interp1(hiss.nm,hiss.lamps_12, vis.nm,'linear');
% vis.resp_8ms_12lamps = vis.rate_8ms_12lamps./vis.rad_12lamps;
%
% nir.dark_50ms_12lamps = (mean(nir.spectra(shut&nir.t.t_ms==50,:)));
% nir.light_50ms_12lamps =(mean(nir.spectra(sky&nir.t.t_ms==50,:)));
% nir.sig_50ms_12lamps = nir.light_50ms_12lamps - nir.dark_50ms_12lamps;
% nir.rate_50ms_12lamps = nir.sig_50ms_12lamps /50;
% nir.rad_12lamps = interp1(hiss.nm,hiss.lamps_12, nir.nm,'linear');
% nir.resp_50ms_12lamps = nir.rate_50ms_12lamps./nir.rad_12lamps;
%
% nir.dark_75ms_12lamps = (mean(nir.spectra(shut&nir.t.t_ms==75,:)));
% nir.light_75ms_12lamps =(mean(nir.spectra(sky&nir.t.t_ms==75,:)));
% nir.sig_75ms_12lamps = nir.light_75ms_12lamps - nir.dark_75ms_12lamps;
% nir.rate_75ms_12lamps = nir.sig_75ms_12lamps /75;
% nir.rad_12lamps = interp1(hiss.nm,hiss.lamps_12, nir.nm,'linear');
% nir.resp_75ms_12lamps = nir.rate_75ms_12lamps./nir.rad_12lamps;
%
% nir.dark_100ms_12lamps = (mean(nir.spectra(shut&nir.t.t_ms==100,:)));
% nir.light_100ms_12lamps =(mean(nir.spectra(sky&nir.t.t_ms==100,:)));
% nir.sig_100ms_12lamps = nir.light_100ms_12lamps - nir.dark_100ms_12lamps;
% nir.rate_100ms_12lamps = nir.sig_100ms_12lamps /100;
% nir.rad_12lamps = interp1(hiss.nm,hiss.lamps_12, nir.nm,'linear');
% nir.resp_100ms_12lamps = nir.rate_100ms_12lamps./nir.rad_12lamps;
%
% %%
% figure;plot(vis.nm, [vis.resp_4ms_12lamps;vis.resp_6ms_12lamps;vis.resp_8ms_12lamps],'-',...
%     nir.nm, [nir.resp_50ms_12lamps;nir.resp_75ms_12lamps;nir.resp_100ms_12lamps],'-');
% legend('4','6','8','50','75','100')

%%
if date=='20171102';
    lamps = [12,9,6];
    sublamps = true;
else;
    lamps = [12,9,6,3,2,1];
    sublamps = false;
end;
vis_mean = []; vis_std = []; nir_mean = []; nir_std = [];
M_vis = []; S_vis = 0; M_nir = []; S_nir = 0;
k = 0;
instname = '4STARB_';

%% Loop through each lamps
for ll = lamps
    k = k+1;
    lamp_str = ['Lamps_',sprintf('%d',ll)];
    if date=='20131121' | date=='20131120'
        switch ll %% make sure that the file number is correctly set for each lamp setting, dependent on the day of calibration.
            case 12
                fnum = '009';
            case 9
                fnum = '010';
            case 6
                fnum = '011';
            case 3
                fnum = '012';
            case 2
                fnum = '013';
            case 1
                fnum = '014';
            case 0
                fnum = '015';
        end
        pp='park';
    elseif date=='20170620' | date=='20170621';
        switch ll
            case 12
                date='20170620';
                fnum = '013';
            case 9
                date='20170620';
                fnum = '014';
            case 6
                date='20170621';
                fnum = '001';
            case 3
                date='20170621';
                fnum = '002';
            case 2
                date='20170621';
                fnum = '003';
            case 1
                date='20170621';
                fnum = '005';
            case 0
                date='20170621';
                fnum = '006';
        end
        pp='ZEN';
     elseif date=='20171102';
        switch ll
            case 12
                fnum = '004';
            case 9
                fnum = '005';
            case 6
                fnum = '006';
            case 0
                fnum = '007';
        end
        pp='ZEN';
    else;
        disp('problem! date not recongnised')
    end
    
    %% load the files
    disp(strcat('Getting lamp #',num2str(ll)))
    [pname,filesep,lamp_str, filesep,instname,date,'_',fnum,'_NIR_',pp,'.dat']
    if ~isafolder([pname,filesep,lamp_str])
        nir = rd_spc_TCAP_v2([pname,filesep,instname,date,'_',fnum,'_NIR_',pp,'.dat']);
        vis = rd_spc_TCAP_v2([pname,filesep,instname,date,'_',fnum,'_VIS_',pp,'.dat']);
    else
        nir = rd_spc_TCAP_v2([pname,filesep,lamp_str, filesep,instname,date,'_',fnum,'_NIR_',pp,'.dat']);
        vis = rd_spc_TCAP_v2([pname,filesep,lamp_str, filesep,instname,date,'_',fnum,'_VIS_',pp,'.dat']);
    end
    shut = nir.t.shutter==0;
    shut(2:end)= shut(1:end-1)&shut(2:end); shut(1:end-1) = shut(1:end-1)&shut(2:end);
    sun = nir.t.shutter==1;
    sun(2:end) = sun(1:end-1)&sun(2:end); sun(1:end-1) = sun(1:end-1)&sun(2:end);
    sky = nir.t.shutter==2;
    sky(2:end) = sky(1:end-1)&sky(2:end); sky(1:end-1) = sky(1:end-1)&sky(2:end);
    
    V = datevec(nir.time);
    % %%
    roytime = V(:,4)*100+V(:,5)+V(:,6)./60;
    %% start plotting of time traces of counts
    figure(5);
    sb(1) = subplot(2,1,1);
    plot(roytime(shut), sum(vis.spectra(shut,:),2)./vis.t.t_ms(shut),'kx',...
        roytime(sun), sum(vis.spectra(sun,:),2)./vis.t.t_ms(sun), 'r.',roytime(sky), sum(vis.spectra(sky,:),2)./vis.t.t_ms(sky),'bx');
    ylabel('sum(cts)')
    legend('shut','red sun','blue sky')
    title([lamp_str, ': ',vis.fname],'interp','none');
    sb(2) = subplot(2,1,2);
    plot(roytime(shut), vis.t.t_ms(shut),'kx',roytime(sun), vis.t.t_ms(sun),'r.',...
        roytime(sky), vis.t.t_ms(sky), 'bx');
    ylabel('ms')
    legend('shut','sun','sky')
    linkaxes(sb,'x')
    
    ff=[pname filesep date '_counts_' lamp_str];
    save_fig(5,ff,true);
    
    %% prepare response funcitons for plotting
    vis_tints = unique(vis.t.t_ms);
    for vs = length(vis_tints):-1:1
        if sum(vis.t.t_ms(shut)==vis_tints(vs))<5||sum(vis.t.t_ms(sky)==vis_tints(vs))<5
            vis_tints(vs) = [];
        end
    end
    nir_tints = unique(nir.t.t_ms);
    for ns = length(nir_tints):-1:1
        if sum(nir.t.t_ms(shut)==nir_tints(ns))<5||sum(nir.t.t_ms(sky)==nir_tints(ns))<5
            nir_tints(ns) = [];
        end
    end
    
    if docorrection
        %% now correct the raw spectra counts for nonlinearity
        disp('Correcting the data for nonlinearity')
        vis_spectra=correct_nonlinear(vis.spectra,true);
        nir_spectra=correct_nonlinear(nir.spectra,true);
        vis.spectra=vis_spectra;
        nir.spectra=nir_spectra;
    end
    
    %% build rate counts an response functions from raw counts
    for vs = length(vis_tints)-1:-1:1
        cal.(lamp_str).vis.t_ms(vs) = vis_tints(vs);
        cal.(lamp_str).vis.dark(vs,:) = mean(vis.spectra(shut&vis.t.t_ms==vis_tints(vs),:));
        cal.(lamp_str).vis.light(vs,:)= mean(vis.spectra(sky &vis.t.t_ms==vis_tints(vs),:));
        cal.(lamp_str).vis.sig(vs,:) = cal.(lamp_str).vis.light(vs,:)-cal.(lamp_str).vis.dark(vs,:);
        cal.(lamp_str).vis.rate(vs,:) = cal.(lamp_str).vis.sig(vs,:) / cal.(lamp_str).vis.t_ms(vs);
        cal.(lamp_str).vis.rad = interp1(hiss.nm,hiss.(['lamps_',num2str(ll)]), vis.nm,'linear');
        cal.(lamp_str).vis.resp(vs,:) = cal.(lamp_str).vis.rate(vs,:)./cal.(lamp_str).vis.rad;
    end
    for ns = length(nir_tints)-1:-1:1
        cal.(lamp_str).nir.t_ms(ns) = nir_tints(ns);
        cal.(lamp_str).nir.dark(ns,:) = mean(nir.spectra(shut&nir.t.t_ms==nir_tints(ns),:));
        cal.(lamp_str).nir.light(ns,:)= mean(nir.spectra(sky &nir.t.t_ms==nir_tints(ns),:));
        cal.(lamp_str).nir.sig(ns,:) = cal.(lamp_str).nir.light(ns,:) - cal.(lamp_str).nir.dark(ns,:);
        cal.(lamp_str).nir.rate(ns,:) = cal.(lamp_str).nir.sig(ns,:) / cal.(lamp_str).nir.t_ms(ns);
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
    figure(6);
    linkaxes(sb,'off');
    subplot(3,1,1);
    plot(vis.nm, cal.(lamp_str).vis.resp,'-');
    title([lamp_str, ': ',vis.fname],'interp','none');
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
    title([lamp_str, ': ',nir.fname],'interp','none');
    ylabel('resp');
    
    subplot(3,1,3);
    plot(vis.nm, 100.*cal.(lamp_str).vis.std_resp./cal.(lamp_str).vis.mean_resp,'b-',...
        nir.nm, 100.*cal.(lamp_str).nir.std_resp./cal.(lamp_str).nir.mean_resp,'r-')
    title(['Relative STD of responsivity: ',lamp_str],'interp','none');
    ylim([0,25]);
    ylabel('%');
    grid;
    xlabel('wavelength [nm]')
    
    ff=[pname filesep date '_responses_' lamp_str];
    save_fig(6,ff,true);
    
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
subplot(2,1,1);
%lines = plot(vis.nm, [mean(cal.Lamps_12.vis.resp);mean(cal.Lamps_9.vis.resp);mean(cal.Lamps_6.vis.resp);...
%    mean(cal.Lamps_3.vis.resp);mean(cal.Lamps_2.vis.resp);mean(cal.Lamps_1.vis.resp)],'-');
if sublamps;
    lines= plot(vis.nm, cal.Lamps_12.vis.mean_resp, ...
    vis.nm, cal.Lamps_9.vis.mean_resp, ...
    vis.nm, cal.Lamps_6.vis.mean_resp,'-');
%colorbar;
recolor(lines,[12,9,6]);
    
else;
lines= plot(vis.nm, cal.Lamps_12.vis.mean_resp, ...
    vis.nm, cal.Lamps_9.vis.mean_resp, ...
    vis.nm, cal.Lamps_6.vis.mean_resp, ...
    vis.nm, cal.Lamps_3.vis.mean_resp, ...
    vis.nm, cal.Lamps_2.vis.mean_resp, ...
    vis.nm, cal.Lamps_1.vis.mean_resp,'-');
%colorbar;
recolor(lines,[12,9,6,3,2,1]);
end;
title([lamp_str, ': ',vis.fname],'interp','none');
ylabel('resp');
xlabel('wavelength [nm]')
legend(num2str(lamps',' %d lamps'), 'location','northwest');
hold('on');
plot(vis.nm, vis_mean, '.');
hold('off');

subplot(2,1,2);
%lines = plot(nir.nm, [mean(cal.Lamps_12.nir.resp);mean(cal.Lamps_9.nir.resp);mean(cal.Lamps_6.nir.resp);...
%    mean(cal.Lamps_3.nir.resp);mean(cal.Lamps_2.nir.resp);mean(cal.Lamps_1.nir.resp)],'-');
if sublamps;
    lines= plot(nir.nm, cal.Lamps_12.nir.mean_resp, ...
    nir.nm, cal.Lamps_9.nir.mean_resp, ...
    nir.nm, cal.Lamps_6.nir.mean_resp,'-');
%colorbar;
recolor(lines,[12,9,6]);
    
else;
lines= plot(nir.nm, cal.Lamps_12.nir.mean_resp, ...
    nir.nm, cal.Lamps_9.nir.mean_resp, ...
    nir.nm, cal.Lamps_6.nir.mean_resp, ...
    nir.nm, cal.Lamps_3.nir.mean_resp, ...
    nir.nm, cal.Lamps_2.nir.mean_resp, ...
    nir.nm, cal.Lamps_1.nir.mean_resp,'-');
%colorbar;
recolor(lines,[12,9,6,3,2,1]);
end;
legend(num2str(lamps',' %d lamps'), 'location','northwest');
hold('on');
plot(nir.nm, nir_mean, '.');
hold('off');
title([lamp_str, ': ',nir.fname],'interp','none');
ylabel('resp');
xlabel('wavelength [nm]')

ff=[pname filesep date '_responses'];
save_fig(10,ff,true);
%%
% Text below copied from hiss_star_cals_May_2013_tracking_nonlin_effect_continued
% Should be adapted to populate from this calibration series.
%
% lamps = 9; lamp_str = (sprintf('lamps_%d',lamps));
% tint = 9;
% tint_ii = find(hiss_rad.STAR_VIS.(lamp_str).Integration==tint);
% vis_SkyRadiance.lamps = lamps;
% vis_SkyRadiance.ms = tint;
%
% vis_SkyRadiance.Pix = [1:length(hiss_rad.STAR_VIS.nm)];
% vis_SkyRadiance.Wavelength = hiss_rad.STAR_VIS.nm;
% vis_SkyRadiance.rate = hiss_rad.STAR_VIS.(lamp_str).mean_spectra(tint_ii,:)';
% vis_SkyRadiance.rad = hiss_rad.STAR_VIS.(lamp_str).radiance';
% vis_SkyRadiance.resp = hiss_rad.STAR_VIS.(lamp_str).resp(tint_ii,:)';
% vis_SkyRadiance.units = hiss.units;
% [~,vis_SkyRadiance.cal_source,~] =fileparts(hiss.fname);
% vis_SkyRadiance.cal_date = '20130506';
% vis_SkyRadiance.comment = '% Calibration used only data with 9-lamps and 9 ms (vis), 140 ms (nir).';
% write_SkyResp_file(vis_SkyRadiance,'comment',vis_SkyRadiance.comment);
%
% tint = 140;
% tint_ii = find(hiss_rad.STAR_NIR.(lamp_str).Integration==tint);
% nir_SkyRadiance.lamps = lamps;
% nir_SkyRadiance.ms = tint;
% nir_SkyRadiance.Pix = [1:length(hiss_rad.STAR_NIR.nm)];
% nir_SkyRadiance.Wavelength = hiss_rad.STAR_NIR.nm;
% nir_SkyRadiance.rate = hiss_rad.STAR_NIR.(lamp_str).mean_spectra(tint_ii,:)';
% nir_SkyRadiance.rad = hiss_rad.STAR_NIR.(lamp_str).radiance';
% nir_SkyRadiance.resp = hiss_rad.STAR_NIR.(lamp_str).resp(tint_ii,:)';
% nir_SkyRadiance.units = hiss.units;
%
% [~,nir_SkyRadiance.cal_source,~] =fileparts(hiss.fname);
% nir_SkyRadiance.cal_date = '20130506';
% nir_SkyRadiance.comment = '% Calibration used only data with 9-lamps and 9 ms (vis), 140 ms (nir).';
% write_SkyResp_file(nir_SkyRadiance,'comment',nir_SkyRadiance.comment);

if docorrection
    corstr='_corr';
else
    corstr='';
end

fname=[pname filesep instname date '_rad_cal' corstr];
save(fname)
disp(['saved to ' fname '.mat'])
disp('Now stopping program')
return
