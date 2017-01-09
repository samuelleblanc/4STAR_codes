function marks = starflags_20160529_CWV_MS_marks_CLOUD_EVENTS_20170109_0921  
 % starflags file for 20160529 created by MS on 20170109_0921 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0921'); 
 daystr = '20160529';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('04:03:59') datenum('04:04:01') 03 
datenum('04:04:06') datenum('04:04:08') 03 
datenum('04:04:06') datenum('04:04:06') 700 
datenum('04:03:59') datenum('04:04:01') 10 
datenum('04:04:06') datenum('04:04:08') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return