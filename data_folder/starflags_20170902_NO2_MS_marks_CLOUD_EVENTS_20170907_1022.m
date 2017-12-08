function marks = starflags_20170902_NO2_MS_marks_CLOUD_EVENTS_20170907_1022  
 % starflags file for 20170902 created by MS on 20170907_1022 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1022'); 
 daystr = '20170902';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:33:53') datenum('12:33:53') 700 
datenum('12:33:55') datenum('12:34:05') 700 
datenum('12:34:08') datenum('12:34:09') 700 
datenum('12:34:23') datenum('12:34:24') 700 
datenum('12:35:43') datenum('12:35:54') 700 
datenum('12:33:17') datenum('12:33:53') 10 
datenum('12:33:55') datenum('12:34:05') 10 
datenum('12:34:08') datenum('12:34:09') 10 
datenum('12:34:23') datenum('12:34:24') 10 
datenum('12:35:43') datenum('13:20:40') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return