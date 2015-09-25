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
% Modified (v1.1): By Samuel LeBlanc, NASA Ames, 2015-08-26
%           - changed some plotting for preparing the interim report
% Modified (v1.2): By Samuel LeBlanc, NASA Ames, 2015-09-16
%           - added most recent test of full head, with fiber backed off
%           from diffuser
%
% -------------------------------------------------------------------------
function plot_star_fiber_temp_test_all
version_set('v1.2')
clear;
toggle.make_new_save = false;
dir = 'C:\Users\sleblan2\Research\4STAR\roof\';

%% disable some warnings
warning('off','MATLAB:smoothn:SLowerBound');
warning('off','MATLAB:smoothn:SUpperBound');
warning('off','MATLAB:smoothn:MaxIter');
warning('off','warn:infiniteerr');

%% Get wavelengths
[wv,wn] = starwavelengths();

[nul,i500] = min(abs(wv-0.500));
[nul,i650] = min(abs(wv-0.650));
[nul,i750] = min(abs(wv-0.750));
[nul,i850] = min(abs(wv-0.850));
[nul,i1200] = min(abs(wn-1.20));

%% define new tests or use old ones.
if toggle.make_new_save
    % define the different limits of the tests
    tests(1).label = 'Prototype fiber - with connectors, no diffuser';
    tests(1).icool = [701:1026] ;
    tests(1).iheat = [1075:1821]; 
    tests(1).idark = [1042];
    tests(1).ylim  = [97.5,103.5];
    tests(1).daystr = '20150224';
    tests(1).filepath = [dir tests(1).daystr filesep tests(1).daystr 'star.mat'];
    tests(1).norm2diode = false;
    tests(1).use_t4 = false;
    
    tests(2).label = 'Prototype fiber - no connectors, no diffuser';
    tests(2).icool = [1887:2073]; 
    tests(2).iheat = [2406:3395]; 
    tests(2).idark = [1863]; 
    tests(2).ylim  = [98.5,102.5];
    tests(2).daystr = '20150224';
    tests(2).filepath = [dir tests(2).daystr filesep tests(2).daystr 'star.mat'];
    tests(2).norm2diode = false;
    tests(2).use_t4 = false;
    
    tests(3).label = 'Prototype fiber - jacketing cut, no diffuser';
    tests(3).icool = [6191:6459]; 
    tests(3).iheat = [6497:7187]; 
    tests(3).idark = [4100]; 
    tests(3).ylim  = [95.5,105.5];
    tests(3).daystr = '20150224';
    tests(3).filepath = [dir tests(3).daystr filesep tests(3).daystr 'star.mat'];
    tests(3).norm2diode = false;
    tests(3).use_t4 = false;
    
    tests(4).label = '800 micron fiber';
    tests(4).icool = [7460:7959]; 
    tests(4).iheat = [7982:8525]; 
    tests(4).idark = [7965];
    tests(4).ylim  = [80,115];
    tests(4).daystr = '20150224';
    tests(4).filepath = [dir tests(4).daystr filesep tests(4).daystr 'star.mat'];
    tests(4).norm2diode = false;
    tests(4).use_t4 = false;
    
    tests(5).label = '800 micron fiber, upper Y section room temp';
    tests(5).icool = [8549:8706]; 
    tests(5).iheat = [8727:9421]; 
    tests(5).idark = [8712]; 
    tests(5).ylim  = [80,115];
    tests(5).daystr = '20150224';
    tests(5).filepath = [dir tests(5).daystr filesep tests(5).daystr 'star.mat'];
    tests(5).norm2diode = false;
    tests(5).use_t4 = false;
    
    tests(6).label = '800 micron jacketing cut';
    tests(6).icool = [9452:9658]; 
    tests(6).iheat = [9695:9954]; 
    tests(6).idark = [9435]; 
    tests(6).ylim  = [98.5,101];
    tests(6).daystr = '20150224';
    tests(6).filepath = [dir tests(6).daystr filesep tests(6).daystr 'star.mat'];
    tests(6).norm2diode = false;
    tests(6).use_t4 = false;
    
    tests(7).label = 'Bare Fiber';
    tests(7).icool = [1070:1414]; 
    tests(7).iheat = [1493:2362];
    tests(7).idark = [1443]; 
    tests(7).ylim  = [98.5,101];
    tests(7).daystr = '20150225';
    tests(7).filepath = [dir tests(7).daystr filesep tests(7).daystr 'star.mat'];
    tests(7).norm2diode = false;
    tests(7).use_t4 = false;
    
    tests(8).label = 'Whole Head, with G10';
    tests(8).icool = [5075:5626]; 
    tests(8).iheat = [5745:7503]; 
    tests(8).idark = [5644]; 
    tests(8).ylim  = [98.5,101];
    tests(8).daystr = '20150304';
    tests(8).filepath = [dir tests(8).daystr filesep tests(8).daystr 'star.mat'];
    tests(8).norm2diode = false;
    tests(8).use_t4 = true;
    
    tests(9).label = 'Whole Head, test #2, more stable';
    tests(9).icool = [752:1780]; 
    tests(9).iheat = [2009:3421]; %used to be 1923:3421
    tests(9).idark = [1794];
    tests(9).ylim  = [98.5,101];
    tests(9).daystr = '20150305';
    tests(9).filepath = [dir tests(9).daystr filesep tests(9).daystr 'star.mat'];
    tests(9).norm2diode = true;
    tests(9).use_t4 = true;
    
    tests(10).label = 'Upper-Y flight fiber, no diffuser test #1';
    tests(10).icool = [117:456]; 
    tests(10).iheat = [479:1588];
    tests(10).idark = [108];
    tests(10).ylim  = [98.5,101];
    tests(10).daystr = '20150325';
    tests(10).filepath = [dir tests(10).daystr filesep tests(10).daystr 'star.mat'];
    tests(10).norm2diode = true;
    tests(10).use_t4 = false;
    
    tests(11).label = 'Upper-Y flight fiber, no diffuser test #2';
    tests(11).icool = [1633:1939]; 
    tests(11).iheat = [1958:3351]; 
    tests(11).idark = [1950]; 
    tests(11).ylim  = [98.5,101];
    tests(11).daystr = '20150325';
    tests(11).filepath = [dir tests(11).daystr filesep tests(11).daystr 'star.mat'];
    tests(11).norm2diode = true;
    tests(11).use_t4 = false;
    
    tests(12).label = 'Upper-Y flight fiber + sample diffuser';
    tests(12).icool = [4025:4045];
    tests(12).iheat = [4053:4357];
    tests(12).idark = [4048]; 
    tests(12).ylim  = [98.5,101];
    tests(12).daystr = '20150325';
    tests(12).filepath = [dir tests(12).daystr filesep tests(12).daystr 'star.mat'];
    tests(12).norm2diode = true;
    tests(12).use_t4 = false;
    
    tests(13).label = 'Upper-Y flight fiber + touching flight diffuser';
    tests(13).icool = [801:1082]; 
    tests(13).iheat = [1684:2466]; 
    tests(13).idark = [1666];
    tests(13).ylim  = [98.5,101];
    tests(13).daystr = '20150330';
    tests(13).filepath = [dir tests(13).daystr filesep tests(13).daystr 'star.mat'];
    tests(13).norm2diode = true;
    tests(13).use_t4 = false;
    
    tests(14).label = 'Upper-Y flight fiber + not touching flight diffuser ';
    tests(14).icool = [2617:2905]; 
    tests(14).iheat = [2929:3064]; 
    tests(14).idark = [2587];
    tests(14).ylim  = [98.5,101];
    tests(14).daystr = '20150330';
    tests(14).filepath = [dir tests(14).daystr filesep tests(14).daystr 'star.mat'];
    tests(14).norm2diode = true;
    tests(14).use_t4 = false;
    
    tests(15).label = 'Upper-Y flight fiber +  touching flight diffuser #2';
    tests(15).icool = [3186:3354]; 
    tests(15).iheat = [3495:4159];
    tests(15).idark = [3176];
    tests(15).ylim  = [98.5,101];
    tests(15).daystr = '20150330';
    tests(15).filepath = [dir tests(15).daystr filesep tests(15).daystr 'star.mat'];
    tests(15).norm2diode = true;
    tests(15).use_t4 = false;
    
    tests(16).label = 'SEAC4RS flight: 2013-08-08, 17:03-17:45';
    tests(16).icool = [4038:4851]; 
    tests(16).iheat = [[4944:4999],[5011:5384],[5406:5838],[5854:6316]]; 
    tests(16).idark = [4894]; 
    tests(16).ylim  = [98.5,101];
    tests(16).daystr = '20130808';
    tests(16).filepath = ['C:\Users\sleblan2\Research\4STAR\SEAC4RS\20130808star_for_temp_test.mat'];
    tests(16).norm2diode = false;
    tests(16).use_t4 = true;
    
    tests(17).label = 'SEAC4RS flight: 2013-08-16, 17:29-18:02';
    tests(17).icool = [14678:15220]; 
    tests(17).iheat = [[14674:15664],[15675:16380]];
    tests(17).idark = [14668]; 
    tests(17).ylim  = [98.5,101];
    tests(17).daystr = '20130816';
    tests(17).filepath = ['C:\Users\sleblan2\Research\4STAR\SEAC4RS\20130816star_for_temp_test.mat'];
    tests(17).norm2diode = false;
    tests(17).use_t4 = true;
    
    tests(18).label = 'MLO cal vs. AATS, 2013-07-08';
    tests(18).icool = [2:10]; 
    tests(18).iheat = [10:13920]; 
    tests(18).idark = [1]; 
    tests(18).ylim  = [98.5,101];
    tests(18).daystr = '20130708';
    tests(18).filepath = ['C:\Users\sleblan2\Research\4STAR\roof\20130708\20130708star_for_temp_test.mat'];
    tests(18).norm2diode = false;
    tests(18).use_t4 = true;
    
    tests(19).label = 'Proto-head + diffuser vs. AATS, 2015-01-13';
    tests(19).icool = [2:10]; 
    tests(19).iheat = [10:7071]; 
    tests(19).idark = [1]; 
    tests(19).ylim  = [98.5,101];
    tests(19).daystr = '20150113';
    tests(19).filepath = ['C:\Users\sleblan2\Research\4STAR\roof\20150113\20150113star_for_temp_test.mat'];
    tests(19).norm2diode = false;
    tests(19).use_t4 = false;
    
    tests(20).label = 'Proto-head + temp-stable diff. vs. AATS, 2015-01-14';
    tests(20).icool = [2:10]; 
    tests(20).iheat = [570:7066]; 
    tests(20).idark = [1]; 
    tests(20).ylim  = [98.5,101];
    tests(20).daystr = '20150114';
    tests(20).filepath = ['C:\Users\sleblan2\Research\4STAR\roof\20150114\20150114star_for_temp_test.mat'];
    tests(20).norm2diode = false;
    tests(20).use_t4 = false;
    
    tests(21).label = 'Head - backed off diffuser - NAAMES 2015 configuration';
    tests(21).icool = [7806:9825]; 
    tests(21).iheat = [9989:14320]; 
    tests(21).idark = [9891]; 
    tests(21).ylim  = [98.5,101];
    tests(21).daystr = '20150911';
    tests(21).filepath = ['C:\Users\sleblan2\Research\4STAR\roof\20150911_HeadTempTest\20150911star.mat'];
    tests(21).norm2diode = false;
    tests(21).use_t4 = true;
    
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
        disp('...Get counts')
        if tests(i).norm2diode  %Use the diode voltage that is saved to the Lat field, for testing.
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
        disp('...temps')
        if tests(i).use_t4 %set to use the t4 temperature which is saved in the RH field for testing.
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
        disp('...smooth and bin')
        theat_err = std(vis_temp_heat);
        tcool_err = std(vis_temp_cool);
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
            if v == i500 | v == i650 | v == i750 | v == i850
                [fit_vis_heat(:,v),fiter_vis_heat(:,v)] = linfitxy(tcenter_heat,vis_per_heat_binned(:,v),theat_err,binstd_vis_heat(:,v),'Plotting',false,'Verbosity',0);
                %[fit_vis_cool(:,v),fiter_vis_cool(:,v)] = linfitxy(tcenter_cool,vis_per_cool_binned(:,v),tcool_err,binstd_vis_cool(:,v),'Plotting',false,'Verbosity',0);
            end
        end
        for w = 1:length(wn)
            nir_per_heat(:,w) = smoothn(nir_per_heat(:,w));
            nir_per_cool(:,w) = smoothn(nir_per_cool(:,w));
            [nir_per_heat_binned(:,w),binnum_nir_heat(:,w),binstd_nir_heat(:,w)] = bindata(nir_temp_heat,nir_per_heat(:,w),tcenter_heat);
            [nir_per_cool_binned(:,w),binnum_nir_cool(:,w),binstd_nir_cool(:,w)] = bindata(nir_temp_cool,nir_per_cool(:,w),tcenter_cool);
            if w == i1200
                [fit_nir_heat(:,w),fiter_nir_heat(:,w)] = linfitxy(tcenter_heat,nir_per_heat_binned(:,w),theat_err,binstd_nir_heat(:,w),'Plotting',false,'Verbosity',0);
                %[fit_nir_cool(:,w),fiter_nir_cool(:,w)] = linfitxy(tcenter_cool,nir_per_cool_binned(:,w),tcool_err,binstd_nir_cool(:,w),'Plotting',false,'Verbosity',0);
            end
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
    disp(['Saving results to: ' dir 'Temp_testing.mat'])
    save([dir 'Temp_testing.mat'],'tests','program_version');
