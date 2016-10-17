function marks = starflags_20160902_O3_MS_marks_CLOUD_EVENTS_20161017_1354  
 % starflags file for 20160902 created by MS on 20161017_1354 to mark CLOUD_EVENTS conditions 
 version_set('20161017_1354'); 
 daystr = '20160902';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:29:24') datenum('09:30:29') 03 
datenum('12:12:20') datenum('12:36:42') 03 
datenum('14:58:47') datenum('14:59:34') 03 
datenum('14:59:50') datenum('14:59:56') 03 
datenum('09:29:54') datenum('09:30:00') 700 
datenum('12:13:13') datenum('12:13:20') 700 
datenum('12:17:45') datenum('12:17:50') 700 
datenum('12:21:58') datenum('12:22:03') 700 
datenum('12:22:30') datenum('12:22:31') 700 
datenum('14:59:24') datenum('14:59:28') 700 
datenum('14:59:50') datenum('14:59:56') 700 
datenum('09:29:24') datenum('09:30:29') 10 
datenum('12:12:20') datenum('12:36:42') 10 
datenum('14:58:47') datenum('14:59:34') 10 
datenum('14:59:50') datenum('14:59:56') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return