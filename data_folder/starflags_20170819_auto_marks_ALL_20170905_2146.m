function marks = starflags_20170819_auto_marks_ALL_20170905_2146  
 % starflags file for 20170819 created by auto on 20170905_2146 to mark ALL conditions 
 version_set('20170905_2146'); 
 daystr = '20170819';  
 % tag = 2: before_or_after_flight 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:42:36') datenum('10:06:25') 02 
datenum('11:54:37') datenum('11:56:13') 02 
datenum('08:42:36') datenum('09:38:57') 700 
datenum('09:39:29') datenum('09:41:25') 700 
datenum('09:41:36') datenum('09:41:39') 700 
datenum('10:00:50') datenum('10:00:54') 700 
datenum('10:10:02') datenum('10:10:11') 700 
datenum('10:10:55') datenum('10:11:33') 700 
datenum('10:14:50') datenum('10:14:59') 700 
datenum('10:20:24') datenum('10:20:28') 700 
datenum('10:22:51') datenum('10:55:29') 700 
datenum('11:00:49') datenum('11:11:40') 700 
datenum('11:16:35') datenum('11:26:46') 700 
datenum('11:45:03') datenum('11:45:08') 700 
datenum('11:56:13') datenum('11:56:13') 700 
datenum('08:42:50') datenum('08:44:47') 10 
datenum('09:38:58') datenum('09:41:57') 10 
datenum('09:42:12') datenum('09:42:24') 10 
datenum('09:42:50') datenum('09:44:23') 10 
datenum('09:44:29') datenum('09:45:49') 10 
datenum('09:45:52') datenum('09:47:20') 10 
datenum('09:47:25') datenum('09:48:16') 10 
datenum('09:52:54') datenum('09:52:55') 10 
datenum('09:54:17') datenum('09:54:20') 10 
datenum('09:57:34') datenum('09:57:52') 10 
datenum('09:57:57') datenum('09:58:00') 10 
datenum('09:58:05') datenum('09:58:29') 10 
datenum('09:58:33') datenum('09:58:36') 10 
datenum('09:59:53') datenum('10:00:03') 10 
datenum('10:00:06') datenum('10:00:07') 10 
datenum('10:00:09') datenum('10:00:17') 10 
datenum('10:01:36') datenum('10:01:45') 10 
datenum('10:01:49') datenum('10:01:55') 10 
datenum('10:02:00') datenum('10:02:34') 10 
datenum('10:02:41') datenum('10:02:44') 10 
datenum('10:03:40') datenum('10:03:49') 10 
datenum('10:04:08') datenum('10:04:29') 10 
datenum('10:04:42') datenum('10:04:51') 10 
datenum('10:04:56') datenum('10:05:00') 10 
datenum('10:06:04') datenum('10:06:15') 10 
datenum('10:06:25') datenum('10:06:36') 10 
datenum('10:07:13') datenum('10:10:44') 10 
datenum('10:11:40') datenum('10:11:44') 10 
datenum('10:15:06') datenum('10:15:10') 10 
datenum('10:18:12') datenum('10:18:14') 10 
datenum('10:18:43') datenum('10:18:46') 10 
datenum('10:22:51') datenum('10:51:02') 10 
datenum('10:51:13') datenum('10:55:35') 10 
datenum('10:56:48') datenum('10:56:59') 10 
datenum('10:58:09') datenum('10:58:21') 10 
datenum('11:00:49') datenum('11:11:52') 10 
datenum('11:15:41') datenum('11:15:51') 10 
datenum('11:27:25') datenum('11:27:36') 10 
datenum('11:33:41') datenum('11:33:52') 10 
datenum('11:34:19') datenum('11:34:38') 10 
datenum('11:34:49') datenum('11:35:02') 10 
datenum('11:40:00') datenum('11:40:10') 10 
datenum('11:42:05') datenum('11:42:14') 10 
datenum('11:43:36') datenum('11:43:45') 10 
datenum('11:45:07') datenum('11:45:34') 10 
datenum('11:52:10') datenum('11:52:16') 10 
datenum('11:52:38') datenum('11:52:50') 10 
datenum('11:52:53') datenum('11:53:17') 10 
datenum('11:53:34') datenum('11:54:03') 10 
datenum('11:54:06') datenum('11:54:08') 10 
datenum('11:54:35') datenum('11:54:46') 10 
datenum('11:55:06') datenum('11:55:11') 10 
datenum('11:55:13') datenum('11:55:16') 10 
datenum('11:55:46') datenum('11:56:06') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return