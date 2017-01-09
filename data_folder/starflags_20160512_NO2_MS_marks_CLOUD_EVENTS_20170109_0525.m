function marks = starflags_20160512_NO2_MS_marks_CLOUD_EVENTS_20170109_0525  
 % starflags file for 20160512 created by MS on 20170109_0525 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0525'); 
 daystr = '20160512';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:01:50') datenum('01:04:01') 03 
datenum('01:04:45') datenum('01:05:13') 03 
datenum('01:14:16') datenum('01:14:54') 03 
datenum('01:14:57') datenum('01:15:10') 03 
datenum('01:15:41') datenum('01:15:42') 03 
datenum('01:15:57') datenum('01:17:17') 03 
datenum('01:18:16') datenum('01:27:43') 03 
datenum('01:19:48') datenum('01:19:53') 700 
datenum('01:01:50') datenum('01:04:01') 10 
datenum('01:04:45') datenum('01:05:13') 10 
datenum('01:14:16') datenum('01:14:54') 10 
datenum('01:14:57') datenum('01:15:10') 10 
datenum('01:15:41') datenum('01:15:42') 10 
datenum('01:15:57') datenum('01:17:17') 10 
datenum('01:18:16') datenum('01:27:43') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return