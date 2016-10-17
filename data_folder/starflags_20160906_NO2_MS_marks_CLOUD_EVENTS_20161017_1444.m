function marks = starflags_20160906_NO2_MS_marks_CLOUD_EVENTS_20161017_1444  
 % starflags file for 20160906 created by MS on 20161017_1444 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1444'); 
 daystr = '20160906';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:23:21') datenum('08:23:21') 03 
datenum('08:23:24') datenum('08:23:26') 03 
datenum('08:23:59') datenum('08:23:59') 03 
datenum('08:46:20') datenum('08:46:24') 03 
datenum('08:47:00') datenum('08:47:00') 03 
datenum('08:23:59') datenum('08:23:59') 700 
datenum('08:47:00') datenum('08:47:00') 700 
datenum('08:23:21') datenum('08:23:21') 10 
datenum('08:23:24') datenum('08:23:26') 10 
datenum('08:23:59') datenum('08:23:59') 10 
datenum('08:46:20') datenum('08:46:24') 10 
datenum('08:47:00') datenum('08:47:00') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return