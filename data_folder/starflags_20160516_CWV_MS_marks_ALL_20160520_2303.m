function marks = starflags_20160516_CWV_MS_marks_ALL_20160520_2303  
 % starflags file for 20160516 created by MS on 20160520_2303 to mark ALL conditions 
 version_set('20160520_2303'); 
 daystr = '20160516';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:49:03') datenum('00:49:04') 700 
datenum('00:49:07') datenum('00:49:07') 700 
datenum('01:17:41') datenum('01:17:41') 700 
datenum('01:20:47') datenum('01:20:51') 700 
datenum('01:22:36') datenum('01:22:46') 700 
datenum('01:50:39') datenum('01:50:43') 700 
datenum('01:51:45') datenum('01:51:47') 700 
datenum('01:53:53') datenum('01:53:53') 700 
datenum('03:01:06') datenum('03:01:06') 700 
datenum('03:01:26') datenum('03:01:28') 700 
datenum('03:03:02') datenum('03:03:09') 700 
datenum('03:03:18') datenum('03:03:24') 700 
datenum('03:04:08') datenum('03:04:09') 700 
datenum('03:12:01') datenum('03:12:09') 700 
datenum('03:18:16') datenum('03:18:23') 700 
datenum('03:25:40') datenum('03:25:48') 700 
datenum('03:27:16') datenum('03:27:17') 700 
datenum('04:01:02') datenum('04:01:39') 700 
datenum('04:06:22') datenum('04:06:27') 700 
datenum('04:23:46') datenum('04:23:53') 700 
datenum('04:57:47') datenum('04:57:47') 700 
datenum('05:02:49') datenum('05:02:55') 700 
datenum('05:03:54') datenum('05:03:54') 700 
datenum('06:30:53') datenum('06:30:53') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return