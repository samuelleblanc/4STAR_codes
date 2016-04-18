flight=[datenum('13:50:51') datenum('19:02:19')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
cleaning=[datenum('19:13:40') datenum('19:21:55') % pre-cleaning; the cleaning for this day was not done as a part of the FORJ test routine, hence the need to manually determine the time periods
    datenum('19:32:55') datenum('19:42:55')] ... % post-cleaning
    -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
    
%langley=[datenum('11:36:22') datenum('13:50:51')] ... 
%    -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);% ground-based 
    
langley=[datenum('11:36:22') datenum('13:50:51')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]) % ground based


groundcomparison=[langley; flight(1,2) datenum('20:00:00')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)])];

horilegs=[datenum('14:01:44') datenum('14:17:07'); ...
    datenum('14:18:52') datenum('14:43:43'); ...
    datenum('14:48:09') datenum('15:10:07'); ...
    datenum('15:42:57') datenum('16:04:56'); ...
    datenum('16:14:09') datenum('16:23:57'); ...
    datenum('16:38:13') datenum('18:33:05'); ...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
vertprofs=[datenum('13:50:51') datenum('14:01:44'); ...
    datenum('14:17:07') datenum('14:18:52'); ...
    datenum('14:43:43') datenum('14:48:09'); ...
    datenum('15:14:08') datenum('15:42:57'); ...
    datenum('16:04:56') datenum('16:14:09'); ...
    datenum('16:23:57') datenum('16:38:13'); ...
    datenum('18:33:05') datenum('19:02:02'); ...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

circles=[horilegs(4,:) ; % one big counterclockwise circle (seen from above); max 6700 m GPS altitude
    horilegs(5,:); % 3100 m GPS alt
    horilegs(6,1) datenum('16:53:12')-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)])]; % two small counterclockwise circle (seen from above); max 6700 m GPS altitude
% Circles were also made during the vertical profiles between the horizontal legs listed here: vertprofs(5,:); % spiral descent     vertprofs(6,:) ; % spiral ascent, two circles 

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.244;  % OMI overpass Wallops
s.NO2col=2e15;  % defailt value

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


