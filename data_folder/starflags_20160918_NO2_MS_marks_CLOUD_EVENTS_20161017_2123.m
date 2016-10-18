function marks = starflags_20160918_NO2_MS_marks_CLOUD_EVENTS_20161017_2123  
 % starflags file for 20160918 created by MS on 20161017_2123 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2123'); 
 daystr = '20160918';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:48:08') datenum('09:48:22') 03 
datenum('09:48:34') datenum('09:48:47') 03 
datenum('09:48:51') datenum('09:48:52') 03 
datenum('09:48:54') datenum('09:48:55') 03 
datenum('09:48:08') datenum('09:48:22') 700 
datenum('09:48:08') datenum('09:48:22') 10 
datenum('09:48:34') datenum('09:48:47') 10 
datenum('09:48:51') datenum('09:48:52') 10 
datenum('09:48:54') datenum('09:48:55') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return