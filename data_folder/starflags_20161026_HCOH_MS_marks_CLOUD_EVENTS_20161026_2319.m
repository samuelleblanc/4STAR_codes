function marks = starflags_20161026_HCOH_MS_marks_CLOUD_EVENTS_20161026_2319  
 % starflags file for 20161026 created by MS on 20161026_2319 to mark CLOUD_EVENTS conditions 
 version_set('20161026_2319'); 
 daystr = '20161026';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('17:24:02') datenum('17:31:14') 03 
datenum('17:40:12') datenum('17:41:08') 03 
datenum('17:31:14') datenum('17:31:14') 700 
datenum('17:41:08') datenum('17:41:08') 700 
datenum('17:24:02') datenum('17:31:14') 10 
datenum('17:40:12') datenum('17:41:08') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return