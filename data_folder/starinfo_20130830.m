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

%get variables from caller 
 
 
% No good time periods ([start end]) and memo for all pixels 
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost. 
% daystr=mfilename; 
% daystr=daystr(end-7:end); 
% No good time periods ([start end]) for specific pixels 
s.ng=[datenum('16:49:52') datenum('16:49:53') 10 
    datenum('17:02:04') datenum('17:02:05') 10 
    datenum('17:03:11') datenum('17:03:13') 10 
    datenum('17:18:00') datenum('17:18:01') 10 
    datenum('17:19:58') datenum('17:20:00') 10 
    datenum('17:29:02') datenum('17:29:09') 10 
    datenum('17:42:00') datenum('17:44:30') 10 
    datenum('18:05:54') datenum('18:05:55') 10 
    datenum('18:36:20') datenum('18:41:20') 10 
    datenum('18:43:43') datenum('18:45:33') 10 
    datenum('19:23:25') datenum('19:27:08') 10 
    datenum('19:27:34') datenum('19:27:36') 10 
    datenum('19:50:28') datenum('19:50:32') 10 
    datenum('20:18:18') datenum('20:18:19') 10 
    datenum('21:14:55') datenum('21:19:18') 10]; 
s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight=[datenum('16:23:42') datenum('24:19:39')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('14:57:10') datenum('16:23:47'); ... 
    datenum('16:34:21') datenum('16:40:32'); ... 
    datenum('16:50:11') datenum('16:51:44'); ... 
    datenum('16:55:05') datenum('17:00:16'); ... 
    datenum('17:02:52') datenum('17:04:34'); ... 
    datenum('17:09:49') datenum('17:12:39'); ... 
    %datenum('17:16:29') datenum('17:16:40'); ... 
    %datenum('17:17:11') datenum('17:17:31'); ... 
    datenum('17:20:03') datenum('17:25:10'); ... 
    %datenum('17:25:32') datenum('17:25:57'); ... 
    %datenum('17:28:42') datenum('17:28:57'); ... 
    datenum('17:29:48') datenum('17:31:46'); ... 
    datenum('17:32:22') datenum('17:34:52'); ... 
    datenum('17:37:19') datenum('17:43:26'); ... 
    datenum('17:45:56') datenum('17:47:06'); ... 
    datenum('17:49:22') datenum('17:52:22'); ... 
    datenum('17:54:22') datenum('17:55:28'); ... 
    datenum('17:57:25') datenum('18:00:19'); ... 
    datenum('18:01:48') datenum('18:03:44'); ... 
    datenum('18:06:28') datenum('18:07:46'); ... 
    datenum('18:08:50') datenum('18:11:26'); ... 
    datenum('18:33:30') datenum('19:09:40'); ... 
    datenum('19:19:22') datenum('19:24:15'); ... % inserted by Yohei; all other lines by Qin 
    datenum('19:28:24') datenum('19:43:34'); ... 
    %datenum('19:46:47') datenum('19:47:17'); ... 
    %datenum('19:49:44') datenum('19:50:20'); ... 
    datenum('19:51:37') datenum('19:54:02'); ... 
    datenum('19:55:41') datenum('19:58:28'); ... 
    %datenum('20:01:52') datenum('20:02:35'); ... 
    datenum('20:04:41') datenum('20:06:19'); ... 
    datenum('20:06:44') datenum('20:10:06'); ... 
    datenum('20:14:13') datenum('20:15:23'); ... 
    datenum('20:16:18') datenum('20:20:47'); ... 
    datenum('20:31:52') datenum('20:35:06'); ... 
    datenum('20:36:34') datenum('20:39:39'); ... 
    datenum('20:40:45') datenum('20:48:07'); ... 
    datenum('20:55:02') datenum('20:58:30'); ... 
    datenum('21:02:18') datenum('21:04:35'); ... 
    datenum('21:10:50') datenum('21:14:33'); ... 
    datenum('21:16:25') datenum('21:20:52'); ... 
    datenum('21:21:53') datenum('21:24:15'); ... 
    datenum('21:25:44') datenum('21:28:33'); ... 
    datenum('21:34:25') datenum('21:37:38'); ... 
    datenum('21:06:54') datenum('21:10:11'); ... 
    %datenum('21:14:51') datenum('21:15:32'); ... 
    %datenum('21:18:41') datenum('21:19:16'); ... 
    datenum('21:37:56') datenum('21:42:04'); ... 
    datenum('21:51:07') datenum('21:59:42'); ... 
    datenum('22:12:46') datenum('22:14:47'); ... 
    datenum('22:16:08') datenum('22:17:42'); ... 
    %datenum('22:19:03') datenum('22:19:33'); ... 
    datenum('22:19:53') datenum('22:20:55'); ... 
    datenum('22:23:36') datenum('22:24:58'); ... 
    datenum('22:26:49') datenum('22:31:31'); ... 
    datenum('22:37:07') datenum('22:42:32'); ... 
    datenum('22:48:50') datenum('22:50:52'); ... 
    datenum('22:58:32') datenum('23:03:48'); ... 
    datenum('23:10:18') datenum('23:13:07'); ... 
    datenum('23:20:03') datenum('23:25:16'); ... 
    datenum('23:30:09') datenum('23:32:06'); ... 
    datenum('23:38:38') datenum('23:47:34'); ... 
    datenum('23:49:00') datenum('24:02:55'); ... 
    datenum('24:04:16') datenum('24:14:26'); ... 
    datenum('24:19:33') datenum('24:24:55')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('16:23:48') datenum('16:34:20'); ... 
%     datenum('16:40:33') datenum('16:50:10'); ... 
    datenum('16:40:33') datenum('16:50:00'); ... 
    datenum('16:51:45') datenum('16:55:04'); ... 
    datenum('17:00:17') datenum('17:02:51'); ... 
    datenum('17:04:35') datenum('17:09:48'); ... 
    datenum('17:12:40') datenum('17:20:02'); ... 
%     datenum('17:25:11') datenum('17:29:47'); ... 
    datenum('17:25:55') datenum('17:29:47'); ... 
    datenum('17:31:47') datenum('17:32:21'); ... 
    datenum('17:34:53') datenum('17:37:18'); ... 
    datenum('17:43:27') datenum('17:45:55'); ... 
    datenum('17:47:07') datenum('17:49:21'); ... 
    datenum('17:52:23') datenum('17:54:21'); ... 
%     datenum('17:55:29') datenum('17:57:24'); ... 
    datenum('17:55:29') datenum('17:57:15'); ... 
    datenum('18:00:20') datenum('18:01:47'); ... 
    datenum('18:03:45') datenum('18:06:27'); ... 
    datenum('18:07:47') datenum('18:08:49'); ... 
    datenum('18:11:30') datenum('18:32:10'); ... 
    datenum('19:09:35') datenum('19:28:24'); ... 
%     datenum('19:43:35') datenum('19:51:36'); ... 
    datenum('19:43:35') datenum('19:49:20'); ... 
    datenum('19:54:03') datenum('19:55:40'); ... 
    datenum('19:58:29') datenum('20:04:40'); ... 
    datenum('20:06:20') datenum('20:06:43'); ... 
    datenum('20:10:07') datenum('20:14:12'); ... 
    datenum('20:15:24') datenum('20:16:17'); ... 
    datenum('20:20:48') datenum('20:31:51'); ... 
    datenum('20:35:07') datenum('20:36:33'); ... 
    datenum('20:39:40') datenum('20:40:44'); ... 
    datenum('20:48:08') datenum('20:55:01'); ... 
    datenum('20:58:31') datenum('21:02:17'); ... 
%     datenum('21:04:36') datenum('21:10:49'); ... % this is not a >1000 m vertical profile 
%     datenum('21:14:34') datenum('21:16:24'); ... 
%     datenum('21:20:53') datenum('21:21:52'); ... 
%     datenum('21:24:16') datenum('21:25:43'); ... 
%     datenum('21:28:34') datenum('21:34:24'); ... 
%     datenum('21:37:39') datenum('21:06:53'); ... 
%     datenum('21:10:12') datenum('21:37:55'); ... 
    datenum('21:42:05') datenum('21:51:06'); ... 
    datenum('21:59:43') datenum('22:12:45'); ... 
    datenum('22:14:48') datenum('22:16:07'); ... 
    datenum('22:17:43') datenum('22:19:52'); ... 
    datenum('22:20:56') datenum('22:23:35'); ... 
    datenum('22:24:59') datenum('22:26:48'); ... 
    datenum('22:31:32') datenum('22:37:06'); ... 
    datenum('22:42:33') datenum('22:48:49'); ... 
    datenum('22:50:53') datenum('22:58:31'); ... 
    datenum('23:03:49') datenum('23:10:17'); ... 
    datenum('23:13:08') datenum('23:20:02'); ... 
    datenum('23:25:17') datenum('23:30:08'); ... 
    datenum('23:32:07') datenum('23:38:37'); ... 
    datenum('23:47:35') datenum('23:48:59'); ... 
    datenum('24:02:56') datenum('24:04:15'); ... 
    datenum('24:14:27') datenum('24:19:32'); ... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.03; % optimized, before the manual inspection (see s.ng above). Yohei, 2013/09/01. 
 
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
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg'); 
    s.AZ_deg=s.AZstep/(-50); 
end; 
 
% notes 
if isfield(s, 'note'); 
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']}; 
end; 
 
 
 
%push variable to caller 
varNames=who(); 
for i=1:length(varNames) 
  assignin('caller',varNames{i},eval(varNames{i})); 
end; 
end 

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
