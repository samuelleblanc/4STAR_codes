function marks = starflags_20160506_O3_MS_marks_ALL_20170109_0432  
 % starflags file for 20160506 created by MS on 20170109_0432 to mark ALL conditions 
 version_set('20170109_0432'); 
 daystr = '20160506';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:06:53') datenum('07:09:49') 03 
datenum('22:06:53') datenum('-2:07:02') 700 
datenum('22:28:02') datenum('-2:28:06') 700 
datenum('22:46:22') datenum('-2:46:26') 700 
datenum('22:50:31') datenum('-2:54:50') 700 
datenum('23:13:06') datenum('-1:13:10') 700 
datenum('23:33:18') datenum('-1:33:22') 700 
datenum('23:51:38') datenum('-1:51:43') 700 
datenum('24:11:55') datenum('00:12:00') 700 
datenum('24:30:16') datenum('00:30:20') 700 
datenum('24:48:36') datenum('00:48:40') 700 
datenum('25:06:56') datenum('01:07:01') 700 
datenum('25:25:16') datenum('01:25:21') 700 
datenum('25:45:32') datenum('01:45:37') 700 
datenum('25:49:23') datenum('01:49:24') 700 
datenum('25:50:42') datenum('01:50:43') 700 
datenum('25:51:04') datenum('01:51:05') 700 
datenum('25:51:35') datenum('01:51:41') 700 
datenum('26:13:54') datenum('02:13:58') 700 
datenum('26:32:14') datenum('02:32:19') 700 
datenum('26:36:03') datenum('02:36:22') 700 
datenum('26:50:42') datenum('02:50:47') 700 
datenum('26:54:58') datenum('02:54:58') 700 
datenum('26:55:33') datenum('02:55:33') 700 
datenum('27:09:03') datenum('03:09:07') 700 
datenum('27:11:24') datenum('03:11:24') 700 
datenum('27:11:26') datenum('03:11:28') 700 
datenum('27:17:24') datenum('03:17:24') 700 
datenum('27:18:40') datenum('03:18:45') 700 
datenum('27:20:25') datenum('03:20:44') 700 
datenum('27:27:29') datenum('03:27:33') 700 
datenum('27:45:49') datenum('03:45:54') 700 
datenum('28:04:10') datenum('04:04:14') 700 
datenum('28:29:00') datenum('04:29:15') 700 
datenum('28:32:11') datenum('04:32:15') 700 
datenum('28:46:05') datenum('04:46:08') 700 
datenum('28:50:31') datenum('04:50:36') 700 
datenum('29:08:52') datenum('05:08:56') 700 
datenum('29:27:12') datenum('05:27:16') 700 
datenum('29:45:32') datenum('05:45:36') 700 
datenum('30:03:06') datenum('06:03:08') 700 
datenum('30:03:57') datenum('06:04:01') 700 
datenum('30:05:38') datenum('06:05:40') 700 
datenum('30:22:18') datenum('06:22:23') 700 
datenum('30:40:39') datenum('06:40:43') 700 
datenum('30:55:35') datenum('06:55:38') 700 
datenum('30:55:51') datenum('06:55:58') 700 
datenum('30:59:12') datenum('06:59:16') 700 
datenum('31:01:01') datenum('07:01:01') 700 
datenum('31:01:33') datenum('07:02:04') 700 
datenum('31:06:48') datenum('07:06:54') 700 
datenum('31:07:08') datenum('07:09:49') 700 
datenum('22:50:03') datenum('-2:53:45') 10 
datenum('22:57:44') datenum('00:07:53') 10 
datenum('25:51:05') datenum('01:52:10') 10 
datenum('26:35:29') datenum('02:36:55') 10 
datenum('27:10:51') datenum('03:11:58') 10 
datenum('27:18:09') datenum('03:19:16') 10 
datenum('27:19:54') datenum('03:21:15') 10 
datenum('27:58:20') datenum('04:01:07') 10 
datenum('28:28:31') datenum('04:29:45') 10 
datenum('28:44:24') datenum('04:46:47') 10 
datenum('31:01:01') datenum('07:02:37') 10 
datenum('31:06:39') datenum('07:06:46') 10 
datenum('31:06:55') datenum('07:06:55') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return