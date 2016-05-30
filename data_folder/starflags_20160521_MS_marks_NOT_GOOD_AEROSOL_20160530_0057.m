function marks = starflags_20160521_MS_marks_NOT_GOOD_AEROSOL_20160530_0057  
 % starflags file for 20160521 created by MS on 20160530_0057 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160530_0057'); 
 daystr = '20160521';  
 % tag = 90: cirrus 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('03:58:10') datenum('04:00:17') 700 
datenum('04:54:22') datenum('05:02:11') 700 
datenum('05:20:34') datenum('05:23:33') 700 
datenum('22:57:17') datenum('23:01:43') 90 
datenum('23:52:40') datenum('24:04:33') 90 
datenum('24:04:39') datenum('24:25:02') 90 
datenum('24:25:09') datenum('24:43:22') 90 
datenum('24:43:29') datenum('25:01:42') 90 
datenum('25:01:49') datenum('25:21:56') 90 
datenum('25:22:02') datenum('25:40:16') 90 
datenum('25:40:22') datenum('25:58:36') 90 
datenum('25:58:42') datenum('26:17:00') 90 
datenum('26:17:07') datenum('26:39:26') 90 
datenum('26:39:33') datenum('27:01:29') 90 
datenum('27:01:35') datenum('27:19:49') 90 
datenum('27:19:55') datenum('27:38:09') 90 
datenum('27:38:15') datenum('27:56:29') 90 
datenum('27:56:36') datenum('28:14:49') 90 
datenum('28:14:56') datenum('28:39:17') 90 
datenum('28:39:23') datenum('29:00:28') 90 
datenum('29:00:34') datenum('29:18:48') 90 
datenum('29:18:54') datenum('29:37:08') 90 
datenum('29:37:15') datenum('29:55:28') 90 
datenum('29:55:35') datenum('30:14:04') 90 
datenum('30:14:11') datenum('30:15:27') 90 
datenum('30:17:41') datenum('30:32:24') 90 
datenum('30:32:31') datenum('30:48:46') 90 
datenum('32:20:00') datenum('32:20:06') 90 
datenum('32:24:05') datenum('32:24:11') 90 
datenum('32:24:24') datenum('32:24:26') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return