else
    %% loading
    disp(['Loading file: ' dir 'Temp_testing.mat'])
    load([dir 'Temp_testing.mat']);
end
%% Now plot the test result
disp('plotting...')
figure(10);
set(gcf,'Position',[100,50,1750,950]);

formstr = 'y = (%1.3f +/- %1.3f)X + (%1.3f +/- %1.3f)';
i = 1;
clr = hsv(length(tests));
plot(tests(1).heat.tc,tests(1).heat.vpb(:,i500),'s','Color',clr(i,:),'DisplayName',tests(1).label);
hold all;
plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
    'Color',clr(i,:),...
    'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
for i=2:length(tests)
    plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(i,:),'DisplayName',tests(i).label);
    plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
        'Color',clr(i,:),...
        'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
end
grid on;
legend(gca,'show','Location','NorthEastOutside')
title('Signal variations at 500 nm')
xlabel('Temperature [°C]')
ylabel('Percent of counts [%]')
hold off;
save_fig(10,[dir 'combined_tests_500'],true);

%% Plotting only subset
figure(11);
set(gcf,'Position',[100,50,1550,950]);
sub = [8,9,11,13,14,16,17,18,19];
i = 7;
clr = hsv(length(tests));
plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(i,:),'DisplayName',tests(i).label);
hold all;
plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
    'Color',clr(i,:),...
    'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
