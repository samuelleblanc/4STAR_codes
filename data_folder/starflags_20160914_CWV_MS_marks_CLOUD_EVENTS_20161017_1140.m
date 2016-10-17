function marks = starflags_20160914_CWV_MS_marks_CLOUD_EVENTS_20161017_1140  
 % starflags file for 20160914 created by MS on 20161017_1140 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1140'); 
 daystr = '20160914';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:00:18') datenum('10:00:20') 03 
datenum('10:01:16') datenum('10:01:16') 03 
datenum('10:26:40') datenum('10:26:43') 03 
datenum('10:34:46') datenum('10:34:46') 03 
datenum('10:41:19') datenum('10:41:20') 03 
datenum('10:41:55') datenum('10:41:57') 03 
datenum('10:43:41') datenum('10:43:52') 03 
datenum('10:45:29') datenum('10:45:34') 03 
datenum('11:10:50') datenum('11:10:52') 03 
datenum('11:21:50') datenum('11:24:19') 03 
datenum('11:31:47') datenum('11:31:50') 03 
datenum('11:32:08') datenum('11:32:08') 03 
datenum('11:32:36') datenum('11:34:39') 03 
datenum('11:44:03') datenum('11:45:31') 03 
datenum('12:05:29') datenum('12:05:30') 03 
datenum('12:17:33') datenum('12:17:33') 03 
datenum('12:17:43') datenum('12:17:50') 03 
datenum('12:20:18') datenum('12:20:37') 03 
datenum('12:20:39') datenum('12:30:58') 03 
datenum('12:43:31') datenum('12:43:33') 03 
datenum('12:43:35') datenum('12:43:36') 03 
datenum('12:43:38') datenum('13:04:33') 03 
datenum('14:11:20') datenum('14:16:28') 03 
datenum('15:30:09') datenum('15:30:13') 03 
datenum('15:57:28') datenum('15:57:38') 03 
datenum('15:57:28') datenum('15:57:38') 02 
datenum('10:43:51') datenum('10:43:51') 700 
datenum('11:22:01') datenum('11:24:18') 700 
datenum('11:32:46') datenum('11:34:37') 700 
datenum('11:44:07') datenum('11:45:31') 700 
datenum('12:20:51') datenum('12:20:51') 700 
datenum('12:29:03') datenum('12:29:06') 700 
datenum('12:29:12') datenum('12:30:58') 700 
datenum('12:43:54') datenum('12:44:01') 700 
datenum('12:44:11') datenum('13:04:33') 700 
datenum('14:16:28') datenum('14:16:28') 700 
datenum('15:57:28') datenum('15:57:38') 700 
datenum('10:00:18') datenum('10:00:20') 10 
datenum('10:01:16') datenum('10:01:16') 10 
datenum('10:26:40') datenum('10:26:43') 10 
datenum('10:34:46') datenum('10:34:46') 10 
datenum('10:41:19') datenum('10:41:20') 10 
datenum('10:41:55') datenum('10:41:57') 10 
datenum('10:43:41') datenum('10:43:52') 10 
datenum('10:45:29') datenum('10:45:34') 10 
datenum('11:10:50') datenum('11:10:52') 10 
datenum('11:21:50') datenum('11:24:19') 10 
datenum('11:31:47') datenum('11:31:50') 10 
datenum('11:32:08') datenum('11:32:08') 10 
datenum('11:32:36') datenum('11:34:39') 10 
datenum('11:44:03') datenum('11:45:31') 10 
datenum('12:05:29') datenum('12:05:30') 10 
datenum('12:17:33') datenum('12:17:33') 10 
datenum('12:17:43') datenum('12:17:50') 10 
datenum('12:20:18') datenum('12:20:37') 10 
datenum('12:20:39') datenum('12:30:58') 10 
datenum('12:43:31') datenum('12:43:33') 10 
datenum('12:43:35') datenum('12:43:36') 10 
datenum('12:43:38') datenum('13:04:33') 10 
datenum('14:11:20') datenum('14:16:28') 10 
datenum('15:30:09') datenum('15:30:13') 10 
datenum('15:57:28') datenum('15:57:38') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return