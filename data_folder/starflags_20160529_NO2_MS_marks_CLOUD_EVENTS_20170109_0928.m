function marks = starflags_20160529_NO2_MS_marks_CLOUD_EVENTS_20170109_0928  
 % starflags file for 20160529 created by MS on 20170109_0928 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0928'); 
 daystr = '20160529';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:59:19') datenum('01:12:19') 03 
datenum('01:17:52') datenum('01:22:07') 03 
datenum('01:25:04') datenum('01:36:01') 03 
datenum('04:39:47') datenum('05:03:49') 03 
datenum('06:42:20') datenum('06:42:20') 03 
datenum('06:42:40') datenum('06:42:59') 03 
datenum('06:43:06') datenum('06:43:10') 03 
datenum('06:51:16') datenum('07:00:54') 03 
datenum('00:59:19') datenum('01:01:14') 700 
datenum('01:02:16') datenum('01:03:52') 700 
datenum('01:03:59') datenum('01:12:19') 700 
datenum('01:17:52') datenum('01:18:06') 700 
datenum('01:18:11') datenum('01:19:32') 700 
datenum('01:19:35') datenum('01:22:07') 700 
datenum('01:26:09') datenum('01:32:07') 700 
datenum('01:32:09') datenum('01:35:42') 700 
datenum('01:35:44') datenum('01:36:01') 700 
datenum('04:46:00') datenum('04:46:00') 700 
datenum('04:53:17') datenum('04:53:22') 700 
datenum('06:42:20') datenum('06:42:20') 700 
datenum('06:42:40') datenum('06:42:59') 700 
datenum('06:43:06') datenum('06:43:10') 700 
datenum('06:51:16') datenum('06:51:36') 700 
datenum('06:51:38') datenum('07:00:54') 700 
datenum('00:59:19') datenum('01:12:19') 10 
datenum('01:17:52') datenum('01:22:07') 10 
datenum('01:25:04') datenum('01:36:01') 10 
datenum('04:39:47') datenum('05:03:49') 10 
datenum('06:42:20') datenum('06:42:20') 10 
datenum('06:42:40') datenum('06:42:59') 10 
datenum('06:43:06') datenum('06:43:10') 10 
datenum('06:51:16') datenum('07:00:54') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return