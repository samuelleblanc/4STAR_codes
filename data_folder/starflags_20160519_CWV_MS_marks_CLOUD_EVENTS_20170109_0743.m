function marks = starflags_20160519_CWV_MS_marks_CLOUD_EVENTS_20170109_0743  
 % starflags file for 20160519 created by MS on 20170109_0743 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0743'); 
 daystr = '20160519';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:35:20') datenum('02:36:09') 03 
datenum('02:36:42') datenum('02:37:23') 03 
datenum('02:37:34') datenum('02:37:37') 03 
datenum('02:37:40') datenum('02:37:55') 03 
datenum('02:38:02') datenum('02:38:15') 03 
datenum('02:38:17') datenum('02:38:19') 03 
datenum('02:58:17') datenum('02:58:18') 03 
datenum('02:59:21') datenum('02:59:22') 03 
datenum('02:59:25') datenum('02:59:44') 03 
datenum('03:00:26') datenum('03:00:26') 03 
datenum('03:09:25') datenum('03:10:36') 03 
datenum('05:27:59') datenum('05:28:46') 03 
datenum('02:35:50') datenum('02:35:50') 700 
datenum('02:36:09') datenum('02:36:09') 700 
datenum('02:36:42') datenum('02:36:43') 700 
datenum('02:37:16') datenum('02:37:18') 700 
datenum('02:37:34') datenum('02:37:35') 700 
datenum('02:37:37') datenum('02:37:37') 700 
datenum('02:37:40') datenum('02:37:40') 700 
datenum('02:37:51') datenum('02:37:55') 700 
datenum('02:38:02') datenum('02:38:09') 700 
datenum('02:38:15') datenum('02:38:15') 700 
datenum('02:38:17') datenum('02:38:17') 700 
datenum('02:58:17') datenum('02:58:18') 700 
datenum('02:59:21') datenum('02:59:22') 700 
datenum('02:59:25') datenum('02:59:44') 700 
datenum('03:00:26') datenum('03:00:26') 700 
datenum('03:09:25') datenum('03:10:36') 700 
datenum('05:27:59') datenum('05:28:46') 700 
datenum('02:35:20') datenum('02:36:09') 10 
datenum('02:36:42') datenum('02:37:23') 10 
datenum('02:37:34') datenum('02:37:37') 10 
datenum('02:37:40') datenum('02:37:55') 10 
datenum('02:38:02') datenum('02:38:15') 10 
datenum('02:38:17') datenum('02:38:19') 10 
datenum('02:58:17') datenum('02:58:18') 10 
datenum('02:59:21') datenum('02:59:22') 10 
datenum('02:59:25') datenum('02:59:44') 10 
datenum('03:00:26') datenum('03:00:26') 10 
datenum('03:09:25') datenum('03:10:36') 10 
datenum('05:27:59') datenum('05:28:46') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return