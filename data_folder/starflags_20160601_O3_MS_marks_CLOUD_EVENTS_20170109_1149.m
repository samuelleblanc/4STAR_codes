function marks = starflags_20160601_O3_MS_marks_CLOUD_EVENTS_20170109_1149  
 % starflags file for 20160601 created by MS on 20170109_1149 to mark CLOUD_EVENTS conditions 
 version_set('20170109_1149'); 
 daystr = '20160601';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:09:32') datenum('06:18:39') 700 
datenum('06:09:32') datenum('06:18:39') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return