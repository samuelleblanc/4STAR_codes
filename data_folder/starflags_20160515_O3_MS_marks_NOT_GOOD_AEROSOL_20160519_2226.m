function marks = starflags_20160515_O3_MS_marks_NOT_GOOD_AEROSOL_20160519_2226  
 % starflags file for 20160515 created by MS on 20160519_2226 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160519_2226'); 
 daystr = '20160515';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:22:56') datenum('01:25:27') 700 
datenum('03:09:05') datenum('03:12:10') 700 
datenum('03:35:16') datenum('03:37:31') 700 
datenum('03:54:04') datenum('03:54:04') 700 
datenum('03:54:21') datenum('03:54:23') 700 
datenum('03:54:29') datenum('03:54:29') 700 
datenum('03:56:17') datenum('03:57:17') 700 
datenum('03:57:34') datenum('03:57:44') 700 
datenum('03:57:58') datenum('03:58:02') 700 
datenum('03:58:06') datenum('03:58:15') 700 
datenum('03:58:22') datenum('03:58:22') 700 
datenum('03:58:26') datenum('03:58:26') 700 
datenum('03:58:37') datenum('03:58:42') 700 
datenum('03:58:47') datenum('03:58:53') 700 
datenum('03:59:16') datenum('03:59:53') 700 
datenum('04:00:03') datenum('04:00:03') 700 
datenum('04:00:05') datenum('04:00:05') 700 
datenum('04:00:09') datenum('04:00:50') 700 
datenum('04:02:00') datenum('04:02:01') 700 
datenum('04:03:01') datenum('04:03:01') 700 
datenum('04:03:57') datenum('04:04:56') 700 
datenum('04:08:02') datenum('04:08:50') 700 
datenum('04:08:55') datenum('04:08:55') 700 
datenum('04:08:59') datenum('04:09:41') 700 
datenum('04:09:45') datenum('04:09:45') 700 
datenum('04:10:12') datenum('04:10:32') 700 
datenum('04:17:11') datenum('04:17:12') 700 
datenum('04:17:27') datenum('04:18:27') 700 
datenum('04:18:45') datenum('04:18:46') 700 
datenum('04:18:54') datenum('04:20:14') 700 
datenum('04:22:37') datenum('04:58:22') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return