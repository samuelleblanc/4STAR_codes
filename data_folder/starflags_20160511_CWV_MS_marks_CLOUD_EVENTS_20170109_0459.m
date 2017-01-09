function marks = starflags_20160511_CWV_MS_marks_CLOUD_EVENTS_20170109_0459  
 % starflags file for 20160511 created by MS on 20170109_0459 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0459'); 
 daystr = '20160511';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('03:01:14') datenum('03:01:14') 03 
datenum('03:02:49') datenum('03:02:49') 03 
datenum('03:02:53') datenum('03:02:53') 03 
datenum('03:09:15') datenum('03:09:15') 03 
datenum('03:09:18') datenum('03:09:18') 03 
datenum('03:36:34') datenum('03:36:34') 03 
datenum('03:37:03') datenum('03:37:03') 03 
datenum('03:37:30') datenum('03:37:30') 03 
datenum('03:37:55') datenum('03:37:55') 03 
datenum('03:43:37') datenum('03:43:37') 03 
datenum('03:01:14') datenum('03:01:14') 10 
datenum('03:02:49') datenum('03:02:49') 10 
datenum('03:02:53') datenum('03:02:53') 10 
datenum('03:09:15') datenum('03:09:15') 10 
datenum('03:09:18') datenum('03:09:18') 10 
datenum('03:36:34') datenum('03:36:34') 10 
datenum('03:37:03') datenum('03:37:03') 10 
datenum('03:37:30') datenum('03:37:30') 10 
datenum('03:37:55') datenum('03:37:55') 10 
datenum('03:43:37') datenum('03:43:37') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return