
flight=[datenum(2016,9,8,7,05,08) datenum(2016,9,8,15,01,20)];
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55)
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)];
s.sd_aero_crit=Inf
    ng = [datenum('2016-09-08 7:20:40') datenum('2016-09-08 7:20:47' ) 90 % probably cirrus above
        datenum('2016-09-08 7:24:12') datenum('2016-09-08 7:28:25') 90% cirrus above
        datenum('2016-09-08 10:54:38') datenum('2016-09-08 10:54:45') 3 % tracking error while turning
        datenum('2016-09-08 11:16:33') datenum('2016-09-08 11:22:31') 10 % scattered clouds
        datenum('2016-09-08 11:22:54') datenum('2016-09-08 11:33:36') 10 % scattered clouds
        datenum('2016-09-08 11:34:06') datenum('2016-09-08 11:34:10') 10 % scattered clouds
        datenum('2016-09-08 11:34:22') datenum('2016-09-08 11:37:06') 10 % in clouds, then clouds above
        datenum('2016-09-08 12:31:45') datenum('2016-09-08 12:31:51') 10 % scattered clouds
        datenum('2016-09-08 12:32:58') datenum('2016-09-08 12:33:00') 10 % scattered clouds
        datenum('2016-09-08 12:33:16') datenum('2016-09-08 12:33:26') 10 % scattered clouds
        datenum('2016-09-08 12:33:31') datenum('2016-09-08 12:33:36') 10 % scattered clouds
        datenum('2016-09-08 12:34:01') datenum('2016-09-08 12:45:32') 10 % in clouds
        datenum('2016-09-08 12:45:57') datenum('2016-09-08 12:47:25') 10 % scattered clouds
        datenum('2016-09-08 12:48:19') datenum('2016-09-08 12:50:56') 10 % clouds
        datenum('2016-09-08 12:51:20') datenum('2016-09-08 12:53:06') 10 % clouds
        datenum('2016-09-08 13:00:59') datenum('2016-09-08 13:07:51') 10 % cloud deck 
        datenum('2016-09-08 14:10:10') datenum('2016-09-08 14:10:12') 10 % scattered clouds
        datenum('2016-09-08 14:10:38') datenum('2016-09-08 14:11:10') 10 % below scattered clouds, then in them
        datenum('2016-09-08 14:13:30') datenum('2016-09-08 14:14:10') 90 % cirrus
        datenum('2016-09-08 14:15:56') datenum('2016-09-08 14:15:59') 90 % cirrus
        datenum('2016-09-08 14:16:08') datenum('2016-09-08 14:16:02') 90 % cirrus
        datenum('2016-09-08 14:16:35') datenum('2016-09-08 14:20:58') 10 % scattered clouds
        datenum('2016-09-08 14:49:00') datenum('2016-09-08 14:54:35') 700 % probably clouds above - hard to tell because fine aerosols must have been also abundant
        datenum('2016-09-08 15:00:00') datenum('2016-09-08 15:00:00') 700 % unknown, a jump in the AOD time series
    ];
%  flag_tags =          [1,                      2 ,                3,                  10,      90,            100,         200,     300,        400,       500,        600,     700,     800,   900,                1000];
%  flag_names = {'unknown','before_or_after_flight','tracking_errors','unspecified_clouds','cirrus','inst_trouble' ,'inst_tests' ,'frost','low_cloud','hor_legs','vert_legs','bad_aod','smoke','dust','unspecified_aerosol'};

% notes
% 12:16 the operator notes "briefly in clouds", but no sign of this is discernible in the 4STAR AOD.
% 1300-1400 changing atitudes through layers of aerosols and under few, if any, discernible clouds. 

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