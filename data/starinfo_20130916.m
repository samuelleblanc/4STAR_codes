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
 
 
flight=[datenum('16:27:20') datenum('24:33:47')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('16:30:22') datenum('16:53:51');... 
datenum('17:08:20') datenum('17:57:37');... 
datenum('18:17:45') datenum('18:50:27');... 
datenum('18:57:31') datenum('18:58:38');... 
datenum('19:01:07') datenum('20:10:39');... 
datenum('20:16:36') datenum('20:24:20');... 
datenum('20:32:52') datenum('20:55:41');... 
datenum('21:11:17') datenum('21:18:40');... 
datenum('21:31:22') datenum('22:20:16');... 
datenum('22:33:35') datenum('22:57:10');... 
datenum('22:59:44') datenum('23:03:31');... 
datenum('23:31:39') datenum('23:34:04');... 
datenum('23:41:54') datenum('23:45:57');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('16:27:21') datenum('17:08:19');... 
datenum('17:57:37') datenum('18:17:45');... 
datenum('18:50:28') datenum('18:53:35');... 
datenum('18:58:39') datenum('19:01:06');... 
datenum('20:10:40') datenum('20:14:20');... 
datenum('20:24:20') datenum('20:30:08');... 
datenum('20:56:32') datenum('21:11:17');... 
datenum('21:18:40') datenum('21:31:22');... 
datenum('23:03:31') datenum('23:24:31');... 
datenum('23:25:47') datenum('23:31:23');... 
datenum('23:34:04') datenum('23:41:54');... 
datenum('23:45:57') datenum('24:04:35');... 
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

