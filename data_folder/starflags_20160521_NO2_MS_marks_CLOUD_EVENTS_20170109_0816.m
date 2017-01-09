function marks = starflags_20160521_NO2_MS_marks_CLOUD_EVENTS_20170109_0816  
 % starflags file for 20160521 created by MS on 20170109_0816 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0816'); 
 daystr = '20160521';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:05:32') datenum('23:06:22') 03 
datenum('23:06:30') datenum('23:06:53') 03 
datenum('23:07:00') datenum('23:07:22') 03 
datenum('23:07:27') datenum('23:09:10') 03 
datenum('24:25:59') datenum('24:28:20') 03 
datenum('24:40:32') datenum('25:03:17') 03 
datenum('25:17:59') datenum('25:23:10') 03 
datenum('25:46:38') datenum('25:46:44') 03 
datenum('25:47:43') datenum('25:47:46') 03 
datenum('25:52:02') datenum('25:53:01') 03 
datenum('25:58:07') datenum('25:58:51') 03 
datenum('25:58:53') datenum('26:03:18') 03 
datenum('26:24:43') datenum('26:27:29') 03 
datenum('29:28:11') datenum('29:51:56') 03 
datenum('30:37:47') datenum('30:37:47') 03 
datenum('30:37:57') datenum('30:37:57') 03 
datenum('30:38:19') datenum('30:38:21') 03 
datenum('30:38:51') datenum('30:39:14') 03 
datenum('23:06:36') datenum('23:06:40') 700 
datenum('23:06:47') datenum('23:06:47') 700 
datenum('23:06:52') datenum('23:06:52') 700 
datenum('23:07:01') datenum('23:07:02') 700 
datenum('23:07:19') datenum('23:07:19') 700 
datenum('23:08:35') datenum('23:08:36') 700 
datenum('24:27:34') datenum('24:27:34') 700 
datenum('24:27:52') datenum('24:27:56') 700 
datenum('24:28:00') datenum('24:28:01') 700 
datenum('24:43:23') datenum('24:43:28') 700 
datenum('25:01:43') datenum('25:01:48') 700 
datenum('25:02:46') datenum('25:02:46') 700 
datenum('25:02:48') datenum('25:02:48') 700 
datenum('25:02:51') datenum('25:02:52') 700 
datenum('25:02:54') datenum('25:03:17') 700 
datenum('25:19:58') datenum('25:20:01') 700 
datenum('25:21:57') datenum('25:22:01') 700 
datenum('25:47:43') datenum('25:47:43') 700 
datenum('25:52:02') datenum('25:52:08') 700 
datenum('25:58:37') datenum('25:58:41') 700 
datenum('26:00:45') datenum('26:00:45') 700 
datenum('26:01:00') datenum('26:01:00') 700 
datenum('26:01:15') datenum('26:01:15') 700 
datenum('26:01:22') datenum('26:01:38') 700 
datenum('26:01:40') datenum('26:01:40') 700 
datenum('26:25:21') datenum('26:25:25') 700 
datenum('26:27:08') datenum('26:27:10') 700 
datenum('29:28:11') datenum('29:37:08') 700 
datenum('29:37:15') datenum('29:51:56') 700 
datenum('23:05:32') datenum('23:06:22') 10 
datenum('23:06:30') datenum('23:06:53') 10 
datenum('23:07:00') datenum('23:07:22') 10 
datenum('23:07:27') datenum('23:09:10') 10 
datenum('24:25:59') datenum('24:28:20') 10 
datenum('24:40:32') datenum('25:03:17') 10 
datenum('25:17:59') datenum('25:23:10') 10 
datenum('25:46:38') datenum('25:46:44') 10 
datenum('25:47:43') datenum('25:47:46') 10 
datenum('25:52:02') datenum('25:53:01') 10 
datenum('25:58:07') datenum('25:58:51') 10 
datenum('25:58:53') datenum('26:03:18') 10 
datenum('26:24:43') datenum('26:27:29') 10 
datenum('29:28:11') datenum('29:51:56') 10 
datenum('30:37:47') datenum('30:37:47') 10 
datenum('30:37:57') datenum('30:37:57') 10 
datenum('30:38:19') datenum('30:38:21') 10 
datenum('30:38:51') datenum('30:39:14') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return