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
 
 
% No good time periods ([start end]) for specific pixels 
%s.ng=[datenum('14:28:34') datenum('14:28:36') 10]; 
%30-40 worked 
% 14:28:34+ 
%s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight=[datenum('12:23:25') datenum('20:39:42')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('12:57:38') datenum('13:02:37');... 
datenum('13:04:53') datenum('13:39:32');... 
datenum('13:56:10') datenum('14:01:59');... 
datenum('14:12:55') datenum('14:22:24');... 
datenum('14:25:28') datenum('14:30:16');... 
datenum('14:57:29') datenum('15:08:16');... 
datenum('15:11:45') datenum('15:21:22');... 
datenum('15:25:37') datenum('15:38:01');... 
datenum('15:48:57') datenum('16:12:22');... 
datenum('16:17:12') datenum('16:38:36');... 
datenum('16:50:19') datenum('17:39:04');... 
datenum('18:13:41') datenum('18:22:31');... 
datenum('18:33:18') datenum('18:39:48');... 
datenum('18:46:23') datenum('18:51:02');... 
datenum('19:19:58') datenum('19:22:36');... 
datenum('19:43:41') datenum('19:49:50');... 
datenum('20:46:15') datenum('21:19:55');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('12:27:09') datenum('12:57:38');... 
datenum('13:02:37') datenum('13:44:35');... 
datenum('14:02:00') datenum('14:12:54');... 
datenum('14:22:25') datenum('14:57:29');... 
datenum('15:08:17') datenum('18:13:32');... 
datenum('18:22:31') datenum('18:32:50');... 
datenum('18:39:49') datenum('19:06:00');... 
datenum('19:23:06') datenum('19:43:41');... 
datenum('19:49:50') datenum('20:17:53');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
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

