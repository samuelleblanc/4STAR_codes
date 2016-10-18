function marks = starflags_20160929_HCOH_MS_marks_CLOUD_EVENTS_20161017_2207  
 % starflags file for 20160929 created by MS on 20161017_2207 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2207'); 
 daystr = '20160929';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:23:40') datenum('09:24:07') 03 
datenum('09:23:40') datenum('09:23:47') 700 
datenum('09:23:40') datenum('09:24:07') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return