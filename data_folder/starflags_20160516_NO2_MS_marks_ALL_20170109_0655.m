function marks = starflags_20160516_NO2_MS_marks_ALL_20170109_0655  
 % starflags file for 20160516 created by MS on 20170109_0655 to mark ALL conditions 
 version_set('20170109_0655'); 
 daystr = '20160516';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:13:08') datenum('07:19:18') 03 
datenum('31:16:45') datenum('07:19:18') 02 
datenum('22:13:08') datenum('-2:13:17') 700 
datenum('22:34:53') datenum('-2:34:58') 700 
datenum('22:53:13') datenum('-2:53:51') 700 
datenum('23:12:07') datenum('-1:12:12') 700 
datenum('23:33:56') datenum('-1:34:01') 700 
datenum('23:52:16') datenum('-1:52:21') 700 
datenum('24:10:36') datenum('00:10:41') 700 
datenum('24:28:56') datenum('00:29:01') 700 
datenum('24:49:03') datenum('00:49:04') 700 
datenum('24:49:07') datenum('00:49:07') 700 
datenum('24:52:03') datenum('00:52:08') 700 
datenum('24:59:45') datenum('01:00:46') 700 
datenum('25:16:13') datenum('01:16:17') 700 
datenum('25:20:47') datenum('01:20:51') 700 
datenum('25:22:35') datenum('01:22:46') 700 
datenum('25:44:34') datenum('01:44:38') 700 
datenum('25:50:33') datenum('01:50:33') 700 
datenum('25:50:35') datenum('01:50:35') 700 
datenum('25:50:39') datenum('01:50:43') 700 
datenum('25:51:44') datenum('01:51:47') 700 
datenum('25:53:52') datenum('01:53:53') 700 
datenum('25:57:07') datenum('01:57:09') 700 
datenum('26:06:28') datenum('02:07:13') 700 
datenum('26:07:16') datenum('02:07:20') 700 
datenum('26:07:46') datenum('02:07:51') 700 
datenum('26:11:09') datenum('02:12:11') 700 
datenum('26:26:07') datenum('02:26:11') 700 
datenum('26:28:32') datenum('02:29:29') 700 
datenum('26:47:09') datenum('02:47:13') 700 
datenum('26:55:06') datenum('02:55:29') 700 
datenum('27:01:06') datenum('03:01:07') 700 
datenum('27:01:25') datenum('03:01:28') 700 
datenum('27:03:02') datenum('03:03:10') 700 
datenum('27:03:18') datenum('03:03:25') 700 
datenum('27:04:06') datenum('03:04:09') 700 
datenum('27:05:29') datenum('03:05:33') 700 
datenum('27:12:01') datenum('03:12:09') 700 
datenum('27:18:16') datenum('03:18:23') 700 
datenum('27:20:02') datenum('03:20:06') 700 
datenum('27:25:40') datenum('03:25:48') 700 
datenum('27:27:15') datenum('03:27:17') 700 
datenum('27:28:36') datenum('03:28:40') 700 
datenum('27:49:37') datenum('03:49:41') 700 
datenum('27:51:02') datenum('03:51:04') 700 
datenum('28:01:02') datenum('04:01:40') 700 
datenum('28:06:21') datenum('04:06:27') 700 
datenum('28:07:47') datenum('04:07:49') 700 
datenum('28:13:08') datenum('04:13:12') 700 
datenum('28:20:26') datenum('04:20:27') 700 
datenum('28:23:27') datenum('04:23:27') 700 
datenum('28:23:45') datenum('04:23:53') 700 
datenum('28:32:23') datenum('04:32:27') 700 
datenum('28:49:55') datenum('04:49:56') 700 
datenum('28:50:43') datenum('04:50:44') 700 
datenum('28:57:47') datenum('04:57:47') 700 
datenum('29:00:27') datenum('05:00:31') 700 
datenum('29:02:49') datenum('05:02:55') 700 
datenum('29:03:52') datenum('05:03:54') 700 
datenum('29:22:50') datenum('05:26:21') 700 
datenum('29:32:55') datenum('05:33:00') 700 
datenum('29:44:36') datenum('05:44:41') 700 
datenum('30:05:08') datenum('06:05:12') 700 
datenum('30:13:10') datenum('06:13:12') 700 
datenum('30:25:11') datenum('06:25:15') 700 
datenum('30:30:52') datenum('06:30:53') 700 
datenum('30:46:41') datenum('06:46:45') 700 
datenum('31:05:01') datenum('07:05:06') 700 
datenum('31:11:34') datenum('07:11:34') 700 
datenum('31:16:45') datenum('07:19:18') 700 
datenum('25:00:47') datenum('01:13:09') 10 
datenum('25:15:53') datenum('01:17:09') 10 
datenum('25:27:53') datenum('01:31:59') 10 
datenum('26:07:12') datenum('02:07:21') 10 
datenum('26:10:43') datenum('02:10:44') 10 
datenum('26:11:07') datenum('02:12:16') 10 
datenum('26:28:24') datenum('02:29:40') 10 
datenum('26:55:05') datenum('02:55:34') 10 
datenum('26:59:38') datenum('03:00:46') 10 
datenum('28:19:44') datenum('04:30:49') 10 
datenum('29:04:36') datenum('05:22:49') 10 
datenum('29:26:16') datenum('06:10:59') 10 
datenum('30:27:43') datenum('06:27:43') 10 
datenum('30:28:12') datenum('06:28:51') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return