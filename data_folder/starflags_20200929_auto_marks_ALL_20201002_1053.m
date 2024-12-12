function marks = starflags_20200929_auto_marks_ALL_20201002_1053  
 % starflags file for 20200929 created by auto on 20201002_1053 to mark ALL conditions 
 version_set('20201002_1053'); 
 daystr = '20200929';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('17:43:43') datenum('17:43:48') 700 
datenum('17:49:14') datenum('17:49:18') 700 
datenum('17:54:45') datenum('17:54:50') 700 
datenum('18:00:16') datenum('18:00:20') 700 
datenum('18:05:47') datenum('18:05:51') 700 
datenum('18:11:18') datenum('18:11:22') 700 
datenum('18:16:51') datenum('18:16:55') 700 
datenum('18:22:21') datenum('18:22:26') 700 
datenum('18:27:53') datenum('18:27:57') 700 
datenum('18:33:24') datenum('18:33:29') 700 
datenum('18:38:54') datenum('18:38:59') 700 
datenum('18:44:26') datenum('18:44:30') 700 
datenum('18:49:56') datenum('18:50:01') 700 
datenum('18:55:27') datenum('18:55:31') 700 
datenum('19:00:57') datenum('19:01:01') 700 
datenum('19:06:29') datenum('19:06:33') 700 
datenum('19:12:00') datenum('19:12:05') 700 
datenum('19:17:32') datenum('19:17:36') 700 
datenum('19:23:02') datenum('19:23:06') 700 
datenum('19:28:34') datenum('19:28:38') 700 
datenum('19:34:05') datenum('19:34:10') 700 
datenum('19:39:35') datenum('19:39:40') 700 
datenum('19:45:07') datenum('19:45:11') 700 
datenum('19:50:37') datenum('19:50:41') 700 
datenum('19:55:53') datenum('19:57:01') 700 
datenum('19:55:49') datenum('19:56:08') 10 
datenum('19:56:15') datenum('19:57:00') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return