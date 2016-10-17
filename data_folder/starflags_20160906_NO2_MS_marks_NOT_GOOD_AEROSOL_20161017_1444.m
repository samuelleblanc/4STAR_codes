function marks = starflags_20160906_NO2_MS_marks_NOT_GOOD_AEROSOL_20161017_1444  
 % starflags file for 20160906 created by MS on 20161017_1444 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1444'); 
 daystr = '20160906';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('05:59:22') datenum('14:47:53') 03 
datenum('14:47:36') datenum('14:47:53') 02 
datenum('05:59:22') datenum('06:59:13') 700 
datenum('06:59:30') datenum('06:59:30') 700 
datenum('06:59:32') datenum('06:59:32') 700 
datenum('06:59:38') datenum('06:59:38') 700 
datenum('06:59:43') datenum('06:59:43') 700 
datenum('07:04:21') datenum('07:04:26') 700 
datenum('07:22:42') datenum('07:22:46') 700 
datenum('07:49:49') datenum('07:49:53') 700 
datenum('08:19:40') datenum('08:19:40') 700 
datenum('08:22:55') datenum('08:22:59') 700 
datenum('08:23:27') datenum('08:23:32') 700 
datenum('08:23:36') datenum('08:23:38') 700 
datenum('08:23:42') datenum('08:24:41') 700 
datenum('08:46:26') datenum('08:46:32') 700 
datenum('08:46:35') datenum('08:46:40') 700 
datenum('08:46:42') datenum('08:48:20') 700 
datenum('08:56:04') datenum('08:56:41') 700 
datenum('09:13:23') datenum('09:13:28') 700 
datenum('09:36:42') datenum('09:36:47') 700 
datenum('09:36:58') datenum('09:37:00') 700 
datenum('09:37:02') datenum('10:04:03') 700 
datenum('10:11:35') datenum('10:15:23') 700 
datenum('10:16:05') datenum('10:19:38') 700 
datenum('10:20:36') datenum('10:20:39') 700 
datenum('11:00:43') datenum('11:03:22') 700 
datenum('11:07:59') datenum('11:08:01') 700 
datenum('11:42:24') datenum('11:42:29') 700 
datenum('12:03:06') datenum('12:03:11') 700 
datenum('12:21:26') datenum('12:21:31') 700 
datenum('12:34:11') datenum('12:34:15') 700 
datenum('12:34:18') datenum('12:34:19') 700 
datenum('13:07:22') datenum('13:07:26') 700 
datenum('13:15:16') datenum('13:39:38') 700 
datenum('13:52:00') datenum('13:52:04') 700 
datenum('14:10:20') datenum('14:10:24') 700 
datenum('14:30:57') datenum('14:30:57') 700 
datenum('14:32:22') datenum('14:32:22') 700 
datenum('14:33:26') datenum('14:33:30') 700 
datenum('14:35:47') datenum('14:35:47') 700 
datenum('14:37:46') datenum('14:37:46') 700 
datenum('14:38:03') datenum('14:38:03') 700 
datenum('14:38:41') datenum('14:38:41') 700 
datenum('14:39:14') datenum('14:39:14') 700 
datenum('14:39:45') datenum('14:39:45') 700 
datenum('14:40:23') datenum('14:40:23') 700 
datenum('14:40:40') datenum('14:40:46') 700 
datenum('14:41:11') datenum('14:41:11') 700 
datenum('14:43:39') datenum('14:43:40') 700 
datenum('14:44:36') datenum('14:44:36') 700 
datenum('14:44:51') datenum('14:44:51') 700 
datenum('14:46:15') datenum('14:46:15') 700 
datenum('14:47:36') datenum('14:47:53') 700 
datenum('08:23:21') datenum('08:23:21') 10 
datenum('08:23:24') datenum('08:23:26') 10 
datenum('08:23:59') datenum('08:23:59') 10 
datenum('08:46:20') datenum('08:46:24') 10 
datenum('08:47:00') datenum('08:47:00') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return