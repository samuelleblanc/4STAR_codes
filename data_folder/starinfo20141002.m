flight=[datenum('21:33:00') datenum('29:53')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
langley=[datenum('25:00:00') datenum('27:36:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
%this is Langley flight- start on Oct-02-2014, Langley portion on Oct-03 2014 UTC
% 
% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
% daystr=mfilename;
% daystr=daystr(end-7:end);
% No good time periods ([start end]) for specific pixels
s.ng=s.ng;
% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.01;

% Ozone and other gases
s.O3h=21;
s.O3col =0.338;  % this is from OMI 10-02-2014 L2 23:20 UTC file%L2G 321
s.NO2col=3.15e15;% OMI stratospheric value

% other tweaks
if isfield(s, 'Pst');
    s.Pst(find(s.Pst<10))=1013;
end;
if isfield(s, 'Lon') & isfield(s, 'Lat');
    ng=[find(s.Lon==0 & s.Lat==0); find(abs(s.Lon)>180); find(abs(s.Lat)>90)];
    s.Lon(ng)=NaN;
    s.Lat(ng)=NaN;
end;
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg');
    s.AZ_deg=s.AZstep/(-50);
end;

% notes
if isfield(s, 'note');
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']};
end;

