flight=[datenum('11:08') datenum('20:40:40')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

horilegs=[datenum('11:30:12') datenum('14:44:42'); ...
datenum('15:02:14') datenum('15:08:19'); ...
datenum('15:32:04') datenum('16:06:30'); ...
datenum('16:20:46') datenum('16:53:48'); ...
datenum('17:30:55') datenum('17:52:56'); ...
datenum('18:05:18') datenum('19:42:12'); ...
 ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

vertprofs=[datenum('11:12:02') datenum('11:30:12'); ...
datenum('14:44:42') datenum('15:02:14'); ...
datenum('15:08:19') datenum('15:25:11'); ...
datenum('15:25:11') datenum('15:32:04'); ...
datenum('16:06:30') datenum('16:08:57'); ...
datenum('16:08:57') datenum('16:20:46'); ...
datenum('16:53:48') datenum('17:30:55'); ...
datenum('17:52:56') datenum('18:05:18'); ...
 ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

%langley=[horilegs(1,1) datenum('14:23:00')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]) % sunrise, various altitudes, under clouds
%    horilegs(6,1) datenum('18:19:38')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)])]; % sunset, various altitudes, under clouds

langley=[datenum('11:30:12') datenum('14:23:00');datenum('18:05:18') datenum('18:19:38')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]) % sunrise, various altitudes, under clouds


% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.339;  % Sam's update on 20151123.
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


