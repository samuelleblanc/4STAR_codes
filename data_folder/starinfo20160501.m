flight =[datenum(2016,5,1,22,30,00) datenum(2016,5,2,6,55,17)];  
ground =[datenum('02:37:27') datenum('06:07:07')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
% s.O3col=0.360;    % OMI's median;first transit
% s.NO2col=3.0e16;  % OMI's median;first transit

s.O3col=0.330;    % OMI O3 average along the track, Qin
s.NO2col=2.96e15;  % OMI NO2 average along the track 

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=1013;
end;
if isfield(s, 'Lon') & isfield(s, 'Lat');
    s.Lon(s.Lon==0 & s.Lat==0)=NaN;
    s.Lat(s.Lon==0 & s.Lat==0)=NaN;
    s.Lon(isnan(s.Lon))       =127.0264; % tweaks for Osan AFB
    s.Lat(s.Lat==0)           =37.0878;  % tweaks for Osan AFB 
    s.Alt(s.Alt==14)          =35.7;  % tweaks for Osan AFB
    s.Alt(s.Alt==0)           =35.7;  % tweaks for Osan AFB  
end;
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg');
    s.AZ_deg=s.AZstep/(-50);
end;

% notes
if isfield(s, 'note');
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']};
end;


