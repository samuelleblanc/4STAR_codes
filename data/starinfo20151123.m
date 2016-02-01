flight=[datenum('10:02:53') datenum('19:12:06')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

horilegs=[datenum('10:29:24') datenum('10:44:34'); ...
datenum('10:46:36') datenum('12:25:54'); ...
datenum('12:45:20') datenum('12:55:35'); ...
datenum('13:03:54') datenum('13:12:43'); ...
datenum('14:06:16') datenum('18:50:27'); ...
datenum('19:00:32') datenum('19:09:30'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

vertprofs=[datenum('10:14:52') datenum('10:29:24'); ...
datenum('10:44:34') datenum('10:46:36'); ...
datenum('12:25:54') datenum('12:45:20'); ...
datenum('12:55:35') datenum('12:58:50'); ...
datenum('12:58:50') datenum('13:03:54'); ...
datenum('13:12:43') datenum('13:26:20'); ...
datenum('13:26:20') datenum('13:39:19'); ...
datenum('13:39:19') datenum('14:06:16'); ...
datenum('18:50:27') datenum('19:00:32'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% langley=[horilegs(1,1) datenum('14:23:00')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]) % sunrise, various altitudes, under clouds
%     horilegs(6,1) datenum('18:19:38')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)])]; % sunset, various altitudes, under clouds
langley=[datenum('10:46:50') datenum('12:25:50')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 

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


