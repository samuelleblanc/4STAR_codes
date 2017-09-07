function marks = starflags_20170830_CWV_MS_marks_NOT_GOOD_AEROSOL_20170907_1143  
 % starflags file for 20170830 created by MS on 20170907_1143 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1143'); 
 daystr = '20170830';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:46:40') datenum('08:02:32') 700 
datenum('09:15:02') datenum('09:15:13') 700 
datenum('10:42:10') datenum('10:42:14') 700 
datenum('10:48:17') datenum('10:48:20') 700 
datenum('10:50:47') datenum('10:50:50') 700 
datenum('10:52:09') datenum('10:52:11') 700 
datenum('10:56:56') datenum('10:57:00') 700 
datenum('11:33:15') datenum('11:33:15') 700 
datenum('11:36:14') datenum('11:36:22') 700 
datenum('12:36:42') datenum('12:37:49') 700 
datenum('12:42:38') datenum('12:42:39') 700 
datenum('12:42:47') datenum('12:42:54') 700 
datenum('12:43:09') datenum('12:43:13') 700 
datenum('12:48:33') datenum('12:48:33') 700 
datenum('12:49:59') datenum('12:50:01') 700 
datenum('12:50:42') datenum('12:50:44') 700 
datenum('12:51:56') datenum('13:00:54') 700 
datenum('13:01:05') datenum('13:05:45') 700 
datenum('13:32:22') datenum('13:33:59') 700 
datenum('14:15:20') datenum('14:15:21') 700 
datenum('14:16:43') datenum('14:16:43') 700 
datenum('16:22:05') datenum('16:40:22') 700 
datenum('16:40:34') datenum('16:42:51') 700 
datenum('16:43:25') datenum('16:45:51') 700 
datenum('15:23:02') datenum('15:37:21') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return