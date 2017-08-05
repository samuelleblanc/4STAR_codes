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
% CJF, 2016-06-07, many structural changes
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

upath = strrep(strrep(userpath,';',filesep),[filesep filesep],filesep);
tmp_file = [upath, '~starflags.mat'];
if exist(tmp_file,'file')
      tmpio = matfile(tmp_file); 
end
fresh_start = true;
if Mode==2 && exist(tmp_file,'file')&&any(strcmp(properties(tmpio),'flagfile'))
   flagfile = tmpio.flagfile;
   fresh_start = logical(menu({['There is an unsaved temporary starflags file intended as:'];[' "',flagfile,'"'];['Load this temp starflags file and continue, or start fresh?']}, 'Load it','Start fresh')-1);
   if fresh_start 
      delete(tmp_file);
      clear tmpio
   else
      flags = load(tmp_file);
      flags_matio = matfile(tmp_file,'writable',true);
   end
end

t = s.t;
daystr = datestr(t(1),'yyyymmdd'); 
now_str = datestr(now,'yyyymmdd_HHMM');

if Mode==1 || fresh_start % Then output flag file with auto-generated flags
   [flags, inp] = define_starflags_20160605(s);
   flagfile = [daystr,'_starflag_auto_created_',now_str,'.mat'];
   flags.flagfile = flagfile; % make it so that we save the flagfile name.
   %Define ouput file names
   % Use "which" to locate directory containing starinfo and put flag files in same location
   outputfile=[getnamedpath('starinfo','Select where starinfo files and flag files are to be saved.'),flagfile];
   op_name_str = 'auto';
   disp(['Automatic flags written to: ' flagfile])
   
   if ~exist(outputfile,'file')
      disp(['Creating ',flagfile]);
      save(outputfile,'-struct','flags','-v7.3');
   else
      disp(['Appending to ',flagfile]);
      save(outputfile,'-append','-struct','flags');
   end
   save(tmp_file,'-struct','flags','-v7.3');
   flags_matio = matfile(tmp_file,'writable',true);
   
   [flag_all, flag_names_all, flag_tag_all] = cnvt_flags2ng(t, flags);
   if ~isempty(flag_all)
      [all_str, all_fname] = write_starflags_marks_file(flag_all,flag_names_all,flag_tag_all,daystr,'all', op_name_str,now_str);
   end
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

    flagfile = [daystr,'_starflag_man_created_',now_str, 'by_',op_name_str,'.mat'];
    outputfile=[getnamedpath('starinfo'),flagfile]; 
    disp(['Starflag manual flags output to:' flagfile])
    
%     save(tmp_file, '-struct','flags','-v7.3');
%     flags_matio = matfile(tmp_file,'Writable',true);
    flags_matio.flagfile = flagfile; flags.flagfile = flagfile;
    time.t = t;
    flags_matio.time = time; flags.time.t = t;
    
    mark_fname = ['starflag_',daystr,'_',op_name_str,'_all_',now_str,'.m'];
    disp(['Corresponding "marks" m-file to: ',mark_fname]);    

    % Define flags which do not flag data as "bad".
    %Once flags are specified above, the "bad" flags are deduced.
    %"bad" flags gray out symbols in plots and show >0 in variable "screen"

    if ~exist('inp','var')
       [~, inp] = define_starflags_20160605(s);
    end
    %We define several fields to plot in the auxiliary panels
    panel_1.aod_380nm = inp.aod_380nm;
    panel_1.aod_452nm = inp.aod_452nm;
    panel_1.aod_865nm = inp.aod_865nm;
    
    panel_2.ang = inp.ang_noscreening;
    panel_2.Quad = sqrt(s.QdVlr.^2 + s.QdVtb.^2)./s.QdVtot;
    panel_3.rawrelstd = inp.rawrelstd(:,1);
    panel_4.Alt = s.Alt;
    
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
    % Here is the place to remove non-logical elements from flag
    F_t=fieldnames(flags);
    for i_f=length(F_t):-1:1
        fld = F_t{i_f};
        if ~islogical(flags.(fld))&&~isempty(flags.(fld))
                F_t(i_f) = [];
        end
    end               
    test_good=zeros(size(F_t));
    for i_f=1:length(flags.flag_struct.flag_noted)
        test_good=test_good+strcmp(flags.flag_struct.flag_noted(i_f),F_t);
    end
    screen_bad_list = F_t(~test_good);
            
    [flags, screen, good, figs] = visi_screen_v15(t,inp.aod_500nm,'time_choice',1,'flags',flags,'flags_matio',flags_matio,'no_mask',flags.flag_struct.flag_noted,'figs',figs,...
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
    no_mask = flags.flag_struct.flag_noted
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

if ~exist('good','var')
    good = [];
end

delete(tmp_file);
return



