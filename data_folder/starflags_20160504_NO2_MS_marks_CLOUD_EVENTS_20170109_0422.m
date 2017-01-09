function marks = starflags_20160504_NO2_MS_marks_CLOUD_EVENTS_20170109_0422  
 % starflags file for 20160504 created by MS on 20170109_0422 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0422'); 
 daystr = '20160504';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:29:00') datenum('22:29:19') 03 
datenum('22:30:12') datenum('22:30:14') 03 
datenum('22:30:17') datenum('22:31:32') 03 
datenum('23:57:01') datenum('23:57:08') 03 
datenum('23:57:58') datenum('23:58:05') 03 
datenum('24:39:19') datenum('24:42:12') 03 
datenum('24:50:12') datenum('25:03:36') 03 
datenum('25:07:45') datenum('25:08:59') 03 
datenum('25:11:39') datenum('25:11:46') 03 
datenum('25:12:39') datenum('25:12:46') 03 
datenum('25:37:06') datenum('25:38:16') 03 
datenum('25:38:18') datenum('25:40:12') 03 
datenum('25:40:20') datenum('25:40:48') 03 
datenum('25:40:54') datenum('25:41:00') 03 
datenum('25:41:12') datenum('25:41:14') 03 
datenum('25:41:36') datenum('25:41:37') 03 
datenum('25:41:39') datenum('25:41:40') 03 
datenum('25:41:42') datenum('25:46:15') 03 
datenum('25:46:18') datenum('25:46:19') 03 
datenum('22:29:02') datenum('22:29:03') 700 
datenum('22:29:08') datenum('22:29:09') 700 
datenum('22:29:11') datenum('22:29:11') 700 
datenum('22:29:16') datenum('22:29:19') 700 
datenum('22:30:12') datenum('22:30:14') 700 
datenum('22:30:17') datenum('22:30:26') 700 
datenum('22:30:38') datenum('22:30:38') 700 
datenum('22:30:58') datenum('22:31:24') 700 
datenum('22:31:29') datenum('22:31:32') 700 
datenum('25:07:50') datenum('25:08:52') 700 
datenum('25:08:54') datenum('25:08:54') 700 
datenum('25:42:13') datenum('25:42:18') 700 
datenum('22:29:00') datenum('22:29:19') 10 
datenum('22:30:12') datenum('22:30:14') 10 
datenum('22:30:17') datenum('22:31:32') 10 
datenum('23:57:01') datenum('23:57:08') 10 
datenum('23:57:58') datenum('23:58:05') 10 
datenum('24:39:19') datenum('24:42:12') 10 
datenum('24:50:12') datenum('25:03:36') 10 
datenum('25:07:45') datenum('25:08:59') 10 
datenum('25:11:39') datenum('25:11:46') 10 
datenum('25:12:39') datenum('25:12:46') 10 
datenum('25:37:06') datenum('25:38:16') 10 
datenum('25:38:18') datenum('25:40:12') 10 
datenum('25:40:20') datenum('25:40:48') 10 
datenum('25:40:54') datenum('25:41:00') 10 
datenum('25:41:12') datenum('25:41:14') 10 
datenum('25:41:36') datenum('25:41:37') 10 
datenum('25:41:39') datenum('25:41:40') 10 
datenum('25:41:42') datenum('25:46:15') 10 
datenum('25:46:18') datenum('25:46:19') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return