function marks = starflags_20160910_NO2_MS_marks_CLOUD_EVENTS_20161017_1506  
 % starflags file for 20160910 created by MS on 20161017_1506 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1506'); 
 daystr = '20160910';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:54:17') datenum('06:56:10') 03 
datenum('06:59:02') datenum('06:59:02') 03 
datenum('06:59:06') datenum('07:00:40') 03 
datenum('09:01:04') datenum('09:01:05') 03 
datenum('09:01:10') datenum('09:02:07') 03 
datenum('06:54:45') datenum('06:54:45') 700 
datenum('06:55:13') datenum('06:55:45') 700 
datenum('06:55:52') datenum('06:55:56') 700 
datenum('06:56:01') datenum('06:56:10') 700 
datenum('06:59:02') datenum('06:59:02') 700 
datenum('06:59:06') datenum('07:00:00') 700 
datenum('09:01:31') datenum('09:01:44') 700 
datenum('06:54:17') datenum('06:56:10') 10 
datenum('06:59:02') datenum('06:59:02') 10 
datenum('06:59:06') datenum('07:00:40') 10 
datenum('09:01:04') datenum('09:01:05') 10 
datenum('09:01:10') datenum('09:02:07') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return