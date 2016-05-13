function marks = starflags_20160511_CWV_MS_marks_ALL_20160513_0550  
 % starflags file for 20160511 created by MS on 20160513_0550 to mark ALL conditions 
 version_set('20160513_0550'); 
 daystr = '20160511';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:35:48') datenum('01:35:54') 700 
datenum('01:50:51') datenum('01:50:55') 700 
datenum('02:34:28') datenum('02:34:45') 700 
datenum('02:35:39') datenum('02:35:45') 700 
datenum('02:35:48') datenum('02:35:48') 700 
datenum('02:35:51') datenum('02:35:54') 700 
datenum('02:36:01') datenum('02:36:11') 700 
datenum('02:36:14') datenum('02:36:17') 700 
datenum('02:39:43') datenum('02:39:51') 700 
datenum('02:41:58') datenum('02:41:58') 700 
datenum('02:49:22') datenum('02:49:26') 700 
datenum('02:49:30') datenum('02:49:30') 700 
datenum('02:53:54') datenum('02:54:00') 700 
datenum('02:55:53') datenum('02:55:58') 700 
datenum('03:01:14') datenum('03:01:22') 700 
datenum('03:02:49') datenum('03:02:53') 700 
datenum('03:09:14') datenum('03:09:19') 700 
datenum('03:30:10') datenum('03:30:12') 700 
datenum('03:36:34') datenum('03:36:41') 700 
datenum('03:37:03') datenum('03:37:09') 700 
datenum('03:50:15') datenum('03:50:18') 700 
datenum('04:29:41') datenum('04:29:43') 700 
datenum('04:32:08') datenum('04:32:08') 700 
datenum('04:32:11') datenum('04:32:12') 700 
datenum('04:33:28') datenum('04:33:35') 700 
datenum('04:35:00') datenum('04:35:00') 700 
datenum('04:35:52') datenum('04:35:55') 700 
datenum('04:37:12') datenum('04:37:13') 700 
datenum('04:37:17') datenum('04:37:20') 700 
datenum('04:38:37') datenum('04:38:43') 700 
datenum('06:26:15') datenum('06:26:24') 700 
datenum('06:26:57') datenum('06:26:58') 700 
datenum('06:27:56') datenum('06:27:56') 700 
datenum('06:28:00') datenum('06:28:57') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return