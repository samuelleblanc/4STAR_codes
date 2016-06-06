function [flags, good, flagfile] = starflag_(s, Mode)
% [flags, good, flagfile] = starflag(s, Mode)
% s is 4STAR struct containing data and optional toggle field
% Mode is optional.
% Mode 1: automatic flags, incorporate existing starsun flags and automated screens.
%   Output: YYYYMMDD_starflag_auto_createdYYYYMMDD_HHMM.mat
% Mode 2: manual/interactive flagging. Incorporate starsun and automated
%         flagging and call visi_screen for manual flagging.
%   Output: YYYYMMDD_starflag_man_createdYYYYMMDD_HHMM_by_Op.mat
%       and starflags_YYYYMMDD_marks_not_aerosol_created_YYYYMMDD_by_Op.m
%       and starflags_YYYYMMDD_marks_smoke_created_YYYYMMDD_by_Op.m
%       and starflags_YYYYMMDD_marks_cirrus_created_YYYYMMDD_vy_Op.m, etc...

% Modification history:
% SL, v1.0, 20141013, added my name to the list of flaggers and added version control of this m script with version_set
% SL, v1.1, 2014-11-12, added Mode 3 for loading previous flag files, with
%                       inclusion of starinfo flags, considerable rebuilding
% MS, 2015-02-17,corrected a bug in line 74; definition of outputfile
%                corrected bug in lines 31,37 (disp function)
% CJF, 2015-01-09, commented "aerosol_init_auto" to make it obsolete
% CJF, 2016-01-17, added more write_starflags_mark_file examples
% SL, 2016-05-04, added special function buttons to visi_screen
version_set('1.4');

while ~exist('s','var')||isempty(s) % then select a starsun file to load parts of
    %        disp(['Loading data from ',daystr,'starsun.mat.  Please wait...']);
    s = [];
    sunfile = getfullname('*starsun*.mat','starsun','Select starsun file to flag.');
    s = matfile(sunfile,'writable',true);
end % done loading starinfo file
if ~exist('Mode','var') || Mode~=1
    Mode = 2;
end
t = s.t;
daystr = datestr(t(1),'yyyymmdd');

% First load some fields that should always exist in starsun
w=s.w; Lon=s.Lon; Lat=s.Lat; Alt=s.Alt; Pst=s.Pst; Tst=s.Tst; aerosolcols=s.aerosolcols;
viscols=s.viscols; nircols=s.nircols; rateaero=s.rateaero;
c0=s.c0; m_aero=s.m_aero; QdVlr=s.QdVlr; QdVtb=s.QdVtb; QdVtot=s.QdVtot; ng=s.ng;Md=s.Md;
Str=s.Str; raw=s.raw; dark=s.dark;

% Next attempt to load some fields that may not exist depending on starsun
% version or toggle settings and populate them
try;
    rawrelstd=s.rawrelstd;
catch;
    ti=9/86400;
    cc=[408 169+1044];
    pp=numel(s.t);
    rawstd=NaN(pp, numel(cc));
    rawmean=NaN(pp, numel(cc));
    for i=1:pp;
        rows=find(t>=t(i)-ti/2&t<=t(i)+ti/2 & Str==1); % Yohei, 2012/10/22 s.Str>0
        if numel(rows)>0;
            rawstd(i,:)=nanstd(raw(rows,cc),0,1); % stdvec.m seems to have a precision problem.
            rawmean(i,:)=nanmean(raw(rows,cc),1);
        end;
    end;
    rawrelstd=rawstd./rawmean;
    clear rawstd rawmean
end;
try
    tau_aero_noscreening=s.tau_aero_noscreening;
catch
    tau_aero_noscreening = s.tau_aero;
end
try isfield(s,'darkstd')
    darkstd=s.darkstd;
catch
    disp('no darkstd')
end
try
    sd_aero_crit = s.sd_aero_crit;
catch
    disp('no sd_aero_crit');
end

