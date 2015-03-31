%% Details of the program:
% NAME:
%   plot_star_head_temp_test_all
%
% PURPOSE:
%  quick and dirty program to plot results from tep check on fiber optics
%  Used to compile all head temperature tests for easy viewing and
%  comparison
%
% CALLING SEQUENCE:
%   plot_star_head_temp_test_all
%
% INPUT:
%  none
%
% OUTPUT:
%  plots
%
% DEPENDENCIES:
%  - version_set.m
%  - t2utch.m
%  - starwavelength.m
%  - smoothn.m : for time series smoothing
%  - linfitxy.m : for linear fitting with uncertainties
%
% NEEDED FILES:
%  - star.mat file compiled from raw data using allstarmat of each temp
%  test day
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, March 30th, 2015
% Modified:
%
% -------------------------------------------------------------------------
function plot_star_fiber_temp_test_all
version_set('v1.0')
clear;
toggle.docontour = false;
dir = 'C:\Users\sleblan2\Research\4STAR\roof\';
%daystr = '20150325';

%load([dir daystr 'star.mat']);

%convert time to utc
%vis_park.utc = t2utch(vis_park.t);
%nir_park.utc = t2utch(nir_park.t);

% define the different limits of the tests
tests(1).label = 'Prototype fiber - with connectors, no diffuser';
tests(1).icool = [701:1026] %from 19:46 to 19:52
tests(1).iheat = [1075:1821]; %from 19:52 to 20:21
tests(1).idark = [1042];  %19:52
tests(1).ylim  = [97.5,103.5];
tests(1).daystr = '20150224';
tests(1).filepath = [dir tests(1).daystr filesep tests(1).daystr 'star.mat'];
tests(1).norm2diode = false;
tests(1).use_t4 = false;

tests(2).label = 'Prototype fiber - no connectors, no diffuser';
tests(2).icool = [1887:2073]; %from 20:26 to 20:44
tests(2).iheat = [2406:3395]; %from 20:46 to 21:24
tests(2).idark = [1863]; % 20:25
tests(2).ylim  = [98.5,102.5];
tests(2).daystr = '20150224';
tests(2).filepath = [dir tests(2).daystr filesep tests(2).daystr 'star.mat'];
tests(2).norm2diode = false;
tests(2).use_t4 = false;

tests(3).label = 'Prototype fiber - jacketing cut, no diffuser';
tests(3).icool = [6191:6459]; %from 21:24 to 21:44
tests(3).iheat = [6497:7187]; %from 21:50 to 22:36, missing data points because of small spectro issue
tests(3).idark = [4100]; %21:24
tests(3).ylim  = [95.5,105.5];
tests(3).daystr = '20150224';
tests(3).filepath = [dir tests(3).daystr filesep tests(3).daystr 'star.mat'];
tests(3).norm2diode = false;
tests(3).use_t4 = false;

tests(4).label = '800 micron fiber';
tests(4).icool = [7460:7959]; %from 24:03 to 24:23
tests(4).iheat = [7982:8525]; %from 24:24 to 24:43
tests(4).idark = [7965]; %24:23
tests(4).ylim  = [80,115];
tests(4).daystr = '20150224';
tests(4).filepath = [dir tests(4).daystr filesep tests(4).daystr 'star.mat'];
tests(4).norm2diode = false;
tests(4).use_t4 = false;

tests(5).label = '800 micron fiber, aluminium and upper Y section out';
tests(5).icool = [8549:8706]; %from 24:49 to 24:56
tests(5).iheat = [8727:9421]; %from 24:57 to 25:20
tests(5).idark = [8712]; %24:57
tests(5).ylim  = [80,115];
tests(5).daystr = '20150224';
tests(5).filepath = [dir tests(5).daystr filesep tests(5).daystr 'star.mat'];
tests(5).norm2diode = false;
tests(5).use_t4 = false;

tests(6).label = '800 micron jacketing cut';
tests(6).icool = [9452:9658]; %from 25:34 to 25:43
tests(6).iheat = [9695:9954]; %from 25:43 to 25:58
tests(6).idark = [9435]; %25:34
tests(6).ylim  = [98.5,101];
tests(6).daystr = '20150224';
tests(6).filepath = [dir tests(6).daystr filesep tests(6).daystr 'star.mat'];
tests(6).norm2diode = false;
tests(6).use_t4 = false;

