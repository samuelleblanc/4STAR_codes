function [qual_flag,t] = get_starflags(daystr,t_in)
%% Details of the program:
% NAME:
%   get_starflags
%
% PURPOSE:
%   To wrap up the required codes to get QA flags, defined from the
%   starinfo files
%
% CALLING SEQUENCE:
%   qual_flag = get_starflags(daystr,t_in)
%
% INPUT:
%  daystr: the daystr of the day to get the flight
%  t_in: input time which is used to match the flags.
%
% OUTPUT:
%  qual_flag: binary flags for the flight
%  t: time of the qual_flag
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
    OK =menu('flagfilename not defined in starinfo','Use the most recent starflag file?','Abort');
    if OK ==1;
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
else
    error('No flagfile that are useable')
end

if exist('t_in','var')
    % t_in exists, so we should compare the time of the flag to the one
    % supplied
    if isfield(flag,'time')
        t = flag.time.t;
    elseif isfield(flag,'flags')
        if isfield(flag.flags,'t');
            t = flag.flags.t;
        elseif isfield(flag.flags,'time')
            t = flag.flags.time.t;
        end;
    elseif isfield(flag,'t')
        t = flag.t;
    else
        error('*** No time defined in the flag file ***')
    end;
    
    if ~(length(t_in)==length(t))
        if length(t_in)<length(t)
            disp('Time variable is smaller than flagged variables. reducing the dimension and matching the times')
            [te,ite] = intersect(t,t_in);
            if length(te)==length(t_in); % the t_in is simply a subset of t
                qual_flag = qual_flag(ite);
                t = t(ite);
            else % bruteforce get the closest values using a knn member isolation
                disp('...Not all times match exactly, getting the nearest neighbor, within 2 seconds')
                [ii,dt] = knnsearch(t,t_in);
                idd = dt<2.0/3600.0/24.0; % Distance no greater than two seconds.
                if length(ii(idd))<length(t_in)
                    error('The time differences are larger than 2 seconds, need to reflag')
                end;
                qual_flag = qual_flag(ii(idd));
                t = t(ii(idd));
            end
        elseif (length(t_in)-length(t))<600 %about 5 minutes
            disp('Time variable is larger than flagged. Finding closes times, and extrapolating')
            [te,ite] = intersect(t_in,t);
            if length(te)==length(t); % the t_in encompasses the flag t, simply need to extrapolate a bit
                qflag = logical(t_in);
                qflag(ite) = qual_flag;
                if ite(1)>1; % the first values starts after
                    qflag(1:ite(1)) = qflag(ite(1));
                end;
                if ite(end)<(length(t)-ite(1)) % the last values are past the ending 
                    qflag(ite(end):end) = qflag(ite(end));
                end;
                qual_flag = qflag;
                t = t_in;
            else % bruteforce knn nearest neighbor
                [ii,dt] = knnsearch(t,t_in);
                idd = dt<2.0/3600.0/24.0; % Distance no greater than two seconds.
                if length(ii(idd))<length(t_in)
                    error('The time differences are larger than 2 seconds, need to reflag')
                end;
                qual_flag = qual_flag(ii(idd));
                t = t_in;
            end;
        else
            error('Time variable input is much larger than flag file. Must reflag')
        end;
    end
end;
return;