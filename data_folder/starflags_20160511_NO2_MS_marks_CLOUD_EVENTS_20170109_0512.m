function marks = starflags_20160511_NO2_MS_marks_CLOUD_EVENTS_20170109_0512  
 % starflags file for 20160511 created by MS on 20170109_0512 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0512'); 
 daystr = '20160511';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:36:09') datenum('23:37:15') 03 
datenum('24:19:48') datenum('24:21:55') 03 
datenum('24:22:30') datenum('24:22:39') 03 
datenum('24:23:32') datenum('24:23:35') 03 
datenum('24:32:09') datenum('24:33:16') 03 
datenum('24:34:35') datenum('24:34:50') 03 
datenum('24:35:41') datenum('24:35:44') 03 
datenum('25:31:58') datenum('25:32:28') 03 
datenum('25:35:48') datenum('25:38:05') 03 
datenum('25:49:54') datenum('25:50:54') 03 
datenum('26:23:37') datenum('26:23:38') 03 
datenum('26:23:58') datenum('26:23:59') 03 
datenum('26:24:03') datenum('26:24:04') 03 
datenum('26:24:56') datenum('26:24:58') 03 
datenum('26:25:01') datenum('26:25:02') 03 
datenum('26:25:27') datenum('26:30:20') 03 
datenum('23:36:48') datenum('23:36:52') 700 
datenum('24:19:48') datenum('24:19:49') 700 
datenum('24:19:55') datenum('24:20:50') 700 
datenum('24:20:56') datenum('24:20:57') 700 
datenum('24:20:59') datenum('24:21:04') 700 
datenum('24:21:15') datenum('24:21:15') 700 
datenum('24:32:16') datenum('24:33:06') 700 
datenum('24:33:11') datenum('24:33:12') 700 
datenum('25:31:58') datenum('25:32:13') 700 
datenum('25:35:48') datenum('25:35:55') 700 
datenum('25:36:31') datenum('25:36:41') 700 
datenum('25:36:43') datenum('25:37:17') 700 
datenum('25:49:55') datenum('25:50:54') 700 
datenum('26:27:57') datenum('26:27:57') 700 
datenum('23:36:09') datenum('23:37:15') 10 
datenum('24:19:48') datenum('24:21:55') 10 
datenum('24:22:30') datenum('24:22:39') 10 
datenum('24:23:32') datenum('24:23:35') 10 
datenum('24:32:09') datenum('24:33:16') 10 
datenum('24:34:35') datenum('24:34:50') 10 
datenum('24:35:41') datenum('24:35:44') 10 
datenum('25:31:58') datenum('25:32:28') 10 
datenum('25:35:48') datenum('25:38:05') 10 
datenum('25:49:54') datenum('25:50:54') 10 
datenum('26:23:37') datenum('26:23:38') 10 
datenum('26:23:58') datenum('26:23:59') 10 
datenum('26:24:03') datenum('26:24:04') 10 
datenum('26:24:56') datenum('26:24:58') 10 
datenum('26:25:01') datenum('26:25:02') 10 
datenum('26:25:27') datenum('26:30:20') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return