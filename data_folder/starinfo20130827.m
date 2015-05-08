function starinfo20130827
%get variables from caller
s=evalin('caller','s');
daystr=evalin('caller','daystr');



% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 3 tracking error, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
% daystr=mfilename;
% daystr=daystr(end-7:end);
% No good time periods ([start end]) for specific pixels
s.ng=[datenum('00:30:08') datenum('00:30:14') 10 
    datenum('00:30:22') datenum('00:30:30') 10 
    datenum('00:30:50') datenum('00:31:45') 10 
    datenum('00:40:12') datenum('00:41:45') 10 
    datenum('00:43:01') datenum('00:43:33') 10 
    datenum('00:43:46') datenum('00:44:42') 10 
    datenum('00:57:50') datenum('01:07:30') 10 % this may not be clouds
datenum('01:17:17') datenum('01:17:42') 10 
datenum('01:32:40') datenum('01:39:30') 10 % this may not be clouds
datenum('01:41:08') datenum('01:41:34') 10 
datenum('01:44:25') datenum('01:45:52') 10 
datenum('18:04:30') datenum('18:04:33') 10 
datenum('18:44:05') datenum('18:44:09') 10 
datenum('18:44:15') datenum('18:44:18') 10 
datenum('18:48:58') datenum('18:48:59') 10 
datenum('18:49:01') datenum('18:49:04') 10 
datenum('18:58:49') datenum('18:59:05') 10 
datenum('18:59:23') datenum('18:59:45') 10 
datenum('19:01:07') datenum('19:01:09') 10 
datenum('19:04:34') datenum('19:04:36') 10 
datenum('19:15:30') datenum('19:15:33') 10 
datenum('19:22:50') datenum('19:22:53') 10 
datenum('19:27:55') datenum('19:28:05') 3 
datenum('19:31:28') datenum('19:31:32') 10 
datenum('19:32:17') datenum('19:32:23') 10 
datenum('19:35:09') datenum('19:35:10') 10 
datenum('19:35:26') datenum('19:35:33') 10 
datenum('19:36:05') datenum('19:36:06') 10 
datenum('19:36:36') datenum('19:36:39') 10 
datenum('19:37:44') datenum('19:37:46') 10 
datenum('19:37:53') datenum('19:37:55') 10 
datenum('19:39:34') datenum('19:39:51') 10 
datenum('19:40:43') datenum('19:40:50') 10 
datenum('19:42:40') datenum('19:42:43') 10 
datenum('19:42:46') datenum('19:42:56') 10 
datenum('19:44:35') datenum('19:44:39') 10 
datenum('19:45:20') datenum('19:45:47') 10 
datenum('19:46:18') datenum('19:46:20') 10 
datenum('19:46:26') datenum('19:46:37') 10 
datenum('19:48:19') datenum('19:48:25') 10 
datenum('19:49:26') datenum('19:49:30') 10 
datenum('19:57:05') datenum('19:57:24') 10 
datenum('19:59:03') datenum('19:59:05') 10 
datenum('20:13:30') datenum('20:13:35') 3 
datenum('20:14:48') datenum('20:14:55') 3 
datenum('20:16:53') datenum('20:17:01') 3 
datenum('20:24:20') datenum('20:24:33') 10 
datenum('20:24:46') datenum('20:24:55') 10 
datenum('20:27:02') datenum('20:27:15') 10 
datenum('20:27:19') datenum('20:27:21') 10 
datenum('20:27:27') datenum('20:27:52') 10 
datenum('20:28:57') datenum('20:28:59') 10 
datenum('20:29:14') datenum('20:29:16') 10 
datenum('20:29:43') datenum('20:29:47') 10 
datenum('20:30:09') datenum('20:30:23') 10 
datenum('20:30:34') datenum('20:32:10') 10 
datenum('20:32:26') datenum('20:32:45') 10 
datenum('20:32:55') datenum('20:32:58') 10 
datenum('20:33:02') datenum('20:33:22') 10 
datenum('20:33:29') datenum('20:34:12') 10 
datenum('20:35:17') datenum('20:35:20') 10 
datenum('20:36:53') datenum('20:37:10') 10 
datenum('20:37:25') datenum('20:37:30') 10 
datenum('20:37:38') datenum('20:37:43') 10 
datenum('20:38:34') datenum('20:38:49') 10 
datenum('20:39:07') datenum('20:39:08') 10 
datenum('20:39:41') datenum('20:40:07') 10 
datenum('20:40:42') datenum('20:41:17') 10 
datenum('20:41:22') datenum('20:41:34') 10 
datenum('20:41:42') datenum('20:41:56') 10 
datenum('20:41:58') datenum('20:43:25') 10 
datenum('20:44:06') datenum('20:44:16') 10 
datenum('20:44:34') datenum('20:49:00') 10 
datenum('21:06:00') datenum('21:08:00') 10 
datenum('21:18:44') datenum('21:18:45') 10 
datenum('21:21:24') datenum('21:21:36') 10 
datenum('21:35:08') datenum('21:35:14') 10 
datenum('21:35:45') datenum('21:35:46') 10 
datenum('21:36:42') datenum('21:36:46') 10 
datenum('21:36:24.5') datenum('21:36:25.5') 10 
datenum('21:37:00') datenum('21:37:07') 10 
datenum('21:37:12') datenum('21:37:14') 10 
datenum('21:53:07') datenum('21:53:25') 10 
datenum('21:54:09') datenum('21:54:15') 10 
datenum('22:03:17') datenum('22:39:00') 90 
datenum('23:11:00') datenum('23:14:00') 10 
datenum('23:53:30') datenum('23:54:09') 3 
     ]; 
