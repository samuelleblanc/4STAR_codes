function marks = starflags_20180209_auto_marks_ALL_20181107_1555  
 % starflags file for 20180209 created by auto on 20181107_1555 to mark ALL conditions 
 version_set('20181107_1555'); 
 daystr = '20180209';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('16:49:17') datenum('17:12:54') 700 
datenum('17:17:05') datenum('17:17:09') 700 
datenum('17:35:25') datenum('17:35:29') 700 
datenum('17:53:45') datenum('17:53:49') 700 
datenum('18:12:05') datenum('18:12:09') 700 
datenum('18:30:25') datenum('18:30:29') 700 
datenum('18:48:45') datenum('18:48:49') 700 
datenum('19:07:05') datenum('19:07:10') 700 
datenum('19:25:25') datenum('19:25:30') 700 
datenum('19:43:45') datenum('19:43:50') 700 
datenum('20:02:06') datenum('20:02:10') 700 
datenum('20:20:26') datenum('20:20:30') 700 
datenum('20:38:46') datenum('20:38:50') 700 
datenum('20:57:06') datenum('20:57:10') 700 
datenum('21:15:26') datenum('21:15:31') 700 
datenum('21:33:48') datenum('21:33:52') 700 
datenum('21:52:08') datenum('21:52:12') 700 
datenum('22:10:28') datenum('22:10:32') 700 
datenum('22:28:48') datenum('22:28:53') 700 
datenum('22:47:08') datenum('22:47:13') 700 
datenum('23:05:28') datenum('23:05:33') 700 
datenum('23:23:48') datenum('23:23:53') 700 
datenum('23:42:09') datenum('23:42:13') 700 
datenum('23:58:53') datenum('23:58:53') 700 
datenum('17:09:00') datenum('17:10:24') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return