function [flags] = starflag(daystr,Mode,s)
%% Function to generate flags for 4STAR data
% uses different modes:
% Mode = 1 "Automatic" aerosol (except strong events) versus clouds;
% starflag is called in starsun.m file and starsun.mat will contain the
% INITIAL (i.e. "automatic") flags (i.e. vis_sun.flag and
% vis_sun.flagallcols); It also produces YYYYMMDD_starflag_auto_createdYYYYMMDD_HHMM.mat
%
% Mode = 2 "in-depth" flagging of aerosol (e.g. smoke or dust) and
% clouds (e.g. low clouds or cirrus); starflag.m is called as stand-alone
%(i.e. outside of starsun.m) and produces YYYYMMDD_starflag_man_createdYYYYMMDD_HHMM_by_Op.mat
% and starflags_YYYYMMDD_marks_not_aerosol_created_YYYYMMDD_by_Op.m
% and starflags_YYYYMMDD_marks_smoke_created_YYYYMMDD_by_Op.m 
% and starflags_YYYYMMDD_marks_cirrus_created_YYYYMMDD_vy_Op.m, etc...
%
% Mode = 3 "Loading" a previous starflag file, with precedence of manual
% vs. auto flagging. should be called whenever the flag file is already
% there, if not, then asks user if they want to do manual or automatic

% Modification history:
% SL, v1.0, 20141013, added my name to the list of flaggers and added version control of this m script wiht version_set
% SL, v1.1, 2014-11-12, added Mode 3 for loading previous flag files, with
%                       inclusion of starinfo flags, considerable rebuilding
% MS, 2015-02-17,corrected a bug in line 74; definition of outputfile
%                corrected bug in lines 31,37 (disp function)
%
version_set('1.1');

if (Mode==3);
    files = ls([starpaths,daystr,'_starflag_man_*']);
    if ~isempty(files);
        flagfile=files(end,:);
        disp(['loading file:' starpaths flagfile])
        load([starpaths flagfile]);
    else;
        files = ls([starpaths,daystr,'_starflag_auto_*']);
        if ~isempty(files);
            flagfile=files(end,:);
            disp(['loading file:' starpaths flagfile])
            load([starpaths flagfile]);
        else;
            flagfile=uigetfile('*starflag*.mat','Select correct starflag file')
        end;
    end;
    
    if isequal(flagfile,0)
        Mode = menu('No file selected, which mode do you want to operate?','Automatic','Manual');
    end;
end;
%define operator for manual screening mode (mode=2)
if (Mode==2)
    op_name = menu('Who is flagging 4STAR data?','Yohei Shinozuka','Connor Flynn','John Livingston','Michal Segal Rozenhaimer','Meloe Kacenelenbogen','Samuel LeBlanc');
    op_name_str = '?';
    switch op_name
        case 1
            op_name_str = 'YS';
        case 2
            op_name_str = 'CF';
        case 3
            op_name_str = 'JL';
        case 4
            op_name_str = 'MS';
        case 5
            op_name_str = 'MK';
        case 6
            op_name_str = 'SL';
    end
end

%Define ouput file names for both modes
switch Mode
    case 1
        flagfile = [daystr,'_starflag_auto_created',datestr(now,'yyyymmdd_hhMM'),'.mat'];
        outputfile=[starpaths,filesep,flagfile];%This has to be starsun.mat
        disp(['Starflag mode 1 to output to:' outputfile])
    case 2
        flagfile = [daystr,'_starflag_man_created',datestr(now,'yyyymmdd_hhMM'), 'by_',op_name_str,'.mat'];
        outputfile=[starpaths,filesep,flagfile];
        disp(['Starflag mode 2 to output to:' outputfile])
end

if ~isempty(s)
    t=s.t;w=s.w;Lon=s.Lon;Lat=s.Lat;Alt=s.Alt;Pst=s.Pst;Tst=s.Tst;aerosolcols=s.aerosolcols;
    viscols=s.viscols;nircols=s.nircols;rateaero=s.rateaero;tau_aero_noscreening=s.tau_aero_noscreening;
    c0=s.c0;m_aero=s.m_aero;QdVlr=s.QdVlr;QdVtb=s.QdVtb;QdVtot=s.QdVtot;ng=s.ng;rawrelstd=s.rawrelstd;Md=s.Md;
    Str=s.Str;raw=s.raw;dark=s.dark;darkstd=s.darkstd;
    
else
    % Now load any fields from starsun.mat that you want to use to generate
    % automated flags or plot in visi_screen.
    disp(['Loading data from ',daystr,'starsun.mat.  Please wait...'])
    slsun(daystr,'t','w', 'Lon', 'Lat', 'Alt', 'Pst', 'Tst', ...
        'aerosolcols','viscols','nircols', ...
        'rateaero',  'tau_aero_noscreening',...
        'c0', 'm_aero','QdVlr','QdVtb','QdVtot',...
        'ng','rawrelstd','Md','Str','raw','dark','darkstd','flags');
