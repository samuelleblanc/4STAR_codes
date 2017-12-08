function marks = starflags_20170824_O3_MS_marks_CLOUD_EVENTS_20170828_0756  
 % starflags file for 20170824 created by MS on 20170828_0756 to mark CLOUD_EVENTS conditions 
 version_set('20170828_0756'); 
 daystr = '20170824';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('08:15:53') datenum('08:38:53') 10 
datenum('10:09:16') datenum('10:09:16') 10 
datenum('11:10:26') datenum('11:28:28') 10 
datenum('11:55:16') datenum('12:27:47') 10 
datenum('14:44:28') datenum('14:45:20') 10 
datenum('14:51:08') datenum('14:54:55') 10 
datenum('14:57:17') datenum('14:58:13') 10 
datenum('15:24:50') datenum('15:26:00') 10 
datenum('16:13:08') datenum('16:13:47') 10 
datenum('16:48:18') datenum('17:21:44') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return