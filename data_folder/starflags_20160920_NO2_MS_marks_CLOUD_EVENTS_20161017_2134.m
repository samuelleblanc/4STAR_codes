function marks = starflags_20160920_NO2_MS_marks_CLOUD_EVENTS_20161017_2134  
 % starflags file for 20160920 created by MS on 20161017_2134 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2134'); 
 daystr = '20160920';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:35:32') datenum('09:37:53') 03 
datenum('12:01:12') datenum('12:03:37') 03 
datenum('12:03:40') datenum('12:03:45') 03 
datenum('12:07:05') datenum('12:08:06') 03 
datenum('12:08:46') datenum('12:08:47') 03 
datenum('12:08:49') datenum('12:08:49') 03 
datenum('12:08:52') datenum('12:08:54') 03 
datenum('12:08:56') datenum('12:08:57') 03 
datenum('09:35:44') datenum('09:35:45') 700 
datenum('09:36:17') datenum('09:36:18') 700 
datenum('09:37:49') datenum('09:37:53') 700 
datenum('12:01:39') datenum('12:01:42') 700 
datenum('12:03:07') datenum('12:03:17') 700 
datenum('12:07:33') datenum('12:07:37') 700 
datenum('09:35:32') datenum('09:37:53') 10 
datenum('12:01:12') datenum('12:03:37') 10 
datenum('12:03:40') datenum('12:03:45') 10 
datenum('12:07:05') datenum('12:08:06') 10 
datenum('12:08:46') datenum('12:08:47') 10 
datenum('12:08:49') datenum('12:08:49') 10 
datenum('12:08:52') datenum('12:08:54') 10 
datenum('12:08:56') datenum('12:08:57') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return