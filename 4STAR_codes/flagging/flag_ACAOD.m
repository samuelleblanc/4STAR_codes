function flag_ACAOD

%% Details of the program:
% NAME:
%   flag_ACAOD
%
% PURPOSE:
%  used for interactive flag generation to determine the Above Cloud AOD,
%  or the portions of the flight representing the entire above cloud
%  aerosol layer
%
% CALLING SEQUENCE:
%   flag_ACAOD
%
% INPUT:
%  none
%
% OUTPUT:
%  plots, and .mat file with flags
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - .ict files for 4STAR AOD
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, 31° 56.0 N, 139° 35.8 W, Feb 2nd, 2018
% -------------------------------------------------------------------------

%% codes
version_set('v1.0')
merge_read = true;


%% set variables and prepare for loading
if merge_read;
    [fa pa] = uigetfile2(['*;*.nc;*.NC;*.ncf;*.ncdf'],['Please select the merged 1 second netcdf file for loading']);
    tt = split(fa,'_'); daystr = tt{3};

    t_n = ncread([pa fa],'time');
    t = datenum(t_n/3600.0/24.0+datenum(1970,1,1,0,0,0));
    flag_mod = ncread([pa fa],'P3_module_flags');
    alt = ncread([pa fa],'HAE_GPS_Altitude');

    flag_incld = flag_mod==1;
    flag_abovecld = flag_mod==2;

    aod = ncread([pa fa],'AOD');
    aod_wl = ncread([pa fa],'AODwavelength');
    [nul,ia] = min(abs(aod_wl-500));
    aod500 = aod(ia,:); 
    aod500(aod500==-9999.0) = NaN;
    [nul,ia] = min(abs(aod_wl-1040));
    aod1040 = aod(ia,:); 
    aod1040(aod1040==-9999.0) = NaN;
    qual_flag = ncread([pa fa],'qual_flag');
    
    cdnc = ncread([pa fa],'CDNC');
    cdnc(cdnc==-9999)=NaN;
    cdn = sum(cdnc);
    
    fl.qual_flag = qual_flag;
    fl.acaod = flag_abovecld;
    fl.incld = flag_incld;
else;
    [fa pa] = uigetfile2(['*' ';' '*.ict' ';' '*.ICT'],['Please select the 4STAR-AOD *.ict file for loading']);
    tt = split(fa,'_'); daystr = tt{3};

    dat = ictread([pa fa]);
    t = datenum(dat.t+datenum(dat.year,1,0,0,0,0));
    aod500 = dat.AOD0501; aod1040 = dat.AOD1040;
    alt = dat.GPS_Alt;
    fl.qual_flag = dat.qual_flag;
    fl.acaod = [];
end;
%% prepare for visi_screen
no_mask = {'acaod'};

panel_1.aod500 = aod500; 
panel_1.aod1040 = aod1040;
panel_2.Alt = alt;

panel_3.CN = cdn;

figs.tau_fig.h = 1;
figs.tau2_fig.h = 2;
figs.leg_fig.h = 3;
figs.aux_fig.h = 4;
figs.tau_fig.pos = [ 0.2990    0.5250    0.2917    0.3889];
figs.tau2_fig.pos = [0.3021    0.0537    0.2917    0.3889];
figs.leg_fig.pos =   [ 0.1109    0.5731    0.1776    0.3611];
figs.aux_fig.pos = [0.6167 0.0769 0.2917 0.8306];

ylims.panel_1 = [-0.01, 0.8];
ylims.panel_2 = [0,7000.0];

[flags, screen, good, figs] = visi_screen_v15(t,aod500,'time_choice',2,'flags',fl,...
                    'no_mask',no_mask,'panel_1',panel_1,'panel_2',panel_2,'panel_3',panel_3,'figs',figs,'ylims',ylims);

%[flags, screen, good, figs] = visi_screen_gases(t,input_param,'time_choice',
%,'flags',flags,'no_mask',no_mask,'figs',figs,...
%        'panel_1', panel_1, 'panel_2',panel_2,'panel_3',panel_3,'panel_4',panel_4,'ylims',ylims, 'figs',figs,...
%        'special_fn_name','Change sd_aero_crit','special_fn_flag_name','unspecified_clouds','special_fn_flag_str',flags_str.unspecified_clouds,'special_fn_flag_var','sd_aero_crit','gas',gas_name_str);

flag_acaod = flags.acaod;

disp(['Saving flag file to:' fa daystr '_falg_acaod.mat'])
save([fa daystr '_falg_acaod.mat'],'-s',flag_acaod,t);


