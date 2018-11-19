function marks = starflags_20180210_auto_marks_ALL_20181107_1557  
 % starflags file for 20180210 created by auto on 20181107_1557 to mark ALL conditions 
 version_set('20181107_1557'); 
 daystr = '20180210';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('16:39:22') datenum('17:12:25') 700 
datenum('17:29:09') datenum('17:29:13') 700 
datenum('17:47:29') datenum('17:47:33') 700 
datenum('18:05:49') datenum('18:05:54') 700 
datenum('18:24:09') datenum('18:24:14') 700 
datenum('18:42:29') datenum('18:42:34') 700 
datenum('19:00:49') datenum('19:00:54') 700 
datenum('19:19:10') datenum('19:19:14') 700 
datenum('19:37:30') datenum('19:37:34') 700 
datenum('19:55:50') datenum('19:55:54') 700 
datenum('20:14:10') datenum('20:14:14') 700 
datenum('20:31:53') datenum('20:32:56') 700 
datenum('20:33:08') datenum('20:34:12') 700 
datenum('20:34:24') datenum('20:35:25') 700 
datenum('20:35:37') datenum('20:36:32') 700 
datenum('20:36:37') datenum('20:36:41') 700 
datenum('20:37:00') datenum('20:37:56') 700 
datenum('20:38:46') datenum('20:39:42') 700 
datenum('20:40:32') datenum('20:41:28') 700 
datenum('20:42:18') datenum('20:43:13') 700 
datenum('20:44:04') datenum('20:44:59') 700 
datenum('20:59:38') datenum('20:59:43') 700 
datenum('21:17:42') datenum('22:03:15') 700 
datenum('22:21:31') datenum('22:21:35') 700 
datenum('22:39:51') datenum('22:39:55') 700 
datenum('22:53:20') datenum('22:53:20') 700 
datenum('16:43:38') datenum('16:44:36') 10 
datenum('17:06:26') datenum('17:06:26') 10 
datenum('17:06:28') datenum('17:06:28') 10 
datenum('17:07:45') datenum('17:10:04') 10 
datenum('20:28:32') datenum('20:28:49') 10 
datenum('20:32:56') datenum('20:33:02') 10 
datenum('20:34:12') datenum('20:34:18') 10 
datenum('20:35:25') datenum('20:35:31') 10 
datenum('20:36:32') datenum('20:36:38') 10 
datenum('20:37:56') datenum('20:38:02') 10 
datenum('20:39:42') datenum('20:39:48') 10 
datenum('20:41:28') datenum('20:41:34') 10 
datenum('20:43:13') datenum('20:43:19') 10 
datenum('20:44:59') datenum('20:45:05') 10 
datenum('22:53:05') datenum('22:53:15') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return