function marks = starflags_20170904_CWV_MS_marks_NOT_GOOD_AEROSOL_20170907_1101  
 % starflags file for 20170904 created by MS on 20170907_1101 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1101'); 
 daystr = '20170904';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:47:22') datenum('10:17:53') 700 
datenum('10:17:59') datenum('10:48:30') 700 
datenum('14:55:11') datenum('14:55:11') 700 
datenum('14:55:16') datenum('14:55:21') 700 
datenum('14:55:26') datenum('14:55:27') 700 
datenum('14:55:34') datenum('14:55:34') 700 
datenum('14:55:39') datenum('14:55:39') 700 
datenum('14:55:43') datenum('14:55:43') 700 
datenum('14:55:45') datenum('14:55:49') 700 
datenum('14:55:51') datenum('14:55:51') 700 
datenum('14:55:56') datenum('14:56:06') 700 
datenum('14:56:08') datenum('14:56:12') 700 
datenum('14:56:16') datenum('14:56:18') 700 
datenum('14:56:20') datenum('14:56:39') 700 
datenum('14:56:41') datenum('14:56:43') 700 
datenum('14:56:45') datenum('14:56:45') 700 
datenum('14:56:47') datenum('14:56:47') 700 
datenum('14:56:50') datenum('14:56:50') 700 
datenum('14:56:57') datenum('14:56:57') 700 
datenum('14:57:01') datenum('14:57:01') 700 
datenum('14:57:04') datenum('14:57:04') 700 
datenum('14:57:38') datenum('14:57:38') 700 
datenum('14:57:40') datenum('14:57:40') 700 
datenum('14:57:46') datenum('14:57:46') 700 
datenum('14:58:02') datenum('14:58:03') 700 
datenum('14:58:10') datenum('14:58:10') 700 
datenum('14:58:40') datenum('14:58:40') 700 
datenum('14:58:47') datenum('14:58:48') 700 
datenum('14:59:04') datenum('14:59:04') 700 
datenum('14:59:06') datenum('14:59:06') 700 
datenum('14:59:08') datenum('14:59:09') 700 
datenum('14:59:12') datenum('14:59:13') 700 
datenum('14:59:15') datenum('14:59:23') 700 
datenum('14:59:25') datenum('14:59:29') 700 
datenum('14:59:31') datenum('14:59:48') 700 
datenum('14:59:50') datenum('14:59:51') 700 
datenum('14:59:54') datenum('15:00:13') 700 
datenum('15:00:15') datenum('15:00:22') 700 
datenum('15:00:24') datenum('15:00:26') 700 
datenum('15:00:29') datenum('15:00:29') 700 
datenum('15:00:31') datenum('15:00:32') 700 
datenum('15:00:34') datenum('15:00:34') 700 
datenum('15:00:36') datenum('15:00:43') 700 
datenum('15:00:45') datenum('15:05:46') 700 
datenum('15:05:53') datenum('15:39:40') 700 
datenum('11:04:05') datenum('11:04:05') 10 
datenum('11:07:16') datenum('11:07:25') 10 
datenum('11:07:32') datenum('11:09:38') 10 
datenum('11:09:48') datenum('11:10:00') 10 
datenum('11:10:11') datenum('11:10:16') 10 
datenum('11:32:14') datenum('11:33:02') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return