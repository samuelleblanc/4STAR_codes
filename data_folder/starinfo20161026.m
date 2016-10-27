
ground=[datenum(2016,10,26,16,09,23) datenum(2016,10,26,23,10,21)];

% Ozone and other gases
s.O3h=21; % 
s.O3col=0.270; % OMI overhead    
s.NO2col=2.0e15; %  

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=1013; % this is for Ames
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