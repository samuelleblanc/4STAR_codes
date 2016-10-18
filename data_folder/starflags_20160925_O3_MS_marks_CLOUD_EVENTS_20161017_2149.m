function marks = starflags_20160925_O3_MS_marks_CLOUD_EVENTS_20161017_2149  
 % starflags file for 20160925 created by MS on 20161017_2149 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2149'); 
 daystr = '20160925';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('12:15:36') datenum('12:17:06') 03 
datenum('12:19:08') datenum('12:19:37') 03 
datenum('12:16:06') datenum('12:16:09') 700 
datenum('12:17:02') datenum('12:17:06') 700 
datenum('12:19:08') datenum('12:19:08') 700 
datenum('12:15:36') datenum('12:17:06') 10 
datenum('12:19:08') datenum('12:19:37') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return