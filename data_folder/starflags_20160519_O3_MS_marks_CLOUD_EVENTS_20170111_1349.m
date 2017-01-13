function marks = starflags_20160519_O3_MS_marks_CLOUD_EVENTS_20170111_1349  
 % starflags file for 20160519 created by MS on 20170111_1349 to mark CLOUD_EVENTS conditions 
 version_set('20170111_1349'); 
 daystr = '20160519';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:48:09') datenum('02:48:10') 03 
datenum('02:48:13') datenum('02:49:10') 03 
datenum('02:49:13') datenum('02:49:16') 03 
datenum('04:31:36') datenum('04:32:47') 03 
datenum('04:56:29') datenum('06:58:52') 03 
datenum('02:48:37') datenum('02:48:49') 700 
datenum('04:32:05') datenum('04:32:24') 700 
datenum('05:14:30') datenum('05:14:30') 700 
datenum('05:21:55') datenum('05:21:55') 700 
datenum('05:21:57') datenum('05:21:57') 700 
datenum('05:25:40') datenum('05:25:45') 700 
datenum('05:31:42') datenum('05:31:47') 700 
datenum('05:47:50') datenum('05:47:51') 700 
datenum('05:47:54') datenum('05:47:55') 700 
datenum('05:49:55') datenum('05:50:00') 700 
datenum('06:08:15') datenum('06:08:20') 700 
datenum('06:26:36') datenum('06:26:40') 700 
datenum('06:36:30') datenum('06:36:30') 700 
datenum('06:36:33') datenum('06:36:33') 700 
datenum('06:36:35') datenum('06:36:35') 700 
datenum('06:39:32') datenum('06:39:38') 700 
datenum('06:47:53') datenum('06:47:58') 700 
datenum('02:48:09') datenum('02:48:10') 10 
datenum('02:48:13') datenum('02:49:10') 10 
datenum('02:49:13') datenum('02:49:16') 10 
datenum('04:31:36') datenum('04:32:47') 10 
datenum('04:56:29') datenum('06:58:52') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return