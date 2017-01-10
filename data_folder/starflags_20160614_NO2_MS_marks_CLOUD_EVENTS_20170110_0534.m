function marks = starflags_20160614_NO2_MS_marks_CLOUD_EVENTS_20170110_0534  
 % starflags file for 20160614 created by MS on 20170110_0534 to mark CLOUD_EVENTS conditions 
 version_set('20170110_0534'); 
 daystr = '20160614';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('04:47:44') datenum('04:50:50') 03 
datenum('05:14:59') datenum('05:15:46') 03 
datenum('05:16:34') datenum('05:20:04') 03 
datenum('05:20:07') datenum('05:20:09') 03 
datenum('05:21:13') datenum('05:21:26') 03 
datenum('05:21:30') datenum('05:21:51') 03 
datenum('05:22:53') datenum('05:23:39') 03 
datenum('05:56:57') datenum('05:58:10') 03 
datenum('05:59:26') datenum('06:05:59') 03 
datenum('04:47:44') datenum('04:47:44') 700 
datenum('04:47:54') datenum('04:47:54') 700 
datenum('04:48:00') datenum('04:48:22') 700 
datenum('04:48:26') datenum('04:49:34') 700 
datenum('04:49:37') datenum('04:49:41') 700 
datenum('04:49:44') datenum('04:49:44') 700 
datenum('04:50:05') datenum('04:50:18') 700 
datenum('05:15:03') datenum('05:15:03') 700 
datenum('05:15:05') datenum('05:15:05') 700 
datenum('05:15:07') datenum('05:15:07') 700 
datenum('05:15:13') datenum('05:15:13') 700 
datenum('05:15:15') datenum('05:15:15') 700 
datenum('05:15:18') datenum('05:15:18') 700 
datenum('05:15:22') datenum('05:15:22') 700 
datenum('05:15:26') datenum('05:15:26') 700 
datenum('05:15:28') datenum('05:15:28') 700 
datenum('05:15:31') datenum('05:15:31') 700 
datenum('05:15:37') datenum('05:15:46') 700 
datenum('05:16:34') datenum('05:16:38') 700 
datenum('05:16:44') datenum('05:16:44') 700 
datenum('05:16:47') datenum('05:16:48') 700 
datenum('05:16:50') datenum('05:16:53') 700 
datenum('05:16:57') datenum('05:16:57') 700 
datenum('05:17:01') datenum('05:17:16') 700 
datenum('05:17:19') datenum('05:17:19') 700 
datenum('05:17:21') datenum('05:17:21') 700 
datenum('05:17:23') datenum('05:17:24') 700 
datenum('05:17:26') datenum('05:17:39') 700 
datenum('05:17:48') datenum('05:17:48') 700 
datenum('05:17:50') datenum('05:17:51') 700 
datenum('05:17:54') datenum('05:17:55') 700 
datenum('05:17:59') datenum('05:17:59') 700 
datenum('05:18:08') datenum('05:18:11') 700 
datenum('05:18:36') datenum('05:18:36') 700 
datenum('05:19:40') datenum('05:20:04') 700 
datenum('05:20:07') datenum('05:20:09') 700 
datenum('05:21:13') datenum('05:21:26') 700 
datenum('05:21:30') datenum('05:21:33') 700 
datenum('05:21:39') datenum('05:21:49') 700 
datenum('05:22:53') datenum('05:22:54') 700 
datenum('05:56:57') datenum('05:56:57') 700 
datenum('05:57:05') datenum('05:57:05') 700 
datenum('05:57:58') datenum('05:58:10') 700 
datenum('06:01:50') datenum('06:01:51') 700 
datenum('04:47:44') datenum('04:50:50') 10 
datenum('05:14:59') datenum('05:15:46') 10 
datenum('05:16:34') datenum('05:20:04') 10 
datenum('05:20:07') datenum('05:20:09') 10 
datenum('05:21:13') datenum('05:21:26') 10 
datenum('05:21:30') datenum('05:21:51') 10 
datenum('05:22:53') datenum('05:23:39') 10 
datenum('05:56:57') datenum('05:58:10') 10 
datenum('05:59:26') datenum('06:05:59') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return