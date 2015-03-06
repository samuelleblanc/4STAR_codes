%% Details of the program:
% NAME:
%   plot_star_fiber_temp_test2
%
% PURPOSE:
%  quick and dirty program to plot results from tep check on fiber optics
%  For 2nd day!
%
% CALLING SEQUENCE:
%   plot_star_fiber_temp_test
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
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, February 24th, 2015
% Modified:
%
% -------------------------------------------------------------------------
%function plot_star_fiber_temp_test
%version_set('v1.0')
clear;

dir = 'C:\Users\sleblan2\Research\4STAR\roof\20150225\';
daystr = '20150225';

load([dir daystr 'star.mat']);

%convert time to utc
vis_park.utc = t2utch(vis_park.t);
nir_park.utc = t2utch(nir_park.t);

% define the different limits of the tests
tests(1).label = 'Bare Fiber';
tests(1).icool = [1070:1414]; %from 19:46 to 19:52 
tests(1).iheat = [1493:2362]; %from 19:52 to 20:21
tests(1).idark = [1443];  %19:52
tests(1).ylim  = [97.5,103.5];

% tests(2).label = 'Only Fiber, no connector';
% tests(2).icool = [1887:2073]; %from 20:26 to 20:44 
% tests(2).iheat = [2406:3395]; %from 20:46 to 21:24
% tests(2).idark = [1863]; % 20:25
% tests(2).ylim  = [98.5,102.5];
% 
% tests(3).label = 'Only Fiber, no connector #2';
% tests(3).icool = [3460:4077]; %from 21:24 to 21:44
% tests(3).iheat = [[4120:4350],[4380:4408],[4442:5979]]; %from 21:50 to 22:36, missing data points because of small spectro issue
% tests(3).idark = [4100]; %21:24
% tests(3).ylim  = [98.5,102.5];
% 
% tests(4).label = 'Fiber jacketing cut, no connector';
% tests(4).icool = [6191:6459]; %from 22:57 to 23:08
% tests(4).iheat = [6497:7187]; %from 23:09 to 23:35
% tests(4).idark = [4100]; %6475]; %23:09
% tests(4).ylim  = [98.5,102.5];
% 
% tests(5).label = 'Fiber #2 (800 micron)';
% tests(5).icool = [7460:7959]; %from 24:03 to 24:23
% tests(5).iheat = [7982:8525]; %from 24:24 to 24:43
% tests(5).idark = [7965]; %24:23
% tests(5).ylim  = [80,115];
% 
% tests(6).label = 'Fiber #2 (800 micron), aluminium and upper Y section out';
% tests(6).icool = [8549:8706]; %from 24:49 to 24:56
% tests(6).iheat = [8727:9421]; %from 24:57 to 25:20
% tests(6).idark = [8712]; %24:57
% tests(6).ylim  = [80,115];
% 
% tests(7).label = {'Fiber #2 (800 micron) jacketing cut,','aluminium and upper Y section out'};
% tests(7).icool = [9452:9658]; %from 25:34 to 25:43
% tests(7).iheat = [9695:9954]; %from 25:43 to 25:58
% tests(7).idark = [9435]; %25:34
% tests(7).ylim  = [98.5,101];

[wv,wn] = starwavelengths();

[nul,i500] = min(abs(wv-0.500));
[nul,i1200] = min(abs(wn-1.20));

%run through each test and plot it
for i=1:length(tests);
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
        vis_cts_heat(j,:) = vis_park.raw(tests(i).iheat(j),:)-vis_park.raw(tests(i).idark,:);
        nir_cts_heat(j,:) = nir_park.raw(tests(i).iheat(j),:)-nir_park.raw(tests(i).idark,:);
        vis_per_heat(j,:) = vis_cts_heat(j,:)./vis_cts_heat(1,:)*100.0;
        nir_per_heat(j,:) = nir_cts_heat(j,:)./nir_cts_heat(1,:)*100.0;
    end;

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
    ylabel('Percent of counts [%]');
    ylim(tests(i).ylim);
    lsline();
    text(0.0,99.0,['slope=' num2str(pcool(1))],'color','blue');
    text(-35.0,99.0,['slope=' num2str(pheat(1))],'color','red');
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
    ylabel('Percent of counts [%]');
    ylim(tests(i).ylim);
    lsline();
    text(0.0,99.5,['slope=' num2str(pcooln(1))],'color','blue');
    text(-35.0,99.5,['slope=' num2str(pheatn(1))],'color','red');
    legend('Cooling','Heating')
    
    save_fig(i,[dir daystr 'tests_' num2str(i)],true);
    
    %%%% new figure of spectral plots %%%%
    figure(i+10);
    for v = 1:length(wv); vh(:,v)=smooth(vis_per_heat(:,v),5); end;
    perlevels = linspace(95,105,21);    
    suptitle(tests(i).label);
 
    subplot(1,2,1);
    contourf(wv,vis_park.Tst(tests(i).iheat),vh,perlevels,'edgecolor','none')
    ylim([-30,20]);
    ylabel('Temperature [°C]');
    xlabel('Wavelength [\mum]');
    title('Vis');
    hh = colorbar;
    ylabel(hh,'Percent change of counts [%]');
   
    subplot(1,2,2);
    for v = 1:length(wn); nh(:,v)=smooth(nir_per_heat(:,v),5); end
    contourf(wn,nir_park.Tst(tests(i).iheat),nh,perlevels,'edgecolor','none')
    ylim([-30,20]);
   % ylabel('Temperature [°C]');
    xlabel('Wavelength [\mum]');
    title('NIR');
    hh = colorbar;
    ylabel(hh,'Percent change of counts [%]');
    save_fig(i+10,[dir daystr 'tests_' num2str(i) '_carpet'],false);    
    clear vh; clear nh;
    
end;
%end
