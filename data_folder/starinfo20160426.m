langley=[datenum('14:12:00') datenum('16:00')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
flight =[datenum('12:33:54') datenum('17:15')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
% quantile(g.omi,[.025 .25 .50 .75 .975])
% 231.7000  244.1000  249.7000  256.1000  319.8000
% omi NO2s is:
% 1x15*[1.9588    2.1015    2.2167    2.4050    2.7541];

s.O3h=21;
s.O3col=0.320;    % OMI's median;first transit
s.NO2col=2.5e15;  % OMI's median;first transit

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


