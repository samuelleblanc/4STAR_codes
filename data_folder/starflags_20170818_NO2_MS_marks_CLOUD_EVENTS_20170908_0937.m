function marks = starflags_20170818_NO2_MS_marks_CLOUD_EVENTS_20170908_0937  
 % starflags file for 20170818 created by MS on 20170908_0937 to mark CLOUD_EVENTS conditions 
 version_set('20170908_0937'); 
 daystr = '20170818';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('13:25:08') datenum('13:25:43') 700 
datenum('13:26:49') datenum('13:27:28') 700 
datenum('13:30:55') datenum('13:31:39') 700 
datenum('14:03:42') datenum('14:03:43') 700 
datenum('14:05:17') datenum('14:05:19') 700 
datenum('14:11:02') datenum('14:11:06') 700 
datenum('14:11:16') datenum('14:11:16') 700 
datenum('14:11:18') datenum('14:11:28') 700 
datenum('14:11:35') datenum('14:11:43') 700 
datenum('14:12:00') datenum('14:12:05') 700 
datenum('14:12:19') datenum('14:12:29') 700 
datenum('14:12:53') datenum('14:12:53') 700 
datenum('14:31:03') datenum('14:31:32') 700 
datenum('15:30:57') datenum('15:31:35') 700 
datenum('15:35:00') datenum('15:35:00') 700 
datenum('15:35:05') datenum('15:35:06') 700 
datenum('15:35:13') datenum('15:35:13') 700 
datenum('15:38:49') datenum('15:39:25') 700 
datenum('15:43:20') datenum('15:43:28') 700 
datenum('13:25:08') datenum('13:31:39') 10 
datenum('13:47:29') datenum('13:55:11') 10 
datenum('14:03:42') datenum('14:05:19') 10 
datenum('14:11:02') datenum('14:12:53') 10 
datenum('14:31:03') datenum('14:43:54') 10 
datenum('15:08:56') datenum('15:10:34') 10 
datenum('15:17:32') datenum('15:22:06') 10 
datenum('15:30:57') datenum('15:39:25') 10 
datenum('15:43:20') datenum('15:45:20') 10 
datenum('16:00:21') datenum('16:08:33') 10 
datenum('17:22:25') datenum('17:26:33') 10 
datenum('17:29:34') datenum('17:31:04') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return