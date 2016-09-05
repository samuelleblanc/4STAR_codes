
% flight=[datenum(2016,6,18,17,00,00) datenum(2016,6,18,22,34,43)];
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55)
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)];
langley=[datenum(2016,8,25,17,00,00) datenum(2016,8,25,19,15,00)];

% Ozone and other gases
s.O3h=21; % 
s.O3col=0.280; % 4star retrieval    
s.NO2col=2.0e15; % 4star  

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=680.25; 
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