if ~exist('sd_aero_crit','var') % then it wasn't found in starun above so read starinfo file
    if isobject(s)
        s = load(s.Properties.Source);
    end
    infofile = fullfile(starpaths, ['starinfo' daystr '.m']);
    infofile_ = ['starinfo_' daystr]
    infofile2 = ['starinfo' daystr] % 2015/02/05 for starinfo files that are functions, found when compiled with mcc for use on cluster
    if exist(infofile_,'file')
        edit(infofile_) ; % open infofile in case user wants to edit it.
        if Mode ~=1
            OK = menu(['Edit ',infofile_,'.m as desired and click OK when done.'],'OK');
        end
        infofnt = str2func(infofile_); % Use function handle instead of eval for compiler compatibility
        s = infofnt(s);
        %     s = eval([infofile2,'(s)']);
    elseif exist(infofile2)==2;
        edit(infofile2) ; % open infofile in case user wants to edit it.
        if Mode ~=1
            OK = menu(['Edit ',infofile2,'.m as desired and click OK when done.'],'OK');
        end
        infofnt = str2func(infofile2); % Use function handle instead of eval for compiler compatibility
        s = infofnt(s);
        %     s = eval([infofile2,'(s)']);
    elseif exist(infofile)==2;
        open(infofile);
        if Mode ~=1
            OK = menu(['Edit ',infofile,'.m as desired and click OK when done.'],'OK');
        end
        run(infofile); %Trying "run" instead of "eval" for better compiler compatibility
        %     eval(['run ' infofile ';']); % 2012/10/22 oddly, this line ignores the starinfo20120710.m after it was edited on a notepad (not on the Matlab editor).
    else; % copy an existing old starinfo file and run it
        while dayspast<maxdayspast;
            dayspast=dayspast+1;
            infofile_previous=fullfile(starpaths, ['starinfo' datestr(datenum(daystr, 'yyyymmdd')-dayspast, 'yyyymmdd') '.m']);
            if exist(infofile_previous);
                copyfile(infofile_previous, infofile);
                if Mode ~=1
                    OK = menu(['Edit ',infofile,'.m as desired and click OK when done.'],'OK');
                end
                open(infofile);
                run(infofile);
                %             eval(['edit ' infofile ';']);
                %             eval(['run ' infofile ';']);
                warning([infofile ' has been created from ' ['starinfo' datestr(datenum(daystr, 'yyyymmdd')-dayspast, 'yyyymmdd') '.m'] '. Inspect it and add notes specific to the measurements of the day, for future data users.']);
                break;
            end;
        end;
    end;
end
% We've populated our workspace with 4STAR measurements
% Now we'll build the input for automatic screening and visi_screen.
% Now apply all starsun and automated flags...
[flags,flag_info] = cnvt_ng2flags(ng,t);




%Define ouput file names
% Use "which" to locate directory containing starinfo and put flag files in same location
starinfo_name = which(['starinfo_',daystr,'.m']); pname = fileparts(starinfo_name); pname = [pname, filesep];
now_str = datestr(now,'yyyymmdd_HHMM');

%%
% if Mode==1 %Automatic mode
flagfile = [daystr,'_starflag_auto_created',now_str,'.mat'];
outputfile=[starpaths,filesep,flagfile];%This has to be starsun.mat
op_name_str = 'auto';
disp(['Starflag mode 1 to output to:' flagfile])
flags.time.t = t;
flags.flag_str = flag_str;
flags.flagfile = flagfile; % make it so that we save the flagfile name.

[~,outmat,ext] = fileparts(outputfile); outmat = [outmat,ext];
if ~exist(outputfile,'file')
    disp(['Creating ',outmat]);
    save(outputfile,'-struct','flags','-v7.3');
else
    disp(['Appending to ',outmat]);
    save(outputfile,'-append','-struct','flags');
end

% Output an m-file representing all these flags in "ng" format
[flag_all, flag_names_all, flag_tag_all] = cnvt_flags2ng(t, flags);
if ~isempty(flag_all)
    [all_str, all_fname] = write_starflags_marks_file(flag_all,flag_names_all,flag_tag_all,daystr,'all', op_name_str,now_str);
end

