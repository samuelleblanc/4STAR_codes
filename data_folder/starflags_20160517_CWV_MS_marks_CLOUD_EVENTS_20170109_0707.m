function marks = starflags_20160517_CWV_MS_marks_CLOUD_EVENTS_20170109_0707  
 % starflags file for 20160517 created by MS on 20170109_0707 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0707'); 
 daystr = '20160517';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('03:20:45') datenum('03:20:46') 10 
datenum('03:21:01') datenum('03:21:02') 10 
datenum('03:21:20') datenum('03:21:20') 10 
datenum('03:34:47') datenum('03:34:49') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return