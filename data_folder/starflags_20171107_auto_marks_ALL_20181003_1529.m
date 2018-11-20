function marks = starflags_20171107_auto_marks_ALL_20181003_1529  
 % starflags file for 20171107 created by auto on 20181003_1529 to mark ALL conditions 
 version_set('20181003_1529'); 
 daystr = '20171107';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('15:12:25') datenum('15:12:32') 700 
datenum('15:16:48') datenum('15:16:55') 700 
datenum('15:31:39') datenum('15:31:43') 700 
datenum('15:50:49') datenum('15:50:53') 700 
datenum('16:09:57') datenum('16:10:01') 700 
datenum('16:29:03') datenum('16:29:08') 700 
datenum('16:48:15') datenum('16:48:19') 700 
datenum('17:07:26') datenum('17:07:30') 700 
datenum('17:26:35') datenum('17:26:40') 700 
datenum('17:45:48') datenum('17:45:53') 700 
datenum('18:04:58') datenum('18:05:03') 700 
datenum('18:24:10') datenum('18:24:14') 700 
datenum('18:43:22') datenum('18:43:26') 700 
datenum('19:02:36') datenum('19:02:40') 700 
datenum('19:21:50') datenum('19:21:54') 700 
datenum('19:41:01') datenum('19:41:06') 700 
datenum('20:00:09') datenum('20:00:13') 700 
datenum('20:19:17') datenum('20:19:22') 700 
datenum('20:38:30') datenum('20:38:35') 700 
datenum('20:57:47') datenum('20:57:52') 700 
datenum('21:16:58') datenum('21:17:02') 700 
datenum('21:36:08') datenum('21:36:12') 700 
datenum('21:55:15') datenum('21:55:19') 700 
datenum('22:14:30') datenum('22:14:35') 700 
datenum('22:33:43') datenum('22:33:47') 700 
datenum('22:52:45') datenum('22:52:49') 700 
datenum('23:11:44') datenum('23:11:49') 700 
datenum('23:30:53') datenum('23:30:57') 700 
datenum('23:50:13') datenum('23:50:17') 700 
datenum('24:09:22') datenum('24:09:26') 700 
datenum('24:26:50') datenum('24:27:27') 700 
datenum('15:16:45') datenum('15:16:59') 10 
datenum('21:54:59') datenum('21:55:00') 10 
datenum('21:55:07') datenum('21:55:11') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return