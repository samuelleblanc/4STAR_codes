function marks = starflags_20160511_O3_MS_marks_CLOUD_EVENTS_20170109_0501  
 % starflags file for 20160511 created by MS on 20170109_0501 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0501'); 
 daystr = '20160511';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:35:05') datenum('01:36:22') 03 
datenum('01:50:20') datenum('01:50:20') 03 
datenum('01:50:22') datenum('01:51:25') 03 
datenum('02:33:55') datenum('02:36:17') 03 
datenum('02:39:14') datenum('02:40:15') 03 
datenum('02:48:47') datenum('02:50:01') 03 
datenum('02:53:23') datenum('02:54:32') 03 
datenum('02:55:22') datenum('02:56:29') 03 
datenum('03:00:44') datenum('03:01:53') 03 
datenum('03:02:19') datenum('03:03:24') 03 
datenum('03:08:45') datenum('03:09:49') 03 
datenum('03:36:03') datenum('03:37:36') 03 
datenum('03:49:32') datenum('03:50:48') 03 
datenum('04:17:29') datenum('04:44:14') 03 
datenum('06:25:16') datenum('06:31:11') 03 
datenum('01:35:48') datenum('01:35:54') 700 
datenum('01:50:50') datenum('01:50:55') 700 
datenum('02:34:27') datenum('02:34:45') 700 
datenum('02:35:37') datenum('02:35:56') 700 
datenum('02:36:01') datenum('02:36:17') 700 
datenum('02:39:43') datenum('02:39:51') 700 
datenum('02:49:22') datenum('02:49:30') 700 
datenum('02:53:54') datenum('02:54:01') 700 
datenum('02:55:53') datenum('02:55:58') 700 
datenum('03:01:14') datenum('03:01:22') 700 
datenum('03:02:49') datenum('03:02:53') 700 
datenum('03:09:15') datenum('03:09:18') 700 
datenum('03:36:34') datenum('03:36:41') 700 
datenum('03:37:03') datenum('03:37:09') 700 
datenum('03:37:30') datenum('03:37:30') 700 
datenum('03:50:15') datenum('03:50:18') 700 
datenum('04:26:56') datenum('04:27:00') 700 
datenum('04:29:41') datenum('04:29:41') 700 
datenum('04:29:43') datenum('04:29:43') 700 
datenum('04:32:08') datenum('04:32:08') 700 
datenum('04:32:11') datenum('04:32:12') 700 
datenum('04:33:28') datenum('04:33:28') 700 
datenum('04:33:30') datenum('04:33:35') 700 
datenum('04:35:00') datenum('04:35:01') 700 
datenum('04:35:52') datenum('04:35:55') 700 
datenum('04:37:12') datenum('04:37:12') 700 
datenum('04:37:19') datenum('04:37:20') 700 
datenum('04:38:37') datenum('04:38:43') 700 
datenum('06:26:15') datenum('06:26:25') 700 
datenum('06:26:57') datenum('06:26:58') 700 
datenum('06:27:56') datenum('06:28:57') 700 
datenum('06:29:51') datenum('06:29:52') 700 
datenum('01:35:05') datenum('01:36:22') 10 
datenum('01:50:20') datenum('01:50:20') 10 
datenum('01:50:22') datenum('01:51:25') 10 
datenum('02:33:55') datenum('02:36:17') 10 
datenum('02:39:14') datenum('02:40:15') 10 
datenum('02:48:47') datenum('02:50:01') 10 
datenum('02:53:23') datenum('02:54:32') 10 
datenum('02:55:22') datenum('02:56:29') 10 
datenum('03:00:44') datenum('03:01:53') 10 
datenum('03:02:19') datenum('03:03:24') 10 
datenum('03:08:45') datenum('03:09:49') 10 
datenum('03:36:03') datenum('03:37:36') 10 
datenum('03:49:32') datenum('03:50:48') 10 
datenum('04:17:29') datenum('04:44:14') 10 
datenum('06:25:16') datenum('06:31:11') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return