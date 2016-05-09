function marks = starflags_20160506_MS_marks_NOT_GOOD_AEROSOL_20160509_0102  
 % starflags file for 20160506 created by MS on 20160509_0102 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160509_0102'); 
 daystr = '20160506';  
 % tag = 90: cirrus 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:49:18') datenum('22:49:24') 700 
datenum('22:49:37') datenum('22:49:43') 700 
datenum('22:50:31') datenum('22:53:43') 700 
datenum('24:32:19') datenum('24:33:21') 90 
datenum('24:33:37') datenum('24:33:37') 90 
datenum('24:33:40') datenum('24:33:56') 90 
datenum('24:33:58') datenum('24:33:58') 90 
datenum('24:34:02') datenum('24:34:03') 90 
datenum('24:34:06') datenum('24:34:30') 90 
datenum('25:06:36') datenum('25:06:36') 90 
datenum('25:07:06') datenum('25:07:06') 90 
datenum('25:20:14') datenum('25:20:16') 90 
datenum('25:48:00') datenum('26:13:53') 90 
datenum('26:14:00') datenum('26:32:13') 90 
datenum('26:32:20') datenum('26:50:41') 90 
datenum('26:50:48') datenum('27:00:49') 90 
datenum('27:09:30') datenum('27:27:28') 90 
datenum('27:27:35') datenum('27:45:48') 90 
datenum('27:45:55') datenum('28:04:09') 90 
datenum('28:04:15') datenum('28:32:10') 90 
datenum('28:32:17') datenum('28:50:30') 90 
datenum('28:50:37') datenum('29:08:50') 90 
datenum('29:08:57') datenum('29:27:10') 90 
datenum('29:27:17') datenum('29:45:31') 90 
datenum('29:45:37') datenum('30:03:55') 90 
datenum('30:04:02') datenum('30:22:17') 90 
datenum('30:22:24') datenum('30:40:37') 90 
datenum('30:40:44') datenum('30:59:11') 90 
datenum('30:59:18') datenum('31:07:24') 90 
datenum('31:07:31') datenum('31:09:48') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return