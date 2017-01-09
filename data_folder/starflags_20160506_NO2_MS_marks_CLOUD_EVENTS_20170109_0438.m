function marks = starflags_20160506_NO2_MS_marks_CLOUD_EVENTS_20170109_0438  
 % starflags file for 20160506 created by MS on 20170109_0438 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0438'); 
 daystr = '20160506';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:57:07') datenum('23:59:13') 03 
datenum('24:36:16') datenum('24:37:35') 03 
datenum('25:11:32') datenum('25:11:36') 03 
datenum('25:18:44') datenum('25:21:47') 03 
datenum('26:31:18') datenum('26:32:38') 03 
datenum('29:18:52') datenum('29:18:52') 03 
datenum('29:18:54') datenum('29:18:54') 03 
datenum('29:19:01') datenum('29:19:01') 03 
datenum('29:21:22') datenum('29:21:23') 03 
datenum('29:21:25') datenum('29:21:25') 03 
datenum('29:21:32') datenum('29:21:34') 03 
datenum('30:01:44') datenum('30:01:48') 03 
datenum('30:01:52') datenum('30:01:52') 03 
datenum('30:01:54') datenum('30:05:32') 03 
datenum('30:26:56') datenum('30:31:05') 03 
datenum('25:20:40') datenum('25:20:40') 700 
datenum('25:20:47') datenum('25:21:16') 700 
datenum('25:21:22') datenum('25:21:30') 700 
datenum('25:21:32') datenum('25:21:35') 700 
datenum('25:21:38') datenum('25:21:41') 700 
datenum('26:31:36') datenum('26:31:37') 700 
datenum('26:32:14') datenum('26:32:19') 700 
datenum('26:32:22') datenum('26:32:23') 700 
datenum('30:02:31') datenum('30:02:31') 700 
datenum('30:02:40') datenum('30:02:40') 700 
datenum('30:02:43') datenum('30:02:43') 700 
datenum('30:02:49') datenum('30:02:49') 700 
datenum('30:02:56') datenum('30:03:10') 700 
datenum('30:03:18') datenum('30:03:19') 700 
datenum('30:03:25') datenum('30:03:26') 700 
datenum('30:03:50') datenum('30:03:50') 700 
datenum('30:03:57') datenum('30:04:01') 700 
datenum('30:05:29') datenum('30:05:29') 700 
datenum('23:57:07') datenum('23:59:13') 10 
datenum('24:36:16') datenum('24:37:35') 10 
datenum('25:11:32') datenum('25:11:36') 10 
datenum('25:18:44') datenum('25:21:47') 10 
datenum('26:31:18') datenum('26:32:38') 10 
datenum('29:18:52') datenum('29:18:52') 10 
datenum('29:18:54') datenum('29:18:54') 10 
datenum('29:19:01') datenum('29:19:01') 10 
datenum('29:21:22') datenum('29:21:23') 10 
datenum('29:21:25') datenum('29:21:25') 10 
datenum('29:21:32') datenum('29:21:34') 10 
datenum('30:01:44') datenum('30:01:48') 10 
datenum('30:01:52') datenum('30:01:52') 10 
datenum('30:01:54') datenum('30:05:32') 10 
datenum('30:26:56') datenum('30:31:05') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return