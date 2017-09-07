function marks = starflags_20170830_NO2_MS_marks_CLOUD_EVENTS_20170907_1157  
 % starflags file for 20170830 created by MS on 20170907_1157 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1157'); 
 daystr = '20170830';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:38:00') datenum('12:38:01') 700 
datenum('12:59:07') datenum('12:59:07') 700 
datenum('13:01:13') datenum('13:01:13') 700 
datenum('12:29:22') datenum('12:34:20') 10 
datenum('12:37:54') datenum('12:52:16') 10 
datenum('12:59:07') datenum('12:59:07') 10 
datenum('13:01:13') datenum('13:01:13') 10 
datenum('15:27:34') datenum('15:37:56') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return