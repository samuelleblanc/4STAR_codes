function marks = starflags_20170812_NO2_MS_marks_CLOUD_EVENTS_20170906_1738  
 % starflags file for 20170812 created by MS on 20170906_1738 to mark CLOUD_EVENTS conditions 
 version_set('20170906_1738'); 
 daystr = '20170812';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('13:48:04') datenum('14:18:24') 10 
datenum('15:17:47') datenum('15:23:34') 10 
datenum('15:29:59') datenum('15:33:28') 10 
datenum('15:39:39') datenum('15:46:20') 10 
datenum('16:15:25') datenum('16:16:24') 10 
datenum('16:21:16') datenum('16:32:10') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return