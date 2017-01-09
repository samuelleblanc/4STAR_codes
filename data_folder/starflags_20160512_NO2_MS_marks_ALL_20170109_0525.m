function marks = starflags_20160512_NO2_MS_marks_ALL_20170109_0525  
 % starflags file for 20160512 created by MS on 20170109_0525 to mark ALL conditions 
 version_set('20170109_0525'); 
 daystr = '20160512';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:12:28') datenum('03:40:37') 03 
datenum('27:38:51') datenum('03:40:37') 02 
datenum('23:12:28') datenum('-1:13:01') 700 
datenum('23:30:52') datenum('-1:30:56') 700 
datenum('23:40:30') datenum('-1:40:30') 700 
datenum('23:40:32') datenum('-1:41:32') 700 
datenum('23:49:12') datenum('-1:49:17') 700 
datenum('23:49:47') datenum('00:07:47') 700 
datenum('24:25:26') datenum('00:25:31') 700 
datenum('24:35:51') datenum('00:35:51') 700 
datenum('24:35:53') datenum('00:35:54') 700 
datenum('24:36:15') datenum('00:54:01') 700 
datenum('25:01:28') datenum('01:01:33') 700 
datenum('25:04:02') datenum('01:04:44') 700 
datenum('25:14:55') datenum('01:14:56') 700 
datenum('25:15:11') datenum('01:15:40') 700 
datenum('25:15:43') datenum('01:15:56') 700 
datenum('25:17:18') datenum('01:18:05') 700 
datenum('25:19:48') datenum('01:19:53') 700 
datenum('25:27:44') datenum('01:28:49') 700 
datenum('25:38:09') datenum('01:38:13') 700 
datenum('25:39:05') datenum('01:39:05') 700 
datenum('25:39:15') datenum('01:39:15') 700 
datenum('25:39:26') datenum('01:39:26') 700 
datenum('25:39:30') datenum('01:39:30') 700 
datenum('25:39:33') datenum('01:39:56') 700 
datenum('25:40:01') datenum('01:49:18') 700 
datenum('25:49:25') datenum('01:49:25') 700 
datenum('25:49:39') datenum('01:49:40') 700 
datenum('25:49:53') datenum('01:49:53') 700 
datenum('25:50:00') datenum('01:50:00') 700 
datenum('25:50:06') datenum('01:50:09') 700 
datenum('25:50:11') datenum('01:50:12') 700 
datenum('25:50:15') datenum('01:50:15') 700 
datenum('25:50:20') datenum('01:50:21') 700 
datenum('25:50:27') datenum('01:50:28') 700 
datenum('25:50:31') datenum('01:50:33') 700 
datenum('25:50:36') datenum('02:26:57') 700 
datenum('26:26:59') datenum('02:27:03') 700 
datenum('26:27:08') datenum('02:58:54') 700 
datenum('27:10:16') datenum('03:13:37') 700 
datenum('27:20:42') datenum('03:21:15') 700 
datenum('27:22:19') datenum('03:22:20') 700 
datenum('27:23:31') datenum('03:23:32') 700 
datenum('27:23:36') datenum('03:23:36') 700 
datenum('27:24:33') datenum('03:24:36') 700 
datenum('27:24:38') datenum('03:24:48') 700 
datenum('27:24:51') datenum('03:24:53') 700 
datenum('27:30:44') datenum('03:30:48') 700 
datenum('27:38:51') datenum('03:40:37') 700 
datenum('25:01:50') datenum('01:04:01') 10 
datenum('25:04:45') datenum('01:05:13') 10 
datenum('25:14:16') datenum('01:14:54') 10 
datenum('25:14:57') datenum('01:15:10') 10 
datenum('25:15:41') datenum('01:15:42') 10 
datenum('25:15:57') datenum('01:17:17') 10 
datenum('25:18:16') datenum('01:27:43') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return