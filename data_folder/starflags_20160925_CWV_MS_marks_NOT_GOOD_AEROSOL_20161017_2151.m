function marks = starflags_20160925_CWV_MS_marks_NOT_GOOD_AEROSOL_20161017_2151  
 % starflags file for 20160925 created by MS on 20161017_2151 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_2151'); 
 daystr = '20160925';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:59:27') datenum('16:26:16') 03 
datenum('07:59:27') datenum('07:59:56') 700 
datenum('08:00:09') datenum('08:01:53') 700 
datenum('08:05:19') datenum('08:05:19') 700 
datenum('08:05:34') datenum('08:05:34') 700 
datenum('08:05:40') datenum('08:05:40') 700 
datenum('08:11:43') datenum('08:11:47') 700 
datenum('08:11:52') datenum('08:11:52') 700 
datenum('08:19:27') datenum('08:19:31') 700 
datenum('08:37:58') datenum('08:38:02') 700 
datenum('08:56:33') datenum('08:56:37') 700 
datenum('09:18:54') datenum('09:18:58') 700 
datenum('09:37:27') datenum('09:37:31') 700 
datenum('09:58:11') datenum('09:58:15') 700 
datenum('10:16:49') datenum('10:16:53') 700 
datenum('10:38:31') datenum('10:38:43') 700 
datenum('10:57:23') datenum('10:57:27') 700 
datenum('10:58:45') datenum('11:29:47') 700 
datenum('11:30:22') datenum('11:41:38') 700 
datenum('12:03:52') datenum('12:03:57') 700 
datenum('12:16:06') datenum('12:16:09') 700 
datenum('12:17:02') datenum('12:19:08') 700 
datenum('12:26:59') datenum('12:27:12') 700 
datenum('12:51:12') datenum('12:51:21') 700 
datenum('13:16:40') datenum('13:16:53') 700 
datenum('13:30:59') datenum('13:52:51') 700 
datenum('14:14:34') datenum('14:14:46') 700 
datenum('14:33:12') datenum('14:33:17') 700 
datenum('14:41:35') datenum('14:41:48') 700 
datenum('15:01:39') datenum('15:01:44') 700 
datenum('15:23:30') datenum('15:23:35') 700 
datenum('15:33:41') datenum('15:33:57') 700 
datenum('15:57:31') datenum('15:57:35') 700 
datenum('16:14:09') datenum('16:14:10') 700 
datenum('16:15:58') datenum('16:16:02') 700 
datenum('16:21:41') datenum('16:21:42') 700 
datenum('16:22:19') datenum('16:22:19') 700 
datenum('16:25:06') datenum('16:25:17') 700 
datenum('16:25:56') datenum('16:26:01') 700 
datenum('16:26:09') datenum('16:26:16') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return