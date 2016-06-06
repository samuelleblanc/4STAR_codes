function marks = starflags_20160526_CF_marks_OTHER_FLAGGED_EVENTS_20160601_2233  
 % starflags file for 20160526 created by CF on 20160601_2233 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160601_2233'); 
 daystr = '20160526';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('02:33:13') datenum('02:33:42') 02 
datenum('02:33:44') datenum('02:34:02') 02 
datenum('02:34:05') datenum('02:34:23') 02 
datenum('02:34:25') datenum('02:34:59') 02 
datenum('02:35:01') datenum('02:35:01') 02 
datenum('02:35:04') datenum('02:35:23') 02 
datenum('02:35:25') datenum('02:35:36') 02 
datenum('02:35:38') datenum('02:35:55') 02 
datenum('02:35:58') datenum('02:37:12') 02 
datenum('02:37:14') datenum('02:37:18') 02 
datenum('02:37:20') datenum('02:39:36') 02 
datenum('02:39:39') datenum('02:40:00') 02 
datenum('02:40:03') datenum('02:40:27') 02 
datenum('02:40:29') datenum('02:40:58') 02 
datenum('02:41:00') datenum('02:41:03') 02 
datenum('02:41:05') datenum('02:42:03') 02 
datenum('02:42:05') datenum('02:42:11') 02 
datenum('02:42:14') datenum('02:43:03') 02 
datenum('02:43:05') datenum('02:43:32') 02 
datenum('02:43:34') datenum('02:43:53') 02 
datenum('02:43:56') datenum('02:44:05') 02 
datenum('02:44:08') datenum('02:44:32') 02 
datenum('02:44:34') datenum('02:45:21') 02 
datenum('02:45:23') datenum('02:45:27') 02 
datenum('02:45:29') datenum('02:45:35') 02 
datenum('02:45:38') datenum('02:46:03') 02 
datenum('02:46:05') datenum('02:46:09') 02 
datenum('02:46:11') datenum('02:46:11') 02 
datenum('02:46:15') datenum('02:46:22') 02 
datenum('02:46:24') datenum('02:46:30') 02 
datenum('02:46:34') datenum('02:46:39') 02 
datenum('02:46:41') datenum('02:46:53') 02 
datenum('02:46:56') datenum('02:47:06') 02 
datenum('02:47:09') datenum('02:47:11') 02 
datenum('02:47:14') datenum('02:47:29') 02 
datenum('02:47:32') datenum('02:47:52') 02 
datenum('02:47:54') datenum('02:50:41') 02 
datenum('02:50:44') datenum('02:54:49') 02 
datenum('02:55:00') datenum('02:55:33') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return