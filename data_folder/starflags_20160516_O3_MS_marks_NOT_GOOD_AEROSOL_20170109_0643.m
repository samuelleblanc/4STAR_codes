function marks = starflags_20160516_O3_MS_marks_NOT_GOOD_AEROSOL_20170109_0643  
 % starflags file for 20160516 created by MS on 20170109_0643 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0643'); 
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
datenum('22:56:02') datenum('-1:12:06') 700 
datenum('23:12:13') datenum('-1:25:25') 700 
datenum('23:33:56') datenum('-1:34:01') 700 
datenum('23:52:16') datenum('-1:52:21') 700 
datenum('24:10:36') datenum('00:10:41') 700 
datenum('24:12:46') datenum('00:28:55') 700 
datenum('24:29:02') datenum('00:49:03') 700 
datenum('24:49:05') datenum('00:49:06') 700 
datenum('24:49:08') datenum('00:52:02') 700 
datenum('24:52:09') datenum('01:16:12') 700 
datenum('25:16:18') datenum('01:18:57') 700 
datenum('25:20:53') datenum('01:22:34') 700 
datenum('25:22:47') datenum('01:23:58') 700 
datenum('25:44:34') datenum('01:44:38') 700 
datenum('25:50:05') datenum('01:52:18') 700 
datenum('25:53:53') datenum('01:53:53') 700 
datenum('26:07:46') datenum('02:07:51') 700 
datenum('26:26:07') datenum('02:26:11') 700 
datenum('26:47:09') datenum('02:47:13') 700 
datenum('27:01:06') datenum('03:01:06') 700 
datenum('27:01:26') datenum('03:01:28') 700 
datenum('27:03:02') datenum('03:03:09') 700 
datenum('27:03:18') datenum('03:03:24') 700 
datenum('27:04:08') datenum('03:04:09') 700 
datenum('27:05:29') datenum('03:05:33') 700 
datenum('27:12:01') datenum('03:12:09') 700 
datenum('27:18:16') datenum('03:18:23') 700 
datenum('27:20:02') datenum('03:20:05') 700 
datenum('27:25:40') datenum('03:25:48') 700 
datenum('27:27:15') datenum('03:27:17') 700 
datenum('27:28:36') datenum('03:28:40') 700 
datenum('27:49:37') datenum('03:49:41') 700 
datenum('27:51:03') datenum('03:51:03') 700 
datenum('28:01:02') datenum('04:01:40') 700 
datenum('28:06:22') datenum('04:06:27') 700 
datenum('28:13:08') datenum('04:13:12') 700 
datenum('28:20:26') datenum('04:20:26') 700 
datenum('28:23:45') datenum('04:23:53') 700 
datenum('28:32:23') datenum('04:32:27') 700 
datenum('28:49:55') datenum('04:49:55') 700 
datenum('28:50:44') datenum('04:50:44') 700 
datenum('28:57:47') datenum('04:57:47') 700 
datenum('29:00:27') datenum('05:00:31') 700 
datenum('29:02:49') datenum('05:02:55') 700 
datenum('29:03:52') datenum('05:03:54') 700 
datenum('29:26:16') datenum('05:26:21') 700 
datenum('29:32:56') datenum('05:33:00') 700 
datenum('29:44:36') datenum('05:44:41') 700 
datenum('30:05:08') datenum('06:05:12') 700 
datenum('30:13:11') datenum('06:13:11') 700 
datenum('30:18:56') datenum('06:25:09') 700 
datenum('30:25:16') datenum('06:29:46') 700 
datenum('30:30:52') datenum('06:30:53') 700 
datenum('30:46:41') datenum('06:46:45') 700 
datenum('31:05:01') datenum('07:05:06') 700 
datenum('31:16:45') datenum('07:19:18') 700 
datenum('27:00:37') datenum('03:29:15') 10 
datenum('28:01:40') datenum('04:02:08') 10 
datenum('28:05:51') datenum('04:06:57') 10 
datenum('28:23:16') datenum('04:24:22') 10 
datenum('29:02:19') datenum('05:04:05') 10 
datenum('29:32:26') datenum('05:33:31') 10 
datenum('30:30:27') datenum('06:31:23') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return