tests(7).label = 'Bare Fiber';
tests(7).icool = [1070:1414]; %from 25:34 to 25:43
tests(7).iheat = [1493:2362]; %from 25:43 to 25:58
tests(7).idark = [1443]; %25:34
tests(7).ylim  = [98.5,101];
tests(7).daystr = '20150225';
tests(7).filepath = [dir tests(7).daystr filesep tests(7).daystr 'star.mat'];
tests(7).norm2diode = false;
tests(7).use_t4 = false;

tests(8).label = 'Whole Head, with G10';
tests(8).icool = [5075:5626]; %from 25:34 to 25:43
tests(8).iheat = [5745:7503]; %from 25:43 to 25:58
tests(8).idark = [5644]; %25:34
tests(8).ylim  = [98.5,101];
tests(8).daystr = '20150304';
tests(8).filepath = [dir tests(8).daystr filesep tests(8).daystr 'star.mat'];
tests(8).norm2diode = false;
tests(8).use_t4 = true;

tests(9).label = 'Whole Head, test #2, more stable';
tests(9).icool = [752:1780]; %from 25:34 to 25:43
tests(9).iheat = [1923:3421]; %from 25:43 to 25:58
tests(9).idark = [1794]; %25:34
tests(9).ylim  = [98.5,101];
tests(9).daystr = '20150305';
tests(9).filepath = [dir tests(9).daystr filesep tests(9).daystr 'star.mat'];
tests(9).norm2diode = true;
tests(9).use_t4 = true;

tests(10).label = 'Upper-Y flight fiber, no diffuser test #1';
tests(10).icool = [117:456]; %from 25:34 to 25:43
tests(10).iheat = [479:1588]; %from 25:43 to 25:58
tests(10).idark = [108]; %25:34
tests(10).ylim  = [98.5,101];
tests(10).daystr = '20150325';
tests(10).filepath = [dir tests(10).daystr filesep tests(10).daystr 'star.mat'];
tests(10).norm2diode = true;
tests(10).use_t4 = false;

tests(11).label = 'Upper-Y flight fiber, no diffuser test #2';
tests(11).icool = [1633:1939]; %from 25:34 to 25:43
tests(11).iheat = [1958:3351]; %from 25:43 to 25:58
tests(11).idark = [1950]; %25:34
tests(11).ylim  = [98.5,101];
tests(11).daystr = '20150325';
tests(11).filepath = [dir tests(11).daystr filesep tests(11).daystr 'star.mat'];
tests(11).norm2diode = true;
tests(11).use_t4 = false;

tests(12).label = 'Upper-Y flight fiber + sample diffuser';
tests(12).icool = [4025:4045]; %from 25:34 to 25:43
tests(12).iheat = [4053:4357]; %from 25:43 to 25:58
tests(12).idark = [4048]; %25:34
tests(12).ylim  = [98.5,101];
tests(12).daystr = '20150325';
tests(12).filepath = [dir tests(12).daystr filesep tests(12).daystr 'star.mat'];
tests(12).norm2diode = true;
tests(12).use_t4 = false;

tests(13).label = 'Upper-Y flight fiber + touching flight diffuser + gershun tube';
tests(13).icool = [801:1082]; %from 25:34 to 25:43
tests(13).iheat = [1684:2466]; %from 25:43 to 25:58
tests(13).idark = [1666]; %25:34
tests(13).ylim  = [98.5,101];
tests(13).daystr = '20150330';
tests(13).filepath = [dir tests(13).daystr filesep tests(13).daystr 'star.mat'];
tests(13).norm2diode = true;
tests(13).use_t4 = false;

tests(14).label = 'Upper-Y flight fiber + not touching flight diffuser + gershun tube';
tests(14).icool = [2617:2905]; %from 25:34 to 25:43
tests(14).iheat = [2929:3064]; %from 25:43 to 25:58
tests(14).idark = [2587]; %25:34
tests(14).ylim  = [98.5,101];
tests(14).daystr = '20150330';
tests(14).filepath = [dir tests(14).daystr filesep tests(14).daystr 'star.mat'];
tests(14).norm2diode = true;
tests(14).use_t4 = false;

