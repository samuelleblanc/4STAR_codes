function marks = starflags_20160927_NO2_MS_marks_CLOUD_EVENTS_20161017_2159  
 % starflags file for 20160927 created by MS on 20161017_2159 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2159'); 
 daystr = '20160927';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('17:22:29') datenum('17:23:50') 03 
datenum('17:23:52') datenum('17:23:53') 03 
datenum('17:23:58') datenum('17:24:21') 03 
datenum('17:24:24') datenum('17:25:25') 03 
datenum('17:28:34') datenum('17:28:35') 03 
datenum('17:30:02') datenum('17:30:31') 03 
datenum('17:33:01') datenum('17:33:01') 03 
datenum('17:33:03') datenum('17:33:03') 03 
datenum('17:33:10') datenum('17:33:15') 03 
datenum('17:33:18') datenum('17:33:19') 03 
datenum('17:34:28') datenum('17:35:43') 03 
datenum('17:35:59') datenum('17:36:04') 03 
datenum('17:38:18') datenum('17:38:19') 03 
datenum('17:38:21') datenum('17:38:26') 03 
datenum('17:38:31') datenum('17:38:32') 03 
datenum('17:38:36') datenum('17:38:39') 03 
datenum('17:38:42') datenum('17:39:57') 03 
datenum('17:22:59') datenum('17:23:21') 700 
datenum('17:24:27') datenum('17:24:59') 700 
datenum('17:30:02') datenum('17:30:02') 700 
datenum('17:34:57') datenum('17:35:39') 700 
datenum('17:38:48') datenum('17:39:32') 700 
datenum('17:22:29') datenum('17:23:50') 10 
datenum('17:23:52') datenum('17:23:53') 10 
datenum('17:23:58') datenum('17:24:21') 10 
datenum('17:24:24') datenum('17:25:25') 10 
datenum('17:28:34') datenum('17:28:35') 10 
datenum('17:30:02') datenum('17:30:31') 10 
datenum('17:33:01') datenum('17:33:01') 10 
datenum('17:33:03') datenum('17:33:03') 10 
datenum('17:33:10') datenum('17:33:15') 10 
datenum('17:33:18') datenum('17:33:19') 10 
datenum('17:34:28') datenum('17:35:43') 10 
datenum('17:35:59') datenum('17:36:04') 10 
datenum('17:38:18') datenum('17:38:19') 10 
datenum('17:38:21') datenum('17:38:26') 10 
datenum('17:38:31') datenum('17:38:32') 10 
datenum('17:38:36') datenum('17:38:39') 10 
datenum('17:38:42') datenum('17:39:57') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return