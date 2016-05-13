function marks = starflags_20160504_CWV_MS_marks_ALL_20160512_1830  
 % starflags file for 20160504 created by MS on 20160512_1830 to mark ALL conditions 
 version_set('20160512_1830'); 
 daystr = '20160504';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:20:37') datenum('00:21:34') 700 
datenum('00:21:42') datenum('00:21:43') 700 
datenum('00:21:51') datenum('00:21:51') 700 
datenum('00:32:02') datenum('00:34:05') 700 
datenum('01:58:35') datenum('01:59:15') 700 
datenum('01:59:55') datenum('02:00:00') 700 
datenum('02:01:08') datenum('02:01:08') 700 
datenum('02:01:19') datenum('02:01:19') 700 
datenum('02:01:21') datenum('02:01:33') 700 
datenum('02:01:37') datenum('02:03:05') 700 
datenum('02:03:08') datenum('02:03:19') 700 
datenum('02:03:23') datenum('02:03:24') 700 
datenum('02:03:55') datenum('02:03:56') 700 
datenum('02:03:59') datenum('02:04:15') 700 
datenum('02:04:56') datenum('02:05:01') 700 
datenum('02:08:28') datenum('02:08:36') 700 
datenum('02:49:56') datenum('02:50:00') 700 
datenum('02:51:16') datenum('02:51:16') 700 
datenum('02:51:18') datenum('02:51:27') 700 
datenum('02:51:31') datenum('02:51:36') 700 
datenum('02:51:47') datenum('02:51:47') 700 
datenum('03:05:41') datenum('03:05:46') 700 
datenum('03:07:17') datenum('03:07:22') 700 
datenum('03:13:56') datenum('03:14:00') 700 
datenum('03:19:22') datenum('03:19:31') 700 
datenum('03:23:13') datenum('03:23:19') 700 
datenum('03:43:05') datenum('03:44:57') 700 
datenum('03:45:05') datenum('03:50:02') 700 
datenum('03:50:56') datenum('03:58:47') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return