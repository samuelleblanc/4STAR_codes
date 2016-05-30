function marks = starflags_20160519_CWV_MS_marks_ALL_20160530_0045  
 % starflags file for 20160519 created by MS on 20160530_0045 to mark ALL conditions 
 version_set('20160530_0045'); 
 daystr = '20160519';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:45:29') datenum('01:45:31') 700 
datenum('02:48:37') datenum('02:48:49') 700 
datenum('02:51:51') datenum('02:51:53') 700 
datenum('03:00:08') datenum('03:00:11') 700 
datenum('03:00:28') datenum('03:00:28') 700 
datenum('03:06:32') datenum('03:06:34') 700 
datenum('03:15:20') datenum('03:15:20') 700 
datenum('03:22:37') datenum('03:22:38') 700 
datenum('03:32:18') datenum('03:32:19') 700 
datenum('03:32:21') datenum('03:32:22') 700 
datenum('04:32:05') datenum('04:32:07') 700 
datenum('04:32:14') datenum('04:32:19') 700 
datenum('04:32:22') datenum('04:32:23') 700 
datenum('05:14:30') datenum('05:14:30') 700 
datenum('05:21:55') datenum('05:21:55') 700 
datenum('05:47:51') datenum('05:47:51') 700 
datenum('05:47:55') datenum('05:47:55') 700 
datenum('06:39:32') datenum('06:39:37') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return