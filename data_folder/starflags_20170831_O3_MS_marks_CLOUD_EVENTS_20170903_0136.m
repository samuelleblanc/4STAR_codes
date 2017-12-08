function marks = starflags_20170831_O3_MS_marks_CLOUD_EVENTS_20170903_0136  
 % starflags file for 20170831 created by MS on 20170903_0136 to mark CLOUD_EVENTS conditions 
 version_set('20170903_0136'); 
 daystr = '20170831';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:43:13') datenum('09:43:13') 700 
datenum('09:43:20') datenum('09:43:22') 700 
datenum('09:43:27') datenum('09:43:27') 700 
datenum('09:36:32') datenum('09:43:27') 10 
datenum('13:17:32') datenum('13:17:48') 10 
datenum('13:18:31') datenum('13:18:41') 10 
datenum('13:21:55') datenum('13:21:55') 10 
datenum('13:22:00') datenum('13:27:17') 10 
datenum('15:19:14') datenum('15:19:14') 10 
datenum('15:51:41') datenum('16:00:59') 10 
datenum('16:01:41') datenum('16:03:47') 10 
datenum('16:06:43') datenum('16:14:05') 10 
datenum('16:36:51') datenum('16:37:48') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return