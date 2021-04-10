function [flight_alb, out_time, min_alb, max_alb] = get_ssfr_flight_albedo(in_time,in_lambda, w_ii)
% [flight_alb, out_time, min_alb, max_alb] = get_ssfr_flight_albedo(in_time,in_lambda, w_ii)
% in_time is required
% in_lambda is optional. Will load txt file for lambda if not provided.
% 
% CJF: v1.2, 2021-04-09, Modified to include error bar plot showing min and
% max values of sfc albedo over sky scan, and output same.
version_set('1.2');
if exist('in_time','var')
    file_str = [datestr(in_time(1),'yyyymmdd'), '_SSFR.mat; ',...
        datestr(in_time(1),'yyyymmdd'), '_SSFR.cdf; '...
        datestr(in_time(1),'yyyymmdd'), '_SSFR.ict; ',...
        datestr(in_time(1),'yyyymmdd'), '_*.out; ',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.mat; ',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.cdf; ',...
        '*',datestr(in_time(1),'yyyymmdd'), '*.out; ',...
        '*SSFR*',datestr(in_time(1),'yyyymmdd'), '*.ict'];
else
    file_str = ['_SSFR.mat; *_SSFR.cdf; *SSFR*.ict ; *.out'];
end
if ~exist('in_lambda','var')
    in_lambda = 500;
end
if ~any(in_lambda>100)
    in_lambda = 1000.* in_lambda;
end
list = [];
while isempty(list)
    [list,pname] = dir_(file_str,'ssfr_alb');
    if isempty(list) setnamedpath('ssfr_alb'); end
end
in_file = dirlist_to_filelist(list,pname);
if length(in_file)~=1 || ~isafile(char(in_file))
    pause(0.1);in_file = getfullname(file_str,'ssfr_alb','Select SSFR mat or cdf file');
else
    in_file = in_file{1};
