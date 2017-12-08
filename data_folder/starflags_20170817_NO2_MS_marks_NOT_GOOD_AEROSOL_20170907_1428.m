function marks = starflags_20170817_NO2_MS_marks_NOT_GOOD_AEROSOL_20170907_1428  
 % starflags file for 20170817 created by MS on 20170907_1428 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1428'); 
 daystr = '20170817';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:58:21') datenum('08:02:12') 700 
datenum('08:42:58') datenum('08:47:03') 700 
datenum('11:29:54') datenum('11:34:25') 700 
datenum('11:37:23') datenum('11:41:19') 700 
datenum('12:36:15') datenum('12:37:21') 700 
datenum('12:44:59') datenum('12:45:52') 700 
datenum('13:11:43') datenum('13:12:49') 700 
datenum('13:15:03') datenum('13:16:34') 700 
datenum('15:30:47') datenum('15:32:03') 700 
datenum('15:51:43') datenum('15:53:04') 700 
datenum('16:10:11') datenum('16:12:38') 700 
datenum('16:15:37') datenum('16:16:58') 700 
datenum('16:18:14') datenum('16:20:25') 700 
datenum('16:40:05') datenum('16:41:58') 700 
datenum('16:43:40') datenum('16:45:12') 700 
datenum('16:54:45') datenum('16:56:26') 700 
datenum('08:38:28') datenum('08:41:52') 10 
datenum('12:37:16') datenum('12:37:21') 10 
datenum('12:42:25') datenum('12:43:12') 10 
datenum('13:11:40') datenum('13:11:42') 10 
datenum('15:55:55') datenum('16:12:32') 10 
datenum('16:12:39') datenum('16:15:35') 10 
datenum('16:15:40') datenum('16:16:57') 10 
datenum('16:16:59') datenum('16:18:13') 10 
datenum('16:18:18') datenum('16:24:38') 10 
datenum('16:47:24') datenum('16:54:44') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return