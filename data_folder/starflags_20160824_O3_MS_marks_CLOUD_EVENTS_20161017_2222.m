function marks = starflags_20160824_O3_MS_marks_CLOUD_EVENTS_20161017_2222  
 % starflags file for 20160824 created by MS on 20161017_2222 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2222'); 
 daystr = '20160824';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('15:24:40') datenum('15:24:48') 03 
datenum('15:24:59') datenum('15:26:06') 03 
datenum('17:32:35') datenum('17:32:47') 03 
datenum('15:25:28') datenum('15:25:33') 700 
datenum('15:24:40') datenum('15:24:48') 10 
datenum('15:24:59') datenum('15:26:06') 10 
datenum('17:32:35') datenum('17:32:47') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return