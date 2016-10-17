function marks = starflags_20160830_NO2_MS_marks_CLOUD_EVENTS_20161017_1148  
 % starflags file for 20160830 created by MS on 20161017_1148 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1148'); 
 daystr = '20160830';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:20:35') datenum('06:20:35') 03 
datenum('06:20:39') datenum('06:20:41') 03 
datenum('06:20:44') datenum('06:20:45') 03 
datenum('06:20:48') datenum('06:20:50') 03 
datenum('06:20:53') datenum('06:20:57') 03 
datenum('06:21:01') datenum('06:21:01') 03 
datenum('06:21:04') datenum('06:21:04') 03 
datenum('07:23:05') datenum('07:24:51') 03 
datenum('08:27:47') datenum('08:32:49') 03 
datenum('06:20:35') datenum('06:20:35') 02 
datenum('06:20:39') datenum('06:20:41') 02 
datenum('06:20:44') datenum('06:20:45') 02 
datenum('06:20:48') datenum('06:20:50') 02 
datenum('06:20:53') datenum('06:20:57') 02 
datenum('06:21:01') datenum('06:21:01') 02 
datenum('06:21:04') datenum('06:21:04') 02 
datenum('08:32:48') datenum('08:32:49') 02 
datenum('06:20:35') datenum('06:20:35') 700 
datenum('06:20:39') datenum('06:20:41') 700 
datenum('06:20:44') datenum('06:20:45') 700 
datenum('06:20:48') datenum('06:20:50') 700 
datenum('06:20:53') datenum('06:20:57') 700 
datenum('06:21:01') datenum('06:21:01') 700 
datenum('06:21:04') datenum('06:21:04') 700 
datenum('07:23:05') datenum('07:24:51') 700 
datenum('08:28:01') datenum('08:32:49') 700 
datenum('06:20:35') datenum('06:20:35') 10 
datenum('06:20:39') datenum('06:20:41') 10 
datenum('06:20:44') datenum('06:20:45') 10 
datenum('06:20:48') datenum('06:20:50') 10 
datenum('06:20:53') datenum('06:20:57') 10 
datenum('06:21:01') datenum('06:21:01') 10 
datenum('06:21:04') datenum('06:21:04') 10 
datenum('07:23:05') datenum('07:24:51') 10 
datenum('08:27:47') datenum('08:32:49') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return