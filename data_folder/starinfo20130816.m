function starinfo20130816
%get variables from caller
s=evalin('caller','s');
daystr=evalin('caller','daystr');

% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
flight=[datenum('14:34:00') datenum('22:58:35')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); % updated 27Sep13 JML
horilegs=[datenum('14:51:27') datenum('15:01:36');...
datenum('15:15:29') datenum('15:26:07');...
datenum('15:34:26') datenum('15:45:57');...
datenum('16:00:58') datenum('16:10:46');...
datenum('16:19:54') datenum('16:31:01');...
datenum('16:43:58') datenum('17:00:41');...
datenum('17:10:02') datenum('17:21:09');...
datenum('17:39:22') datenum('17:59:11');...
datenum('18:13:56') datenum('18:22:06');...
datenum('19:03:52') datenum('19:07:13');...
datenum('19:26:43') datenum('19:30:52');...
datenum('19:31:59') datenum('19:37:48');...
datenum('19:45:13') datenum('19:54:55');...
datenum('20:04:17') datenum('20:08:18');...
datenum('20:16:15') datenum('20:23:53');...
datenum('20:28:55') datenum('20:38:34');...
datenum('20:48:34') datenum('21:01:39');...
datenum('21:11:23') datenum('21:19:38');...
datenum('21:51:00') datenum('21:56:13');...
datenum('22:01:24') datenum('22:06:29');...
datenum('22:09:53') datenum('22:29:57');...
datenum('22:43:33') datenum('22:51:13');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
vertprofs=[datenum('14:34:00') datenum('14:51:27');...
datenum('15:01:36') datenum('15:15:29');...
datenum('15:26:08') datenum('15:33:57');...
datenum('15:45:58') datenum('16:00:31');...
datenum('16:10:47') datenum('16:19:54');...
datenum('16:31:01') datenum('16:43:56');...
datenum('17:00:41') datenum('17:09:44');...
datenum('17:21:12') datenum('17:37:23');...
datenum('17:59:12') datenum('18:25:49');...
datenum('18:36:05') datenum('19:03:52');...
datenum('19:07:13') datenum('19:26:42');...
datenum('19:42:26') datenum('20:15:29');...
datenum('20:23:58') datenum('20:44:38');...
datenum('20:45:20') datenum('21:10:10');...
datenum('21:19:39') datenum('21:39:15');...
datenum('21:39:25') datenum('22:09:24');...
datenum('22:29:58') datenum('22:58:35');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
groundcomparison=[datenum('13:23:25') datenum('14:27:08')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% daystr=mfilename;
% daystr=daystr(end-7:end);
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
end
