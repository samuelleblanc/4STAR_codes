function [flags_out,inp] = define_starflags_20160605(s, flags_in);
% [flags_out,inp] = define_starflags_20160605(s, flags_in);
% define flags for use in visiscreen.  This includes initial population
% of "auto" screens as well as manual flags.

% Note the date in the function name.  The idea here is that we may
% develope specific date-stamped flagging routines for different missions
% or purposes. In conjunction with changes in this function, there may also
% be date-specific changes in the set_starflags_yyyymmdd function below.  

if ~exist('flags_in','var')
    flags_in = [];
end

% First load some fields that should always exist in starsun
w=s.w; Lon=s.Lon; Lat=s.Lat; Alt=s.Alt; Pst=s.Pst; Tst=s.Tst; aerosolcols=s.aerosolcols;
viscols=s.viscols; nircols=s.nircols; rateaero=s.rateaero;
c0=s.c0; m_aero=s.m_aero; QdVlr=s.QdVlr; QdVtb=s.QdVtb; QdVtot=s.QdVtot; ng=s.ng;Md=s.Md;
Str=s.Str; raw=s.raw; dark=s.dark; 
%CJF:  Loop below uses t but never defined? Error popped up during sky scan
%processing but I don't see how it could ever have run. Maybe catch 
t = s.t;

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
if isfield(s,'darkstd')||isprop(s,'darkstd')
    darkstd=s.darkstd;
else
    disp('no darkstd')
end
try
    sd_aero_crit = s.sd_aero_crit;
catch
    disp('no sd_aero_crit');
end
t = s.t;
daystr = datestr(t(1), 'yyyymmdd');
starinfo_name = which(['starinfo_',daystr,'.m']); pname = fileparts(starinfo_name); pname = [pname, filesep];

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
[flags_in,flag_info] = cnvt_ng2flags(ng,t);
if ~exist('flags_str','var')
    flags_str = [];
end


%%
% if Mode==1 %Automatic mode

flag_names = {'before_or_after_flight','bad_aod','frost','unspecified_clouds','low_cloud','cirrus','smoke','dust','hor_legs','spiral'};
flag_noted =  {'before_or_after_flight','smoke','dust','hor_legs','spiral'}; % This subset of flags don't gray out the value

for ff = 1:length(flag_names)
    name = char(flag_names(ff));
    if ~isfield(flags_in,name)
        flags_in.(name) = [];
    end
end

inp.t = s.t;
w = s.w;
Alt = s.Alt;
if isfield(s,'flight')
    flight = s.flight;
elseif any(Alt>0)
    flight(1) = inp.t(find(Alt>0,1,'first'));
    flight(2) = inp.t(find(Alt>0,1,'last'));
else
    flight(1) = inp.t(1);
    flight(2) = inp.t(end);
end

inp.flight = flight;
inp.Md = s.Md; 
inp.Str = s.Str;
inp.sd_aero_crit = s.sd_aero_crit;
if ~isfield(s,'rawrelstd')&&isavar('rawrelstd') 
   s.rawrelstd = rawrelstd;
end
inp.rawrelstd = s.rawrelstd(:,1);

nm_380 = interp1(w,[1:length(w)],.38, 'nearest');
nm_500 = interp1(w,[1:length(w)],.5, 'nearest');
nm_870 = interp1(w,[1:length(w)],.87, 'nearest');
nm_452 = interp1(w,[1:length(w)],.452, 'nearest');
nm_865 = interp1(w,[1:length(w)],.865, 'nearest');
inp.colsang=[nm_452 nm_865];
tau_aero_noscreening = s.tau_aero_noscreening;
inp.ang_noscreening=sca2angstrom(tau_aero_noscreening(:,inp.colsang), w(inp.colsang));
inp.aod_380nm = tau_aero_noscreening(:,nm_380);
inp.aod_452nm = tau_aero_noscreening(:,nm_452);
inp.aod_500nm = tau_aero_noscreening(:,nm_500);
inp.aod_865nm = tau_aero_noscreening(:,nm_865);
inp.aod_500nm_max=3;
inp.min_aod = -0.05;
inp.m_aero = s.m_aero;
inp.m_aero_max=15;
c0 = s.c0;                % cjf: I think negative or non-physical c0 would be better 
inp.c0_500nm = c0(nm_500);% handled by setting c0(c0<=) = NaN instead of setting a flag
raw = s.raw; inp.raw_500nm = raw(:,nm_500); clear raw
dark = s.dark; inp.dark_500nm = dark(:,nm_500); clear dark
darkstd = s.darkstd; inp.darkstd_500nm = darkstd(:,nm_500); clear darkstd

flags_out = set_starflags_20160605(inp,flags_in);
flags_out.flag_struct.flag_str = capture_m('set_starflags_20160605.m');
flags_out.flag_struct.flag_names = flag_names;
flags_out.flag_struct.flag_noted = flag_noted;

return

