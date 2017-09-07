function marks = starflags_20170904_O3_MS_marks_CLOUD_EVENTS_20170907_1105  
 % starflags file for 20170904 created by MS on 20170907_1105 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1105'); 
 daystr = '20170904';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:19:46') datenum('10:21:00') 700 
datenum('10:19:46') datenum('10:47:50') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return