tests(15).label = 'Upper-Y flight fiber +  touching flight diffuser + gershun tube';
tests(15).icool = [3186:3354]; %from 25:34 to 25:43
tests(15).iheat = [3495:4159]; %from 25:43 to 25:58
tests(15).idark = [3176]; %25:34
tests(15).ylim  = [98.5,101];
tests(15).daystr = '20150330';
tests(15).filepath = [dir tests(15).daystr filesep tests(15).daystr 'star.mat'];
tests(15).norm2diode = true;
tests(15).use_t4 = false;

%% Get wavelengths
[wv,wn] = starwavelengths();

[nul,i500] = min(abs(wv-0.500));
[nul,i650] = min(abs(wv-0.650));
[nul,i750] = min(abs(wv-0.750));
[nul,i850] = min(abs(wv-0.850));
[nul,i1200] = min(abs(wn-1.20));

%% run through each test and plot it
for i=1:length(tests);
    disp(['On test #' num2str(i) '/' num2str(length(tests))])
    %% load the file
    disp(['Loading file: ' tests(i).filepath])
    load(tests(i).filepath)
    %convert time to utc
    vis_park.utc = t2utch(vis_park.t);
    nir_park.utc = t2utch(nir_park.t);
    
    %% substract darks
    disp('Get counts')
    if tests(i).norm2diode
        diode_cts = abs(vis_park.Lat);
        diode_per_heat = diode_cts(tests(i).iheat)./diode_cts(tests(i).iheat(1));
        diode_per_cool = diode_cts(tests(i).icool)./diode_cts(tests(i).icool(1));
    else
        diode_per_heat = repmat(1.0,[length(tests(i).iheat),1]);
        diode_per_cool = repmat(1.0,[length(tests(i).icool),1]);
    end
    
    vis_cts_cool = vis_park.raw(tests(i).icool,:)*0.0; vis_cts_heat = vis_park.raw(tests(i).iheat,:)*0.0;
    nir_cts_cool = nir_park.raw(tests(i).icool,:)*0.0; nir_cts_heat = nir_park.raw(tests(i).iheat,:)*0.0;
    vis_per_cool = vis_cts_cool; vis_per_heat = vis_cts_heat; nir_per_cool = nir_cts_cool; nir_per_heat = nir_cts_heat;
    for j=1:length(tests(i).icool);
        vis_cts_cool(j,:) = vis_park.raw(tests(i).icool(j),:)-vis_park.raw(tests(i).idark,:);
        nir_cts_cool(j,:) = nir_park.raw(tests(i).icool(j),:)-nir_park.raw(tests(i).idark,:);
        vis_per_cool(j,:) = vis_cts_cool(j,:)./vis_cts_cool(1,:)*100.0./diode_per_cool(j);
        nir_per_cool(j,:) = nir_cts_cool(j,:)./nir_cts_cool(1,:)*100.0./diode_per_cool(j);
    end;
    for j=1:length(tests(i).iheat);
        vis_cts_heat(j,:) = (vis_park.raw(tests(i).iheat(j),:)-vis_park.raw(tests(i).idark,:));
        nir_cts_heat(j,:) = (nir_park.raw(tests(i).iheat(j),:)-nir_park.raw(tests(i).idark,:));
        vis_per_heat(j,:) = vis_cts_heat(j,:)./vis_cts_heat(1,:)*100.0./diode_per_heat(j);
        nir_per_heat(j,:) = nir_cts_heat(j,:)./nir_cts_heat(1,:)*100.0./diode_per_heat(j);
    end;
    
    %% Get temperatures
    disp('temps')
    if tests(i).use_t4
        vis_temp_heat = vis_park.RH(tests(i).iheat);
        vis_temp_cool = vis_park.RH(tests(i).icool);
        nir_temp_heat = nir_park.RH(tests(i).iheat);
        nir_temp_cool = nir_park.RH(tests(i).icool);
    else
        vis_temp_heat = vis_park.Tst(tests(i).iheat);
        vis_temp_cool = vis_park.Tst(tests(i).icool);
        nir_temp_heat = nir_park.Tst(tests(i).iheat);
        nir_temp_cool = nir_park.Tst(tests(i).icool);
    end
    
    %% Smooth and bin the data
    disp('smooth and bin')
    vis_temp_heat = smoothn(vis_temp_heat);
    vis_temp_cool = smoothn(vis_temp_cool);
    nir_temp_heat = smoothn(nir_temp_heat);
    nir_temp_cool = smoothn(nir_temp_cool);
    
    [tnum_heat,tcenter_heat] = hist(vis_temp_heat,50);
    [tnum_cool,tcenter_cool] = hist(vis_temp_cool,50);
    
    vis_per_heat_binned = repmat(NaN,[length(tcenter_heat),length(wv)]);
    vis_per_cool_binned = repmat(NaN,[length(tcenter_cool),length(wv)]);
    nir_per_heat_binned = repmat(NaN,[length(tcenter_heat),length(wn)]);
    nir_per_cool_binned = repmat(NaN,[length(tcenter_cool),length(wn)]);
    
    binnum_vis_heat = vis_per_heat_binned*NaN; binnum_vis_cool = vis_per_heat_binned*NaN; binstd_vis_heat = vis_per_heat_binned*NaN; binstd_vis_cool = vis_per_heat_binned*NaN;
    binnum_nir_heat = nir_per_heat_binned*NaN; binnum_nir_cool = nir_per_heat_binned*NaN; binstd_nir_heat = nir_per_heat_binned*NaN; binstd_nir_cool = nir_per_heat_binned*NaN;
    
    fit_vis_heat = repmat(NaN,[2,length(wv)]); fiter_vis_heat = fit_vis_heat;
    fit_vis_cool = repmat(NaN,[2,length(wv)]); fiter_vis_cool = fit_vis_cool;
    fit_nir_heat = repmat(NaN,[2,length(wn)]); fiter_nir_heat = fit_nir_heat;
    fit_nir_cool = repmat(NaN,[2,length(wn)]); fiter_nir_cool = fit_nir_cool;
    
    for v = 1:length(wv)
        vis_per_heat(:,v) = smoothn(vis_per_heat(:,v));
        vis_per_cool(:,v) = smoothn(vis_per_cool(:,v));
        [vis_per_heat_binned(:,v),binnum_vis_heat(:,v),binstd_vis_heat(:,v)] = bindata(vis_temp_heat,vis_per_heat(:,v),tcenter_heat);
        [vis_per_cool_binned(:,v),binnum_vis_cool(:,v),binstd_vis_cool(:,v)] = bindata(vis_temp_cool,vis_per_cool(:,v),tcenter_cool);
        [fit_vis_heat(:,v),fiter_vis_heat(:,v)] = linfitxy(tcenter_heat,vis_per_heat_binned(:,v),tcenter_heat*0.05,binstd_vis_heat(:,v),'Plotting',false,'Verbosity',0);
        [fit_vis_cool(:,v),fiter_vis_cool(:,v)] = linfitxy(tcenter_cool,vis_per_cool_binned(:,v),tcenter_cool*0.05,binstd_vis_cool(:,v),'Plotting',false,'Verbosity',0);
    end
    for w = 1:length(wn)
        nir_per_heat(:,w) = smoothn(nir_per_heat(:,w));
        nir_per_cool(:,w) = smoothn(nir_per_cool(:,w));
        [nir_per_heat_binned(:,w),binnum_nir_heat(:,w),binstd_nir_heat(:,w)] = bindata(nir_temp_heat,nir_per_heat(:,w),tcenter_heat);
        [nir_per_cool_binned(:,w),binnum_nir_cool(:,w),binstd_nir_cool(:,w)] = bindata(nir_temp_cool,nir_per_cool(:,w),tcenter_cool);
        [fit_nir_heat(:,w),fiter_nir_heat(:,w)] = linfitxy(tcenter_heat,nir_per_heat_binned(:,w),tcenter_heat*0.05,binstd_nir_heat(:,w),'Plotting',false,'Verbosity',0);
        [fit_nir_cool(:,w),fiter_nir_cool(:,w)] = linfitxy(tcenter_cool,nir_per_cool_binned(:,w),tcenter_cool*0.05,binstd_nir_cool(:,w),'Plotting',false,'Verbosity',0);
    end
    
    tests(i).heat.vt = vis_temp_heat;
    tests(i).cool.vt = vis_temp_cool;
    tests(i).heat.nt = nir_temp_heat;
    tests(i).cool.nt = nir_temp_cool;
    tests(i).heat.vp = vis_per_heat;
    tests(i).cool.vp = vis_per_cool;
    tests(i).heat.np = nir_per_heat;
    tests(i).cool.np = nir_per_cool;
    tests(i).heat.tc = tcenter_heat;
    tests(i).cool.tc = tcenter_cool;
    tests(i).heat.vpb = vis_per_heat_binned;
    tests(i).cool.vpb = vis_per_cool_binned;
    tests(i).heat.npb = nir_per_heat_binned;
    tests(i).cool.npb = nir_per_cool_binned;
    tests(i).heat.vfit = fit_vis_heat;
    tests(i).cool.vfit = fit_vis_cool;
    tests(i).heat.nfit = fit_nir_heat;
    tests(i).cool.nfit = fit_nir_cool;
    tests(i).heat.vfite = fiter_vis_heat;
    tests(i).cool.vfite = fiter_vis_cool;
    tests(i).heat.nfite = fiter_nir_heat;
    tests(i).cool.nfite = fiter_nir_cool;
    
