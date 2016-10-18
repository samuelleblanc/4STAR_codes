function marks = starflags_20160918_O3_MS_marks_CLOUD_EVENTS_20161017_2118  
 % starflags file for 20160918 created by MS on 20161017_2118 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2118'); 
 daystr = '20160918';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:46:22') datenum('10:47:29') 03 
datenum('11:21:58') datenum('11:24:12') 03 
datenum('11:24:47') datenum('11:24:47') 03 
datenum('11:27:13') datenum('11:29:24') 03 
datenum('11:32:21') datenum('11:34:36') 03 
datenum('11:37:47') datenum('11:38:54') 03 
datenum('11:40:31') datenum('11:41:32') 03 
datenum('11:41:34') datenum('11:41:35') 03 
datenum('11:53:47') datenum('11:53:50') 03 
datenum('11:53:53') datenum('11:54:28') 03 
datenum('11:56:41') datenum('11:57:21') 03 
datenum('10:46:50') datenum('10:47:00') 700 
datenum('11:22:28') datenum('11:22:32') 700 
datenum('11:23:03') datenum('11:23:42') 700 
datenum('11:27:42') datenum('11:27:53') 700 
datenum('11:27:57') datenum('11:28:01') 700 
datenum('11:28:18') datenum('11:28:55') 700 
datenum('11:32:21') datenum('11:32:49') 700 
datenum('11:33:01') datenum('11:33:29') 700 
datenum('11:34:12') datenum('11:34:36') 700 
datenum('11:38:17') datenum('11:38:25') 700 
datenum('11:41:01') datenum('11:41:09') 700 
datenum('11:54:18') datenum('11:54:28') 700 
datenum('11:56:41') datenum('11:56:50') 700 
datenum('10:46:22') datenum('10:47:29') 10 
datenum('11:21:58') datenum('11:24:12') 10 
datenum('11:24:47') datenum('11:24:47') 10 
datenum('11:27:13') datenum('11:29:24') 10 
datenum('11:32:21') datenum('11:34:36') 10 
datenum('11:37:47') datenum('11:38:54') 10 
datenum('11:40:31') datenum('11:41:32') 10 
datenum('11:41:34') datenum('11:41:35') 10 
datenum('11:53:47') datenum('11:53:50') 10 
datenum('11:53:53') datenum('11:54:28') 10 
datenum('11:56:41') datenum('11:57:21') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return