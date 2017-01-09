function marks = starflags_20160519_NO2_MS_marks_CLOUD_EVENTS_20170109_0754  
 % starflags file for 20160519 created by MS on 20170109_0754 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0754'); 
 daystr = '20160519';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:53:28') datenum('23:54:39') 03 
datenum('24:48:46') datenum('24:56:23') 03 
datenum('25:14:16') datenum('25:25:42') 03 
datenum('25:34:13') datenum('25:35:15') 03 
datenum('26:41:36') datenum('26:42:46') 03 
datenum('27:08:01') datenum('27:09:01') 03 
datenum('29:09:54') datenum('30:24:54') 03 
datenum('30:39:32') datenum('30:44:03') 03 
datenum('23:53:36') datenum('23:54:35') 700 
datenum('24:49:12') datenum('24:50:07') 700 
datenum('25:17:43') datenum('25:17:44') 700 
datenum('25:17:56') datenum('25:18:01') 700 
datenum('25:24:32') datenum('25:24:32') 700 
datenum('25:25:10') datenum('25:25:11') 700 
datenum('29:14:29') datenum('29:14:30') 700 
datenum('29:14:37') datenum('29:14:37') 700 
datenum('29:16:04') datenum('29:16:38') 700 
datenum('29:21:48') datenum('29:21:48') 700 
datenum('29:21:55') datenum('29:21:55') 700 
datenum('29:21:57') datenum('29:21:57') 700 
datenum('29:25:40') datenum('29:25:45') 700 
datenum('29:31:42') datenum('29:31:47') 700 
datenum('29:44:44') datenum('29:44:46') 700 
datenum('29:47:49') datenum('29:47:52') 700 
datenum('29:47:54') datenum('29:47:55') 700 
datenum('29:49:55') datenum('29:50:00') 700 
datenum('29:52:32') datenum('29:52:32') 700 
datenum('30:08:15') datenum('30:08:20') 700 
datenum('30:39:32') datenum('30:39:38') 700 
datenum('23:53:28') datenum('23:54:39') 10 
datenum('24:48:46') datenum('24:56:23') 10 
datenum('25:14:16') datenum('25:25:42') 10 
datenum('25:34:13') datenum('25:35:15') 10 
datenum('26:41:36') datenum('26:42:46') 10 
datenum('27:08:01') datenum('27:09:01') 10 
datenum('29:09:54') datenum('30:24:54') 10 
datenum('30:39:32') datenum('30:44:03') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return