function marks = starflags_20160516_NO2_MS_marks_CLOUD_EVENTS_20170109_0655  
 % starflags file for 20160516 created by MS on 20170109_0655 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0655'); 
 daystr = '20160516';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:00:47') datenum('01:13:09') 03 
datenum('01:15:53') datenum('01:17:09') 03 
datenum('01:27:53') datenum('01:31:59') 03 
datenum('02:07:12') datenum('02:07:21') 03 
datenum('02:10:43') datenum('02:10:44') 03 
datenum('02:11:07') datenum('02:12:16') 03 
datenum('02:28:24') datenum('02:29:40') 03 
datenum('02:55:05') datenum('02:55:34') 03 
datenum('02:59:38') datenum('03:00:46') 03 
datenum('04:19:44') datenum('04:30:49') 03 
datenum('05:04:36') datenum('05:22:49') 03 
datenum('05:26:16') datenum('06:10:59') 03 
datenum('06:27:43') datenum('06:27:43') 03 
datenum('06:28:12') datenum('06:28:51') 03 
datenum('01:16:13') datenum('01:16:17') 700 
datenum('02:07:12') datenum('02:07:13') 700 
datenum('02:07:16') datenum('02:07:20') 700 
datenum('02:11:09') datenum('02:12:11') 700 
datenum('02:28:32') datenum('02:29:29') 700 
datenum('02:55:06') datenum('02:55:29') 700 
datenum('04:20:26') datenum('04:20:27') 700 
datenum('04:23:27') datenum('04:23:27') 700 
datenum('04:23:45') datenum('04:23:53') 700 
datenum('05:26:16') datenum('05:26:21') 700 
datenum('05:32:55') datenum('05:33:00') 700 
datenum('05:44:36') datenum('05:44:41') 700 
datenum('06:05:08') datenum('06:05:12') 700 
datenum('01:00:47') datenum('01:13:09') 10 
datenum('01:15:53') datenum('01:17:09') 10 
datenum('01:27:53') datenum('01:31:59') 10 
datenum('02:07:12') datenum('02:07:21') 10 
datenum('02:10:43') datenum('02:10:44') 10 
datenum('02:11:07') datenum('02:12:16') 10 
datenum('02:28:24') datenum('02:29:40') 10 
datenum('02:55:05') datenum('02:55:34') 10 
datenum('02:59:38') datenum('03:00:46') 10 
datenum('04:19:44') datenum('04:30:49') 10 
datenum('05:04:36') datenum('05:22:49') 10 
datenum('05:26:16') datenum('06:10:59') 10 
datenum('06:27:43') datenum('06:27:43') 10 
datenum('06:28:12') datenum('06:28:51') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return