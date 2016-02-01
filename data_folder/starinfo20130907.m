function starinfo20130907
%get variables from caller
s=evalin('caller','s');
daystr=evalin('caller','daystr');

% No good time periods ([start end]) for specific pixels
s.ng=[datenum('00:00:00') datenum('00:21:59') 90];
s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
flight=[datenum('00:05:04') datenum('00:21:59')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
horilegs=[datenum('00:16:10') datenum('00:16:30');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
vertprofs=[datenum('00:05:06') datenum('00:22:00');...
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

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

%push variable to caller
varNames=who();
for i=1:length(varNames)
  assignin('caller',varNames{i},eval(varNames{i}));
end;
end

