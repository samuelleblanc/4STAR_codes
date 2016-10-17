function marks = starflags_20160908_O3_MS_marks_CLOUD_EVENTS_20161017_1455  
 % starflags file for 20160908 created by MS on 20161017_1455 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1455'); 
 daystr = '20160908';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:55:36') datenum('06:55:55') 03 
datenum('07:06:05') datenum('07:06:27') 03 
datenum('11:15:49') datenum('11:38:44') 03 
datenum('07:06:05') datenum('07:06:13') 700 
datenum('11:17:06') datenum('11:17:11') 700 
datenum('11:17:17') datenum('11:17:20') 700 
datenum('11:17:25') datenum('11:17:28') 700 
datenum('11:17:32') datenum('11:17:39') 700 
datenum('11:17:44') datenum('11:17:48') 700 
datenum('11:19:34') datenum('11:19:35') 700 
datenum('11:20:10') datenum('11:20:10') 700 
datenum('11:20:35') datenum('11:20:35') 700 
datenum('11:20:40') datenum('11:20:42') 700 
datenum('11:22:10') datenum('11:22:11') 700 
datenum('11:25:03') datenum('11:25:10') 700 
datenum('11:25:19') datenum('11:25:32') 700 
datenum('11:25:41') datenum('11:25:47') 700 
datenum('11:27:27') datenum('11:27:27') 700 
datenum('11:27:36') datenum('11:28:02') 700 
datenum('11:28:06') datenum('11:28:06') 700 
datenum('11:28:11') datenum('11:28:11') 700 
datenum('11:28:20') datenum('11:28:20') 700 
datenum('11:28:40') datenum('11:28:41') 700 
datenum('11:28:47') datenum('11:28:52') 700 
datenum('11:29:09') datenum('11:29:09') 700 
datenum('11:29:12') datenum('11:29:12') 700 
datenum('11:29:27') datenum('11:29:28') 700 
datenum('11:30:38') datenum('11:30:43') 700 
datenum('11:33:34') datenum('11:33:34') 700 
datenum('11:34:37') datenum('11:34:37') 700 
datenum('11:34:40') datenum('11:34:57') 700 
datenum('11:35:05') datenum('11:35:05') 700 
datenum('11:35:16') datenum('11:35:16') 700 
datenum('11:35:26') datenum('11:35:26') 700 
datenum('11:35:31') datenum('11:35:41') 700 
datenum('11:35:52') datenum('11:35:55') 700 
datenum('11:36:02') datenum('11:36:02') 700 
datenum('11:36:05') datenum('11:36:06') 700 
datenum('06:55:36') datenum('06:55:55') 10 
datenum('07:06:05') datenum('07:06:27') 10 
datenum('11:15:49') datenum('11:38:44') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return