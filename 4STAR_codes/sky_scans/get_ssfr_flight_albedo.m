function [flight_alb, out_time] = get_ssfr_flight_albedo(in_time,in_lambda)
% [flight_alb, out_time] = get_ssfr_flight_albedo(in_time,in_lambda)
% in_time is required
% in_lambda is optional. Will load txt file for lambda if not provided.
if exist('in_time','var')
    file_str = [datestr(in_time(1),'yyyymmdd'), '_SSFR.mat; ',...
        datestr(in_time(1),'yyyymmdd'), '_SSFR.cdf; '...
        datestr(in_time(1),'yyyymmdd'), '_SSFR.ict; ',...
        datestr(in_time(1),'yyyymmdd'), '_*.out; ',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.mat; ',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.cdf; ',...
        'SSFR_*_',datestr(in_time(1),'yyyymmdd'), '_*.ict; ' ,...
        '*',datestr(in_time(1),'yyyymmdd'), '*.out',...
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
[list,pname] = dir_(file_str,'ssfr_alb');
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
    flight_alb = interp1(wl', ssfr_alb(:,ainb), in_lambda,'linear');    
    figure_(442); xx(2) = subplot(2,1,2);
    plot(ssfr.time, ssfr_alb(3,:),'k.',ssfr.time(ainb), ssfr_alb(3,ainb),'ro'); dynamicDateTicks
    legend('flight albedo')
    xx(1) = subplot(2,1,1);
    plot(ssfr.time, ssfr_down(3,:),'-',ssfr.time, ssfr_up(3,:),'-'); dynamicDateTicks
    legend('down','up');
    title(['SSFR irradiances: ',datestr(ssfr.time(1),'yyyymmdd HH:MM'), '-',...
    datestr(ssfr.time(end),'HH:MM')]);    
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
for ww = length(in_lambda):-1:1
   flight_albedo(ww) = meannonan(flight_alb(ww,:));
end
flight_alb = flight_albedo;
figure_(442); if isavar('xx'); subplot(2,1,1); gca; end
plot(in_lambda, flight_alb,'-'); title(['SSFR flight-level albedo: ',datestr(double(out_time(1)),'yyyy-mm-dd HH:MM:SS')]);
xlabel('wavelength [nm]'); ylabel('albedo');ylim([-0.05, 1.05]);
good = ~isnan(flight_alb)&(flight_alb>.1)&(flight_alb<1);
if ~any(good)
   warning('Did not find ANY good flight level albedo values...');
   xl = xlim;
   text(xl(1)+(xl(2)-xl(1))./5, .9, 'No good SSFR albedo found!!', 'color','red');
   open('get_ssfr_flight_albedo');
%    pause(10);
%    close(gcf);
end
else
   flight_alb=[]; out_time = [];
end
return

