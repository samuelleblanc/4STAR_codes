flight=[datenum(2016,4,18,19,17,0) datenum(2016,4,18,22,42,30)]; !!! to be updated 

circles = [datenum(2016,4,18,20,08,48) datenum(2016,4,18,20,16,41)
    datenum(2016,4,18,20,16,41) datenum(2016,4,18,20,25,30)];
% Ozone and other gases
s.O3h=21; % Yohei's guess
s.O3col=0.300; % Yohei's guess    
s.NO2col=2.0e15; % Yohei's guess 

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=1013.25; 
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