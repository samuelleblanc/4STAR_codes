function marks = starflags_20160601_NO2_MS_marks_CLOUD_EVENTS_20170109_1200  
 % starflags file for 20160601 created by MS on 20170109_1200 to mark CLOUD_EVENTS conditions 
 version_set('20170109_1200'); 
 daystr = '20160601';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:24:00') datenum('02:28:19') 700 
datenum('02:30:06') datenum('02:31:12') 700 
datenum('02:31:15') datenum('02:33:57') 700 
datenum('03:53:57') datenum('03:55:36') 700 
datenum('03:55:42') datenum('03:57:44') 700 
datenum('04:09:24') datenum('04:09:24') 700 
datenum('04:09:39') datenum('04:10:40') 700 
datenum('02:24:00') datenum('02:28:20') 10 
datenum('02:30:06') datenum('02:34:01') 10 
datenum('03:53:48') datenum('03:55:36') 10 
datenum('03:55:42') datenum('03:57:50') 10 
datenum('04:09:24') datenum('04:09:24') 10 
datenum('04:09:34') datenum('04:09:36') 10 
datenum('04:09:39') datenum('04:10:40') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return