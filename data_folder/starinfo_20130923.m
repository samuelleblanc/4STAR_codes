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
 
 
flight=[datenum('16:43:07') datenum('24:10:21')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('16:45:26') datenum('16:50:02');... 
datenum('16:52:00') datenum('16:59:47');... 
datenum('17:28:14') datenum('18:03:16');... 
datenum('18:20:53') datenum('18:52:32');... 
datenum('19:24:15') datenum('19:26:56');... 
datenum('19:37:04') datenum('19:41:19');... 
datenum('20:24:12') datenum('22:42:36');... 
datenum('22:59:01') datenum('23:20:03');... 
datenum('23:29:30') datenum('23:31:09');... 
datenum('23:33:58') datenum('23:41:12');... 
datenum('23:47:09') datenum('23:53:11');... 
datenum('24:10:18') datenum('24:16:01');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('16:43:10') datenum('17:28:13');... 
datenum('18:03:16') datenum('18:20:52');... 
datenum('19:17:47') datenum('19:24:15');... 
datenum('19:26:56') datenum('19:29:53');... 
datenum('19:31:33') datenum('19:37:03');... 
datenum('19:41:19') datenum('19:44:26');... 
datenum('19:54:16') datenum('19:56:06');... 
datenum('19:56:08') datenum('19:59:37');... 
datenum('20:02:45') datenum('20:24:11');... 
datenum('22:42:36') datenum('22:59:01');... 
datenum('23:20:03') datenum('23:29:30');... 
datenum('23:31:09') datenum('23:41:59');... 
datenum('23:42:32') datenum('23:47:08');... 
datenum('23:53:12') datenum('24:04:25');... 
datenum('24:04:25') datenum('24:06:20');... 
datenum('24:07:34') datenum('24:10:18');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.2;% changed by MS, 20140407 
 
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