end
if isafile(in_file)
    [pname, fname, ex] = fileparts(in_file);
    if strcmp(ex,'.mat')
        ssfr = load(in_file);
    elseif strcmp(ex,'.cdf')
        ssfr = fix_ssfr_nc_time(in_file);
    elseif strcmp(ex,'.ict')
        ssfr = rd_ict(in_file);
    elseif strcmp(ex,'.out')
        ssfr = restore_idl(in_file); [pname, fname] = fileparts(in_file);
        if contains(in_file,'calibspcs')
            filedate = strtok(fname, '_');
            ssfr.time = datenum(filedate,'yyyymmdd') + ssfr.TMHRS./24;
            ssfr.nm = ssfr.NADLAMBDA;
        else
            [~,filedate] = strtok(fname,'_'); filedate(1) = [];
            ssfr.time = datenum(filedate,'yyyymmdd') + ssfr.UTC./24;
            ssfr.nm = ssfr.WL;
        end
        
    end
    % end
    [times, good_ii] = unique(ssfr.time);
    i = 1;
    while i < length(good_ii)
        if good_ii(i)< good_ii(i+1)
            i = i +1;
        else
            good_ii(i+1) = [];
        end
    end
    
    pause(0.1);
    if ~isavar('in_time') in_time = mean(ssfr.time(good_ii)); end
    ainb = interp1(ssfr.time(good_ii),good_ii,in_time,'nearest','extrap');
    if isfield(ssfr,'vars') % old-style ANC struct
        ssfr_up = ssfr.vars.NSPECTRA.data(:,ainb);
        ssfr_down = ssfr.vars.ZSPECTRA.data(:,ainb);
        if exist('in_lambda','var')
            ssfr_up_alb = interp1(ssfr.vars.NADLAMBDA.data, ssfr_up, in_lambda,'linear');
            ssfr_down_alb = interp1(ssfr.vars.ZENLAMBDA.data, ssfr_down, in_lambda,'linear');
            flight_alb = ssfr_up_alb./ssfr_down_alb;
            flight_alb(flight_alb<0|flight_alb>1) = NaN;
            figure_(442); plot(1e3.*in_lambda, flight_alb,'r-');
        else
            ssfr_alb = load(['D:\data\seac4rs\alb4connor\20130806_2306UTC.txt'])
            ssfr_up_alb = interp1(ssfr.vars.NADLAMBDA.data, ssfr_up, ssfr_alb(:,1),'linear');
            ssfr_down_alb = interp1(ssfr.vars.ZENLAMBDA.data, ssfr_down, ssfr_alb(:,1),'linear');
            flight_alb = ssfr_up_alb./ssfr_down_alb;
            flight_alb(flight_alb<0|flight_alb>1) = NaN;
            figure_(442); plot(ssfr_alb(:,1),ssfr_alb(:,2),'ok-',ssfr_alb(:,1), flight_alb,'r-');
        end
    elseif isfield(ssfr,'vdata') % new style ANC struct
        ssfr_up = ssfr.vdata.NSPECTRA(:,ainb);
        ssfr_down = ssfr.vdata.ZSPECTRA(:,ainb);
        if exist('in_lambda','var')
            ssfr_up_alb = interp1(ssfr.vdata.NADLAMBDA, ssfr_up, in_lambda,'linear');
            ssfr_down_alb = interp1(ssfr.vdata.ZENLAMBDA, ssfr_down, in_lambda,'linear');
            flight_alb = ssfr_up_alb./ssfr_down_alb;
            flight_alb(flight_alb<0|flight_alb>1) = NaN;
            figure_(442); plot(1e3.*in_lambda, flight_alb,'r-');
        else
            ssfr_alb = load(['D:\data\seac4rs\alb4connor\20130806_2306UTC.txt'])
            ssfr_up_alb = interp1(ssfr.vdata.NADLAMBDA, ssfr_up, ssfr_alb(:,1),'linear');
            ssfr_down_alb = interp1(ssfr.vdata.ZENLAMBDA, ssfr_down, ssfr_alb(:,1),'linear');
            flight_alb = ssfr_up_alb./ssfr_down_alb;
            flight_alb(flight_alb<0|flight_alb>1) = NaN;
            figure_(442); plot(ssfr_alb(:,1),ssfr_alb(:,2),'ok-',ssfr_alb(:,1), flight_alb,'r-');
        end
    elseif isfield(ssfr,'DN415') % maybe ICT?
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
        miss = ssfr_up<-1000|ssfr_down<-1000;
        ssfr_up(miss) = NaN; ssfr_down(miss) = NaN;
        ssfr_alb = ssfr_up./ssfr_down;
        ssfr_alb(ssfr_alb<0|ssfr_alb>1) = NaN; ssfr_alb(miss) = NaN;
        flight_alb = interp1(wl', ssfr_alb, in_lambda,'linear');
        xl_time = mean(ssfr.time(ainb));
        figure_(442);
        xx(1) = subplot(3,1,1);
        plot(ssfr.time, ssfr_down(3,:),'-',ssfr.time, ssfr_up(3,:),'-',...
            ssfr.time, ssfr_alb(3,:),'k.',ssfr.time(ainb), ssfr_alb(3,ainb),'r.'); dynamicDateTicks
        legend('downwelling','upwelling', 'albedo');
        title(['SSFR irradiances: ',datestr(ssfr.time(1),'yyyymmdd HH:MM'), '-',...
            datestr(ssfr.time(end),'HH:MM')]);
        xlim([xl_time - .25./24, xl_time + .25./24]);dynamicDateTicks
        xx(2) = subplot(3,1,2);
        if ~isavar('w_ii')
            plot(ssfr.time(ainb), ssfr_alb([3,5,10],ainb),'*', ssfr.time, ssfr_alb([3,5,10],:),'k-');
            xlim([xl_time - 2./(24*60), xl_time + 2./(24*60)]);dynamicDateTicks; 
            ylim([min(nanmin(ssfr_alb([3,5,10],:)))-.2, max(nanmax(ssfr_alb([3,5,10],:)))+.2]);
            legend('albedo 500nm', 'albedo 870nm', 'albedo 1650nm')
        else
            plot(ssfr.time(ainb), flight_alb(w_ii,ainb),'*', ssfr.time, flight_alb(w_ii,:),'k-');
            xlim([xl_time - 2./(24*60), xl_time + 2./(24*60)]);dynamicDateTicks; 
            ylim([min(nanmin(flight_alb))-.2, max(nanmax(flight_alb))+.2]);
            for nms = 1:length(w_ii)
                leg_str(nms) = string(sprintf('alb %1.0f nm',in_lambda(w_ii(nms))));
            end
            legend(leg_str)
        end
    end
    %     linkaxes(xx,'x');
elseif isfield(ssfr, 'TMHRS') % IDL .out file
    good_ii= good_ii(ssfr.SHUTTER(good_ii)==0);
    SAT = any(ssfr.SAT(good_ii),2);
    good_ii = good_ii(~SAT);
    ainb = interp1(ssfr.time(good_ii),good_ii,in_time,'nearest','extrap');
    ssfr_up = ssfr.NSPECTRA(:,ainb);ssfr_up = interp1(ssfr.NADLAMBDA, ssfr_up, ssfr.nm,'linear');
    ssfr_down = ssfr.ZSPECTRA(:,ainb);
    ssfr_alb = ssfr_up./ssfr_down;
    ssfr_alb(ssfr_alb<0|ssfr_alb>1) = NaN;
    flight_alb = interp1(ssfr.nm', ssfr_alb, in_lambda,'linear');
elseif isfield(ssfr, 'UTC') % IDL .out file
    ssfr_up = ssfr.NADSPECTRA(:,ainb);
    ssfr_down = ssfr.ZENSPECTRA(:,ainb);
    ssfr_alb = ssfr_up./ssfr_down;
    ssfr_alb(ssfr_alb<0|ssfr_alb>1) = NaN;
    flight_alb = interp1(ssfr.nm', ssfr_alb, in_lambda,'linear');
end
out_time = ssfr.time(ainb);
flight_albedo = nanmean(flight_alb(:,ainb),2)';
min_alb = nanmin(flight_alb(:,ainb),[],2)';
max_alb = nanmax(flight_alb(:,ainb),[],2)';
% for ww = length(in_lambda):-1:1
%    flight_albedo(ww) = meannonan(flight_alb(ww,:));
% end
flight_alb = flight_albedo;
figure_(442);
if isavar('xx');
    subplot(3,1,1); gca; xlim([min(out_time)-30/(24*60), max(out_time)+30/(24*60)]);dynamicDateTicks;
    subplot(3,1,2); gca; xlim([min(out_time)-2/(24*60), max(out_time)+2/(24*60)]);dynamicDateTicks;
    subplot(3,1,3); gca;
end
if ~isavar('w_ii')
    nms = interp1(in_lambda, [1:length(in_lambda)],[500,870,1650],'nearest');    
    plot(in_lambda, flight_alb,'m-', in_lambda(nms(1)), flight_alb(nms(1)),'bo',...
        in_lambda(nms(2)), flight_alb(nms(2)),'go', in_lambda(nms(3)), flight_alb(nms(3)),'ro');
    tl = title([datestr(double(out_time(1)),'yyyy-mm-dd HH:MM:SS')],'color','r');
    set(tl,'units','normalized'); tlp = get(tl,'position'); set(tl,'position',[.5,.85]);
    ylim([nanmin(flight_alb)-.2, nanmax(flight_alb)+.2]);
    legend('flight level albedo');
    xlabel('wavelength [nm]'); ylabel('albedo');ylim([-0.05, 1.05]);
    hold('on');
    neg = min_alb - flight_albedo;
    pos = max_alb - flight_albedo;
    % neg = min(ssfr_alb([3 5 10],ainb)')-nanmean(ssfr_alb([3 5 10],ainb)');
    % pos = max(ssfr_alb([3 5 10],ainb)')-nanmean(ssfr_alb([3 5 10],ainb)');
    errorbar(in_lambda(nms), flight_alb(nms),neg(nms), pos(nms), 'color','k','linestyle','none');
    hold('off')
else
    nms = in_lambda(w_ii);
    for nms = 1:length(w_ii)
    plot(in_lambda(w_ii(nms)), flight_alb(w_ii(nms)),'o'); hold('on')
    end
    plot(in_lambda, flight_alb,'k-'); 
    tl = title([datestr(double(out_time(1)),'yyyy-mm-dd HH:MM:SS')],'color','r');
    set(tl,'units','normalized'); tlp = get(tl,'position'); set(tl,'position',[.5,.85]); 
    ylim([nanmin(flight_alb)-.2, nanmax(flight_alb)+.2]);
    legend('flight level albedo');
    xlabel('wavelength [nm]'); ylabel('albedo');ylim([nanmin(flight_alb)-.2, nanmax(flight_alb)+.2]);
   
    neg = min_alb - flight_albedo;
    pos = max_alb - flight_albedo;
    % neg = min(ssfr_alb([3 5 10],ainb)')-nanmean(ssfr_alb([3 5 10],ainb)');
    % pos = max(ssfr_alb([3 5 10],ainb)')-nanmean(ssfr_alb([3 5 10],ainb)');
    errorbar(in_lambda(w_ii), flight_alb(w_ii),neg(w_ii), pos(w_ii), 'color','k','linestyle','none');
    hold('off')
    minx = 100.*round(min(in_lambda(w_ii))./100)-50;
    maxx = 100.*round(max(in_lambda(w_ii))./100) + 50;
    xlim([minx, maxx]);
end

    good = ~isnan(flight_alb)&(flight_alb>.01)&(flight_alb<1);
    if ~any(good)
        warning('Did not find ANY good flight level albedo values...');
        xl = xlim;
        text(xl(1)+(xl(2)-xl(1))./5, .9, 'No good SSFR albedo found!!', 'color','red');
        open('get_ssfr_flight_albedo');
        %    pause(10);
        %    close(gcf);
        flight_alb=[]; out_time = [];
    else
        flight_alb(~good) = interp1(in_lambda(good), flight_alb(good),in_lambda(~good),'nearest','extrap');
    end



return

