function marks = starflags_20160929_CWV_MS_marks_ALL_20161017_2204  
 % starflags file for 20160929 created by MS on 20161017_2204 to mark ALL conditions 
 version_set('20161017_2204'); 
 daystr = '20160929';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:14:18') datenum('18:24:00') 03 
datenum('07:14:18') datenum('09:29:01') 700 
datenum('09:38:14') datenum('09:38:19') 700 
datenum('09:56:36') datenum('09:56:41') 700 
datenum('10:14:58') datenum('10:15:02') 700 
datenum('10:33:21') datenum('10:33:26') 700 
datenum('12:05:20') datenum('12:05:25') 700 
datenum('12:34:02') datenum('12:34:13') 700 
datenum('12:52:34') datenum('12:52:39') 700 
datenum('13:58:58') datenum('13:59:08') 700 
datenum('14:03:58') datenum('14:04:00') 700 
datenum('14:17:25') datenum('14:17:29') 700 
datenum('14:35:54') datenum('14:35:58') 700 
datenum('14:54:21') datenum('14:54:25') 700 
datenum('16:01:29') datenum('16:01:40') 700 
datenum('16:19:57') datenum('16:20:02') 700 
datenum('16:38:22') datenum('16:38:26') 700 
datenum('16:56:44') datenum('16:56:49') 700 
datenum('17:15:08') datenum('17:15:12') 700 
datenum('17:43:03') datenum('17:50:11') 700 
datenum('18:08:27') datenum('18:08:31') 700 
datenum('18:14:59') datenum('18:15:11') 700 
datenum('18:15:26') datenum('18:15:26') 700 
datenum('18:15:36') datenum('18:15:47') 700 
datenum('18:23:06') datenum('18:24:00') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return