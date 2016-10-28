function qual_flag = get_starflags(daystr)
%% Details of the program:
% NAME:
%   get_starflags
%
% PURPOSE:
%   To wrap up the required codes to get QA flags, defined from the
%   starinfo files
%
% CALLING SEQUENCE:
%   qual_flag = get_starflags(daystr)
%
% INPUT:
%  daystr: the daystr of the day to get the flight
%
% OUTPUT:
%  QAflag: binary flags for the flight
%
% DEPENDENCIES:
%  - version_set.m
%  - ...
%
% NEEDED FILES:
%  - starinfo for the flight with the flagfile defined 
%  - flagfile 
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, Moffett, CA, 2016-10-28
% -------------------------------------------------------------------------

%% function start
version_set('v1.0')

infofile_ = ['starinfo_' daystr '.m'];
infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
s.dummy = '';
try
    s = infofnt(s);
catch
    eval([infofile_(1:end-2),'(s)']);
end

%% Load the flag file
if isfield(s, 'flagfilename');
    disp(['Loading flag file: ' s.flagfilename])
    flag = load(s.flagfilename); 
else
    files = ls([starpaths,daystr,'_starflag_man_*']);
    if ~isempty(files);
        flagfile=files(end,:);
        disp(['loading file:' starpaths flagfile])
        flag = load([starpaths flagfile]);
    else
        files = ls([starpaths,daystr,'_starflag_auto_*']);
        if ~isempty(files);
            flagfile=files(end,:);
            disp(['loading file:' starpaths flagfile])
            flag = load([starpaths flagfile]);
        else
            flagfile=getfullname([daystr,'*_starflag_*.mat'],'starflag','Select starflag file');
            flag = load(flagfile);
        end;
    end;
end

%% Combine the flag values
disp('Setting the flags')
if isfield(flag,'manual_flags');
    qual_flag = ~flag.manual_flags.good;
elseif strcmp(daystr,'20160529') || strcmp(daystr,'20160601') || strcmp(daystr,'20160604')
    qual_flag = bitor(flag.flags.before_or_after_flight,flag.flags.bad_aod);
    qual_flag = bitor(qual_flag,flag.flags.cirrus);
    qual_flag = bitor(qual_flag,flag.flags.frost);
    qual_flag = bitor(qual_flag,flag.flags.low_cloud);
    qual_flag = bitor(qual_flag,flag.flags.unspecified_clouds);
elseif isfield(flag,'flags');
    qual_flag = bitor(flag.flags.before_or_after_flight,flag.flags.bad_aod);
    qual_flag = bitor(qual_flag,flag.flags.cirrus);
    qual_flag = bitor(qual_flag,flag.flags.frost);
    qual_flag = bitor(qual_flag,flag.flags.low_cloud);
    qual_flag = bitor(qual_flag,flag.flags.unspecified_clouds);
elseif isfield(flag,'before_or_after_flight');
    % only for automatic flagging
    qual_flag = bitor(flag.before_or_after_flight,flag.bad_aod);
    try
        qual_flag = bitor(qual_flag,flag.cirrus);
        qual_flag = bitor(qual_flag,flag.frost);
        qual_flag = bitor(qual_flag,flag.low_cloud);
        qual_flag = bitor(qual_flag,flag.unspecified_clouds);
    catch
        disp('No flags for cirrus, frost, low_cloud, or unsecified_clouds found, Keep moving on')
    end
elseif isfield(flag,'screened')
   flag_tags = [1  ,2 ,3,10,90,100,200,300,400,500,600,700,800,900,1000];
   flag_names = {'unknown','before_or_after_flight','tracking_errors','unspecified_clouds','cirrus',...
                 'inst_trouble' ,'inst_tests' ,'frost','low_cloud','hor_legs','vert_legs','bad_aod','smoke','dust','unspecified_aerosol'};
    for tag = 1:length(flag_tags)
        flag.(flag_names{tag}) = flag.screened==flag_tags(tag);
    end  
    qual_flag = bitor(flag.before_or_after_flight,flag.bad_aod);
    qual_flag = bitor(qual_flag,flag.cirrus);
    qual_flag = bitor(qual_flag,flag.frost);
    qual_flag = bitor(qual_flag,flag.low_cloud);
    qual_flag = bitor(qual_flag,flag.unspecified_clouds);
    if length(flag.screened)==length(t);
       flag.time.t = t; 
    end
else
    error('No flagfile that are useable')
end

return;