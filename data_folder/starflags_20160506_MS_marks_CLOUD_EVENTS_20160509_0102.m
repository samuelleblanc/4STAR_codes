function marks = starflags_20160506_MS_marks_CLOUD_EVENTS_20160509_0102  
 % starflags file for 20160506 created by MS on 20160509_0102 to mark CLOUD_EVENTS conditions 
 version_set('20160509_0102'); 
 daystr = '20160506';  
 % tag = 90: cirrus 
 marks=[ 
 datenum('00:32:19') datenum('00:33:21') 90 
datenum('00:33:37') datenum('00:33:37') 90 
datenum('00:33:40') datenum('00:33:56') 90 
datenum('00:33:58') datenum('00:33:58') 90 
datenum('00:34:02') datenum('00:34:03') 90 
datenum('00:34:06') datenum('00:34:30') 90 
datenum('01:06:36') datenum('01:06:36') 90 
datenum('01:07:06') datenum('01:07:06') 90 
datenum('01:20:14') datenum('01:20:16') 90 
datenum('01:48:00') datenum('02:13:53') 90 
datenum('02:14:00') datenum('02:32:13') 90 
datenum('02:32:20') datenum('02:50:41') 90 
datenum('02:50:48') datenum('03:00:49') 90 
datenum('03:09:30') datenum('03:27:28') 90 
datenum('03:27:35') datenum('03:45:48') 90 
datenum('03:45:55') datenum('04:04:09') 90 
datenum('04:04:15') datenum('04:32:10') 90 
datenum('04:32:17') datenum('04:50:30') 90 
datenum('04:50:37') datenum('05:08:50') 90 
datenum('05:08:57') datenum('05:27:10') 90 
datenum('05:27:17') datenum('05:45:31') 90 
datenum('05:45:37') datenum('06:03:55') 90 
datenum('06:04:02') datenum('06:22:17') 90 
datenum('06:22:24') datenum('06:40:37') 90 
datenum('06:40:44') datenum('06:59:11') 90 
datenum('06:59:18') datenum('07:07:24') 90 
datenum('07:07:31') datenum('07:09:48') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return