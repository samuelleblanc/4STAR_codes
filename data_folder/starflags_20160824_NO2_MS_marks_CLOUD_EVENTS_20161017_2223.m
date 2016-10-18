function marks = starflags_20160824_NO2_MS_marks_CLOUD_EVENTS_20161017_2223  
 % starflags file for 20160824 created by MS on 20161017_2223 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2223'); 
 daystr = '20160824';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('17:32:20') datenum('17:32:48') 03 
datenum('17:32:54') datenum('17:32:54') 03 
datenum('17:32:58') datenum('17:32:58') 03 
datenum('17:33:20') datenum('17:33:20') 03 
datenum('17:33:22') datenum('17:34:08') 03 
datenum('17:34:13') datenum('17:34:25') 03 
datenum('17:35:31') datenum('17:35:31') 03 
datenum('17:35:38') datenum('17:35:41') 03 
datenum('17:35:46') datenum('17:36:00') 03 
datenum('17:36:02') datenum('17:36:23') 03 
datenum('17:36:34') datenum('17:36:34') 03 
datenum('17:32:54') datenum('17:32:54') 700 
datenum('17:32:58') datenum('17:32:58') 700 
datenum('17:33:20') datenum('17:33:20') 700 
datenum('17:33:22') datenum('17:34:08') 700 
datenum('17:34:13') datenum('17:34:25') 700 
datenum('17:35:31') datenum('17:35:31') 700 
datenum('17:35:38') datenum('17:35:41') 700 
datenum('17:35:46') datenum('17:36:00') 700 
datenum('17:36:02') datenum('17:36:14') 700 
datenum('17:32:20') datenum('17:32:48') 10 
datenum('17:32:54') datenum('17:32:54') 10 
datenum('17:32:58') datenum('17:32:58') 10 
datenum('17:33:20') datenum('17:33:20') 10 
datenum('17:33:22') datenum('17:34:08') 10 
datenum('17:34:13') datenum('17:34:25') 10 
datenum('17:35:31') datenum('17:35:31') 10 
datenum('17:35:38') datenum('17:35:41') 10 
datenum('17:35:46') datenum('17:36:00') 10 
datenum('17:36:02') datenum('17:36:23') 10 
datenum('17:36:34') datenum('17:36:34') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return