for i=2:length(tests)
    if ismember(i,sub)
        plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(i,:),'DisplayName',tests(i).label);
        plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
            'Color',clr(i,:),...
            'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
    end
end
grid on;
legend(gca,'show','Location','NorthEastOutside')
title('Signal variations at 500 nm')
xlabel('Temperature [°C]')
ylabel('Percent of counts [%]')
hold off;
save_fig(11,[dir 'combined_tests_subset_500'],true);

%% Plotting only sub-subset
figure(12);
set(gcf,'Position',[100,50,1550,950]);
sub = [13,14,16,17,18,19,21];
i = 13;
j = 1;
clr = hsv(length(sub));
plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(j,:),'DisplayName',tests(i).label);
hold all;
plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
    'Color',clr(j,:),...
    'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
for i=14:length(tests)
    if ismember(i,sub)
        j = j+1;
        if i==19;
            tests(i).heat.vpb(:,i500) = tests(i).heat.vpb(:,i500)./tests(i).heat.vpb(1,i500)*100.0;
            tests(i).heat.vfit(2,i500) = tests(i).heat.vfit(2,i500)-11.0;
        end;
        plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(j,:),'DisplayName',tests(i).label);
        plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
            'Color',clr(j,:),...
            'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
    end
end
grid on;
legend(gca,'show','Location','NorthEastOutside')
title('Signal variations at 500 nm')
xlabel('Temperature [°C]')
ylabel('Percent of counts [%]')
hold off;
save_fig(12,[dir 'combined_tests_subsubset_500'],true);

