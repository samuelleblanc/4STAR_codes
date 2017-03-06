function [flight_alb, out_time] = get_ssfr_flight_albedo(in_time,in_lambda)
% [flight_alb, out_time] = get_ssfr_flight_albedo(in_time,in_lambda)
% in_time is required
% in_lambda is optional. Will load txt file for lambda if not provided.
if exist('in_time','var')
    file_str = [datestr(in_time(1),'yyyymmdd'), '_SSFR.mat;',...
        datestr(in_time(1),'yyyymmdd'), '_SSFR.cdf; '...
        datestr(in_time(1),'yyyymmdd'), '_SSFR.ict;',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.mat;',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.cdf;',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.ict'];
else
    file_str = ['_SSFR.mat; *_SSFR.cdf; *_SSFR.ict'];
end
if ~any(in_lambda>100)
    in_lambda = 1000.* in_lambda;
end

pause(0.1);in_file = getfullname(file_str,'ssfr_alb','Select SSFR mat or cdf file');
if exist(in_file,'file')
    [pname, fname, ex] = fileparts(in_file);
    if strcmp(ex,'.mat')
        ssfr = load(in_file);
    elseif strcmp(ex,'.cdf')
        ssfr = fix_ssfr_nc_time(in_file);
    elseif strcmp(ex,'.ict')
       ssfr = rd_ict(in_file);
    end
end
pause(0.1);

ainb = interp1(ssfr.time,[1:length(ssfr.time)],in_time,'nearest','extrap');
if isfield(ssfr,'vars')
    ssfr_up = ssfr.vars.NSPECTRA.data(:,ainb);
    ssfr_down = ssfr.vars.ZSPECTRA.data(:,ainb);
    if exist('in_lambda','var')
        ssfr_up_alb = interp1(ssfr.vars.NADLAMBDA.data, ssfr_up, 1e3.*in_lambda,'linear');
        ssfr_down_alb = interp1(ssfr.vars.ZENLAMBDA.data, ssfr_down, 1e3.*in_lambda,'linear');
        flight_alb = ssfr_up_alb./ssfr_down_alb;
        flight_alb(flight_alb<0|flight_alb>1) = NaN;
        figure; plot(1e3.*in_lambda, flight_alb,'r-');
    else
        ssfr_alb = load(['D:\data\seac4rs\alb4connor\20130806_2306UTC.txt'])
        ssfr_up_alb = interp1(ssfr.vars.NADLAMBDA.data, ssfr_up, ssfr_alb(:,1),'linear');
        ssfr_down_alb = interp1(ssfr.vars.ZENLAMBDA.data, ssfr_down, ssfr_alb(:,1),'linear');
        flight_alb = ssfr_up_alb./ssfr_down_alb;
        flight_alb(flight_alb<0|flight_alb>1) = NaN;
        figure; plot(ssfr_alb(:,1),ssfr_alb(:,2),'ok-',ssfr_alb(:,1), flight_alb,'r-');
    end
elseif isfield(ssfr,'vdata')
    ssfr_up = ssfr.vdata.NSPECTRA(:,ainb);
    ssfr_down = ssfr.vdata.ZSPECTRA(:,ainb);
    if exist('in_lambda','var')
        ssfr_up_alb = interp1(ssfr.vdata.NADLAMBDA, ssfr_up, 1e3.*in_lambda,'linear');
        ssfr_down_alb = interp1(ssfr.vdata.ZENLAMBDA, ssfr_down, 1e3.*in_lambda,'linear');
        flight_alb = ssfr_up_alb./ssfr_down_alb;
        flight_alb(flight_alb<0|flight_alb>1) = NaN;
        figure; plot(1e3.*in_lambda, flight_alb,'r-');
    else
        ssfr_alb = load(['D:\data\seac4rs\alb4connor\20130806_2306UTC.txt'])
        ssfr_up_alb = interp1(ssfr.vdata.NADLAMBDA, ssfr_up, ssfr_alb(:,1),'linear');
        ssfr_down_alb = interp1(ssfr.vdata.ZENLAMBDA, ssfr_down, ssfr_alb(:,1),'linear');
        flight_alb = ssfr_up_alb./ssfr_down_alb;
        flight_alb(flight_alb<0|flight_alb>1) = NaN;
        figure; plot(ssfr_alb(:,1),ssfr_alb(:,2),'ok-',ssfr_alb(:,1), flight_alb,'r-');
    end        
elseif isfield(ssfr,'DN415')
    fields = fieldnames(ssfr);
    ssfr_down = []; ssfr_up = []; wl = [];
    for fld = 1:length(fields)
        field = fields{fld};
        if strcmp(field(1:2),'DN')
            wl(end+1) = sscanf(field(3:end),'%f');
            ssfr_down(end+1,:) = ssfr.(field)';
            ssfr_up(end+1,:) = ssfr.(strrep(field,'DN','UP'))';
        end
    end 
    ssfr_up = ssfr_up(:,ainb);
    ssfr_down = ssfr_down(:,ainb);    
    ssfr_alb = ssfr_up./ssfr_down;
    ssfr_alb(ssfr_alb<0|ssfr_alb>1) = NaN;
    flight_alb = interp1(wl', ssfr_alb, in_lambda,'linear');    
end
out_time = ssfr.time(ainb);
return

