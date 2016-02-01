function starinfo20130803
%get variables from caller
s=evalin('caller','s');
daystr=evalin('caller','daystr');

% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
s.ng=[];
flight=[datenum('00:00:00') datenum('02:15:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
!!! A rough timing reported by Roy, to be updated.

% daystr=mfilename;
% daystr=daystr(end-7:end);
% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
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

