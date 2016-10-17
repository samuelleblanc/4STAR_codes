function marks = starflags_20160902_HCOH_MS_marks_CLOUD_EVENTS_20161017_1402  
 % starflags file for 20160902 created by MS on 20161017_1402 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1402'); 
 daystr = '20160902';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:12:45') datenum('12:13:47') 03 
datenum('12:13:50') datenum('12:13:50') 03 
datenum('12:17:15') datenum('12:18:14') 03 
datenum('12:18:16') datenum('12:18:16') 03 
datenum('12:18:21') datenum('12:18:21') 03 
datenum('12:20:59') datenum('12:22:58') 03 
datenum('12:23:00') datenum('12:23:00') 03 
datenum('12:23:03') datenum('12:23:03') 03 
datenum('12:12:48') datenum('12:12:48') 700 
datenum('12:12:51') datenum('12:12:52') 700 
datenum('12:12:55') datenum('12:12:55') 700 
datenum('12:12:57') datenum('12:12:57') 700 
datenum('12:13:03') datenum('12:13:03') 700 
datenum('12:13:09') datenum('12:13:23') 700 
datenum('12:13:25') datenum('12:13:25') 700 
datenum('12:13:28') datenum('12:13:28') 700 
datenum('12:13:34') datenum('12:13:34') 700 
datenum('12:13:37') datenum('12:13:37') 700 
datenum('12:13:40') datenum('12:13:40') 700 
datenum('12:13:43') datenum('12:13:43') 700 
datenum('12:17:15') datenum('12:17:15') 700 
datenum('12:17:21') datenum('12:17:22') 700 
datenum('12:17:27') datenum('12:17:27') 700 
datenum('12:17:30') datenum('12:17:31') 700 
datenum('12:17:33') datenum('12:17:37') 700 
datenum('12:17:39') datenum('12:17:39') 700 
datenum('12:17:41') datenum('12:17:54') 700 
datenum('12:17:56') datenum('12:17:59') 700 
datenum('12:18:03') datenum('12:18:05') 700 
datenum('12:18:07') datenum('12:18:07') 700 
datenum('12:18:11') datenum('12:18:11') 700 
datenum('12:18:13') datenum('12:18:13') 700 
datenum('12:18:16') datenum('12:18:16') 700 
datenum('12:18:21') datenum('12:18:21') 700 
datenum('12:20:59') datenum('12:21:07') 700 
datenum('12:21:09') datenum('12:21:14') 700 
datenum('12:21:18') datenum('12:21:22') 700 
datenum('12:21:25') datenum('12:21:30') 700 
datenum('12:21:34') datenum('12:21:36') 700 
datenum('12:21:39') datenum('12:21:41') 700 
datenum('12:21:43') datenum('12:21:45') 700 
datenum('12:21:49') datenum('12:21:51') 700 
datenum('12:21:53') datenum('12:22:06') 700 
datenum('12:22:08') datenum('12:22:19') 700 
datenum('12:22:22') datenum('12:22:35') 700 
datenum('12:22:37') datenum('12:22:38') 700 
datenum('12:22:40') datenum('12:22:45') 700 
datenum('12:22:47') datenum('12:22:48') 700 
datenum('12:22:50') datenum('12:22:58') 700 
datenum('12:23:00') datenum('12:23:00') 700 
datenum('12:23:03') datenum('12:23:03') 700 
datenum('12:12:45') datenum('12:13:47') 10 
datenum('12:13:50') datenum('12:13:50') 10 
datenum('12:17:15') datenum('12:18:14') 10 
datenum('12:18:16') datenum('12:18:16') 10 
datenum('12:18:21') datenum('12:18:21') 10 
datenum('12:20:59') datenum('12:22:58') 10 
datenum('12:23:00') datenum('12:23:00') 10 
datenum('12:23:03') datenum('12:23:03') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return