function marks = starflags_20171026_auto_marks_ALL_20181003_1452  
 % starflags file for 20171026 created by auto on 20181003_1452 to mark ALL conditions 
 version_set('20181003_1452'); 
 daystr = '20171026';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('14:42:28') datenum('14:49:46') 700 
datenum('15:01:22') datenum('15:01:27') 700 
datenum('15:20:15') datenum('15:20:20') 700 
datenum('15:39:04') datenum('15:39:09') 700 
datenum('15:57:55') datenum('15:57:59') 700 
datenum('16:16:45') datenum('16:16:49') 700 
datenum('16:35:37') datenum('16:35:42') 700 
datenum('16:54:33') datenum('16:54:37') 700 
datenum('17:13:22') datenum('17:13:27') 700 
datenum('17:32:16') datenum('17:32:21') 700 
datenum('17:51:11') datenum('17:51:15') 700 
datenum('18:10:05') datenum('18:10:09') 700 
datenum('18:28:56') datenum('18:29:01') 700 
datenum('18:47:52') datenum('18:47:57') 700 
datenum('19:06:50') datenum('19:06:55') 700 
datenum('19:25:52') datenum('19:25:56') 700 
datenum('19:44:53') datenum('19:44:58') 700 
datenum('20:03:47') datenum('20:03:52') 700 
datenum('20:22:44') datenum('20:22:48') 700 
datenum('20:41:45') datenum('20:41:49') 700 
datenum('21:00:47') datenum('21:00:52') 700 
datenum('21:19:48') datenum('21:19:53') 700 
datenum('21:38:50') datenum('21:38:54') 700 
datenum('23:48:55') datenum('23:51:50') 700 
datenum('14:42:38') datenum('14:42:47') 10 
datenum('14:43:00') datenum('14:43:11') 10 
datenum('14:43:50') datenum('14:43:53') 10 
datenum('14:45:40') datenum('14:45:41') 10 
datenum('23:50:46') datenum('23:51:50') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return