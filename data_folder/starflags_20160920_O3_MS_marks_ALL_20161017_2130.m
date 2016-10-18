function marks = starflags_20160920_O3_MS_marks_ALL_20161017_2130  
 % starflags file for 20160920 created by MS on 20161017_2130 to mark ALL conditions 
 version_set('20161017_2130'); 
 daystr = '20160920';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:00:09') datenum('15:00:11') 03 
datenum('07:00:09') datenum('07:00:20') 700 
datenum('07:18:36') datenum('07:18:40') 700 
datenum('07:36:56') datenum('07:37:00') 700 
datenum('07:55:16') datenum('07:55:20') 700 
datenum('08:17:17') datenum('08:17:21') 700 
datenum('08:35:37') datenum('08:35:41') 700 
datenum('08:43:05') datenum('08:55:50') 700 
datenum('09:14:06') datenum('09:14:10') 700 
datenum('09:37:50') datenum('09:37:53') 700 
datenum('09:38:27') datenum('09:40:27') 700 
datenum('10:55:15') datenum('10:55:15') 700 
datenum('11:09:55') datenum('11:09:56') 700 
datenum('11:10:05') datenum('11:10:07') 700 
datenum('11:10:30') datenum('11:10:34') 700 
datenum('11:12:48') datenum('11:12:49') 700 
datenum('11:14:40') datenum('11:14:41') 700 
datenum('11:16:44') datenum('11:16:44') 700 
datenum('11:17:24') datenum('11:17:30') 700 
datenum('11:17:40') datenum('11:17:40') 700 
datenum('11:33:06') datenum('11:33:11') 700 
datenum('11:41:06') datenum('11:41:07') 700 
datenum('11:41:44') datenum('11:54:44') 700 
datenum('11:54:46') datenum('11:54:47') 700 
datenum('11:56:01') datenum('11:56:04') 700 
datenum('11:56:50') datenum('11:56:58') 700 
datenum('11:57:37') datenum('11:57:37') 700 
datenum('11:59:52') datenum('11:59:56') 700 
datenum('12:01:41') datenum('12:01:41') 700 
datenum('12:03:07') datenum('12:03:15') 700 
datenum('12:07:35') datenum('12:07:36') 700 
datenum('12:15:09') datenum('12:15:09') 700 
datenum('12:15:14') datenum('12:15:17') 700 
datenum('12:19:34') datenum('12:19:39') 700 
datenum('12:35:40') datenum('12:36:00') 700 
datenum('12:36:10') datenum('12:36:30') 700 
datenum('12:36:41') datenum('12:36:45') 700 
datenum('12:36:48') datenum('12:37:00') 700 
datenum('12:43:32') datenum('12:43:37') 700 
datenum('12:48:17') datenum('12:48:19') 700 
datenum('12:55:58') datenum('12:57:00') 700 
datenum('12:57:03') datenum('12:57:04') 700 
datenum('12:57:26') datenum('12:59:12') 700 
datenum('13:21:54') datenum('13:21:58') 700 
datenum('13:41:43') datenum('13:41:47') 700 
datenum('14:03:03') datenum('14:03:08') 700 
datenum('14:21:23') datenum('14:21:28') 700 
datenum('14:38:42') datenum('14:39:43') 700 
datenum('14:57:54') datenum('14:57:58') 700 
datenum('14:58:29') datenum('15:00:11') 700 
datenum('12:14:44') datenum('12:15:45') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return