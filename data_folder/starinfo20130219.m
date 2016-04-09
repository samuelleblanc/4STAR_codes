% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
s.ng=[];
%langley=[datenum('18:46:00') datenum('21:37:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
groundcomparisonwithAATS=[datenum('14:06:30') datenum('14:53:40')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
flight=[datenum('14:57:00') datenum('19:03:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
%spiral=[datenum('15:53:00') datenum('16:05:10')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); !!! update this
% spiral
spiral=[datenum('15:52:05') datenum('16:05:08')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% Alt (4642)-(5405)-ascent
% daystr=mfilename;
% daystr=daystr(end-7:end);
% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% No good time periods ([start end]) for specific pixels
s.ng=s.ng;

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.328;
s.NO2col=2.66e15;

% other tweaks
s.Pst(find(s.Pst<=10))=1013.25;

% Corrections 
s.note=['See ' mfilename '.m for additional info. ' s.note];
