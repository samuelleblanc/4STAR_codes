%% Details of the program:
% PURPOSE:
%  Codes to calculate the c0 from high altitude spectra
%  Uses predefined startospheric AOD spectrum
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
% -------------------------------------------------------------------------
%close all
clear all

version_set('1.1');
if ~isunix;
    fp = 'C:\Users\sleblan2\Research\ORACLES\data_2017\';
else;
    fp = '/nobackup/sleblan2/ORACLES/data_2017/';
end;
%% set day info
daystr = '20170809';
daystr = '20170815'


%wl = [340.,   380.,   440.,   500.,   675.,   870.,  1020.,  1640.];
%aod = [0.01341534,  0.01563484,  0.01673158,  0.01320213,  0.00794751,...
%       0.00896252,  0.00709206,  0.00568186]; % MLO high alt values in september
   
%wl =  [1640.   ,1020.   ,870.    ,675.    ,500.    ,440.    ,380.    ,340.    ,300.];
%aod = [0.004104,0.011504,0.009940,0.010834,0.016625,0.020482,0.036209,0.038874,0.040].*0.85; %Bonanza value at lowest AOD in August 5th, 2016 (altitude at 1382 m near Namibia)

do_polyfit = true;
wl = [451.7,470.2,500.7,520,530.3,532.0,550.3,605.5,660.1,780.6,864.6,1019.9,1064.2,1235.8,1558.7,1626.6,1650.1];
iwl = [347, 370,  408,  432,445,  447,  470,  539,  608,  761,  869,  1084,  1109,  1213,  1439,  1492,  1511];


if isequal(daystr, '20160918');
    aod(1:6)= aod(1:6)+0.03; % to account for some window deposition
    aod(7:8)= aod(7:8)+0.015; % to account for some window deposition
elseif isequal(daystr,'20160904');
    aod(1:6) = aod(1:6)+0.020; % to account for some window deposition
elseif isequal(daystr,'20160902');
    aod(1:6) = aod(1:6)+0.025; % to account for some window deposition
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
    %% get the aods from polyfit reconstruction
    [a2,a1,a0,ang,curvature]=polyfitaod(w(iwl).*1000.0,nanmean(tau_aero(ok,iwl)));
    aods = exp(polyval([a2,a1,a0],log(w.*1000.0)));

else
    %% interpolate the aods
    aods = interp1(wl,aod,w.*1000.0,'pchip');
    aodp = exp(polyval(polyfit(log(wl),log(aod),2),log(w.*1000.0)));
    %aods = aodp;
end;
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

%% Prepare for saving c0 file
filesuffix='refined_high_alt_low_m_frompolyfit'; %_loglogquad';
additionalnotes={'Using a high altitude AOD spectra, which has been polyfit to extrapolate to problematic wavelengths, calculating the c0 from the AOD at low airmass. '};
w_vis = w(1:1044);
w_nir = w(1045:end);

% read the previous cal
visfilename=[daystr '_VIS_C0_' filesuffix '.dat'];
nirfilename=[daystr '_NIR_C0_' filesuffix '.dat'];
disp(['printing to ' visfilename])
starsavec0([starpaths visfilename], source, additionalnotes, w_vis, vis_c0, visc0_std);
disp(['printing to ' nirfilename])
starsavec0([starpaths nirfilename], source, additionalnotes, w_nir, nir_c0, nirc0_std);
