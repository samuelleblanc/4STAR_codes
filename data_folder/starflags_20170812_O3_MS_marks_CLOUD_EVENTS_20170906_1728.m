function marks = starflags_20170812_O3_MS_marks_CLOUD_EVENTS_20170906_1728  
 % starflags file for 20170812 created by MS on 20170906_1728 to mark CLOUD_EVENTS conditions 
 version_set('20170906_1728'); 
 daystr = '20170812';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('08:26:45') datenum('08:36:45') 10 
datenum('09:07:28') datenum('09:09:55') 10 
datenum('10:10:56') datenum('10:12:46') 10 
datenum('10:57:41') datenum('10:59:54') 10 
datenum('11:28:50') datenum('11:32:06') 10 
datenum('12:07:13') datenum('12:11:15') 10 
datenum('12:39:38') datenum('12:42:07') 10 
datenum('13:07:42') datenum('13:11:19') 10 
datenum('13:32:16') datenum('13:48:07') 10 
datenum('14:33:01') datenum('14:54:17') 10 
datenum('14:57:47') datenum('15:02:06') 10 
datenum('15:05:28') datenum('15:07:09') 10 
datenum('15:11:28') datenum('15:16:43') 10 
datenum('15:39:39') datenum('15:45:04') 10 
datenum('16:21:05') datenum('16:32:10') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return