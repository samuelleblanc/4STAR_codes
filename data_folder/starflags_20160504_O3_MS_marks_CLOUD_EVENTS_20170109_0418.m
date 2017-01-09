function marks = starflags_20160504_O3_MS_marks_CLOUD_EVENTS_20170109_0418  
 % starflags file for 20160504 created by MS on 20170109_0418 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0418'); 
 daystr = '20160504';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:20:00') datenum('00:22:04') 03 
datenum('00:31:33') datenum('00:31:50') 03 
datenum('00:34:03') datenum('00:34:37') 03 
datenum('01:59:33') datenum('01:59:45') 03 
datenum('02:00:27') datenum('02:00:27') 03 
datenum('02:01:04') datenum('02:01:27') 03 
datenum('02:02:27') datenum('02:05:31') 03 
datenum('02:07:58') datenum('02:09:06') 03 
datenum('03:42:41') datenum('03:42:41') 03 
datenum('03:52:23') datenum('03:54:25') 03 
datenum('03:54:29') datenum('03:54:36') 03 
datenum('03:54:38') datenum('03:55:17') 03 
datenum('03:55:19') datenum('03:55:46') 03 
datenum('03:55:48') datenum('03:59:03') 03 
datenum('03:59:05') datenum('03:59:05') 03 
datenum('00:20:15') datenum('00:20:15') 700 
datenum('00:20:25') datenum('00:21:34') 700 
datenum('00:21:42') datenum('00:21:43') 700 
datenum('00:21:51') datenum('00:21:51') 700 
datenum('00:31:33') datenum('00:31:34') 700 
datenum('00:34:03') datenum('00:34:05') 700 
datenum('02:01:08') datenum('02:01:08') 700 
datenum('02:01:19') datenum('02:01:19') 700 
datenum('02:01:21') datenum('02:01:27') 700 
datenum('02:02:27') datenum('02:03:05') 700 
datenum('02:03:08') datenum('02:03:19') 700 
datenum('02:03:23') datenum('02:03:24') 700 
datenum('02:03:55') datenum('02:03:56') 700 
datenum('02:04:00') datenum('02:04:14') 700 
datenum('02:04:56') datenum('02:05:01') 700 
datenum('02:08:28') datenum('02:08:36') 700 
datenum('03:52:23') datenum('03:54:25') 700 
datenum('03:54:29') datenum('03:54:36') 700 
datenum('03:54:38') datenum('03:55:17') 700 
datenum('03:55:19') datenum('03:55:46') 700 
datenum('03:55:48') datenum('03:58:36') 700 
datenum('00:20:00') datenum('00:22:04') 10 
datenum('00:31:33') datenum('00:31:50') 10 
datenum('00:34:03') datenum('00:34:37') 10 
datenum('01:59:33') datenum('01:59:45') 10 
datenum('02:00:27') datenum('02:00:27') 10 
datenum('02:01:04') datenum('02:01:27') 10 
datenum('02:02:27') datenum('02:05:31') 10 
datenum('02:07:58') datenum('02:09:06') 10 
datenum('03:42:41') datenum('03:42:41') 10 
datenum('03:52:23') datenum('03:54:25') 10 
datenum('03:54:29') datenum('03:54:36') 10 
datenum('03:54:38') datenum('03:55:17') 10 
datenum('03:55:19') datenum('03:55:46') 10 
datenum('03:55:48') datenum('03:59:03') 10 
datenum('03:59:05') datenum('03:59:05') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return