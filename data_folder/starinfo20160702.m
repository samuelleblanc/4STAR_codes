ground =[datenum('16:13:00') datenum('18:08')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);  
langley=[datenum('16:13:00') datenum('18:08')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 

%langley1=[datenum(2016,07,02,16,13,00) datenum(2016,07,02,18,08,00)]; %morning Langley 2-12 NB: instrument error (I think?) means we lost between ~14 and ~11 airmass here; 16:10 actually starts around 16:13, and airmass 11 (rayleigh)
%langley2=[datenum(2016,07,03,03,00,00) datenum(2016,07,03,05,00,00)]; %evening Langley airmass ~2.2 to 12 (all we had for that one)

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.258; % OMI overpass
s.NO2col=3.18e15; % OMI overpass

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=680;%MLO
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