%% Plotting only sub-subset
if false;
figure(13);
set(gcf,'Position',[100,50,1550,950]);
sub = [3,4,6];
i = 1;
j = 1;
clr = hsv(length(sub)+1);
plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(j,:),'DisplayName',tests(i).label);
hold all;
plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
    'Color',clr(j,:),...
    'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
for i=1:length(tests)
    if ismember(i,sub)
        j = j+1;
        if i==19;
            tests(i).heat.vpb(:,i500) = tests(i).heat.vpb(:,i500)./tests(i).heat.vpb(1,i500)*100.0;
            tests(i).heat.vfit(2,i500) = tests(i).heat.vfit(2,i500)-11.0;
        end;
        plot(tests(i).heat.tc,tests(i).heat.vpb(:,i500),'s','Color',clr(j,:),'DisplayName',tests(i).label);
        plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i500)+tests(i).heat.vfit(2,i500),...
            'Color',clr(j,:),...
            'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i500),tests(i).heat.vfite(1,i500),tests(i).heat.vfit(2,i500),tests(i).heat.vfite(2,i500)));
    end
end
grid on;
legend(gca,'show','Location','NorthEastOutside')
title('Signal variations at 500 nm')
xlabel('Temperature [°C]')
ylabel('Percent of counts [%]')
hold off;
save_fig(13,[dir 'combined_tests_microbending_500'],true);
end;

