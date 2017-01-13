function marks = starflags_20160511_NO2_MS_marks_CLOUD_EVENTS_20170111_1346  
 % starflags file for 20160511 created by MS on 20170111_1346 to mark CLOUD_EVENTS conditions 
 version_set('20170111_1346'); 
 daystr = '20160511';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:36:14') datenum('23:37:14') 03 
datenum('24:19:33') datenum('24:26:54') 03 
datenum('24:31:28') datenum('24:33:56') 03 
datenum('25:26:06') datenum('25:36:46') 03 
datenum('25:37:17') datenum('26:56:47') 03 
datenum('28:23:49') datenum('28:26:25') 03 
datenum('28:27:30') datenum('28:30:49') 03 
datenum('23:36:48') datenum('23:36:52') 700 
datenum('24:19:48') datenum('24:19:49') 700 
datenum('24:19:55') datenum('24:20:50') 700 
datenum('24:20:56') datenum('24:20:57') 700 
datenum('24:20:59') datenum('24:21:04') 700 
datenum('24:21:15') datenum('24:21:15') 700 
datenum('24:31:49') datenum('24:31:53') 700 
datenum('24:32:16') datenum('24:33:06') 700 
datenum('24:33:11') datenum('24:33:12') 700 
datenum('25:27:47') datenum('25:27:51') 700 
datenum('25:31:58') datenum('25:32:13') 700 
datenum('25:35:47') datenum('25:35:55') 700 
datenum('25:36:31') datenum('25:36:41') 700 
datenum('25:36:43') datenum('25:36:46') 700 
datenum('25:37:17') datenum('25:37:17') 700 
datenum('25:46:07') datenum('25:46:11') 700 
datenum('25:49:55') datenum('25:50:56') 700 
datenum('26:04:27') datenum('26:04:32') 700 
datenum('26:22:48') datenum('26:22:52') 700 
datenum('26:27:57') datenum('26:27:57') 700 
datenum('26:33:07') datenum('26:33:07') 700 
datenum('26:34:27') datenum('26:34:45') 700 
datenum('26:35:34') datenum('26:35:56') 700 
datenum('26:36:00') datenum('26:38:34') 700 
datenum('26:39:43') datenum('26:39:51') 700 
datenum('26:41:57') datenum('26:41:59') 700 
datenum('26:43:39') datenum('26:43:45') 700 
datenum('26:44:00') datenum('26:44:00') 700 
datenum('26:47:32') datenum('26:47:33') 700 
datenum('26:49:19') datenum('26:49:30') 700 
datenum('26:51:05') datenum('26:51:06') 700 
datenum('26:51:22') datenum('26:51:22') 700 
datenum('26:51:56') datenum('26:51:59') 700 
datenum('26:53:54') datenum('26:54:01') 700 
datenum('26:55:52') datenum('26:55:58') 700 
datenum('28:24:43') datenum('28:25:39') 700 
datenum('28:26:24') datenum('28:26:25') 700 
datenum('28:27:30') datenum('28:27:32') 700 
datenum('28:27:36') datenum('28:27:39') 700 
datenum('28:27:46') datenum('28:27:49') 700 
datenum('28:29:41') datenum('28:29:43') 700 
datenum('23:36:14') datenum('23:37:14') 10 
datenum('24:19:33') datenum('24:26:54') 10 
datenum('24:31:28') datenum('24:33:56') 10 
datenum('25:26:06') datenum('25:36:46') 10 
datenum('25:37:17') datenum('26:56:47') 10 
datenum('28:23:49') datenum('28:26:25') 10 
datenum('28:27:30') datenum('28:30:49') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return