flight=[datenum('10:27:18') datenum('19:44:06')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

horilegs=[datenum('10:59:48') datenum('13:24:37'); ...
    datenum('13:41:32') datenum('13:52:23'); ...
    datenum('14:06:20') datenum('14:18:01'); ...
    datenum('14:34:00') datenum('15:03:16'); ...
    datenum('15:19:26') datenum('15:27:01'); ...
    datenum('15:40:07') datenum('16:09:32'); ...
    datenum('17:10:25') datenum('17:37:21'); ...
    datenum('17:40:23') datenum('19:24:38'); ...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
vertprofs=[datenum('10:27:19') datenum('10:59:48'); ...
    datenum('13:24:37') datenum('13:41:32'); ...
    datenum('13:52:23') datenum('13:59:23'); ...
    datenum('13:59:23') datenum('14:06:20'); ...
    datenum('14:18:01') datenum('14:34:00'); ...
    datenum('15:03:16') datenum('15:19:26'); ...
    datenum('15:27:01') datenum('15:32:31'); ...
    datenum('15:32:31') datenum('15:40:07'); ...
    datenum('16:09:32') datenum('16:39:22'); ...
    datenum('16:39:22') datenum('16:52:45'); ...
    datenum('16:57:22') datenum('17:10:25'); ...
%     datenum('17:37:21') datenum('17:40:23'); ...
%     datenum('19:24:38') datenum('19:25:35'); ...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
langley=[flight(1,1) horilegs(4,2) % sunrise, various altitudes, under clouds
    horilegs(4,1) flight(end,end)]; % sunset, various altitudes, under clouds
circles=horilegs([1 4 7 8],:); 

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


