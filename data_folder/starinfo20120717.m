% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests.
% s.ng=[];
% daystr=mfilename;
% daystr=daystr(end-7:end);
% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
flight=[datenum('13:58:25') datenum('17:24:07')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
%vertprof=[datenum('15:44:51') datenum('15:56:52')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
%!!! update vertprof
%spiral=[datenum('15:44:50') datenum('15:56:50'); datenum('16:30:05') datenum('16:53:25')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
spiral=[datenum('14:55:48') datenum('15:15:00'); datenum('15:28:00') datenum('15:34:48'); datenum('16:30:00') datenum('16:39:36');datenum('15:45:00') datenum('15:55:48');datenum('17:06:36') datenum('17:16:12')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% % % Hi Yohei,
% % % 
% % % Do you know of any “glitch” that occurred on July 17th? Forj “hiccup” etc.?
% % % I am getting a weird jump in my retrieved values after 15.76UT.
% % % 
% % % Let me know,
% % % Michal

% Ray Rogers says 4STAR above-3km AOD is 0.12 at 532 nm, and the HSRL 3km-to-B200 layer AOD is 0.06. He remembers a report of something above the B200 - no good for layer AOD comparison. 

% No good time periods ([start end]) for specific pixels
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
