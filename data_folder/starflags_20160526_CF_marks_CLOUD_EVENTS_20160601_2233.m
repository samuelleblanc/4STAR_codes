function marks = starflags_20160526_CF_marks_CLOUD_EVENTS_20160601_2233  
 % starflags file for 20160526 created by CF on 20160601_2233 to mark CLOUD_EVENTS conditions 
 version_set('20160601_2233'); 
 daystr = '20160526';  
 % tag = 2: before_or_after_flight 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:33:13') datenum('02:33:18') 02 
datenum('02:33:13') datenum('02:33:18') 700 
datenum('02:33:13') datenum('02:33:18') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return