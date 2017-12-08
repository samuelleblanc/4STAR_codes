function marks = starflags_20170902_CWV_MS_marks_NOT_GOOD_AEROSOL_20170907_1010  
 % starflags file for 20170902 created by MS on 20170907_1010 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1010'); 
 daystr = '20170902';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:09:19') datenum('09:19:03') 700 
datenum('10:51:49') datenum('10:51:49') 700 
datenum('10:53:26') datenum('10:53:30') 700 
datenum('10:57:50') datenum('10:57:52') 700 
datenum('10:59:06') datenum('10:59:07') 700 
datenum('11:16:26') datenum('11:52:35') 700 
datenum('12:34:20') datenum('12:34:21') 700 
datenum('12:34:24') datenum('12:35:17') 700 
datenum('12:36:23') datenum('12:36:23') 700 
datenum('12:41:19') datenum('12:41:19') 700 
datenum('12:41:22') datenum('12:41:22') 700 
datenum('12:42:02') datenum('12:42:03') 700 
datenum('12:42:54') datenum('12:42:58') 700 
datenum('12:44:00') datenum('12:44:00') 700 
datenum('12:48:18') datenum('12:48:22') 700 
datenum('12:48:26') datenum('12:48:27') 700 
datenum('12:49:05') datenum('12:49:06') 700 
datenum('12:49:17') datenum('12:49:17') 700 
datenum('12:49:51') datenum('12:50:00') 700 
datenum('12:50:11') datenum('12:50:12') 700 
datenum('12:50:25') datenum('12:50:25') 700 
datenum('12:50:33') datenum('12:50:33') 700 
datenum('12:50:48') datenum('12:50:49') 700 
datenum('12:51:32') datenum('12:51:33') 700 
datenum('12:51:35') datenum('12:51:36') 700 
datenum('12:51:54') datenum('12:51:54') 700 
datenum('13:04:32') datenum('13:04:34') 700 
datenum('13:06:30') datenum('13:06:32') 700 
datenum('13:11:07') datenum('13:11:11') 700 
datenum('13:11:16') datenum('13:11:17') 700 
datenum('13:12:55') datenum('13:13:03') 700 
datenum('13:14:49') datenum('13:14:50') 700 
datenum('13:15:42') datenum('13:15:42') 700 
datenum('13:18:45') datenum('13:18:45') 700 
datenum('13:18:52') datenum('13:18:53') 700 
datenum('15:50:50') datenum('15:57:24') 700 
datenum('16:29:40') datenum('16:38:17') 700 
datenum('17:27:37') datenum('17:34:32') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return