%% Details of the program:
% PURPOSE:
%  Codes to calculate the c0 from high altitude spectra
%  Uses predefined startospheric AOD spectrum
%  For the ORACLES 2018 data
%
% INPUT:
%  none - script
%
% OUTPUT:
%  plots and c0 files
%
% DEPENDENCIES:
%  - version_set.m
%  - starsavec0
%  - save_fig
%  - ...
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%  - starinfo for the flight with the flagfile defined 
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2017-05-22
% Modified (v1.1): By Samuel LeBlanc, in between Accra and Addis Ababa, 2017-08-24
%                  ported from ORACLES 2016 calibrations. Using the polyfit
%                  aod from the aod measurements in certain wavelengths.
% Modified (v1.2): By Samuel LeBlanc, Santa Cruz, CA, 2018-04-13
%                  Added information from the Bonanza AERONET station
%                  during 2017 for interpolation
% Modified (v2.0): By Samuel LeBlanc, NASA Ames Research Center, 2019-04-29
%                  Ported from 2017
%                  Changed reference spectra to El Farafa and Ragged Point
% -------------------------------------------------------------------------
%close all
clear all

version_set('2.0');
fp = getnamedpath('ORACLES_2018')
%if ~isunix;
%    fp = 'C:\Users\sleblanc\Research\ORACLES\data_2017\';
%else;
%    fp = '/nobackup/sleblan2/ORACLES/data_2017/';
%end;
%% set day info
daystr = '20180921';
%daystr = '20181007';
%daystr = '20181015';
daystr = '20181003'

%% Set properties
do_polyfit = false;

%wl = [340.,   380.,   440.,   500.,   675.,   870.,  1020.,  1640.];
%aod = [0.01341534,  0.01563484,  0.01673158,  0.01320213,  0.00794751,...
%       0.00896252,  0.00709206,  0.00568186]; % MLO high alt values in september
   
%wl =  [1640.   ,1020.   ,870.    ,675.    ,500.    ,440.    ,380.    ,340.    ,300.];
%aod = [0.004104,0.011504,0.009940,0.010834,0.016625,0.020482,0.036209,0.038874,0.040].*0.85; %Bonanza value at lowest AOD in August 5th, 2016 (altitude at 1382 m near Namibia)

% Bonanza AERONET lowest AOD in May, 29th, 2017 (Altitude at 1382m near Namibia)
% wl = [1639.3, 1019.2, 869.4, 674.5,500.8,439.3,380.4];
% aod = [0.004255, 0.009498, 0.012748,0.015987,0.019789,0.022428,0.026261];
% aod1 = [0.005255,0.015498,0.012748,0.015987,0.018789,0.016928,0.024261];
% aod2 = [0.005343,0.015398,0.013256,0.016453,0.019224,0.017603,0.024781];
% aod3 = [0.005408,0.015505,0.013670,0.016772,0.019318,0.017669,0.025454];
% aod4 = [0.005567,0.014730,0.013359,0.016331,0.019271,0.016880,0.026168];
% aod5 = [0.005576,0.015176,0.013370,0.016668,0.019338,0.016688,0.026568];
% aod6 = [0.005953,0.016694,0.013924,0.016957,0.019399,0.016852,0.027548];

% St-Helena AERONET lowest AOD in December 2nd, 2017, (Altitude 1381m West of Namibia)
%wl = [];
%aod = [];

% El Farafa AERONET Lowest AOD in Jan. 2nd, 2018 (92 m, 27.058N, 27.99E)
%wl = [1640., 1020.0, 870.0, 675.0, 500.0,440.0,380.0,340.0];
%aod = [0.010675,0.013395,0.014967,0.016125,0.024037,0.027803,0.03664,0.043148];

%wl = [451.7,470.2,500.7,520,530.3,532.0,550.3,605.5,660.1,780.6,864.6,1019.9,1064.2,1235.8,1558.7,1626.6,1650.1];
iwl = [347, 370,  408,  432,445,  447,  470,  539,  608,  761,  869,  1084,  1109,  1213,  1439,  1492,  1511];
if isequal(daystr,'20180921');
    % Ragged Point, Barbados, AERONET, Lowest AOD in September 23rd, 2018
    site = 'RaggedPoint';
    wl = [1640.,     1020.0,   870.0,    675.0,    500.0,    440.0,    380.0,   340.0];
    aod = [0.0354276,0.0391504,0.0400586,0.0431784,0.05328,0.055071,0.0643618,0.072006];
    aod = aod-0.03;
elseif isequal(daystr, '20181007');
    % El Farafa AERONET Lowest AOD in Jan. 2nd, 2018 (92 m, 27.058N, 27.99E)
    site = 'ElFarafa';
wl = [1640., 1020.0, 870.0, 675.0, 500.0,440.0,380.0,340.0];
aod = [0.010675,0.013395,0.014967,0.016125,0.024037,0.027803,0.03664,0.043148];
    aod(end) = aod(end)+0.008; % for low wavelength shape
    aod(3) = aod(3)+0.004;
    aod(4:8) = aod(4:8)+0.009; % for some window deposition
    aod = aod +0.009; % for some window deposition
    aod(6:8) = aod(6:8)+0.007;
    aod(1) = aod(1) - 0.003;
    
