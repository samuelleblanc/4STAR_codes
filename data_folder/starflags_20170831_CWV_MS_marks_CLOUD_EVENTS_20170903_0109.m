function marks = starflags_20170831_CWV_MS_marks_CLOUD_EVENTS_20170903_0109  
 % starflags file for 20170831 created by MS on 20170903_0109 to mark CLOUD_EVENTS conditions 
 version_set('20170903_0109'); 
 daystr = '20170831';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('09:37:02') datenum('09:43:22') 10 
datenum('09:45:08') datenum('09:45:26') 10 
datenum('09:46:08') datenum('09:46:09') 10 
datenum('09:51:45') datenum('09:51:54') 10 
datenum('10:09:01') datenum('10:09:04') 10 
datenum('10:23:59') datenum('10:23:59') 10 
datenum('11:58:26') datenum('11:58:27') 10 
datenum('13:18:03') datenum('13:18:41') 10 
datenum('13:22:23') datenum('13:26:37') 10 
datenum('15:51:33') datenum('15:51:36') 10 
datenum('15:51:54') datenum('16:00:59') 10 
datenum('16:01:41') datenum('16:02:12') 10 
datenum('16:02:21') datenum('16:03:06') 10 
datenum('16:07:27') datenum('16:14:03') 10 
datenum('16:37:22') datenum('16:37:46') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return