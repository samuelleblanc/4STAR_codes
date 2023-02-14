function marks = starflags_20201104_auto_marks_ALL_20221220_1032  
 % starflags file for 20201104 created by auto on 20221220_1032 to mark ALL conditions 
 version_set('20221220_1032'); 
 daystr = '20201104';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('17:38:24') datenum('17:38:29') 700 
datenum('17:56:44') datenum('17:56:49') 700 
datenum('18:15:05') datenum('18:15:09') 700 
datenum('18:33:25') datenum('18:33:29') 700 
datenum('18:51:45') datenum('18:51:49') 700 
datenum('19:10:05') datenum('19:10:10') 700 
datenum('19:28:25') datenum('19:28:30') 700 
datenum('19:46:45') datenum('19:46:50') 700 
datenum('20:05:06') datenum('20:05:10') 700 
datenum('20:23:26') datenum('20:23:30') 700 
datenum('20:41:46') datenum('20:41:50') 700 
datenum('21:00:06') datenum('21:00:10') 700 
datenum('21:18:26') datenum('21:18:30') 700 
datenum('21:36:46') datenum('21:36:50') 700 
datenum('21:55:06') datenum('21:55:11') 700 
datenum('22:13:26') datenum('22:13:31') 700 
datenum('22:31:46') datenum('22:31:51') 700 
datenum('22:50:07') datenum('22:50:11') 700 
datenum('23:08:27') datenum('23:08:31') 700 
datenum('23:26:47') datenum('23:26:51') 700 
datenum('23:45:07') datenum('23:45:11') 700 
datenum('24:03:27') datenum('24:03:31') 700 
datenum('24:21:47') datenum('24:21:51') 700 
datenum('24:40:07') datenum('24:40:11') 700 
datenum('24:43:33') datenum('24:49:19') 700 
datenum('23:41:16') datenum('23:41:27') 10 
datenum('23:42:34') datenum('23:42:45') 10 
datenum('23:42:59') datenum('23:43:11') 10 
datenum('23:46:04') datenum('23:46:15') 10 
datenum('24:42:41') datenum('24:44:46') 10 
datenum('24:46:18') datenum('24:47:47') 10 
datenum('24:47:53') datenum('24:47:53') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return