if Mode~=1
    op_name = menu('Who is flagging 4STAR data?','Yohei Shinozuka','Connor Flynn','John Livingston','Michal Segal Rozenhaimer',...
        'Meloe Kacenelenbogen','Samuel LeBlanc','Jens Redemann','Kristina Pistone');
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
        case 7
            op_name_str = 'JR';
        case 8
            op_name_str = 'KP';
    end
    % Define several flags
    % flags.before_or_after_flight = t<flight(1) | t>flight(2);
    % flags.bad_aod = false(size(t));
    % flags.unspecified_clouds = false(size(t));   
    flags.smoke = [];
    flags.dust = [];
    flags.cirrus = [];
    flags.low_cloud = [];
    flags.hor_legs = [];
    flags.spiral = [];
    flags.frost = [];

    % Define flags which do not flag data as "bad".
    no_mask = {'smoke','dust','before_or_after_flight','hor_legs', 'spiral'};
    %Once flags are specified above, the "bad" flags are deduced.
    %"bad" flags gray out symbols in plots and show >0 in variable "screen"

    
    %We define several fields to plot in the auxiliary panels
    panel_1.aod_380nm = aod_380nm;
    panel_1.aod_452nm = aod_452nm;
    panel_1.aod_865nm = aod_865nm;
    
    panel_2.ang = ang_noscreening;
    panel_2.Quad = sqrt(s.QdVlr.^2 + s.QdVtb.^2)./s.QdVtot;
    panel_3.rawrelstd = rawrelstd(:,1);
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
    
    if isfield(flags,'aerosol_init_auto')
        flags = rmfield(flags,'aerosol_init_auto');
    end
    if isfield(flags,'auto_settings')
        auto_settings = flags.auto_settings;
        flags = rmfield(flags,'auto_settings');
    end
    F_t=fieldnames(flags);
    test_good=zeros(size(F_t));
    for i_f=1:length(no_mask)
        test_good=test_good+strcmp(no_mask(i_f),F_t);
    end
    screen_bad_list = F_t(~test_good);
            
    flagfile = [daystr,'_starflag_man_created',now_str, 'by_',op_name_str,'.mat'];
    outputfile=[starpaths,filesep,flagfile];
    disp(['Starflag mode 2 to output to:' flagfile])
    
    flags_matio = matfile(flagfile,'Writable',true);
    flags_matio.flagfile = flagfile;
    
    mark_fname = ['starflag_',daystr,'_',op_name_str,'_all_',now_str,'.m'];
    disp(['Corresponding "marks" m-file to: ',mark_fname])
        
    [flags, screen, good, figs] = visi_screen_v14(t,aod_500nm,'time_choice',1,'flags',flags,'flags_matio',flags_matio,'no_mask',no_mask,'figs',figs,...
        'panel_1', panel_1, 'panel_2',panel_2,'panel_3',panel_3,'panel_4',panel_4,'ylims',ylims, 'figs',figs,'field_name','aod 500nm');
    %     ,...
    %         'special_fn_name','Change sd_aero_crit','special_fn_flag_name','unspecified_clouds','special_fn_flag_str',flags_str.unspecified_clouds,'special_fn_flag_var','sd_aero_crit');
    % returns:
    %   flags: struct of logicals (from flags inarg) of length(time)
    %           Also contains time, and settings in "manual_flags", and
    %   screen: bitwise mapping of flags not in flag_list into uint32.
    %   good: good = screened==0
    %   figs: output of figure numbers and positions to preserve figure layout
    % Now populate the struct that will be output to starsun.mat.
    flags.time.t = t;
    manual_flags.nomask_list=no_mask;
    manual_flags.screen_bad_list=screen_bad_list;
    manual_flags.good=good; % These are only those records not marked by tests in screen_bad_list
    %     manual_flags.screen=logical(screen); % bitwise mapping of flags not in screen_bad_list into uint32.
    manual_flags.screen=screen; % bitwise mapping of flags not in screen_bad_list into uint32.
    %%
    %%
    if exist('auto_settings','var')
        manual_flags.auto_settings = auto_settings;
    end
    manual_flags.flagfile = flagfile;
    flags.manual_flags = manual_flags;
    flags.flagfile = flagfile; % make it so that we save the flagfile name.
    [~,outmat,ext] = fileparts(outputfile); outmat = [outmat,ext];
    if ~exist(outputfile,'file')
        disp(['Creating ',outmat]);
        save(outputfile,'-struct','flags','-v7.3');
    else
        disp(['Appending to ',outmat]);
        save(outputfile,'-append','-struct','flags');
    end
    
    % Output an m-file representing all these flags in "ng" format
    [flag_all, flag_names_all, flag_tag_all] = cnvt_flags2ng(t, flags);
    if ~isempty(flag_all)
        [all_str, all_fname] = write_starflags_marks_file(flag_all,flag_names_all,flag_tag_all,daystr,'all', op_name_str,now_str);
    end
    
    % Output an m-file marking all not_good_aerosol events
    [flag_aod, flag_names_aod, flag_tag_aod] = cnvt_flags2ng(t, flags,~good);
    if ~isempty(flag_aod)
        aod_str = write_starflags_marks_file(flag_aod,flag_names_aod,flag_tag_aod,daystr,'not_good_aerosol', op_name_str,now_str);
    end
    other_flagged = false(size(good));
    for fld = 1:length(no_mask)
        other_flagged = other_flagged | flags.(no_mask{fld});
        other_flags.(no_mask{fld}) = flags.(no_mask{fld});
    end
    % Output an m-file marking all other events not marked as bad_aerosol events
    other_flags.time = flags.time;
    [flag_other, flag_names_other, flag_tag_other] = cnvt_flags2ng(t, other_flags,other_flagged);
    if ~isempty(flag_other)
        other_str = write_starflags_marks_file(flag_other,flag_names_other,flag_tag_other,daystr,'other_flagged_events', op_name_str,now_str);
    end
    % Output an m-file marking cloud events (low cloud, cirrus, unspecified)
    cld_mask = {'unspecified_clouds','cirrus','low_cloud'};
    cloud_flagged = false(size(good));
    for fld = 1:length(cld_mask)
        cloud_flagged = cloud_flagged | flags.(cld_mask{fld});
        cloud_flags.(cld_mask{fld}) = flags.(cld_mask{fld});
    end
    cloud_flags.time = flags.time;
    % The line below would produce a flag file containing all flags for times also associated with cloud flags.
    [flag_cloud, flag_names_cloud, flag_tag_cloud] = cnvt_flags2ng(t, flags,cloud_flagged);
    % The line below would produce a flag file containing ONLY cloud flags.
    % [flag_cloud, flag_names_cloud, flag_tag_cloud] = cnvt_flags2ng(t, cloud_flags,cloud_flagged);
    if ~isempty(flag_cloud)
        cloud_str = write_starflags_marks_file(flag_cloud,flag_names_cloud,flag_tag_cloud,daystr,'cloud_events', op_name_str,now_str);
    end
    
    answer = menu('Write mask files, similar to "ng" in star_info, for selected flags?','Yes','No');
    Mark_subset_file = answer ==1;
    flag_list = fieldnames(flags);
    for x = length(flag_list):-1:1
        if ~islogical(flags.(flag_list{x}))
            flag_list(x) = [];
        end
    end
    while (Mark_subset_file)
        
        this_flag = menu('Select a flag or "DONE"',{flag_list{:}, ' ', 'DONE'});
        pause(.05)
        if this_flag <= length(flag_list)
            neg = menu(['Select times when ',flag_list{this_flag},' is TRUE or FALSE?'],'True','False');
            if neg==1
                these = flags.(flag_list{this_flag});
                this_str = flag_list{this_flag};
            else
                these = ~flags.(flag_list{this_flag});
                this_str = ['NOT_',flag_list{this_flag}];
            end
            % This will generate a subset for the selected flag
            [flag_selected, flag_names_selected, flag_tag_selected] = cnvt_flags2ng(t, flags,these);
            if ~isempty(flag_selected)
                selected_str = write_starflags_marks_file(flag_selected,flag_names_selected,flag_tag_selected,daystr,this_str, op_name_str,now_str);
            end
            
        else
            Mark_subset_file = false;
        end
        %Write subset output files:
        %starflags_YYYYMMDD_marks_not_aerosol_created_YYYYMMDD_by_Op.m
        %starflags_YYYYMMDD_marks_smoke_created_YYYYMMDD_by_Op.m etc...
        %similar to s.ng in starinfo but with new fields to identify flags and flag_tags
        
        % This will generate a subset identifying smoke events
        %         [flag_aod_smoke, flag_names_smoke, flag_tag_smoke] = cnvt_flags2ng(t, flags,flags.smoke);
        %         if ~isempty(flag_aod_smoke)
        %             smoke_str = write_starflags_marks_file(flag_aod_smoke,flag_names_smoke,flag_tag_smoke,daystr,'smoke', op_name_str);
        %         else
        %             disp('no smoke selected');
        %         end
        %
        %         % This will generate a subset identifying dust events
        %         [flag_aod_dust, flag_names_dust, flag_tag_dust] = cnvt_flags2ng(t, flags,flags.dust);
        %         if ~isempty(flag_aod_dust)
        %             dust_str = write_starflags_marks_file(flag_aod_dust,flag_names_dust,flag_tag_dust,daystr,'dust', op_name_str);
        %         else
        %             disp('no dust selected');
        %         end
        %
        %         [flag_cirrus, flag_names_cirrus, flag_tag_cirrus] = cnvt_flags2ng(t, flags,flags.cirrus);
        %         if ~isempty(flag_cirrus)
        %             cirrus_str = write_starflags_marks_file(flag_cirrus,flag_names_cirrus,flag_tag_cirrus,daystr,'cirrus', op_name_str);
        %         else
        %             disp('no cirrus selected');
        %         end
    end
end

%Write output file:
%Mode 1: YYYYMMDD_auto_starflag_createdYYYYMMDD_HHMM.mat
%Mode 2: YYYYMMDD_man_starflag_createdYYYYMMDD_HHMM_by_Op.mat
flags.flagfile = flagfile; % make it so that we save the flagfile name.
[~,outmat,ext] = fileparts(outputfile); outmat = [outmat,ext];
if ~exist(outputfile,'file')
    disp(['Creating ',outmat]);
    save(outputfile,'-struct','flags');
else
    disp(['Appending to ',outmat]);
    save(outputfile,'-append','-struct','flags');
end

if ~exist('good','var')
    good = [];
end

return



