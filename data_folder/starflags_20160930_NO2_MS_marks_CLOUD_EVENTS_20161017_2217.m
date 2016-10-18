function marks = starflags_20160930_NO2_MS_marks_CLOUD_EVENTS_20161017_2217  
 % starflags file for 20160930 created by MS on 20161017_2217 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2217'); 
 daystr = '20160930';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:51:24') datenum('10:51:28') 03 
datenum('10:52:46') datenum('10:52:48') 03 
datenum('10:53:57') datenum('10:53:59') 03 
datenum('10:54:39') datenum('10:54:41') 03 
datenum('10:54:50') datenum('10:54:50') 03 
datenum('10:55:02') datenum('10:55:04') 03 
datenum('10:55:10') datenum('10:55:10') 03 
datenum('10:57:34') datenum('10:57:53') 03 
datenum('12:50:31') datenum('12:50:31') 03 
datenum('12:50:40') datenum('12:52:37') 03 
datenum('12:53:45') datenum('12:53:54') 03 
datenum('12:53:56') datenum('12:54:05') 03 
datenum('12:54:08') datenum('12:54:16') 03 
datenum('15:47:42') datenum('15:48:50') 03 
datenum('15:50:02') datenum('15:51:24') 03 
datenum('15:51:36') datenum('15:51:36') 03 
datenum('15:51:38') datenum('15:51:56') 03 
datenum('15:56:42') datenum('15:57:28') 03 
datenum('10:52:46') datenum('10:52:48') 700 
datenum('10:53:57') datenum('10:53:59') 700 
datenum('10:54:39') datenum('10:54:41') 700 
datenum('10:54:50') datenum('10:54:50') 700 
datenum('10:55:02') datenum('10:55:04') 700 
datenum('10:55:10') datenum('10:55:10') 700 
datenum('10:57:34') datenum('10:57:34') 700 
datenum('12:50:51') datenum('12:50:55') 700 
datenum('12:51:00') datenum('12:51:07') 700 
datenum('12:51:41') datenum('12:51:41') 700 
datenum('12:51:44') datenum('12:51:44') 700 
datenum('12:51:47') datenum('12:51:47') 700 
datenum('12:51:54') datenum('12:51:55') 700 
datenum('12:51:57') datenum('12:52:00') 700 
datenum('12:52:02') datenum('12:52:12') 700 
datenum('12:52:19') datenum('12:52:19') 700 
datenum('12:52:25') datenum('12:52:25') 700 
datenum('15:47:59') datenum('15:48:38') 700 
datenum('15:48:41') datenum('15:48:50') 700 
datenum('15:50:14') datenum('15:50:15') 700 
datenum('15:50:18') datenum('15:51:24') 700 
datenum('15:57:07') datenum('15:57:28') 700 
datenum('10:51:24') datenum('10:51:28') 10 
datenum('10:52:46') datenum('10:52:48') 10 
datenum('10:53:57') datenum('10:53:59') 10 
datenum('10:54:39') datenum('10:54:41') 10 
datenum('10:54:50') datenum('10:54:50') 10 
datenum('10:55:02') datenum('10:55:04') 10 
datenum('10:55:10') datenum('10:55:10') 10 
datenum('10:57:34') datenum('10:57:53') 10 
datenum('12:50:31') datenum('12:50:31') 10 
datenum('12:50:40') datenum('12:52:37') 10 
datenum('12:53:45') datenum('12:53:54') 10 
datenum('12:53:56') datenum('12:54:05') 10 
datenum('12:54:08') datenum('12:54:16') 10 
datenum('15:47:42') datenum('15:48:50') 10 
datenum('15:50:02') datenum('15:51:24') 10 
datenum('15:51:36') datenum('15:51:36') 10 
datenum('15:51:38') datenum('15:51:56') 10 
datenum('15:56:42') datenum('15:57:28') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return