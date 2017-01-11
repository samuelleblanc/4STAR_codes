function marks = starflags_20160501_CWV_MS_marks_CLOUD_EVENTS_20170111_1246  
 % starflags file for 20160501 created by MS on 20170111_1246 to mark CLOUD_EVENTS conditions 
 version_set('20170111_1246'); 
 daystr = '20160501';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:27:03') datenum('00:27:04') 03 
datenum('00:27:09') datenum('00:27:09') 03 
datenum('00:27:16') datenum('00:27:16') 03 
datenum('00:27:38') datenum('00:27:43') 03 
datenum('00:27:58') datenum('00:27:58') 03 
datenum('00:28:08') datenum('00:28:09') 03 
datenum('00:28:12') datenum('00:28:12') 03 
datenum('00:28:18') datenum('00:28:18') 03 
datenum('00:28:20') datenum('00:28:21') 03 
datenum('00:28:26') datenum('00:28:29') 03 
datenum('00:28:57') datenum('00:28:57') 03 
datenum('00:30:06') datenum('00:30:06') 03 
datenum('00:30:28') datenum('00:30:28') 03 
datenum('00:31:15') datenum('00:31:15') 03 
datenum('00:31:49') datenum('00:31:52') 03 
datenum('00:33:50') datenum('00:33:50') 03 
datenum('02:22:53') datenum('02:22:53') 03 
datenum('02:22:58') datenum('02:23:03') 03 
datenum('05:59:36') datenum('05:59:38') 03 
datenum('05:59:52') datenum('05:59:52') 03 
datenum('06:00:03') datenum('06:00:25') 03 
datenum('06:45:21') datenum('06:45:56') 03 
datenum('06:46:05') datenum('06:46:05') 03 
datenum('00:28:18') datenum('00:28:18') 700 
datenum('00:28:57') datenum('00:28:57') 700 
datenum('00:30:06') datenum('00:30:06') 700 
datenum('00:30:28') datenum('00:30:28') 700 
datenum('00:31:15') datenum('00:31:15') 700 
datenum('00:31:51') datenum('00:31:51') 700 
datenum('00:33:50') datenum('00:33:50') 700 
datenum('02:22:58') datenum('02:22:58') 700 
datenum('02:23:01') datenum('02:23:01') 700 
datenum('05:59:36') datenum('05:59:38') 700 
datenum('05:59:52') datenum('05:59:52') 700 
datenum('06:00:25') datenum('06:00:25') 700 
datenum('06:45:21') datenum('06:45:21') 700 
datenum('06:45:45') datenum('06:45:45') 700 
datenum('06:45:56') datenum('06:45:56') 700 
datenum('00:27:03') datenum('00:27:04') 10 
datenum('00:27:09') datenum('00:27:09') 10 
datenum('00:27:16') datenum('00:27:16') 10 
datenum('00:27:38') datenum('00:27:43') 10 
datenum('00:27:58') datenum('00:27:58') 10 
datenum('00:28:08') datenum('00:28:09') 10 
datenum('00:28:12') datenum('00:28:12') 10 
datenum('00:28:18') datenum('00:28:18') 10 
datenum('00:28:20') datenum('00:28:21') 10 
datenum('00:28:26') datenum('00:28:29') 10 
datenum('00:28:57') datenum('00:28:57') 10 
datenum('00:30:06') datenum('00:30:06') 10 
datenum('00:30:28') datenum('00:30:28') 10 
datenum('00:31:15') datenum('00:31:15') 10 
datenum('00:31:49') datenum('00:31:52') 10 
datenum('00:33:50') datenum('00:33:50') 10 
datenum('02:22:53') datenum('02:22:53') 10 
datenum('02:22:58') datenum('02:23:03') 10 
datenum('05:59:36') datenum('05:59:38') 10 
datenum('05:59:52') datenum('05:59:52') 10 
datenum('06:00:03') datenum('06:00:25') 10 
datenum('06:45:21') datenum('06:45:56') 10 
datenum('06:46:05') datenum('06:46:05') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return