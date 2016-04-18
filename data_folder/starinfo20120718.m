% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.

% daystr=mfilename;
% daystr=daystr(end-7:end);
% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
flight=[datenum('13:58:08') datenum('17:20:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
spiral=[datenum('15:10:12') datenum('15:16:48');datenum('15:27:00') datenum('15:36:00'); datenum('15:46:48') datenum('15:51:36')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% No good time periods ([start end]) for specific pixels
s.ng=[];
s.ng=s.ng;

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.270; % 0.290; % 0.290 'arctassumer' ; 0.287 'ames' value

% other tweaks
s.Pst(find(s.Pst<10))=1013.25; 

% Corrections 
s.note=['See ' mfilename '.m for additional info. ' s.note];