end

s.note{end+1} = ['Flagging with starflag with output at:' flagfile]
% t = s.t;
% slsun(daystr, 't'); %Get time from the starsun file because we need it to convert the
% ng structure in the initial starinfo file into logical flags of length(t)
sinfo_file=fullfile(starpaths, ['starinfo' daystr '.m']);
% sinfo_file = getfullname(['starinfo',daystr,'*.m'],'starinfo','Select starinfo file.');
[sinfo] = get_starinfo_parts(sinfo_file,daystr);
if isfield(sinfo,'flight')
    flight = sinfo.flight;
elseif any(Alt>0)
    flight(1) = t(find(Alt>0,1,'first'));
    flight(2) = t(find(Alt>0,1,'last'));
else
    flight(1) = t(1);
    flight(2) = t(end);
end
if isfield(sinfo,'horilegs')
    horilegs = sinfo.horilegs;
end
% evalstarinfo(daystr,'flight'); %Make sure there is no empty line before the "flight" line in starinfo file
% evalstarinfo(daystr,'horilegs');



% We've populated our workspace with 4STAR measurements
% Now we'll build the input for automatic screening and visi_screen.

nm_500 = interp1(w,[1:length(w)],.5, 'nearest');
nm_870 = interp1(w,[1:length(w)],.87, 'nearest');
nm_452 = interp1(w,[1:length(w)],.452, 'nearest');
nm_865 = interp1(w,[1:length(w)],.865, 'nearest');
colsang=[nm_452 nm_865];
ang_noscreening=sca2angstrom(tau_aero_noscreening(:,colsang), w(colsang));
aod_500nm = tau_aero_noscreening(:,nm_500);
aod_865nm = tau_aero_noscreening(:,nm_865);
aod_500nm_max=3;
m_aero_max=15;

% % initializing a logical field
% good_ang = true(size(ang_noscreening));
% % Here is an example of how to use logical flags in succession without
% % overwriting initial results.  If this section is run repeatedly a smaller
% % and smaller subset of "good_ang" values would be true and screened by
% % madf_span.
% [good_ang(good_ang)] = madf_span(ang_noscreening(good_ang),50,3);sum(good_ang)



%Fixed pre-screening in the case of Mode 1 automatic
if (Mode==1)
    flags_str.before_or_after_flight = '(t<flight(1)|t>flight(2))';
    flags_str.unspecified_clouds = 'aod_500nm>aod_500nm_max | (ang_noscreening<.2 & aod_500nm>0.08) | rawrelstd(:,1)>.01';
    flags_str.bad_aod = 'aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500) | c0(:,nm_500)<=0';
    flags_str.smoke = '';
    flags_str.dust = '';
    flags_str.cirrus = '';
    flags_str.low_cloud = '';
    flags_str.hor_legs = '';
    flags_str.vert_legs = '';
    flags_str.unspecified_aerosol = '';
    flags_str.frost = '';
    reset_flags=true;
end


