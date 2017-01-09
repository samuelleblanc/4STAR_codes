function marks = starflags_20160516_O3_MS_marks_CLOUD_EVENTS_20170109_0643  
 % starflags file for 20160516 created by MS on 20170109_0643 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0643'); 
 daystr = '20160516';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('03:00:37') datenum('03:29:15') 03 
datenum('04:01:40') datenum('04:02:08') 03 
datenum('04:05:51') datenum('04:06:57') 03 
datenum('04:23:16') datenum('04:24:22') 03 
datenum('05:02:19') datenum('05:04:05') 03 
datenum('05:32:26') datenum('05:33:31') 03 
datenum('06:30:27') datenum('06:31:23') 03 
datenum('03:01:06') datenum('03:01:06') 700 
datenum('03:01:26') datenum('03:01:28') 700 
datenum('03:03:02') datenum('03:03:09') 700 
datenum('03:03:18') datenum('03:03:24') 700 
datenum('03:04:08') datenum('03:04:09') 700 
datenum('03:05:29') datenum('03:05:33') 700 
datenum('03:12:01') datenum('03:12:09') 700 
datenum('03:18:16') datenum('03:18:23') 700 
datenum('03:20:02') datenum('03:20:05') 700 
datenum('03:25:40') datenum('03:25:48') 700 
datenum('03:27:15') datenum('03:27:17') 700 
datenum('03:28:36') datenum('03:28:40') 700 
datenum('04:01:40') datenum('04:01:40') 700 
datenum('04:06:22') datenum('04:06:27') 700 
datenum('04:23:45') datenum('04:23:53') 700 
datenum('05:02:49') datenum('05:02:55') 700 
datenum('05:03:52') datenum('05:03:54') 700 
datenum('05:32:56') datenum('05:33:00') 700 
datenum('06:30:52') datenum('06:30:53') 700 
datenum('03:00:37') datenum('03:29:15') 10 
datenum('04:01:40') datenum('04:02:08') 10 
datenum('04:05:51') datenum('04:06:57') 10 
datenum('04:23:16') datenum('04:24:22') 10 
datenum('05:02:19') datenum('05:04:05') 10 
datenum('05:32:26') datenum('05:33:31') 10 
datenum('06:30:27') datenum('06:31:23') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return