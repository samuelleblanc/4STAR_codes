function marks = starflags_20170821_CWV_MS_marks_CLOUD_EVENTS_20170908_0950  
 % starflags file for 20170821 created by MS on 20170908_0950 to mark CLOUD_EVENTS conditions 
 version_set('20170908_0950'); 
 daystr = '20170821';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('10:07:59') datenum('10:07:59') 10 
datenum('10:57:06') datenum('10:57:27') 10 
datenum('11:14:24') datenum('11:14:24') 10 
datenum('12:43:35') datenum('12:43:36') 10 
datenum('12:44:27') datenum('12:44:30') 10 
datenum('12:49:47') datenum('12:49:57') 10 
datenum('12:51:20') datenum('12:51:22') 10 
datenum('12:57:07') datenum('12:57:13') 10 
datenum('12:57:53') datenum('12:57:58') 10 
datenum('12:58:03') datenum('12:58:03') 10 
datenum('12:59:07') datenum('12:59:49') 10 
datenum('13:03:00') datenum('13:06:08') 10 
datenum('13:25:21') datenum('13:26:05') 10 
datenum('13:34:22') datenum('13:35:45') 10 
datenum('15:45:58') datenum('15:48:05') 10 
datenum('16:28:31') datenum('16:29:38') 10 
datenum('16:29:43') datenum('16:30:09') 10 
datenum('17:39:25') datenum('17:52:59') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return