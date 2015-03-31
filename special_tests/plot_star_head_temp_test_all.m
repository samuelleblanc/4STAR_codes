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
%function plot_star_fiber_temp_test_all
%version_set('v1.0')
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
    % load the file
    load(tests(i).filepath)
    %convert time to utc
    vis_park.utc = t2utch(vis_park.t);
    nir_park.utc = t2utch(nir_park.t);
    
    % substract darks
    vis_cts_cool = vis_park.raw(tests(i).icool,:)*0.0; vis_cts_heat = vis_park.raw(tests(i).iheat,:)*0.0;
    nir_cts_cool = nir_park.raw(tests(i).icool,:)*0.0; nir_cts_heat = nir_park.raw(tests(i).iheat,:)*0.0;
    vis_per_cool = vis_cts_cool; vis_per_heat = vis_cts_heat; nir_per_cool = nir_cts_cool; nir_per_heat = nir_cts_heat;
    for j=1:length(tests(i).icool);
        vis_cts_cool(j,:) = vis_park.raw(tests(i).icool(j),:)-vis_park.raw(tests(i).idark,:);
        nir_cts_cool(j,:) = nir_park.raw(tests(i).icool(j),:)-nir_park.raw(tests(i).idark,:);
        vis_per_cool(j,:) = vis_cts_cool(j,:)./vis_cts_cool(1,:)*100.0;
        nir_per_cool(j,:) = nir_cts_cool(j,:)./nir_cts_cool(1,:)*100.0;
    end;
    for j=1:length(tests(i).iheat);
        vis_cts_heat(j,:) = (vis_park.raw(tests(i).iheat(j),:)-vis_park.raw(tests(i).idark,:))/vis_park.Alt(tests(i).iheat(j))*-1.0;
        nir_cts_heat(j,:) = (nir_park.raw(tests(i).iheat(j),:)-nir_park.raw(tests(i).idark,:))/nir_park.Alt(tests(i).iheat(j))*-1.0;
        vis_per_heat(j,:) = vis_cts_heat(j,:)./vis_cts_heat(1,:)*100.0;
        nir_per_heat(j,:) = nir_cts_heat(j,:)./nir_cts_heat(1,:)*100.0;
    end;
    
    if tests(i).norm2diode
        diode_cts = abs(vis_park.Lat);
        diode_per_heat = diode_cts(tests(i).iheat)./diode_cts(tests(i).iheat(1));
        diode_per_cool = diode_cts(tests(i).icool)./diode_cts(tests(i).icool(1));
        vis_per_heat = vis_per_heat./diode_per_heat;
        nir_per_heat = nir_per_heat./diode_per_heat;
        vis_per_cool = vis_per_cool./diode_per_cool;
        nir_per_cool = nir_per_cool./diode_per_cool;
    end
    
    %% Get temperatures
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
    
    %% Smooth the data
    for v = 1:length(wv)
        vis_per_heat(:,v) = smoothn(vis_per_heat(:,v));
        vis_per_cool(:,v) = smoothn(vis_per_cool(:,v));
    end
    for w = 1:length(wn)
        nir_per_heat(:,w) = smoothn(nir_per_heat(:,w));
        nir_per_cool(:,w) = smoothn(nir_per_cool(:,w));
    end
    
    vis_temp_heat = smoothn(vis_temp_heat);
    vis_temp_cool = smoothn(vis_temp_cool);
    nir_temp_heat = smoothn(nir_temp_heat);
    nir_temp_cool = smoothn(nir_temp_cool);
    
    %% Bin to remove sampling issues
    
    
    
    
    
    figure(i);
    subplot(2,1,1);
    plot(vis_park.Tst(tests(i).icool),vis_per_cool(:,i500),'b.');
    pcool = polyfit(vis_park.Tst(tests(i).icool),vis_per_cool(:,i500),1);
    hold on;
    plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i500),'r+');
    pheat = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i500),1);
    grid();
    title('Vis at 500 nm');
    xlabel('Temperature [°C]');
    ylabel('Percent of counts  normalized to photodiode [%]');
    ylim(tests(i).ylim);
    lsline();
    text(5.0,99.0,['slope=' num2str(pcool(1))],'color','blue');
    text(25.0,99.0,['slope=' num2str(pheat(1))],'color','red');
    suptitle(tests(i).label);
    
    subplot(2,1,2);
    plot(nir_park.Tst(tests(i).icool),nir_per_cool(:,i1200),'b.');
    pcooln = polyfit(nir_park.Tst(tests(i).icool),nir_per_cool(:,i1200),1);
    hold on;
    plot(nir_park.Tst(tests(i).iheat),nir_per_heat(:,i1200),'r+');
    pheatn = polyfit(nir_park.Tst(tests(i).iheat),nir_per_heat(:,i1200),1);
    grid();
    title('Nir at 1200 nm');
    xlabel('Temperature [°C]');
    ylabel('Percent of counts normalized to photodiode [%]');
    ylim(tests(i).ylim);
    lsline();
    text(5.0,99.5,['slope=' num2str(pcooln(1))],'color','blue');
    text(25.0,99.5,['slope=' num2str(pheatn(1))],'color','red');
    legend('Cooling','Heating')
    
    save_fig(i,[dir daystr 'tests_' num2str(i)],true);
    
    %%%% new figure of spectral plots %%%%
    if toggle.docontour;
        figure(i+10);
        for v = 1:length(wv); vh(:,v)=smooth(vis_per_heat(:,v),5); end;
        perlevels = linspace(95,105,21);
        suptitle(tests(i).label);
        
        subplot(1,2,1);
        contourf(wv,vis_park.Tst(tests(i).iheat),vh,perlevels,'edgecolor','none')
        ylim([-10,20]);
        ylabel('Temperature [°C]');
        xlabel('Wavelength [\mum]');
        title('Vis');
        hh = colorbar;
        ylabel(hh,'Percent change of counts [%]');
        
        subplot(1,2,2);
        for v = 1:length(wn); nh(:,v)=smooth(nir_per_heat(:,v),5); end
        contourf(wn,nir_park.RH(tests(i).iheat),nh,perlevels,'edgecolor','none')
        ylim([-10,20]);
        % ylabel('Temperature [°C]');
        xlabel('Wavelength [\mum]');
        title('NIR');
        hh = colorbar;
        ylabel(hh,'Percent change of counts [%]');
        save_fig(i+10,[dir daystr 'tests_' num2str(i) '_carpet'],false);
        clear vh; clear nh;
    end;
    
    %%%% multispectral plots %%%%
    figure(i+20);
    plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i500),'b.');
    hold on;
    plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i650),'r.');
    plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i750),'g.');
    plot(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i850),'k.');
    
    pheat500 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i500),1);
    pheat650 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i650),1);
    pheat750 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i750),1);
    pheat850 = polyfit(vis_park.Tst(tests(i).iheat),vis_per_heat(:,i850),1);
    
    grid();
    legend(['500 nm slope=' num2str(pheat500(1))],...
    ['650 nm slope=' num2str(pheat650(1))],...
    ['750 nm slope=' num2str(pheat750(1))],...
    ['850 nm slope=' num2str(pheat850(1))]);
    title('Vis');
    xlabel('Temperature [°C]');
    ylabel('Percent of counts normalized to photodiode [%]');
    lsline();
    save_fig(i+20,[dir daystr 'tests_' num2str(i) '_multispectral']);
end;
%end
