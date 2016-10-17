function marks = starflags_20160902_O3_MS_marks_NOT_GOOD_AEROSOL_20161017_1354  
 % starflags file for 20160902 created by MS on 20161017_1354 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1354'); 
 daystr = '20160902';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('05:10:06') datenum('16:17:56') 03 
datenum('05:10:06') datenum('06:33:17') 700 
datenum('07:22:07') datenum('07:22:11') 700 
datenum('07:40:27') datenum('07:40:31') 700 
datenum('07:59:44') datenum('07:59:48') 700 
datenum('08:10:27') datenum('08:12:04') 700 
datenum('08:35:10') datenum('08:35:14') 700 
datenum('08:55:58') datenum('08:56:03') 700 
datenum('09:16:40') datenum('09:16:44') 700 
datenum('09:27:06') datenum('09:27:42') 700 
datenum('09:29:54') datenum('09:30:00') 700 
datenum('09:42:33') datenum('09:42:37') 700 
datenum('09:56:00') datenum('09:57:33') 700 
datenum('10:15:49') datenum('10:15:53') 700 
datenum('10:34:59') datenum('10:36:28') 700 
datenum('10:36:30') datenum('10:36:56') 700 
datenum('10:38:37') datenum('10:38:41') 700 
datenum('10:41:14') datenum('10:41:18') 700 
datenum('10:54:06') datenum('10:54:12') 700 
datenum('10:56:57') datenum('10:57:01') 700 
datenum('11:03:46') datenum('11:03:57') 700 
datenum('11:04:56') datenum('11:04:56') 700 
datenum('11:05:42') datenum('11:05:43') 700 
datenum('11:05:47') datenum('11:05:51') 700 
datenum('11:05:54') datenum('11:06:09') 700 
datenum('11:56:30') datenum('11:56:34') 700 
datenum('12:01:13') datenum('12:03:43') 700 
datenum('12:13:13') datenum('12:13:20') 700 
datenum('12:17:45') datenum('12:17:50') 700 
datenum('12:21:58') datenum('12:22:03') 700 
datenum('12:22:30') datenum('12:22:31') 700 
datenum('12:51:59') datenum('12:51:59') 700 
datenum('12:59:16') datenum('12:59:21') 700 
datenum('13:17:36') datenum('13:17:41') 700 
datenum('13:19:43') datenum('13:20:15') 700 
datenum('13:20:18') datenum('13:20:24') 700 
datenum('13:20:28') datenum('13:20:34') 700 
datenum('13:20:37') datenum('13:20:40') 700 
datenum('13:38:22') datenum('13:38:27') 700 
datenum('13:56:43') datenum('13:56:47') 700 
datenum('14:15:03') datenum('14:15:07') 700 
datenum('14:33:23') datenum('14:33:27') 700 
datenum('14:52:42') datenum('14:52:47') 700 
datenum('14:59:24') datenum('14:59:28') 700 
datenum('14:59:45') datenum('16:17:56') 700 
datenum('09:29:24') datenum('09:30:29') 10 
datenum('12:12:20') datenum('12:36:42') 10 
datenum('14:58:47') datenum('14:59:34') 10 
datenum('14:59:50') datenum('14:59:56') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return