%% now for 850 nm

figure(20);
set(gcf,'Position',[100,50,1550,950]);

formstr = 'y = (%1.3f +/- %1.3f)X + (%1.3f +/- %1.3f)';
i = 1;
clr = hsv(length(tests));
plot(tests(1).heat.tc,tests(1).heat.vpb(:,i850),'s','Color',clr(i,:),'DisplayName',tests(1).label);
hold all;
plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i850)+tests(i).heat.vfit(2,i850),...
    'Color',clr(i,:),...
    'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i850),tests(i).heat.vfite(1,i850),tests(i).heat.vfit(2,i850),tests(i).heat.vfite(2,i850)));
for i=2:length(tests)
    plot(tests(i).heat.tc,tests(i).heat.vpb(:,i850),'s','Color',clr(i,:),'DisplayName',tests(i).label);
    plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i850)+tests(i).heat.vfit(2,i850),...
        'Color',clr(i,:),...
        'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i850),tests(i).heat.vfite(1,i850),tests(i).heat.vfit(2,i850),tests(i).heat.vfite(2,i850)));
end
grid on;
legend(gca,'show','Location','NorthEastOutside')
title('Signal variations at 850 nm')
xlabel('Temperature [°C]')
ylabel('Percent of counts [%]')
hold off;
save_fig(20,[dir 'combined_tests_850'],true);

%% Plotting only subset
figure(21);
set(gcf,'Position',[100,50,1550,950]);
i = 7;
clr = hsv(length(tests));
plot(tests(i).heat.tc,tests(i).heat.vpb(:,i850),'s','Color',clr(i,:),'DisplayName',tests(i).label);
hold all;
plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i850)+tests(i).heat.vfit(2,i850),...
    'Color',clr(i,:),...
    'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i850),tests(i).heat.vfite(1,i850),tests(i).heat.vfit(2,i850),tests(i).heat.vfite(2,i850)));
for i=2:length(tests)
    if ismember(i,sub)
        plot(tests(i).heat.tc,tests(i).heat.vpb(:,i850),'s','Color',clr(i,:),'DisplayName',tests(i).label);
        plot(tests(i).heat.tc,tests(i).heat.tc*tests(i).heat.vfit(1,i850)+tests(i).heat.vfit(2,i850),...
            'Color',clr(i,:),...
            'DisplayName',sprintf(formstr,tests(i).heat.vfit(1,i850),tests(i).heat.vfite(1,i850),tests(i).heat.vfit(2,i850),tests(i).heat.vfite(2,i850)));
    end
end
grid on;
legend(gca,'show','Location','NorthEastOutside')
title('Signal variations at 850 nm')
xlabel('Temperature [°C]')
ylabel('Percent of counts [%]')
hold off;
save_fig(21,[dir 'combined_tests_subset_850'],true);
end