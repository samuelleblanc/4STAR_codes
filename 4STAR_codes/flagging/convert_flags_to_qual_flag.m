function [qual_flag,flag] = convert_flags_to_qual_flag(flag,t,flight);
%% Function to convert the various flags in the flags starflag struct
% Can be applied to older starflags versions
% qual_flag : 1 for bad aod, 0 for good aod


%% core of flas
if isfield(flag,'manual_flags');
    qual_flag = ~flag.manual_flags.good;
elseif isfield(flag,'flags');
    qual_flag = bitor(flag.flags.before_or_after_flight,flag.flags.bad_aod);
    if isfield(flag.flags,'cirrus'); qual_flag = bitor(qual_flag,flag.flags.cirrus); end;
    if isfield(flag.flags,'frost'); qual_flag = bitor(qual_flag,flag.flags.frost); end;
    if isfield(flag.flags,'low_cloud'); qual_flag = bitor(qual_flag,flag.flags.low_cloud); end;
    if isfield(flag.flags,'unspecified_clouds'); qual_flag = bitor(qual_flag,flag.flags.unspecified_clouds); end;
elseif isfield(flag,'before_or_after_flight');
    % only for automatic flagging
    if length(flag.before_or_after_flight) <1;
        if nargin<2;
            try;
                flag.before_or_after_flight = flag.t<= flag.t(1) | flag.t>= flag.t(end);
            catch;
                flag.before_or_after_flight = flag.unspecified_clouds.*0;
            end;
        else;
            flag.before_or_after_flight = t<flight(1) | t>flight(2);
            try
                flag.time.t = flag.t;
            catch
                flag.time.t = t;
            end;
        end;
    end
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
    if nargin > 1;
        if length(flag.screened)==length(t);
            flag.time.t = t;
        end
    end;
else
    
    error('No flagfile that are useable')
end
return