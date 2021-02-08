function [flags, qual_flag, flagfile] = starflagGases(s, Mode,gas_name_str)
% [flags, good, flagfile] = starflag(s, Mode)
% s is 4STAR struct containing data and optional toggle field
% Mode is optional. 1 = automatic flags, 2 = manual flags, 3 = load
% previous flag file and optionally augment with new automated or manual
% gas_name_str - 'CWV', or 'O3', or 'NO2', or 'HCOH'
%---------------------------------------------------------------------------
%% Function to generate flags for 4STAR data
% uses different modes:
% Mode = 1 "Automatic" aerosol (except strong events) versus clouds;
% starflag is called in starsun.m file and starsun.mat will contain the
% INITIAL (i.e. "automatic") flags (i.e. vis_sun.flag and
% vis_sun.flagallcols); It also produces YYYYMMDD_starflag_auto_createdYYYYMMDD_HHMM.mat
% reset_flags=true;
%
% Mode = 2 "Manual" flagging of aerosol (e.g. smoke or dust) and
% clouds (e.g. low clouds or cirrus); starflag.m is called as stand-alone
%(i.e. outside of starsun.m) and produces YYYYMMDD_starflag_man_createdYYYYMMDD_HHMM_by_Op.mat
% and starflags_YYYYMMDD_marks_not_aerosol_created_YYYYMMDD_by_Op.m
% and starflags_YYYYMMDD_marks_smoke_created_YYYYMMDD_by_Op.m
% and starflags_YYYYMMDD_marks_cirrus_created_YYYYMMDD_vy_Op.m, etc...
% %
% Mode = 3 "Loading" a previous starflag file, with precedence of manual
% vs. auto flagging. should be called whenever the flag file is already
% there, if not, then asks user if they want to do manual or automatic

% Modification history:
% SL, v1.0, 20141013, added my name to the list of flaggers and added version control of this m script with version_set
% SL, v1.1, 2014-11-12, added Mode 3 for loading previous flag files, with
%                       inclusion of starinfo flags, considerable rebuilding
% MS, 2015-02-17,corrected a bug in line 74; definition of outputfile
%                corrected bug in lines 31,37 (disp function)
% CJF, 2015-01-09, commented "aerosol_init_auto" to make it obsolete
% CJF, 2016-01-17, added more write_starflags_mark_file examples
% SL, 2016-05-04, added special function buttons to visi_screen
% MS, 2016-05-09, modified starflag for gases
% MS, 2016-10-17, modified to add automatic QA filtering and HCOH readout
%                 use case 3 as defualt
%                 minimizing variables read from starsun
% MS, 2016-11-02, updating starflag for automatic gas flagging in
%                 starwrapper
% MS, 2016-11-02, gas_name_str - added gas name to use in starsun
%                 twaeking to read gas variables from s structure
% MS, 2016-01-16, fixing bugs related to Mode==1 gas flags
%------------------------------------------------------------------------------
version_set('1.5');
if ~exist('s','var')||isempty(s) % then select a starsun file to load parts of
    %        disp(['Loading data from ',daystr,'starsun.mat.  Please wait...']);
    s = [];
    sunfile = getfullname('*starsun*.mat','starsun','Select starsun file to flag.');
    s = load(sunfile);%,'tau_aero','m_aero','flags','t','w','rawrelstd','Lon','Lat','Alt','Pst','Tst','aerosolcols','viscols','nircols','rateaero','c0','QdVlr','QdVtb','QdVtot','ng','Md','raw','Str','dark',...
                      %'tau_aero_noscreening','darkstd','sd_aero_crit');
                 
    tmp = load('w.mat');             
    s.w = double(tmp.w);
end % done loading starinfo file

daystr = datestr(s.t(1),'yyyymmdd');

% load gas_summary file, else use s structure
if ~exist('Mode','var')||Mode==0
    Mode = 2;
