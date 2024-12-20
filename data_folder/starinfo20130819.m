%function starinfo20130819
%get variables from caller
%s=evalin('caller','s');
%daystr=evalin('caller','daystr');

% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
% daystr=mfilename;
% daystr=daystr(end-7:end);
% No good time periods ([start end]) for specific pixels
%s.ng=s.ng;
flight=[datenum('14:57:25') datenum('23:24:09')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); % updated 27Sep13 JML
horilegs=[datenum('15:16:05') datenum('15:26:50');...
datenum('15:34:32') datenum('17:37:54');...
datenum('17:51:11') datenum('17:55:48');...
datenum('18:28:09') datenum('18:48:13');...
datenum('18:53:34') datenum('19:12:02');...
datenum('19:15:26') datenum('19:33:58');...
datenum('19:41:00') datenum('20:14:22');...
datenum('21:09:15') datenum('21:31:51');...
datenum('21:34:23') datenum('21:43:35');...
datenum('21:47:02') datenum('21:53:12');...
datenum('21:59:11') datenum('22:22:05');...
datenum('22:30:56') datenum('22:45:42');...
datenum('22:46:49') datenum('22:51:45');...
datenum('22:54:44') datenum('23:05:24');...
datenum('23:07:08') datenum('23:12:04');...
datenum('23:13:37') datenum('23:20:07');...
datenum('23:24:12') datenum('23:32:07');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
vertprofs=[datenum('14:57:27') datenum('15:34:13');...
datenum('17:37:55') datenum('18:02:09');...
datenum('18:22:13') datenum('19:40:59');...
datenum('20:14:24') datenum('20:29:22');...
datenum('20:55:25') datenum('21:09:14');...
datenum('21:31:51') datenum('21:46:57');...
datenum('21:53:13') datenum('21:59:10');...
datenum('22:22:06') datenum('23:24:07');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
groundcomparison=[datenum('13:56:50') datenum('14:57:26')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

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
%varNames=who();
%for i=1:length(varNames)
%  assignin('caller',varNames{i},eval(varNames{i}));
%end;
%end

