function marks = starflags_20160827_NO2_MS_marks_NOT_GOOD_AEROSOL_20161017_2232  
 % starflags file for 20160827 created by MS on 20161017_2232 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_2232'); 
 daystr = '20160827';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:59:48') datenum('14:30:32') 03 
datenum('07:59:48') datenum('08:01:07') 700 
datenum('08:01:09') datenum('08:01:17') 700 
datenum('08:01:19') datenum('08:01:26') 700 
datenum('08:01:29') datenum('08:01:37') 700 
datenum('08:01:40') datenum('08:01:44') 700 
datenum('08:01:50') datenum('08:01:56') 700 
datenum('08:01:58') datenum('08:02:02') 700 
datenum('08:02:05') datenum('08:02:05') 700 
datenum('08:02:07') datenum('08:02:08') 700 
datenum('08:02:12') datenum('08:02:12') 700 
datenum('08:02:14') datenum('08:02:15') 700 
datenum('08:02:17') datenum('08:02:18') 700 
datenum('08:02:20') datenum('08:02:20') 700 
datenum('08:02:25') datenum('08:02:25') 700 
datenum('08:02:29') datenum('08:02:29') 700 
datenum('08:02:32') datenum('08:02:36') 700 
datenum('08:02:38') datenum('08:02:38') 700 
datenum('08:02:41') datenum('08:02:41') 700 
datenum('08:02:43') datenum('08:02:43') 700 
datenum('08:02:49') datenum('08:02:49') 700 
datenum('08:02:51') datenum('08:02:53') 700 
datenum('08:02:56') datenum('08:02:56') 700 
datenum('08:02:59') datenum('08:03:00') 700 
datenum('08:03:02') datenum('08:03:02') 700 
datenum('08:03:05') datenum('08:03:05') 700 
datenum('08:03:08') datenum('08:03:08') 700 
datenum('08:03:33') datenum('08:03:33') 700 
datenum('08:04:11') datenum('08:04:11') 700 
datenum('08:19:13') datenum('08:19:18') 700 
datenum('08:37:33') datenum('08:37:38') 700 
datenum('08:55:53') datenum('08:55:58') 700 
datenum('09:14:14') datenum('09:14:18') 700 
datenum('09:32:34') datenum('09:32:39') 700 
datenum('09:50:54') datenum('09:50:59') 700 
datenum('09:59:30') datenum('09:59:33') 700 
datenum('11:07:51') datenum('11:07:55') 700 
datenum('11:26:11') datenum('11:26:15') 700 
datenum('11:44:31') datenum('11:44:35') 700 
datenum('12:02:51') datenum('12:02:55') 700 
datenum('12:21:11') datenum('12:21:16') 700 
datenum('12:39:31') datenum('12:39:36') 700 
datenum('12:57:51') datenum('12:57:56') 700 
datenum('13:16:11') datenum('13:16:16') 700 
datenum('13:34:32') datenum('13:34:36') 700 
datenum('13:52:52') datenum('13:52:56') 700 
datenum('14:11:12') datenum('14:11:16') 700 
datenum('14:29:32') datenum('14:29:36') 700 
datenum('14:29:48') datenum('14:29:54') 700 
datenum('14:29:56') datenum('14:29:58') 700 
datenum('14:30:00') datenum('14:30:01') 700 
datenum('14:30:32') datenum('14:30:32') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return