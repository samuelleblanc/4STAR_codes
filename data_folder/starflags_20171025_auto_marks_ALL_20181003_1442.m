function marks = starflags_20171025_auto_marks_ALL_20181003_1442  
 % starflags file for 20171025 created by auto on 20181003_1442 to mark ALL conditions 
 version_set('20181003_1442'); 
 daystr = '20171025';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('14:22:18') datenum('14:48:20') 700 
datenum('15:01:50') datenum('15:01:54') 700 
datenum('15:20:50') datenum('15:20:54') 700 
datenum('15:39:55') datenum('15:39:59') 700 
datenum('15:58:58') datenum('15:59:03') 700 
datenum('16:18:00') datenum('16:18:04') 700 
datenum('16:37:03') datenum('16:37:08') 700 
datenum('16:56:10') datenum('16:56:14') 700 
datenum('17:15:19') datenum('17:15:24') 700 
datenum('17:34:29') datenum('17:34:34') 700 
datenum('17:53:38') datenum('17:53:42') 700 
datenum('18:12:48') datenum('18:12:52') 700 
datenum('18:32:00') datenum('18:32:05') 700 
datenum('18:51:13') datenum('18:51:17') 700 
datenum('19:10:21') datenum('19:10:26') 700 
datenum('19:29:29') datenum('19:29:34') 700 
datenum('19:48:37') datenum('19:48:41') 700 
datenum('20:07:47') datenum('20:07:51') 700 
datenum('20:26:56') datenum('20:27:00') 700 
datenum('20:46:04') datenum('20:46:08') 700 
datenum('21:05:06') datenum('21:05:11') 700 
datenum('21:24:12') datenum('21:24:17') 700 
datenum('21:43:27') datenum('21:43:32') 700 
datenum('21:53:41') datenum('21:59:25') 700 
datenum('22:18:35') datenum('22:18:39') 700 
datenum('22:37:51') datenum('22:37:56') 700 
datenum('22:57:00') datenum('22:57:05') 700 
datenum('23:15:57') datenum('23:16:01') 700 
datenum('23:34:47') datenum('23:34:52') 700 
datenum('23:53:50') datenum('23:53:55') 700 
datenum('24:12:55') datenum('24:13:00') 700 
datenum('24:31:55') datenum('24:32:00') 700 
datenum('24:50:54') datenum('24:50:59') 700 
datenum('24:55:23') datenum('25:08:51') 700 
datenum('14:44:00') datenum('14:44:06') 10 
datenum('14:44:22') datenum('14:44:37') 10 
datenum('25:01:50') datenum('25:01:57') 10 
datenum('25:02:13') datenum('25:02:21') 10 
datenum('25:02:38') datenum('25:02:45') 10 
datenum('25:04:21') datenum('25:04:24') 10 
datenum('25:04:30') datenum('25:04:57') 10 
datenum('25:05:02') datenum('25:06:35') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return