%Choice of pre-screening and/ or selecting previous flags in the case of
%Mode 2 manual
if (Mode==2)
    input_flags_select = menu('Previous flags as input and/ or alternate pre-screening?',...
        '1: No Previous flags & No pre-screening',...
        '2: Previous flags from starsun & No user-defined pre-screening',...
        '3: Previous flags from starsun & user-defined pre-screening',...
        '4: No Previous flags & user-defined pre-screening',...
        '5: Previous flags from separate file & No user-defined pre-screening',...
        '6: Previous flags from separate file & user-defined pre-screening');
    reset_flags=false;
    switch input_flags_select
        case 1 %Previous flags:No, your own pre-screening:No
            clear('flags')
            flags_str.before_or_after_flight = '';
            flags_str.unspecified_clouds = '';
            flags_str.bad_aod = '';
            flags_str.smoke = '';
            flags_str.dust = '';
            flags_str.cirrus = '';
            flags_str.low_cloud = '';
            flags_str.hor_legs = '';
            flags_str.vert_legs = '';
            flags_str.unspecified_aerosol = '';
            flags_str.frost = '';
            reset_flags=true;
        case 2 %Previous flags:Yes from starsun, your own pre-screening:No
            reset_flags=false;
        case 3 %Previous flags:Yes from starsun, your own pre-screening:Yes
            %User needs to modify what's below
            flags_str.before_or_after_flight = 'flags.before_or_after_flight | (t<flight(1)|t>flight(2))';
            flags_str.unspecified_clouds = 'flags.unspecified_clouds | aod_500nm>aod_500nm_max | (ang_noscreening<.2 & aod_500nm>0.08) | rawrelstd(:,1)>.01';
            flags_str.bad_aod = 'flags.bad_aod | aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500) | c0(:,nm_500)<=0';
            flags_str.smoke = '';
            flags_str.dust = '';
            flags_str.cirrus = '';
            flags_str.low_cloud = '';
            flags_str.hor_legs = '';
            flags_str.vert_legs = '';
            flags_str.unspecified_aerosol = '';
            flags_str.frost = '';
            reset_flags=true;
        case 4 %Previous flags:No, your own pre-screening:yes
            %Users need to modify what's below:
            clear('flags')
            flags_str.before_or_after_flight = '(t<flight(1)|t>flight(2))';
            flags_str.unspecified_clouds = 'aod_500nm>aod_500nm_max | (ang_noscreening<.2 & aod_500nm>0.08) | rawrelstd(:,1)>.01';
            flags_str.bad_aod = 'aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500) | c0(:,nm_500)<=0';
            flags_str.smoke = '';
            flags_str.dust = '';
            flags_str.cirrus = '';
            flags_str.low_cloud = '';
            flags_str.hor_legs = '';
            flags_str.vert_legs = '';
            flags_str.unspecified_aerosol = '';
            flags_str.frost = '';
            reset_flags=true;
            
        case 5 %Previous flags:Yes separate file, your own pre-screening:No
            clear('flags')
            source='ask';
            [sourcefile, ext, daystr,filen]=starsource(source, 'sun');
            %             load(sourcefile{1}); THIS IS TO READ MK's FILE
            flags=load(sourcefile{1});%THIS IS TO READ MICHAL's FILE
            t=flags.time.t;
            reset_flags=false;
        case 6 %'Previous flags:Yes separate file, your own pre-screening:Yes');
            clear('flags')
            source='ask';
            [sourcefile, ext, daystr,filen]=starsource(source, 'sun');
            load(sourcefile{1});
            
            %Users need to modify what's below:
            flags_str.before_or_after_flight = 'flags.before_or_after_flight | (t<flight(1)|t>flight(2))';
            flags_str.unspecified_clouds = 'flags.unspecified_clouds | aod_500nm>aod_500nm_max | (ang_noscreening<.2 & aod_500nm>0.08) | rawrelstd(:,1)>.01';
            flags_str.bad_aod = 'flags.bad_aod | aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500) | c0(:,nm_500)<=0';
            flags_str.smoke = '';
            flags_str.dust = '';
            flags_str.cirrus = '';
            flags_str.low_cloud = '';
            flags_str.hor_legs = '';
            flags_str.vert_legs = '';
            flags_str.unspecified_aerosol = '';
            flags_str.frost = '';
            reset_flags=true;
    end
end


if (reset_flags)
    if ~isempty(flags_str.before_or_after_flight) flags.before_or_after_flight = eval(flags_str.before_or_after_flight); else flags.before_or_after_flight=[]; end
    if ~isempty(flags_str.bad_aod) flags.bad_aod = eval(flags_str.bad_aod); else flags.bad_aod = []; end
    if ~isempty(flags_str.unspecified_clouds) flags.unspecified_clouds = eval(flags_str.unspecified_clouds); else flags.unspecified_clouds = []; end
    if ~isempty(flags_str.smoke) flags.smoke=eval(flags_str.smoke);else flags.smoke = []; end
    if ~isempty(flags_str.dust) flags.dust=eval(flags_str.dust);else flags.dust = []; end
    if ~isempty(flags_str.cirrus) flags.cirrus=eval(flags_str.cirrus);else flags.cirrus = []; end
    if ~isempty(flags_str.low_cloud) flags.low_cloud=eval(flags_str.low_cloud);else flags.low_cloud = []; end
    if ~isempty(flags_str.hor_legs) flags.hor_legs=eval(flags_str.hor_legs);else flags.hor_legs = []; end
    if ~isempty(flags_str.vert_legs) flags.vert_legs=eval(flags_str.vert_legs);else flags.vert_legs = []; end
    if ~isempty(flags_str.unspecified_aerosol) flags.unspecified_aerosol=eval(flags_str.unspecified_aerosol);else flags.unspecified_aerosol = []; end
    if ~isempty(flags_str.frost) flags.frost=eval(flags_str.frost);else flags.frost = []; end
    flags.auto_settings = flags_str;
end

if (Mode==1)
    flags.aerosol_init_auto=(~flags.before_or_after_flight & ~flags.bad_aod & ~flags.unspecified_clouds);
end

