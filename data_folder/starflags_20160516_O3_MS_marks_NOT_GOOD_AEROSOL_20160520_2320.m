function marks = starflags_20160516_O3_MS_marks_NOT_GOOD_AEROSOL_20160520_2320  
 % starflags file for 20160516 created by MS on 20160520_2320 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160520_2320'); 
 daystr = '20160516';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:20:47') datenum('01:21:16') 700 
datenum('01:22:09') datenum('01:23:10') 700 
datenum('01:23:13') datenum('01:23:14') 700 
datenum('01:23:39') datenum('01:23:58') 700 
datenum('03:02:35') datenum('03:03:35') 700 
datenum('03:12:01') datenum('03:12:26') 700 
datenum('04:01:02') datenum('04:01:39') 700 
datenum('04:01:42') datenum('04:01:53') 700 
datenum('04:01:57') datenum('04:01:59') 700 
datenum('04:02:01') datenum('04:02:07') 700 
datenum('04:05:53') datenum('04:05:53') 700 
datenum('04:05:55') datenum('04:06:56') 700 
datenum('04:23:19') datenum('04:24:19') 700 
datenum('04:57:47') datenum('04:58:16') 700 
datenum('05:02:22') datenum('05:02:23') 700 
datenum('05:02:25') datenum('05:04:05') 700 
datenum('06:30:27') datenum('06:31:21') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return