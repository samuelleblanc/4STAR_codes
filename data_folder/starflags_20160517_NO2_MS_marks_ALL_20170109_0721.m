function marks = starflags_20160517_NO2_MS_marks_ALL_20170109_0721  
 % starflags file for 20160517 created by MS on 20170109_0721 to mark ALL conditions 
 version_set('20170109_0721'); 
 daystr = '20160517';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:52:00') datenum('00:55:00') 700 
datenum('01:15:57') datenum('01:19:45') 700 
datenum('01:49:20') datenum('01:49:27') 700 
datenum('01:50:18') datenum('01:50:27') 700 
datenum('01:50:49') datenum('01:50:53') 700 
datenum('01:51:51') datenum('01:51:53') 700 
datenum('02:02:00') datenum('02:03:01') 700 
datenum('02:03:25') datenum('02:03:53') 700 
datenum('02:05:37') datenum('02:06:36') 700 
datenum('02:11:30') datenum('02:14:43') 700 
datenum('03:19:59') datenum('03:21:38') 700 
datenum('03:43:33') datenum('03:54:21') 700 
datenum('04:00:08') datenum('04:12:41') 700 
datenum('04:46:09') datenum('05:26:10') 700 
datenum('07:00:56') datenum('07:02:36') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return