elseif isequal(daystr,'20181015');
    site = 'ElFarafa';
    % El Farafa AERONET Lowest AOD in Jan. 2nd, 2018 (92 m, 27.058N, 27.99E)
wl = [1640., 1020.0, 870.0, 675.0, 500.0,440.0,380.0,340.0];
aod = [0.010675,0.013395,0.014967,0.016125,0.024037,0.027803,0.03664,0.043148];
    aod = aod+0.010; % to account for some window deposition
    aod(6:8) = aod(6:8)+0.005;
    aod(4:8) = aod(4:8)+0.003; % for some window deposition
    aod(1) = aod(1) - 0.003;
elseif isequal(daystr,'20181003');
    site = 'Misamfu';
    % Misamfu AERONET Lowest AOD in Dec. 19th, 2018 (1381 m, 10.1712S, 31.2241E)
wl = [1640.,    1020.0,   870.0,   675.0,   500.0,   440.0,   380.0,   340.0];
aod = [0.004058,0.014006,0.0184973,0.0215423,0.03315,0.035411,0.04032,0.064329];
    aod = (aod+0.01).*1.3; %for window deposition
end;

%% load file starsun
source=['4STAR_' daystr 'starsun.mat'];
file=fullfile(fp, source);

load(file, 't', 'w', 'rateaero', 'm_aero','AZstep','Lat','Lon','Tst','tau_aero','tau_aero_noscreening');
AZ_deg_   = AZstep/(-50);
AZ_deg    = mod(AZ_deg_,360); AZ_deg = round(AZ_deg);

%% load starinfo file information
starinfofile=fullfile(starpaths, ['starinfo_' daystr(1:8) '.m']);
starinfofile_=['starinfo_' daystr(1:8)];
s.dummy = '';
try;
    try;
        infofnt = str2func(starinfofile_);
        try;
            s = infofnt(s);
            high_alt_c0 = s.high_alt_c0;
        catch;
            eval([starinfofile_,'(s)']);
            high_alt_c0 = s.high_alt_c0;
        end;
    catch;
        edit(starinfofile)
        error('No high_alt_c0 time defined in starinfo file')
    end;
catch;
    s0=importdata(starinfofile);
    %s1=s(strmatch('langley',s));
    s1=s0(strncmp('high_alt_c0',s0,1));
    eval(s1{:});
end;
ok=incl(t,high_alt_c0);

if do_polyfit; 
    %% get the aods from 4STAR high alt polyfit reconstruction
    [a2,a1,a0,ang,curvature]=polyfitaod(w(iwl).*1000.0,nanmean(tau_aero(ok,iwl)));
    aods = exp(polyval([a2,a1,a0],log(w.*1000.0)));

else
    %% interpolate the AERONET aods
    aods = interp1(wl,aod,w.*1000.0,'pchip');
    aodp = exp(polyval(polyfit(log(wl),log(aod),2),log(w.*1000.0)));
    aods = aodp;
end;
aodp = exp(polyval(polyfit(log(wl),log(aod),2),log(w.*1000.0)));

%% get the average rateaero 'c'
rate = nanmean(rateaero(ok,:));
rate_std = nanstd(rateaero(ok,:));

%% calculate the appropriate c0 to reproduce the aods
c0 = rate./exp(-1.0.*aods.*nanmean(m_aero(ok)));
c0_std = rate_std./exp(-1.0.*aods.*nanmean(m_aero(ok)));
vis_c0 = c0(1:1044);
nir_c0 = c0(1045:end);
visc0_std = c0_std(1:1044);
nirc0_std = c0_std(1045:end);

%% Plot the AODs and the comparison aods
figure;
plot(w*1000.0,nanmean(tau_aero(ok,:)),'.');
hold on;
plot(w(iwl)*1000.0,nanmean(tau_aero(ok,iwl)),'x');
plot(w*1000.0,aods,'--');
plot(wl,aod,'-+');
plot(w*1000.0,aodp,'o');
title([daystr ' - ' site])
xlabel('Wavelength [nm]')
ylabel('AOD')
ylim([-0.001,0.07])
legend('Original 4STAR AOD','selected 4STAR AOD','Polyfit 4STAR AOD','AERONET AOD','Fitted AERONET AOD')


%% Prepare for saving c0 file
if do_polyfit;
    filesuffix='refined_high_alt_low_m_frompolyfit'; %_loglogquad';
    additionalnotes={'Using a high altitude AOD spectra, which has been polyfit to extrapolate to problematic wavelengths, calculating the c0 from the AOD at low airmass. '};
else;
    filesuffix=['refined_high_alt_low_m_frompolyfit_' site]; %_loglogquad';
    additionalnotes={['Using a high altitude AOD spectra from ' site ' AERONET station, which has been polyfit to extrapolate, calculating the c0 from the comparison 4STARs AOD at low airmass to AERONET. ']};    
end;
w_vis = w(1:1044);
w_nir = w(1045:end);

% wirte the new cal
visfilename=[daystr '_VIS_C0_' filesuffix '.dat'];
nirfilename=[daystr '_NIR_C0_' filesuffix '.dat'];
disp(['printing to ' visfilename])
starsavec0([starpaths visfilename], source, additionalnotes, w_vis, vis_c0, visc0_std);
disp(['printing to ' nirfilename])
starsavec0([starpaths nirfilename], source, additionalnotes, w_nir, nir_c0, nirc0_std);

