function marks = starflags_20170809_NO2_MS_marks_CLOUD_EVENTS_20170906_1655  
 % starflags file for 20170809 created by MS on 20170906_1655 to mark CLOUD_EVENTS conditions 
 version_set('20170906_1655'); 
 daystr = '20170809';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('11:26:45') datenum('11:26:45') 700 
datenum('11:26:48') datenum('11:27:40') 700 
datenum('13:40:02') datenum('13:40:02') 700 
datenum('13:40:10') datenum('13:40:10') 700 
datenum('11:13:39') datenum('11:26:42') 10 
datenum('11:26:45') datenum('11:26:45') 10 
datenum('11:26:48') datenum('11:27:40') 10 
datenum('13:25:47') datenum('13:25:58') 10 
datenum('13:27:02') datenum('13:27:07') 10 
datenum('13:38:43') datenum('13:41:22') 10 
datenum('16:18:51') datenum('16:32:02') 10 
datenum('17:19:36') datenum('17:26:02') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return