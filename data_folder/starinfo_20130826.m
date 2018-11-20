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
try; 
catch; 
    s.dummy = true; 
end; 
 
 
% No good time periods ([start end]) and memo for all pixels 
%  flag: 1 for unknown or others, 2 for before and after measurements, 3 tracking error 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost. 
% daystr=mfilename; 
% daystr=daystr(end-7:end); 
% No good time periods ([start end]) for specific pixels 
s.ng=[datenum('18:24:28') datenum('18:40:00') 90 
     datenum('19:34:41') datenum('19:34:48') 3 
     datenum('20:17:10') datenum('20:17:13') 90 
     datenum('20:35:33') datenum('20:36:23') 3 % changing pitch 
     datenum('20:57:00') datenum('20:57:30') 3  
     datenum('21:12:00') datenum('21:12:30') 3  
     datenum('21:16:15') datenum('21:16:30') 10  
     datenum('21:17:25') datenum('21:17:40') 10  
     datenum('21:18:55') datenum('21:19:01') 3  
     datenum('21:36:50') datenum('21:38:10') 3  
     datenum('21:46:50') datenum('21:47:15') 3  
     datenum('21:49:00') datenum('21:49:30') 10  
     datenum('21:55:53') datenum('21:55:57') 10  
     datenum('21:56:19') datenum('21:56:34') 10  
     datenum('22:00:30') datenum('22:00:45') 10  
     datenum('22:04:40') datenum('22:04:50') 10  
     datenum('22:05:52') datenum('22:05:53') 10  
     datenum('22:12:14') datenum('22:12:25') 10  
     datenum('22:13:29') datenum('22:13:55') 10  
     datenum('22:14:13') datenum('22:14:14') 10  
     datenum('22:17:12') datenum('22:17:33') 10  
     datenum('22:22:30') datenum('22:22:53') 10  
     datenum('22:23:13') datenum('22:23:16') 10  
     datenum('22:35:30') datenum('23:00:50') 90  
     datenum('23:06:50') datenum('23:06:54') 10  
     datenum('23:35:57') datenum('23:36:04') 10 % Cu here and there 
     datenum('23:39:52') datenum('23:40:04') 10  
     datenum('23:40:14') datenum('23:41:02') 10  
     datenum('23:41:15') datenum('23:41:25') 10  
     datenum('23:49:00') datenum('23:49:20') 10  
     datenum('23:55:15') datenum('23:55:24') 10  
     datenum('23:56:23') datenum('23:56:27') 10  
     datenum('23:59:15') datenum('23:59:28') 10  
     datenum('23:59:34') datenum('23:59:50') 10  
     ];  
s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% flight=[datenum('18:07:11') datenum('24:25:02')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight=[datenum('18:07:11') datenum('25:47:41')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('18:40:05') datenum('20:03:09');... 
datenum('20:08:54') datenum('20:38:58');... 
datenum('20:46:05') datenum('20:52:27');... 
datenum('21:02:38') datenum('21:08:06');... 
datenum('21:09:29') datenum('21:37:52');... 
datenum('21:49:25') datenum('22:15:53');... 
datenum('22:23:13') datenum('22:30:18');... 
datenum('22:32:13') datenum('22:39:19');... 
datenum('22:50:56') datenum('22:53:31');... 
datenum('22:55:13') datenum('23:02:52');... 
datenum('23:04:31') datenum('23:32:12');... 
datenum('23:39:53') datenum('24:02:52');... 
datenum('24:09:28') datenum('24:17:13');... 
datenum('24:20:41') datenum('24:25:02');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('18:24:29') datenum('18:40:04');... 
datenum('20:03:10') datenum('20:08:22');... 
datenum('20:38:58') datenum('20:46:04');... 
datenum('20:52:27') datenum('21:02:37');... 
datenum('21:37:53') datenum('21:49:24');... 
datenum('22:15:58') datenum('22:42:41');... 
datenum('22:43:27') datenum('22:55:02');... 
datenum('23:02:54') datenum('23:34:40');... 
datenum('24:02:54') datenum('24:09:27');... 
datenum('24:17:13') datenum('24:20:40');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=Inf; % to save AOD of the massive smoke from Yosemite rim fire 
 
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

