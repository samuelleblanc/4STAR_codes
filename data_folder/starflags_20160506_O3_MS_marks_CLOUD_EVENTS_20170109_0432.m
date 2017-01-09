function marks = starflags_20160506_O3_MS_marks_CLOUD_EVENTS_20170109_0432  
 % starflags file for 20160506 created by MS on 20170109_0432 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0432'); 
 daystr = '20160506';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:50:03') datenum('22:53:45') 03 
datenum('22:57:44') datenum('24:07:53') 03 
datenum('25:51:05') datenum('25:52:10') 03 
datenum('26:35:29') datenum('26:36:55') 03 
datenum('27:10:51') datenum('27:11:58') 03 
datenum('27:18:09') datenum('27:19:16') 03 
datenum('27:19:54') datenum('27:21:15') 03 
datenum('27:58:20') datenum('28:01:07') 03 
datenum('28:28:31') datenum('28:29:45') 03 
datenum('28:44:24') datenum('28:46:47') 03 
datenum('31:01:01') datenum('31:02:37') 03 
datenum('31:06:39') datenum('31:06:46') 03 
datenum('31:06:55') datenum('31:06:55') 03 
datenum('22:50:31') datenum('22:53:45') 700 
datenum('23:13:06') datenum('23:13:10') 700 
datenum('23:33:18') datenum('23:33:22') 700 
datenum('23:51:38') datenum('23:51:43') 700 
datenum('25:51:05') datenum('25:51:05') 700 
datenum('25:51:35') datenum('25:51:41') 700 
datenum('26:36:03') datenum('26:36:22') 700 
datenum('27:11:24') datenum('27:11:24') 700 
datenum('27:11:26') datenum('27:11:28') 700 
datenum('27:18:40') datenum('27:18:45') 700 
datenum('27:20:25') datenum('27:20:44') 700 
datenum('28:29:00') datenum('28:29:15') 700 
datenum('28:46:05') datenum('28:46:08') 700 
datenum('31:01:01') datenum('31:01:01') 700 
datenum('31:01:33') datenum('31:02:04') 700 
datenum('22:50:03') datenum('22:53:45') 10 
datenum('22:57:44') datenum('24:07:53') 10 
datenum('25:51:05') datenum('25:52:10') 10 
datenum('26:35:29') datenum('26:36:55') 10 
datenum('27:10:51') datenum('27:11:58') 10 
datenum('27:18:09') datenum('27:19:16') 10 
datenum('27:19:54') datenum('27:21:15') 10 
datenum('27:58:20') datenum('28:01:07') 10 
datenum('28:28:31') datenum('28:29:45') 10 
datenum('28:44:24') datenum('28:46:47') 10 
datenum('31:01:01') datenum('31:02:37') 10 
datenum('31:06:39') datenum('31:06:46') 10 
datenum('31:06:55') datenum('31:06:55') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return