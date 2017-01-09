function marks = starflags_20160512_O3_MS_marks_CLOUD_EVENTS_20170109_0523  
 % starflags file for 20160512 created by MS on 20170109_0523 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0523'); 
 daystr = '20160512';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:38:56') datenum('01:50:50') 03 
datenum('03:20:12') datenum('03:20:29') 03 
datenum('03:21:35') datenum('03:21:44') 03 
datenum('01:39:41') datenum('01:39:45') 700 
datenum('01:49:14') datenum('01:49:14') 700 
datenum('01:50:36') datenum('01:50:50') 700 
datenum('01:38:56') datenum('01:50:50') 10 
datenum('03:20:12') datenum('03:20:29') 10 
datenum('03:21:35') datenum('03:21:44') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return