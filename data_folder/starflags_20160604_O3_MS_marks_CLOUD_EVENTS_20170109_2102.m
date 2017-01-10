function marks = starflags_20160604_O3_MS_marks_CLOUD_EVENTS_20170109_2102  
 % starflags file for 20160604 created by MS on 20170109_2102 to mark CLOUD_EVENTS conditions 
 version_set('20170109_2102'); 
 daystr = '20160604';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('04:41:04') datenum('04:50:12') 700 
datenum('05:16:49') datenum('05:18:52') 700 
datenum('04:41:04') datenum('04:50:12') 10 
datenum('05:16:49') datenum('05:18:52') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return