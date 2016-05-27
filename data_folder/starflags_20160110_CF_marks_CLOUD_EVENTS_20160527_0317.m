function marks = starflags_20160110_CF_marks_CLOUD_EVENTS_20160527_0317  
 % starflags file for 20160110 created by CF on 20160527_0317 to mark CLOUD_EVENTS conditions 
 version_set('20160527_0317'); 
 daystr = '20160110';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('17:01:54') datenum('17:01:54') 700 
datenum('17:01:58') datenum('17:02:18') 700 
datenum('17:02:25') datenum('17:20:18') 700 
datenum('17:21:26') datenum('17:21:43') 700 
datenum('17:21:50') datenum('17:21:51') 700 
datenum('17:22:10') datenum('17:23:21') 700 
datenum('17:23:23') datenum('17:23:23') 700 
datenum('20:28:40') datenum('20:28:40') 700 
datenum('20:28:43') datenum('20:28:48') 700 
datenum('20:36:16') datenum('20:36:20') 700 
datenum('20:36:23') datenum('20:36:26') 700 
datenum('20:36:30') datenum('20:36:33') 700 
datenum('22:00:22') datenum('22:00:25') 700 
datenum('22:00:29') datenum('22:00:31') 700 
datenum('22:00:36') datenum('22:00:36') 700 
datenum('22:00:39') datenum('22:00:40') 700 
datenum('22:02:15') datenum('22:02:15') 700 
datenum('22:02:17') datenum('22:02:17') 700 
datenum('22:02:48') datenum('22:02:48') 700 
datenum('22:02:53') datenum('22:02:56') 700 
datenum('22:03:00') datenum('22:03:03') 700 
datenum('23:08:10') datenum('23:08:13') 700 
datenum('23:08:32') datenum('23:08:32') 700 
datenum('23:08:36') datenum('23:08:39') 700 
datenum('23:08:42') datenum('23:08:46') 700 
datenum('23:08:48') datenum('23:08:50') 700 
datenum('23:08:55') datenum('23:08:57') 700 
datenum('23:09:02') datenum('23:09:05') 700 
datenum('23:10:14') datenum('23:10:19') 700 
datenum('23:10:25') datenum('23:10:31') 700 
datenum('23:40:18') datenum('23:40:21') 700 
datenum('23:40:24') datenum('23:40:24') 700 
datenum('23:40:28') datenum('23:40:28') 700 
datenum('23:40:30') datenum('23:40:32') 700 
datenum('17:01:54') datenum('17:01:54') 10 
datenum('17:01:58') datenum('17:02:18') 10 
datenum('17:02:25') datenum('17:21:43') 10 
datenum('17:21:50') datenum('17:21:51') 10 
datenum('17:22:10') datenum('17:23:21') 10 
datenum('17:23:23') datenum('17:23:23') 10 
datenum('20:28:40') datenum('20:28:40') 10 
datenum('20:28:43') datenum('20:35:38') 10 
datenum('20:35:46') datenum('20:36:33') 10 
datenum('22:00:22') datenum('22:03:03') 10 
datenum('23:08:10') datenum('23:09:05') 10 
datenum('23:10:14') datenum('23:10:19') 10 
datenum('23:10:25') datenum('23:10:31') 10 
datenum('23:40:18') datenum('23:40:33') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return