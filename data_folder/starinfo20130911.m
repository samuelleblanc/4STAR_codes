function starinfo20130911
%get variables from caller
s=evalin('caller','s');
daystr=evalin('caller','daystr');


flight=[datenum('15:27:03') datenum('24:13:08')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('15:47:03') datenum('16:17:17');...
datenum('16:29:20') datenum('16:38:06');...
datenum('17:14:43') datenum('17:16:50');...
datenum('17:39:52') datenum('17:41:14');...
datenum('17:49:33') datenum('17:56:25');...
datenum('18:00:47') datenum('18:02:30');...
datenum('18:06:16') datenum('18:09:33');...
datenum('18:13:38') datenum('18:16:30');...
datenum('18:21:02') datenum('18:26:29');...
datenum('18:28:38') datenum('18:30:05');...
datenum('18:33:18') datenum('19:21:11');...
datenum('19:26:46') datenum('19:41:37');...
datenum('20:04:02') datenum('20:15:35');...
datenum('20:19:44') datenum('20:27:27');...
datenum('20:37:49') datenum('20:58:17');...
datenum('21:27:00') datenum('22:12:52');...
datenum('22:45:25') datenum('22:52:23');...
datenum('22:58:13') datenum('23:55:35');...
datenum('00:13:11') datenum('00:18:37');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
vertprofs=[datenum('15:27:10') datenum('15:47:02');...
datenum('16:17:19') datenum('16:47:16');...
datenum('16:53:43') datenum('17:14:42');...
datenum('17:16:52') datenum('17:32:12');...
datenum('17:32:55') datenum('17:39:30');...
datenum('17:41:15') datenum('17:49:33');...
datenum('17:56:27') datenum('18:06:03');...
datenum('18:09:33') datenum('18:20:52');...
datenum('18:26:29') datenum('18:28:37');...
datenum('18:30:05') datenum('18:33:17');...
datenum('19:21:12') datenum('19:26:45');...
datenum('19:41:37') datenum('19:51:04');...
datenum('19:53:10') datenum('19:54:14');...
datenum('19:54:16') datenum('19:58:04');...
datenum('19:59:52') datenum('20:03:24');...
datenum('20:15:35') datenum('20:19:43');...
datenum('20:27:27') datenum('20:30:17');...
datenum('20:58:17') datenum('21:27:00');...
datenum('22:12:52') datenum('22:35:06');...
datenum('22:35:08') datenum('22:58:12');...
datenum('23:55:36') datenum('24:13:11');...
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

