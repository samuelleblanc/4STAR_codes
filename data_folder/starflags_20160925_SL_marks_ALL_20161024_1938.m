function marks = starflags_20160925_SL_marks_ALL_20161024_1938  
 % starflags file for 20160925 created by SL on 20161024_1938 to mark ALL conditions 
 version_set('20161024_1938'); 
 daystr = '20160925';  
 % tag = 2: before_or_after_flight 
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('07:59:27') datenum('07:59:37') 02 
datenum('08:19:27') datenum('08:19:31') 02 
datenum('08:37:58') datenum('08:38:02') 02 
datenum('08:56:33') datenum('08:56:37') 02 
datenum('09:18:54') datenum('09:18:58') 02 
datenum('09:37:27') datenum('09:37:31') 02 
datenum('09:58:11') datenum('09:58:15') 02 
datenum('10:16:49') datenum('10:16:53') 02 
datenum('10:38:31') datenum('10:38:43') 02 
datenum('10:57:23') datenum('10:57:27') 02 
datenum('11:29:34') datenum('11:29:47') 02 
datenum('11:37:09') datenum('11:41:38') 02 
datenum('12:03:52') datenum('12:03:57') 02 
datenum('12:26:59') datenum('12:27:12') 02 
datenum('12:51:12') datenum('12:51:21') 02 
datenum('13:16:40') datenum('13:16:53') 02 
datenum('13:52:38') datenum('13:52:51') 02 
datenum('14:14:34') datenum('14:14:46') 02 
datenum('14:33:12') datenum('14:33:17') 02 
datenum('14:41:35') datenum('14:41:48') 02 
datenum('15:01:39') datenum('15:01:44') 02 
datenum('15:23:30') datenum('15:23:35') 02 
datenum('15:33:41') datenum('15:33:56') 02 
datenum('15:57:31') datenum('15:57:35') 02 
datenum('16:15:58') datenum('16:16:02') 02 
datenum('16:25:06') datenum('16:25:16') 02 
datenum('16:26:11') datenum('16:26:15') 02 
datenum('07:59:39') datenum('08:01:55') 10 
datenum('08:02:28') datenum('08:02:43') 10 
datenum('08:04:57') datenum('08:06:41') 10 
datenum('08:09:54') datenum('08:12:18') 10 
datenum('10:58:45') datenum('11:00:09') 10 
datenum('11:30:22') datenum('11:37:07') 10 
datenum('12:16:04') datenum('12:16:09') 10 
datenum('12:17:01') datenum('12:19:09') 10 
datenum('13:30:59') datenum('13:32:18') 10 
datenum('15:33:57') datenum('15:33:57') 10 
datenum('16:14:08') datenum('16:14:11') 10 
datenum('16:21:40') datenum('16:21:42') 10 
datenum('16:22:18') datenum('16:22:29') 10 
datenum('16:25:17') datenum('16:25:17') 10 
datenum('16:26:01') datenum('16:26:01') 10 
datenum('16:26:09') datenum('16:26:09') 10 
datenum('16:26:16') datenum('16:26:16') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return