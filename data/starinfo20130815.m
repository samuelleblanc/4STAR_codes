function starinfo20130815
%get variables from caller
s=evalin('caller','s');
daystr=evalin('caller','daystr');


% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
flight=[datenum('15:41:45') datenum('23:00:40')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
!!! rough timing
horilegs=[datenum('17:28:40') datenum('18:01:05'); datenum('18:05:24') datenum('18:11:25'); datenum('18:16:50') datenum('18:19:48'); datenum('18:22:09') datenum('18:46:25'); datenum('18:47:30') datenum('18:53:50'); datenum('18:55:00') datenum('18:56:00'); datenum('18:56:30') datenum('18:58:30'); datenum('19:00:07') datenum('19:24:40')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
!!! horilegs to be completed
% vertprof=[datenum('22:10:10') datenum('22:27:20'); datenum('22:27:20') datenum('22:42:29'); datenum('23:01:50') datenum('23:33:30')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
!!! vertprof to be completed
% daystr=mfilename;
% daystr=daystr(end-7:end);
% No good time periods ([start end]) for specific pixels
s.ng=s.ng;

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.300;  % Yohei's guess, to be updated
s.NO2col=5e15; % Yohei's guess, to be updated

% other tweaks
s.Pst(find(s.Pst<10))=1013; 

% Corrections 
s.note=['See ' mfilename '.m for additional info. ' s.note];

%push variable to caller
varNames=who();
for i=1:length(varNames)
  assignin('caller',varNames{i},eval(varNames{i}));
end;
end