s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
flight=[datenum('00:26:36') datenum('01:47:41'); datenum('18:03:24') datenum('25:13:42')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% the first row represents the end of the 2013/08/26 flight,  the second row the 2013/08/27 flight, which ended in 2013/08/28 UTC
horilegs=[datenum('00:26:37') datenum('00:29:17');...
    datenum('00:48:36') datenum('00:58:45');...
    datenum('01:12:10') datenum('01:26:44');...
    datenum('01:47:35') datenum('01:48:49');...
    datenum('15:24:38') datenum('18:02:32');...
    datenum('18:11:34') datenum('18:27:24');...
    datenum('18:29:21') datenum('18:32:26');...
    datenum('18:34:04') datenum('18:35:42');...
    datenum('18:37:19') datenum('18:39:02');...
    datenum('18:50:12') datenum('19:00:15');...
    datenum('19:12:23') datenum('19:31:29');...
    datenum('19:35:49') datenum('19:37:29');...
    datenum('19:44:09') datenum('19:46:02');...
    datenum('19:53:13') datenum('19:57:00');...
    datenum('20:04:27') datenum('20:16:48');...
    datenum('20:49:53') datenum('20:59:52');...
    datenum('21:04:23') datenum('21:13:42');...
    datenum('21:18:01') datenum('21:24:29');...
    datenum('21:27:04') datenum('22:08:25');...
    datenum('22:14:43') datenum('22:18:49');...
    datenum('22:26:30') datenum('22:54:40');...
    datenum('23:01:12') datenum('23:07:52');...
    datenum('23:33:55') datenum('23:43:31');...
    datenum('23:47:20') datenum('23:57:32');...
    datenum('24:02:52') datenum('24:16:47');...
    datenum('24:22:58') datenum('24:51:48');...
    datenum('24:58:22') datenum('25:07:12');...
    datenum('25:10:54') datenum('25:13:41');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
vertprofs=[datenum('00:29:17') datenum('00:34:41');...
    datenum('00:40:26') datenum('00:48:36');...
    datenum('00:58:45') datenum('01:02:04');...
    datenum('01:02:05') datenum('01:12:09');...
    datenum('01:26:45') datenum('01:47:34');...
    datenum('18:03:24') datenum('18:11:33');... %datenum('18:02:43') datenum('18:11:33')
    datenum('18:27:25') datenum('18:44:12');...
    datenum('18:44:13') datenum('19:11:59');...
    datenum('19:31:30') datenum('19:46:30');...
    datenum('19:46:31') datenum('20:04:11');...
    datenum('20:16:49') datenum('20:32:52');...
    datenum('20:43:24') datenum('21:01:00');...
    datenum('21:13:43') datenum('21:26:52');...
    datenum('22:08:26') datenum('22:13:47');...
    datenum('22:17:27') datenum('22:26:10');...
    datenum('22:18:50') datenum('22:20:38');...
    datenum('22:18:50') datenum('22:26:10');...
    datenum('22:54:40') datenum('23:01:05');...
    datenum('23:07:55') datenum('24:22:12');...
    datenum('24:51:48') datenum('24:56:59');...
    datenum('25:07:13') datenum('25:09:41');...
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
end;
end