end
if Mode == 2
        
        % upload gas_summary
        
        try
            %gas = load(['E:\KORUS-AQ\gas_summary\',daystr,'_gas_summary.mat']);
            gas = load(getfullname('*_gas_summary.mat','gas_summary','Select gas_summary file to flag.'));
        catch
            if strcmp(daystr,'20160426')
                %gas = load(['E:\KORUS-AQ\gas_summary\',daystr,'_gas_summary_1.mat']);
                gas = load(['E:\KORUS-AQ\gas_summary\',daystr,'_gas_summary_2.mat']);
            end
        end
end


if ~isfield(s,'sd_aero_crit') % read starinfo file
    daystr = datestr(s.t(1),'yyyymmdd');
    infofile = fullfile(starpaths, ['starinfo' daystr '.m']);
    infofile_ = ['starinfo_' daystr]
    infofile2 = ['starinfo' daystr] % 2015/02/05 for starinfo files that are functions, found when compiled with mcc for use on cluster
    if exist(infofile_)==2;
        edit(infofile_) ; % open infofile in case user wants to edit it.
        infofnt = str2func(infofile_); % Use function handle instead of eval for compiler compatibility
        s = infofnt(s);
        %     s = eval([infofile2,'(s)']);
    elseif exist(infofile2)==2;
        edit(infofile2) ; % open infofile in case user wants to edit it.
        infofnt = str2func(infofile2); % Use function handle instead of eval for compiler compatibility
        s = infofnt(s);
        %     s = eval([infofile2,'(s)']);
    elseif exist(infofile)==2;
        open(infofile);
        run(infofile); %Trying "run" instead of "eval" for better compiler compatibility
        %     eval(['run ' infofile ';']); % 2012/10/22 oddly, this line ignores the starinfo20120710.m after it was edited on a notepad (not on the Matlab editor).
    else; % copy an existing old starinfo file and run it
        while dayspast<maxdayspast;
            dayspast=dayspast+1;
            infofile_previous=fullfile(starpaths, ['starinfo' datestr(datenum(daystr, 'yyyymmdd')-dayspast, 'yyyymmdd') '.m']);
            if exist(infofile_previous);
                copyfile(infofile_previous, infofile);
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
if ~isempty(s)
    t=s.t;w=s.w;Lon=s.Lon;Lat=s.Lat;Alt=s.Alt;
    c0=s.c0;m_aero=s.m_aero;QdVlr=s.QdVlr;QdVtot=s.QdVtot;ng=s.ng;Md=s.Md;
    try;
        Pst=s.Pst;Tst=s.Tst;aerosolcols=s.aerosolcols;
        viscols=s.viscols;nircols=s.nircols;rateaero=s.rateaero;
        w = s.w;
    catch;
        disp('Missing some variables, trying anyway')
    end;
    try;
        rawrelstd=s.rawrelstd;
    catch;
        ti=9/86400;
        cc=[408 169+1044];
        pp=numel(s.t);
        s.rawstd=NaN(pp, numel(cc));
        s.rawmean=NaN(pp, numel(cc));
        for i=1:pp;
            rows=find(s.t>=s.t(i)-ti/2&s.t<=s.t(i)+ti/2 & s.Str==1); % Yohei, 2012/10/22 s.Str>0
            if numel(rows)>0;
                s.rawstd(i,:)=nanstd(s.raw(rows,cc),0,1); % stdvec.m seems to have a precision problem.
                s.rawmean(i,:)=nanmean(s.raw(rows,cc),1);
            end;
        end;
        s.rawrelstd=s.rawstd./s.rawmean;
        rawrelstd=s.rawrelstd;
    end;
    Str=s.Str;raw=s.raw;dark=s.dark;
%     if isfield(s,'tau_aero_noscreening')
%         tau_aero_noscreening=s.tau_aero_noscreening;
%     else
%         tau_aero_noscreening = s.tau_aero;
%     end
    if isfield(s,'darkstd')
        darkstd=s.darkstd;
    end
    sd_aero_crit = s.sd_aero_crit;
    
end

if ~exist('Mode','var')||Mode==0
    Mode = 2;
end
if (Mode==3);
    files = ls([starpaths,daystr,'_starflag_man_*']);
    if ~isempty(files);
        flagfile=files(end,:);
        disp(['loading file:' starpaths flagfile])
        flags = load([starpaths flagfile]);
    else
        files = ls([starpaths,daystr,'_starflag_auto_*']);
        if ~isempty(files);
            flagfile=files(end,:);
            disp(['loading file:' starpaths flagfile])
            flags = load([starpaths flagfile]);
        else
            flagfile=getfullname([daystr,'*_starflag_*.mat'],'starflag','Select starflag file');
            flags = load(flagfile);
        end;
    end;
    if isfield(flags, 'flags')
        flags = flags.flags;
    end
    if isequal(flagfile,0)
        Mode = menu('No file selected, which mode do you want to operate?','Automatic','Manual');
    end;
end;
%define operator for manual screening mode (mode=2)
if (Mode==2)
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
    
    % define gas name to analyze
     gas_name = menu('what gas field is being flagged?','CWV','O3','NO2','HCOH');
     gas_name_str = '?';
    switch gas_name
        case 1
            gas_name_str = 'CWV';
        case 2
            gas_name_str = 'O3';
        case 3
            gas_name_str = 'NO2';
        case 4
            gas_name_str = 'HCOH';    
    end
end

%Define ouput file names for both modes
starinfo_name = which(['starinfo_',daystr,'.m']); pname = fileparts(starinfo_name); pname = [pname, filesep];
now_str = datestr(now,'yyyymmdd_HHMM');
switch Mode
    case 1
        flagfile = [daystr,'_starflag_auto_created_for_',gas_name_str,'_',now_str,'.mat'];
        outputfile=[starpaths,filesep,flagfile];%This has to be starsun.mat
        op_name_str = 'auto';
        disp(['Starflag mode 1 to output to:' flagfile])
    case 2
        flagfile = [daystr,'_starflag_',gas_name_str,'_man_created',now_str, 'by_',op_name_str,'.mat'];
        outputfile=[starpaths,filesep,flagfile];
        disp(['Starflag mode 2 to output to:' flagfile])
end
 mark_fname = ['starflag_',gas_name_str,'_',op_name_str,'_all_',now_str,'.m'];
 disp(['Corresponding "marks" m-file to: ',mark_fname])


if isfield(s,'flight')
    flight = s.flight;
elseif any(Alt>0)
    flight(1) = t(find(Alt>0,1,'first'));
    flight(2) = t(find(Alt>0,1,'last'));
else
    flight(1) = t(1);
    flight(2) = t(end);
end
horilegs = [];
if isfield(s,'horileg')
    s.horilegs = s.horileg;
    s = rmfield(s,'horileg');
end
if isfield(s,'horilegs')
    horilegs = s.horilegs;
end
flags.hor_legs = false(size(t));
for r = 1:size(horilegs,1)
    flags.hor_legs = flags.hor_legs | (t>=horilegs(r,1)&t<=horilegs(r,2));
end
if isfield(s,'groundcomparison')
    groundtest = s.groundcomparison;
else
    groundtest = [];
end
flags.groundtest = false(size(t));
for r = 1:size(groundtest,1)
    flags.groundtest = flags.groundtest | (t>=groundtest(r,1)&t<=groundtest(r,2));
end

[flags,flag_info] = cnvt_ng2flags(ng,t);
flags.before_or_after_flight = t<flight(1) | t>flight(2);
if ~isfield(flags, 'bad_aod')
    flags.bad_aod = false(size(t));
end
if ~isfield(flags, 'unspecified_clouds')
    flags.unspecified_clouds = false(size(t));
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
if Mode==1
    % reading from s strcture
    % ang_noscreening=sca2angstrom(s.tau_aero_noscreening(:,colsang), w(colsang));
    aod_500nm = s.tau_aero_noscreening(:,nm_500);
    aod_865nm = s.tau_aero_noscreening(:,nm_865);
else
    try
    % reading from reduced starsun_for_starflag structure
    % ang_noscreening=s.ang_noscreening;%sca2angstrom(tau_aero_noscreening(:,colsang), w(colsang));
            aod_500nm = s.aod_500nm;%tau_aero_noscreening(:,nm_500);
            aod_865nm = s.aod_865nm;%tau_aero_noscreening(:,nm_865);
    catch
            aod_500nm = s.tau_aero_noscreening(:,nm_500);
            aod_865nm = s.tau_aero_noscreening(:,nm_865);
    end
end

% define input param to flag
if Mode == 1
        % this is automatic -reading from starsun fields
        if strcmp(gas_name_str,'CWV')
            input_param = s.cwv.cwv940m1;
            std_param   = s.cwv.cwv940m1std;
        elseif strcmp(gas_name_str,'O3')
            input_param = s.gas.o3.o3DU;
            std_param   = s.gas.o3.o3resiDU;
        elseif strcmp(gas_name_str,'NO2')
            Loschmidt=2.686763e19;                   % molec/cm3*atm
            input_param = (s.gas.no2.no2_molec_cm2)/(Loschmidt/1000);
            std_param   = s.gas.no2.no2resi;
        elseif strcmp(gas_name_str,'HCOH')
            input_param = s.gas.hcoh.hcoh_DU;
            std_param   = s.gas.hcoh.hcohresi;
        end
    
elseif Mode == 2
        
        if strcmp(gas_name_str,'CWV')
            input_param = gas.cwv;
            std_param   = gas.cwv_std;
        elseif strcmp(gas_name_str,'O3')
            input_param = gas.o3DU;
            std_param   = gas.o3resiDU;
        elseif strcmp(gas_name_str,'NO2')
            input_param = gas.no2DU;
            std_param   = gas.no2resiDU;
        elseif strcmp(gas_name_str,'HCOH')
            input_param = gas.hcoh_DU;
            std_param   = gas.hcohresi;
        end

end

aod_500nm_max=3;%s.aod_500nm_max;%3
m_aero_max=15;

% % initializing a logical field
% good_ang = true(size(ang_noscreening));
% % Here is an example of how to use logical flags in succession without
% % overwriting initial results.  If this section is run repeatedly a smaller
% % and smaller subset of "good_ang" values would be true and screened by
% % madf_span.
% [good_ang(good_ang)] = madf_span(ang_noscreening(good_ang),50,3);sum(good_ang)



%Fixed pre-screening in the case of Mode 1 automatic
% this is very stringent flagging
if (Mode==1)    
     flags_str.before_or_after_flight = 'flags.before_or_after_flight | (t<flight(1)|t>flight(2))';
                if strcmp(gas_name_str,'CWV')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>0.1 |  std_param==0 | ~isfinite(input_param) | isnan(input_param) | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'O3')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<200 | std_param>0.5 |  std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'NO2')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>4e-4 | std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'HCOH')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>4e-4 | std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                 
                end
            %end
            flags_str.unspecified_clouds = '';
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
            % define here pre-screened std criteria
            flags_str.before_or_after_flight = 'flags.before_or_after_flight | (t<flight(1)|t>flight(2))';
            %flags_str.unspecified_clouds = 'flags.unspecified_clouds | aod_500nm>aod_500nm_max | (ang_noscreening<.2 & aod_500nm>0.08) | rawrelstd(:,1)>sd_aero_crit';
            %if exist('darkstd','var')
            %    flags_str.bad_aod = 'aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500) | c0(:,nm_500)<=0';
            %else
                % original: flags_str.bad_aod = 'flags.bad_aod | aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | c0(:,nm_500)<=0';
                % previously std_param for CWV was 0.4, and O3 was 2 (less
                % stringent)
                if strcmp(gas_name_str,'CWV')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>0.1 |  std_param==0 | ~isfinite(input_param) | isnan(input_param) | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'O3')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<200 | std_param>0.5 |  std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'NO2')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>4e-4 | std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'HCOH')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>4e-4 | std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                 
                end
            %end
            flags_str.unspecified_clouds = '';
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
            flags_str.unspecified_clouds = 'aod_500nm>aod_500nm_max | (ang_noscreening<.2 & aod_500nm>0.08) | rawrelstd(:,1)>sd_aero_crit';
            if exist('darkstd','var')
                flags_str.bad_aod = 'aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500) | c0(:,nm_500)<=0';
            else
                flags_str.bad_aod = 'aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | c0(:,nm_500)<=0';
            end
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
            [sourcefile, ext, ~,filen]=starsource(source, 'sun');
            if exist('sourcefile','var')&&~isempty(sourcefile) && exist(sourcefile{1},'file')
                flags = load(sourcefile{1});
            else
                flags = load(getfullname([daystr,'*_starflag_*.mat'],'starflag','Select starflag file'));
            end
            if isfield(flags,'flags')
                flags = flags.flags;
            end
            %             load(sourcefile{1}); THIS IS TO READ MK's FILE
            %             flags=load(sourcefile{1});%THIS IS TO READ MICHAL's FILE
            if isfield(flags,'time')&&isfield(flags.time,'t')
                t=flags.time.t;
            end
            reset_flags=false;
        case 6 %'Previous flags:Yes separate file, your own pre-screening:Yes');
            clear('flags')
            source='ask';
            [sourcefile, ext, ~,filen]=starsource(source, 'sun');
