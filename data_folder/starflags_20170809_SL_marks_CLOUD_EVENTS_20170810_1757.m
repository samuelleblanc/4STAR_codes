function marks = starflags_20170809_SL_marks_CLOUD_EVENTS_20170810_1757  
 % starflags file for 20170809 created by SL on 20170810_1757 to mark CLOUD_EVENTS conditions 
 version_set('20170810_1757'); 
 daystr = '20170809';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:09:15') datenum('09:41:12') 700 
datenum('09:44:32') datenum('09:44:58') 700 
datenum('09:45:03') datenum('09:45:06') 700 
datenum('09:45:12') datenum('09:45:20') 700 
datenum('09:45:31') datenum('09:45:45') 700 
datenum('09:45:51') datenum('09:46:33') 700 
datenum('09:46:44') datenum('09:46:44') 700 
datenum('09:46:49') datenum('09:50:21') 700 
datenum('11:26:47') datenum('12:04:53') 700 
datenum('13:26:17') datenum('13:26:17') 700 
datenum('13:26:28') datenum('13:26:33') 700 
datenum('13:27:24') datenum('13:27:24') 700 
datenum('13:40:29') datenum('13:41:22') 700 
datenum('13:59:25') datenum('14:01:45') 700 
datenum('14:07:53') datenum('14:09:49') 700 
datenum('09:09:15') datenum('09:41:12') 10 
datenum('09:44:32') datenum('09:44:58') 10 
datenum('09:45:03') datenum('09:45:06') 10 
datenum('09:45:12') datenum('09:45:20') 10 
datenum('09:45:31') datenum('09:45:45') 10 
datenum('09:45:51') datenum('09:46:33') 10 
datenum('09:46:44') datenum('09:46:44') 10 
datenum('09:46:49') datenum('09:50:21') 10 
datenum('11:26:47') datenum('12:04:53') 10 
datenum('13:26:17') datenum('13:26:17') 10 
datenum('13:26:28') datenum('13:26:33') 10 
datenum('13:27:24') datenum('13:27:24') 10 
datenum('13:40:29') datenum('13:41:22') 10 
datenum('13:59:25') datenum('14:01:45') 10 
datenum('14:07:53') datenum('14:09:49') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return