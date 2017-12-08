function marks = starflags_20170902_O3_MS_marks_CLOUD_EVENTS_20170907_1017  
 % starflags file for 20170902 created by MS on 20170907_1017 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1017'); 
 daystr = '20170902';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('09:47:50') datenum('09:47:50') 10 
datenum('09:49:32') datenum('09:49:34') 10 
datenum('10:52:49') datenum('11:03:17') 10 
datenum('12:39:13') datenum('13:24:38') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return