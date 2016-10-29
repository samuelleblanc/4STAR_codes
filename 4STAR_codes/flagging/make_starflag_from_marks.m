function make_starflag_from_marks(marks_file,starsun_file)
%% Details of the program:
% NAME:
%   make_starflag_from_marks
% 
% PURPOSE:
%  Create a starflag file from the marks all file
%
% INPUT:
%  marks_file: (optional) full file path of the marks file to be read
%  starsun_file: (optional) full file path of the starsun file containing
%  the correct time (t) variable. 
% 
% OUTPUT:
%  staflag save file
%
% DEPENDENCIES:
%  - version_set.m (for version control of the script)
%  - cnvt_ng2flags.m
%  - getgullname.m
%
% NEEDED FILES:
%  - marks files (.m) and starsun files (.mat) for the same day
%
% EXAMPLE:
%   NA
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, CA, 2016-10-24
% Modified (v1.1): 
%
% -------------------------------------------------------------------------

%% start of function
version_set('1.0');

%% load the marks file
if ~exist('marks_file','var')||~isstruct(marks_file)
    if ~exist('marks_file','var')||~exist(marks_file,'file')
      marks_file = getfullname('starflags_*_marks_*.m','star_marks','Select star mark file');
    end
end
marked = get_starinfo_parts(marks_file);
try
    marks = marked.data;
    starinfo = false;
catch
    marks = marked.ng;
    starinfo = true;
end
%% load the time variable from the starsun
if ~exist('starsun_file','var')||~isstruct(starsun_file)
    if ~exist('starsun_file','var')||~exist(starsun_file,'file')
      starsun_file = getfullname('*starsun_*.mat','starsun','Select starsun file for flagging');
    end
end

s = load(starsun_file,'t');

%% translate the marks to starflags
[flags,flag_info,t] = cnvt_ng2flags(marks,s.t);

%% create the variables to be saved
f.bad_aod = [];
f.before_or_after_flight = [];
f.cirrus = [];
f.dust = [];
f.flagfile = '';
f.frost = [];
f.hor_legs = [];
f.low_cloud = [];
f.smoke = [];
f.t = [];
f.unspecified_aerosol = [];
f.unspecified_clouds = [];
f.vert_legs = [];

flag = catstruct(f,flags);

%% create name a save the file
if starinfo
    daystr = datestr(s.t(1),'yyyymmdd');
    dnow = datestr(now,'yyyymmdd_HHMM');
    flag.flagfile = [daystr,'_starflag_man_created', dnow, '_from_starinfo.mat']
else
    hh = strsplit(marks_file,'_');
    flag.flagfile = [hh{2},'_starflag_man_created', hh{6}, '_', hh{end}(1:4), 'by_', hh{3}, '_from_marks.mat']
end
save(flag.flagfile,'-struct','flag');