if (Mode==2)
    %Run visi_screen in manual mode (mode=2)
    %We define several fields to plot in the auxiliary panels
    panel_1.aod_500nm = aod_500nm;
    panel_1.aod_865nm = aod_865nm;
    panel_2.ang = ang_noscreening;
    panel_2.std_ang = sliding_std(ang_noscreening,10);
    panel_3.rawrelstd = rawrelstd;
    panel_4.Alt = Alt;
    
    ylims.panel_1 = [-.1, 2];
    ylims.panel_2 = [-1,4];
    ylims.panel_3 = [0,1];
    ylims.panel_4 = [0,8000];
    figs.tau_fig.h = 1;
    figs.tau2_fig.h = 2;
    figs.leg_fig.h = 3;
    figs.aux_fig.h = 4;
    figs.tau_fig.pos = [ 0.2990    0.5250    0.2917    0.3889];
    figs.tau2_fig.pos = [0.3021    0.0537    0.2917    0.3889];
    figs.leg_fig.pos =   [ 0.1109    0.5731    0.1776    0.3611];
    figs.aux_fig.pos = [0.6167 0.0769 0.2917 0.8306];
    
    % Define any good flags (i.e. will show 1 in variable "good")
    % When points are classified for ex. smoke and unspecified_clouds (this
    % could happen when pre-screening and then correcting with visual display),
    % we keep records are both smoke and unspecified_clouds in flags but
    % variable "good" =1
    
    %if looking for all types of aerosols:
    goodnomask = {'smoke','dust','unspecified_aerosol','aerosol_init_auto'};
    %Once good flags are specified above, the bad ones are deduced.
    %Those bad flags will gray out the symbols in plots
    %and will show >0 in variable "screen"
    F_t=fieldnames(flags);
    test_good=zeros(size(F_t));
    for i_f=1:length(goodnomask)
        test_good=test_good+strcmp(goodnomask(i_f),F_t);
    end
    screen_bad_list = F_t(~test_good);
    
    [flags, screen, good, figs] = visi_screen(t,aod_500nm','time_choice',2,'flags',flags,'goodnomask',goodnomask,'figs',figs,...
        'panel_1', panel_1, 'panel_2',panel_2,'panel_3',panel_3,'panel_4',panel_4,'ylims',ylims,'time_choice',1, 'figs',figs);
    
    flags_struct.screen=logical(screen);
    flags_struct.good=good;
    flags_struct.goodnomask_list=goodnomask;
    flags_struct.screen_bad_list=screen_bad_list;
end


%Write output file:
%Mode 1: YYYYMMDD_auto_starflag_createdYYYYMMDD_HHMM.mat
%Mode 2: YYYYMMDD_man_starflag_createdYYYYMMDD_HHMM_by_Op.mat
flags.flagfile = flagfile; % make it so that we save the flagfile name.
if ~exist(outputfile,'file')
    save(outputfile,'flags');
    if (Mode==2)
        save(outputfile,'-append','flags_struct');
    end
end

if (Mode==2);
    answer = menu('Write mask file, similar to startinfo?','Yes','No');
    if answer == 2; Mark_subset_file=false; else; Mark_subset_file=true; end;
    if (Mark_subset_file)
        %Write subset output files:
        %starflags_YYYYMMDD_marks_not_aerosol_created_YYYYMMDD_by_Op.m
        %starflags_YYYYMMDD_marks_smoke_created_YYYYMMDD_by_Op.m etc...
        %similar to s.ng in starinfo but with new fields to identify flags and flag_tags
        
        % This will generate a smaller subset with only "not good" conditions
        [flag_aod, flag_names_aod, flag_tag_aod] = cnvt_flags2ng(t, flags,~good);
        if ~isempty(flag_aod)
            aod_str = write_starflags_marks_file(flag_aod,flag_names_aod,flag_tag_aod,daystr,'not_aerosol', op_name_str);
        else
            disp('no clouds or bad aod selected');
        end
        
        % This will generate a subset identifying smoke events
        [flag_aod_smoke, flag_names_smoke, flag_tag_smoke] = cnvt_flags2ng(t, flags,flags.smoke);
        if ~isempty(flag_aod_smoke)
            smoke_str = write_starflags_marks_file(flag_aod_smoke,flag_names_smoke,flag_tag_smoke,daystr,'smoke', op_name_str);
        else
            disp('no smoke selected');
        end
        
        % This will generate a subset identifying smoke events
        [flag_aod_dust, flag_names_dust, flag_tag_dust] = cnvt_flags2ng(t, flags,flags.dust);
        if ~isempty(flag_aod_dust)
            dust_str = write_starflags_marks_file(flag_aod_dust,flag_names_dust,flag_tag_dust,daystr,'dust', op_name_str);
        else
            disp('no dust selected');
        end
        
        [flag_cirrus, flag_names_cirus, flag_tag_cirrus] = cnvt_flags2ng(t, flags,flags.cirrus);
        if ~isempty(flag_cirrus)
            cirrus_str = write_starflags_marks_file(flag_cirrus,flag_names_cirrus,flag_tag_cirrus,daystr,'cirrus', op_name_str);
        else
            disp('no cirrus selected');
        end
    end
end
return