%             if exist('sourcefile','var') && ~isempty(sourcefile) && exist(sourcefile{1},'file')
%                 flags = load(sourcefile{1});
%             else
                flags = load(getfullname([daystr,'*_starflag_*.mat'],'starflag','Select starflag file'));
            %end
            if isfield(flags,'flags')
                flags = flags.flags;
            end
            %Users need to modify what's below:
              flags_str.before_or_after_flight = 'flags.before_or_after_flight | (t<flight(1)|t>flight(2))';
            %flags_str.unspecified_clouds = 'flags.unspecified_clouds | aod_500nm>aod_500nm_max | (ang_noscreening<.2 & aod_500nm>0.08) | rawrelstd(:,1)>sd_aero_crit';
            %if exist('darkstd','var')
            %    flags_str.bad_aod = 'aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | raw(:,nm_500)-dark(:,nm_500)<=darkstd(:,nm_500) | c0(:,nm_500)<=0';
            %else
                % original: flags_str.bad_aod = 'flags.bad_aod | aod_500nm<0 | aod_865nm<0 | ~isfinite(aod_500nm) | ~isfinite(aod_865nm) | ~(Md==1) | ~(Str==1) | (m_aero>m_aero_max) | c0(:,nm_500)<=0';
                % previously std_param for CWV was 0.4, and O3 was 2 (less
                % stringent)
                if strcmp(gas_name_str,'CWV')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>0.1 |  std_param==0 | ~isfinite(input_param) | isnan(input_param) | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'O3')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<200 | std_param>0.5 |  std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'NO2')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>4e-4 | std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                elseif strcmp(gas_name_str,'HCOH')
                        flags_str.bad_aod = 'flags.bad_aod | input_param<0 | std_param>4e-4 | std_param==0 |~isfinite(input_param) | isnan(input_param)  | ~isfinite(std_param) | isnan(std_param) | (m_aero>m_aero_max)';
                 
                end
            %end
            flags_str.unspecified_clouds = '';
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
    auto_settings = flags_str;
