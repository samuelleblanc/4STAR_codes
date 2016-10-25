function marks = starflags_20160925_SL_marks_CLOUD_EVENTS_20161024_1938  
 % starflags file for 20160925 created by SL on 20161024_1938 to mark CLOUD_EVENTS conditions 
 version_set('20161024_1938'); 
 daystr = '20160925';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('07:59:39') datenum('08:01:55') 10 
datenum('08:02:28') datenum('08:02:43') 10 
datenum('08:04:57') datenum('08:06:41') 10 
datenum('08:09:54') datenum('08:12:18') 10 
datenum('10:58:45') datenum('11:00:09') 10 
datenum('11:30:22') datenum('11:37:07') 10 
datenum('12:16:04') datenum('12:16:09') 10 
datenum('12:17:01') datenum('12:19:09') 10 
datenum('13:30:59') datenum('13:32:18') 10 
datenum('15:33:57') datenum('15:33:57') 10 
datenum('16:14:08') datenum('16:14:11') 10 
datenum('16:21:40') datenum('16:21:42') 10 
datenum('16:22:18') datenum('16:22:29') 10 
datenum('16:25:17') datenum('16:25:17') 10 
datenum('16:26:01') datenum('16:26:01') 10 
datenum('16:26:09') datenum('16:26:09') 10 
datenum('16:26:16') datenum('16:26:16') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return