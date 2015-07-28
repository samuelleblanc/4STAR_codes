%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost, 400 for dirt.
s.ng=[]; 
flight=[datenum('15:17:00') datenum('16:46:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% No good time periods ([start end]) for specific pixels
s.ng=s.ng;

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.319; % to be filled
s.NO2col=2.85e15; % to be filled

% other tweaks
s.Pst(find(s.Pst<=10))=1013.25;

% Corrections
s.note=['See ' mfilename '.m for additional info. ' s.note];
