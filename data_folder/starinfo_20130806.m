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
s.ng=[]; 
s.flight=[datenum('17:58:48') datenum('26:42:42')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); % updated 27Sep13 JML 
smoke=[datenum('19:50:00') datenum('20:06:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% from Livingston's flight notes. 
groundcomparison=[datenum('14:25:00') datenum('17:58:29')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
%!!! A rough timing, to be updated. No good post-flight comparison, as dirt may have deposited during the flight. 
% horileg=[datenum('02:04:05') datenum('02:22:59')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('18:23:56') datenum('18:48:43'); ... 
    datenum('19:01:47') datenum('19:14:16'); ... 
    datenum('19:26:12') datenum('19:49:51'); ... 
    datenum('19:54:23') datenum('20:07:44'); ... 
    datenum('20:34:22') datenum('21:07:00'); ... 
    datenum('21:12:24') datenum('21:20:44'); ... 
    datenum('21:42:48') datenum('21:49:22'); ... 
    datenum('22:07:06') datenum('22:21:52'); ... 
    datenum('22:23:56') datenum('22:38:39'); ... 
    datenum('22:39:40') datenum('23:05:29'); ... 
    datenum('23:07:56') datenum('23:40:17'); ... 
    datenum('23:41:26') datenum('23:49:45'); ... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('17:58:50') datenum('18:23:56'); ... 
    datenum('18:48:43') datenum('19:26:05'); ... 
    datenum('19:49:51') datenum('19:52:31'); ... 
    datenum('20:22:14') datenum('20:34:21'); ... 
    datenum('21:07:00') datenum('21:32:38'); ... 
    datenum('21:34:28') datenum('21:42:48'); ... 
    datenum('21:49:23') datenum('21:52:31'); ... 
    datenum('21:54:18') datenum('22:39:10'); ... 
    datenum('23:49:46') datenum('24:12:52'); ... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% daystr=mfilename; 
% daystr=daystr(end-7:end); 
% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% No good time periods ([start end]) for specific pixels 
s.ng=s.ng; 
 
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

