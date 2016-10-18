function marks = starflags_20160927_HCOH_MS_marks_CLOUD_EVENTS_20161017_2201  
 % starflags file for 20160927 created by MS on 20161017_2201 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2201'); 
 daystr = '20160927';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:40:57') datenum('09:45:24') 03 
datenum('09:40:57') datenum('09:42:34') 700 
datenum('09:42:36') datenum('09:42:45') 700 
datenum('09:42:47') datenum('09:42:47') 700 
datenum('09:42:50') datenum('09:42:50') 700 
datenum('09:42:53') datenum('09:42:53') 700 
datenum('09:42:55') datenum('09:43:00') 700 
datenum('09:43:07') datenum('09:43:07') 700 
datenum('09:43:10') datenum('09:43:11') 700 
datenum('09:43:14') datenum('09:43:14') 700 
datenum('09:43:16') datenum('09:43:17') 700 
datenum('09:43:21') datenum('09:43:21') 700 
datenum('09:43:23') datenum('09:43:23') 700 
datenum('09:45:24') datenum('09:45:24') 700 
datenum('09:40:57') datenum('09:45:24') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return