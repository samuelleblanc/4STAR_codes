function marks = starflags_20160602_NO2_MS_marks_CLOUD_EVENTS_20170109_1244  
 % starflags file for 20160602 created by MS on 20170109_1244 to mark CLOUD_EVENTS conditions 
 version_set('20170109_1244'); 
 daystr = '20160602';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:08:53') datenum('01:45:10') 700 
datenum('01:53:04') datenum('02:36:50') 700 
datenum('01:08:53') datenum('01:45:10') 10 
datenum('01:53:04') datenum('02:36:50') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return