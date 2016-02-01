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

% No good time periods ([start end]) and memo for all pixels 
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost. 
% daystr=mfilename; 
% daystr=daystr(end-7:end); 
% No good time periods ([start end]) for specific pixels 
s.ng=[datenum('17:21:06') datenum('17:21:15') 100 
    datenum('17:25:30') datenum('17:30:30') 90 % based on flight notes. warrants further verification (also for the earlier segments in the same area), perhaps looking at DC-8 forward camera, DIAL/HSRL, etc. 
    datenum('18:01:20') datenum('18:01:30') 10 
    datenum('20:02:01') datenum('20:02:25') 10 
    datenum('21:41:48') datenum('21:43:33') 10]; % the flight operator (Yohei) saw cirrus in some other time periods. Only those with apparent >0.02 impact are noted here.  
% datenum('18:31:50') datenum('18:31:55');datenum('18:34:25') datenum('18:34:30');datenum('19:46:07') datenum('19:46:12') tracking error (by ~0.01 AOD 500 nm)  
s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight=[datenum('15:02:44') datenum('22:27:03')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('15:14:42') datenum('15:59:40');... 
datenum('16:20:28') datenum('16:24:19');... 
datenum('16:32:38') datenum('16:43:51');... 
datenum('16:54:51') datenum('17:03:30');... 
datenum('17:08:05') datenum('17:23:12');... 
datenum('17:35:59') datenum('17:45:01');... 
datenum('18:26:53') datenum('18:49:08');... 
datenum('18:52:21') datenum('19:26:34');... 
datenum('19:33:33') datenum('19:54:45');... 
datenum('20:11:20') datenum('20:17:55');... 
datenum('20:20:31') datenum('20:27:49');... 
datenum('20:30:07') datenum('20:34:56');... 
datenum('21:13:13') datenum('21:19:01');... 
datenum('22:02:57') datenum('22:10:20');... 
datenum('22:27:07') datenum('22:38:31');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('15:02:50') datenum('15:14:40');... 
datenum('15:59:46') datenum('16:28:24');... 
datenum('16:52:24') datenum('17:35:32');... 
datenum('17:59:24') datenum('18:25:25');... 
datenum('19:26:35') datenum('20:11:10');... 
datenum('20:27:50') datenum('20:45:23');... 
datenum('21:05:27') datenum('21:13:02');... 
datenum('21:19:02') datenum('21:26:21');... 
datenum('21:26:26') datenum('21:31:15');... 
datenum('21:31:18') datenum('21:35:55');... 
datenum('21:52:51') datenum('22:02:29');... 
datenum('22:10:20') datenum('22:27:06');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; % do not raise this, or re-do the manual cloud screening 
 
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

