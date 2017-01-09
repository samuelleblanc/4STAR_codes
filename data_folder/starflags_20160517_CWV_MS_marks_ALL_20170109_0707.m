function marks = starflags_20160517_CWV_MS_marks_ALL_20170109_0707  
 % starflags file for 20160517 created by MS on 20170109_0707 to mark ALL conditions 
 version_set('20170109_0707'); 
 daystr = '20160517';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:23:27') datenum('07:42:01') 700 
datenum('07:52:31') datenum('07:52:31') 700 
datenum('07:52:50') datenum('07:52:50') 700 
datenum('07:52:56') datenum('07:53:02') 700 
datenum('07:53:08') datenum('07:53:13') 700 
datenum('07:53:16') datenum('07:53:16') 700 
datenum('07:53:18') datenum('07:53:22') 700 
datenum('07:53:24') datenum('07:53:25') 700 
datenum('07:53:28') datenum('07:53:34') 700 
datenum('07:53:36') datenum('07:53:37') 700 
datenum('07:53:40') datenum('07:53:41') 700 
datenum('07:53:46') datenum('07:53:50') 700 
datenum('07:53:54') datenum('07:53:54') 700 
datenum('07:53:56') datenum('07:53:56') 700 
datenum('07:53:59') datenum('07:53:59') 700 
datenum('07:54:01') datenum('07:54:01') 700 
datenum('07:54:04') datenum('07:54:07') 700 
datenum('07:54:11') datenum('07:54:18') 700 
datenum('07:54:23') datenum('07:54:23') 700 
datenum('07:54:26') datenum('07:54:26') 700 
datenum('07:54:30') datenum('07:54:34') 700 
datenum('07:54:36') datenum('07:54:36') 700 
datenum('07:54:38') datenum('07:54:40') 700 
datenum('27:25:30') datenum('27:25:49') 700 
datenum('27:46:32') datenum('27:46:48') 700 
datenum('27:46:51') datenum('27:47:52') 700 
datenum('27:47:56') datenum('27:48:11') 700 
datenum('27:48:14') datenum('27:49:18') 700 
datenum('27:49:22') datenum('27:49:37') 700 
datenum('27:49:44') datenum('27:50:03') 700 
datenum('27:50:16') datenum('27:50:18') 700 
datenum('28:19:10') datenum('28:19:16') 700 
datenum('28:20:38') datenum('28:20:42') 700 
datenum('28:34:39') datenum('28:34:41') 700 
datenum('28:44:35') datenum('28:46:37') 700 
datenum('28:47:48') datenum('28:47:50') 700 
datenum('29:58:58') datenum('29:59:03') 700 
datenum('27:20:45') datenum('27:20:46') 10 
datenum('27:21:01') datenum('27:21:02') 10 
datenum('27:21:20') datenum('27:21:20') 10 
datenum('27:34:47') datenum('27:34:49') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return