end

qual_flag = bitor(flags.before_or_after_flight,flags.bad_aod);

% I think we don't need "aerosol_init_auto" flag at all.
% if (Mode==1)
%    % I think this has the sense of the flags reversed.
%    % Flags need to be "true" for "bad"
% %     flags.aerosol_init_auto=(~flags.before_or_after_flight & ~flags.bad_aod & ~flags.unspecified_clouds);
%     flags.aerosol_init_auto= flags.bad_aod | flags.unspecified_clouds;
% end

if (Mode==2)
    %Run visi_screen in manual mode (mode=2)
    %We define several fields to plot in the auxiliary panels
    panel_1.aod_500nm = aod_500nm;
    panel_1.aod_865nm = aod_865nm;
    panel_2.param = input_param;
    %panel_2.std_ang = sliding_std(ang_noscreening,10)';
    panel_3.rawrelstd = std_param;
    panel_4.Alt = Alt;
    
    ylims.panel_1 = [-.1, 2];
    ylims.panel_2 = [min(input_param) max(input_param)];
    ylims.panel_3 = [min(std_param) max(std_param)];
    ylims.panel_4 = [0,8000];
    ylims.tau_fig = [min(input_param) max(input_param)];
    ylims.tau2_fig= [min(input_param) max(input_param)];
    figs.tau_fig.h = 1;
    figs.tau2_fig.h = 2;
    figs.leg_fig.h = 3;
    figs.aux_fig.h = 4;
    figs.tau_fig.pos = [ 0.2990    0.5250    0.2917    0.3889];
    figs.tau2_fig.pos = [0.3021    0.0537    0.2917    0.3889];
    figs.leg_fig.pos =   [ 0.1109    0.5731    0.1776    0.3611];
    figs.aux_fig.pos = [0.6167 0.0769 0.2917 0.8306];
    
    % Define flags which do not flag data as "bad".
    no_mask = {'smoke','dust','unspecified_aerosol','before_or_after_flight','hor_legs', 'vert_legs'};
    %Once flags are specified above, the "bad" flags are deduced.
    %"bad" flags gray out symbols in plots and show >0 in variable "screen"
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
    
    % define which param to send to main screen
    
    [flags, screen, good, figs] = visi_screen_gases(t,input_param,'time_choice',2,'flags',flags,'no_mask',no_mask,'figs',figs,...
        'panel_1', panel_1, 'panel_2',panel_2,'panel_3',panel_3,'panel_4',panel_4,'ylims',ylims, 'figs',figs,...
        'special_fn_name','Change sd_aero_crit','special_fn_flag_name','unspecified_clouds','special_fn_flag_str',flags_str.unspecified_clouds,'special_fn_flag_var','sd_aero_crit','gas',gas_name_str);
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
    manual_flags.screen=logical(screen); % bitwise mapping of flags not in screen_bad_list into uint32.
    if exist('auto_settings','var')
        manual_flags.auto_settings = auto_settings;
    end
    manual_flags.flagfile = flagfile;
    flags.manual_flags = manual_flags;
    % Output an m-file representing all these flags in "ng" format
    [flag_all, flag_names_all, flag_tag_all] = cnvt_flags2ng(t, flags);
    if ~isempty(flag_all)
        [all_str, all_fname] = write_starflags_marks_file_gases(flag_all,flag_names_all,flag_tag_all,daystr,'all', op_name_str,now_str,gas_name_str);
    end
    
    % Output an m-file marking all not_good_aerosol events
    [flag_aod, flag_names_aod, flag_tag_aod] = cnvt_flags2ng(t, flags,~good);
    if ~isempty(flag_aod)
        aod_str = write_starflags_marks_file_gases(flag_aod,flag_names_aod,flag_tag_aod,daystr,'not_good_aerosol', op_name_str,now_str,gas_name_str);
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
        other_str = write_starflags_marks_file_gases(flag_other,flag_names_other,flag_tag_other,daystr,'other_flagged_events', op_name_str,now_str,gas_name_str);
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
        cloud_str = write_starflags_marks_file_gases(flag_cloud,flag_names_cloud,flag_tag_cloud,daystr,'cloud_events', op_name_str,now_str,gas_name_str);
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
                selected_str = write_starflags_marks_file_gases(flag_selected,flag_names_selected,flag_tag_selected,daystr,this_str, op_name_str,now_str,gas_name_str);
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



