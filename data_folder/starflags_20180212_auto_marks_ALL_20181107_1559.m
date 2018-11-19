function marks = starflags_20180212_auto_marks_ALL_20181107_1559  
 % starflags file for 20180212 created by auto on 20181107_1559 to mark ALL conditions 
 version_set('20181107_1559'); 
 daystr = '20180212';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('16:34:22') datenum('17:11:20') 700 
datenum('17:25:53') datenum('17:25:57') 700 
datenum('17:44:13') datenum('17:44:17') 700 
datenum('18:02:33') datenum('18:02:37') 700 
datenum('18:20:53') datenum('18:20:57') 700 
datenum('18:39:13') datenum('18:39:17') 700 
datenum('18:57:33') datenum('18:57:37') 700 
datenum('19:15:53') datenum('19:15:57') 700 
datenum('19:34:13') datenum('19:34:18') 700 
datenum('19:52:33') datenum('19:52:38') 700 
datenum('20:10:53') datenum('20:10:58') 700 
datenum('20:29:13') datenum('20:29:18') 700 
datenum('20:47:34') datenum('20:47:38') 700 
datenum('21:05:54') datenum('21:05:58') 700 
datenum('21:24:14') datenum('21:24:18') 700 
datenum('21:42:34') datenum('21:42:38') 700 
datenum('22:00:54') datenum('22:00:58') 700 
datenum('22:19:14') datenum('22:19:18') 700 
datenum('22:37:34') datenum('22:37:39') 700 
datenum('22:55:54') datenum('22:55:59') 700 
datenum('23:10:30') datenum('23:10:30') 700 
datenum('16:42:38') datenum('16:43:28') 10 
datenum('17:04:46') datenum('17:04:46') 10 
datenum('17:05:52') datenum('17:08:03') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return