function marks = starflags_20160902_NO2_MS_marks_CLOUD_EVENTS_20161017_1359  
 % starflags file for 20160902 created by MS on 20161017_1359 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1359'); 
 daystr = '20160902';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('11:03:16') datenum('11:05:40') 03 
datenum('11:03:44') datenum('11:03:57') 700 
datenum('11:04:55') datenum('11:04:57') 700 
datenum('11:04:59') datenum('11:04:59') 700 
datenum('11:05:31') datenum('11:05:33') 700 
datenum('11:05:40') datenum('11:05:40') 700 
datenum('11:03:16') datenum('11:05:40') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return