function marks = starflags_20160530_NO2_MS_marks_ALL_20170109_1123  
 % starflags file for 20160530 created by MS on 20170109_1123 to mark ALL conditions 
 version_set('20170109_1123'); 
 daystr = '20160530';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:35:02') datenum('22:35:25') 700 
datenum('22:35:27') datenum('22:35:29') 700 
datenum('22:35:31') datenum('22:37:37') 700 
datenum('22:37:39') datenum('22:42:59') 700 
datenum('22:43:10') datenum('22:52:01') 700 
datenum('22:52:03') datenum('22:55:31') 700 
datenum('22:55:33') datenum('22:56:02') 700 
datenum('22:56:04') datenum('23:03:47') 700 
datenum('23:11:38') datenum('23:12:14') 700 
datenum('23:18:55') datenum('23:21:46') 700 
datenum('23:27:12') datenum('23:46:39') 700 
datenum('23:53:58') datenum('23:55:00') 700 
datenum('24:35:30') datenum('24:44:44') 700 
datenum('25:09:02') datenum('25:46:06') 700 
datenum('26:37:16') datenum('26:40:47') 700 
datenum('26:40:49') datenum('26:43:33') 700 
datenum('27:40:29') datenum('27:47:47') 700 
datenum('28:18:21') datenum('28:57:15') 700 
datenum('29:18:39') datenum('29:25:48') 700 
datenum('29:26:10') datenum('29:26:11') 700 
datenum('29:26:13') datenum('29:27:53') 700 
datenum('29:27:57') datenum('29:28:39') 700 
datenum('29:28:41') datenum('29:29:02') 700 
datenum('29:29:04') datenum('29:29:14') 700 
datenum('29:29:16') datenum('29:29:20') 700 
datenum('29:29:23') datenum('29:30:14') 700 
datenum('29:30:16') datenum('29:30:21') 700 
datenum('29:30:23') datenum('29:30:23') 700 
datenum('29:30:25') datenum('29:30:32') 700 
datenum('29:31:43') datenum('29:32:45') 700 
datenum('29:33:15') datenum('29:53:04') 700 
datenum('29:57:47') datenum('29:58:12') 700 
datenum('29:58:15') datenum('29:58:19') 700 
datenum('29:58:21') datenum('29:58:25') 700 
datenum('30:00:23') datenum('30:00:40') 700 
datenum('30:00:43') datenum('30:02:57') 700 
datenum('30:03:01') datenum('30:03:01') 700 
datenum('30:03:03') datenum('30:05:49') 700 
datenum('30:05:52') datenum('30:06:00') 700 
datenum('30:06:03') datenum('30:06:05') 700 
datenum('30:06:07') datenum('30:07:48') 700 
datenum('30:07:50') datenum('30:07:55') 700 
datenum('30:07:57') datenum('30:07:59') 700 
datenum('30:08:01') datenum('30:08:11') 700 
datenum('30:08:13') datenum('30:08:13') 700 
datenum('30:08:16') datenum('30:08:16') 700 
datenum('23:53:58') datenum('23:55:00') 10 
datenum('25:14:27') datenum('25:46:06') 10 
datenum('29:25:49') datenum('29:26:09') 10 
datenum('29:26:11') datenum('29:26:12') 10 
datenum('29:27:12') datenum('29:27:12') 10 
datenum('29:27:47') datenum('29:27:49') 10 
datenum('29:27:55') datenum('29:28:40') 10 
datenum('29:28:51') datenum('29:28:52') 10 
datenum('29:29:02') datenum('29:29:03') 10 
datenum('29:29:07') datenum('29:29:12') 10 
datenum('29:29:14') datenum('29:29:18') 10 
datenum('29:29:21') datenum('29:30:26') 10 
datenum('29:30:32') datenum('29:31:42') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return