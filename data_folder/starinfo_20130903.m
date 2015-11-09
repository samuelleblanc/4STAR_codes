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
%s.ng=[datenum('17:26:20') datenum('17:26:21') 10  
%datenum('18:14:04') datenum('18:14:06') 10 
%datenum('18:41:19') datenum('18:41:21') 10 
%datenum('18:41:21') datenum('18:41:22') 10 
%datenum('18:56:38') datenum('18:56:39') 10 
%datenum('21:03:20') datenum('21:03:21') 10]; 
%s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight=[datenum('15:10:27') datenum('23:54:58')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('15:20:11') datenum('15:52:55');... 
datenum('16:02:05') datenum('16:53:37');... 
datenum('16:56:17') datenum('17:05:15');... 
datenum('17:06:58') datenum('17:18:20');... 
datenum('17:26:33') datenum('17:29:02');... 
datenum('17:37:52') datenum('18:32:02');... 
datenum('18:36:25') datenum('18:41:10');... 
datenum('18:46:21') datenum('19:14:00');... 
datenum('19:21:08') datenum('19:25:11');... 
datenum('19:26:42') datenum('20:37:37');... 
datenum('20:40:21') datenum('20:53:26');... 
datenum('21:01:23') datenum('21:09:30');... 
datenum('21:12:34') datenum('21:31:00');... 
datenum('21:35:02') datenum('22:03:55');... 
datenum('22:13:40') datenum('22:27:13');... 
datenum('22:43:35') datenum('23:34:58');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('15:15:04') datenum('15:20:10');... 
datenum('15:52:55') datenum('16:02:04');... 
datenum('17:18:21') datenum('19:26:41');... 
datenum('20:37:37') datenum('22:13:39');... 
datenum('22:27:13') datenum('22:43:35');... 
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