end %tests

%% saving
disp(['Saving results to: ' dir 'Temp_testing'])
save([dir 'Temp_testing'],'tests','program_version','-mat');


%% Now plot the test result
disp('plotting...')
figure(10);

formstr = 'y = (%1.2f +/- %1.2f)X + (%1.2f +/- %1.2f)';

plot(tests(1).heat.tc,tests(1).heat.vpb(:,i500),'s','DisplayName',tests(1).label);
hold all;
clr = jet(length(tests));
for i=2:length(tests)
    plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(i,:),'DisplayName',tests(i).label);
    plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
        'Color',clr(i,:),...
        'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
end
legend(gca,'show')
title('Signal variations at 500 nm')
xlabel('Temperature [°C]')
ylabel('Percent of counts [%]')
save_fig(i,[dir 'combined_tests_500'],true);

%     %%%% new figure of spectral plots %%%%
%     if toggle.docontour;
%         figure(i+10);
%         for v = 1:length(wv); vh(:,v)=smooth(vis_per_heat(:,v),5); end;
%         perlevels = linspace(95,105,21);
%         suptitle(tests(i).label);
%
%         subplot(1,2,1);
%         contourf(wv,vis_park.Tst(tests(i).iheat),vh,perlevels,'edgecolor','none')
%         ylim([-10,20]);
%         ylabel('Temperature [°C]');
%         xlabel('Wavelength [\mum]');
%         title('Vis');
%         hh = colorbar;
%         ylabel(hh,'Percent change of counts [%]');
%
%         subplot(1,2,2);
%         for v = 1:length(wn); nh(:,v)=smooth(nir_per_heat(:,v),5); end
%         contourf(wn,nir_park.RH(tests(i).iheat),nh,perlevels,'edgecolor','none')
%         ylim([-10,20]);
%         % ylabel('Temperature [°C]');
%         xlabel('Wavelength [\mum]');
%         title('NIR');
%         hh = colorbar;
%         ylabel(hh,'Percent change of counts [%]');
%         save_fig(i+10,[dir daystr 'tests_' num2str(i) '_carpet'],false);
%         clear vh; clear nh;
%     end;
%
%     %%%% multispectral plots %%%%
%     figure(i+20);
%     plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i500),'b.');
%     hold on;
%     plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i650),'r.');
%     plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i750),'g.');
%     plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i850),'k.');
%
%     pheat500 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i500),1);
%     pheat650 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i650),1);
%     pheat750 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i750),1);
%     pheat850 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i850),1);
%
%     grid();
%     legend(['500 nm slope=' num2str(pheat500(1))],...
%     ['650 nm slope=' num2str(pheat650(1))],...
%     ['750 nm slope=' num2str(pheat750(1))],...
%     ['850 nm slope=' num2str(pheat850(1))]);
%     title('Vis');
%     xlabel('Temperature [°C]');
%     ylabel('Percent of counts normalized to photodiode [%]');
%     lsline();
%     save_fig(i+20,[dir daystr 'tests_' num2str(i) '_multispectral']);
%end;
%end
