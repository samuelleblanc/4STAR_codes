function s = starinfo(s)
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t)
   daystr = datestr(s.t(1),'yyyymmdd');
else
   daystr=evalin('caller','daystr');
end

toggle = update_toggle;
if isfield(s, 'toggle')
   toggle = catstruct(s.toggle, toggle);
end
s.toggle = toggle;

% sinfo = starinfo_20130808(s) 
 
%get variables from caller 
 
% No good time periods ([start end]) and memo for all pixels 
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost. 
s.daystr = datestr(s.t(1),'yyyymmdd'); 
ng=[]; 
% flight_=[datenum('16:17:50') datenum('24:06:11')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); % updated 27Sep13 JML 
s.flight=[datenum('16:17:50') datenum('24:06:11')]-datenum('00:00:00')+floor(s.t(1)); % updated 27Sep13 JML 
% groundcomparison=[datenum('14:20:50') datenum('18:00:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
!!! A rough timing, to be updated. No good post-flight comparison, as dirt may have deposited during the flight. 
s.transects=[datenum('22:00:00') datenum('24:06:20')]-datenum('00:00:00')+floor(s.t(1)); 
s.horilegs=[datenum('15:35:50') datenum('16:17:54');... 
datenum('16:28:24') datenum('16:44:23');... 
datenum('17:10:53') datenum('17:28:08');... 
datenum('17:32:11') datenum('17:42:39');... 
datenum('17:45:50') datenum('17:56:01');... 
datenum('17:58:46') datenum('18:08:29');... 
datenum('18:11:10') datenum('18:21:05');... 
datenum('18:23:43') datenum('18:34:09');... 
datenum('18:37:01') datenum('18:50:11');... 
datenum('18:58:59') datenum('19:07:16');... 
datenum('19:10:11') datenum('19:20:05');... 
datenum('19:22:04') datenum('19:31:57');... 
datenum('19:38:21') datenum('19:40:42');... 
datenum('19:42:42') datenum('19:48:23');... 
datenum('19:55:07') datenum('20:04:35');... 
datenum('20:21:34') datenum('20:34:42');... 
datenum('20:37:29') datenum('20:47:51');... 
datenum('20:51:44') datenum('21:02:04');... 
datenum('21:06:17') datenum('21:16:07');... 
datenum('21:20:19') datenum('21:30:54');... 
datenum('21:50:11') datenum('21:58:50');... 
datenum('22:00:07') datenum('22:07:38');... 
datenum('22:08:06') datenum('22:10:19');... 
datenum('22:18:00') datenum('22:20:53');... 
datenum('22:44:54') datenum('23:01:49');... 
datenum('23:05:37') datenum('23:20:00');... 
datenum('23:33:43') datenum('23:51:01');... 
datenum('24:06:14') datenum('24:07:20');... 
    ]-datenum('00:00:00')+floor(s.t(1)); 
s.vertprofs=[datenum('16:17:54') datenum('17:10:52');... 
datenum('17:28:08') datenum('18:23:43');... 
datenum('18:34:09') datenum('18:57:21');... 
datenum('19:07:17') datenum('19:10:10');... 
datenum('19:20:07') datenum('19:37:55');... 
datenum('19:40:43') datenum('19:55:07');... 
datenum('20:04:35') datenum('20:37:28');... 
datenum('20:47:52') datenum('22:08:05');... 
datenum('22:10:20') datenum('22:27:19');... 
datenum('22:27:20') datenum('22:42:27');... 
datenum('23:01:50') datenum('23:33:32');... 
datenum('23:51:01') datenum('24:06:13');... 
    ]-datenum('00:00:00')+floor(s.t(1)); 
 
% daystr=mfilename; 
% daystr=daystr(end-7:end); 
% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% No good time periods ([start end]) for specific pixels 
% s.ng=ng; 
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
 
% Ozone and other gases 
s.O3h=21; 
s.O3col=0.300;  % Yohei's guess, to be updated 
s.NO2col=5e15; % Yohei's guess, to be updated 
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013; 
end; 
if isfield(s, 'Lon') & isfield(s, 'Lat'); 
    s.Lon(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lat(s.Lon==0 & s.Lat==0)=NaN; 
end; 
% if isfield(s, 'AZstep') & isfield(s, 'AZ_deg'); 
%     s.AZ_deg=s.AZstep/(-50); 
% end; 
 
% notes 
if isfield(s, 'note'); 
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']}; 
end; 
 
push variable to caller 
varNames=who(); 
for i=1:length(varNames) 
   if ~strcmp(varNames{i},'s') 
  assignin('caller',varNames{i},eval(varNames{i})); 
   end 
end; 
 
 
 %push variable to caller
% Bad coding practice to blind-push variables to the caller.  
% Creates potential for clobbering and makes collaborative coding more
% difficult because fields appear in caller memory space undeclared.

varNames=who();
for i=1:length(varNames)
   if ~strcmp(varNames{i},'s')
  assignin('caller',varNames{i},eval(varNames{i}));
   end
end;

return

