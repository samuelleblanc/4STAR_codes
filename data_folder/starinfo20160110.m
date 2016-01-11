ground =[datenum('17:20:00') datenum('23:50')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);  
langley=[datenum('17:20:00') datenum('23:50')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col=0.253;    % OMI overpass Jan-8
s.NO2col=2.64e15; % OMI overpass Jan-8

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


