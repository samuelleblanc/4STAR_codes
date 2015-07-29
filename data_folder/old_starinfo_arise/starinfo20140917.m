%flight=[datenum('0:0:0') datenum('2:00');  datenum('24:00:00') datenum('25:26:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
flight=[datenum('18:28:00.12') datenum('25:22:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
langley=[datenum('0:0:0') datenum('2:00');  datenum('25:41:00') datenum('27:00:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
%langley=[datenum([2014 09 17 25 41 0]) datenum([2014 09 17 27 0 0])];
% 
% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
% daystr=mfilename;
% daystr=daystr(end-7:end);
% No good time periods ([start end]) for specific pixels
s.ng=s.ng;
% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.306;% OMI 09/16-17 Eielson% 298 is OMI average L2TOMO3
s.NO2col=2.97e15;%2e15;  % OMI L2 product above Eilson

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=1013;
end;
if isfield(s, 'Lon') & isfield(s, 'Lat');
    ng=[find(s.Lon==0 & s.Lat==0); find(abs(s.Lon)>180); find(abs(s.Lat)>90)];
    s.Lon(ng)=NaN;
    s.Lat(ng)=NaN;
end;
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg');
    s.AZ_deg=s.AZstep/(-50);
end;

% notes
if isfield(s, 'note');
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']};
end;

