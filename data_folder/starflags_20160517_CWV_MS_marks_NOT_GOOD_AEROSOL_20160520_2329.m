function marks = starflags_20160517_CWV_MS_marks_NOT_GOOD_AEROSOL_20160520_2329  
 % starflags file for 20160517 created by MS on 20160520_2329 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160520_2329'); 
 daystr = '20160517';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:23:35') datenum('07:42:01') 700 
datenum('07:42:14') datenum('07:42:14') 700 
datenum('07:52:48') datenum('07:54:40') 700 
datenum('26:49:53') datenum('26:49:55') 700 
datenum('27:25:30') datenum('27:25:38') 700 
datenum('27:25:41') datenum('27:25:46') 700 
datenum('27:25:49') datenum('27:25:49') 700 
datenum('27:34:47') datenum('27:34:49') 700 
datenum('27:46:27') datenum('27:46:29') 700 
datenum('27:46:32') datenum('27:46:40') 700 
datenum('27:46:43') datenum('27:48:30') 700 
datenum('27:48:33') datenum('27:49:18') 700 
datenum('27:49:22') datenum('27:49:39') 700 
datenum('27:49:44') datenum('27:50:05') 700 
datenum('27:50:14') datenum('27:50:18') 700 
datenum('28:07:20') datenum('28:07:22') 700 
datenum('28:19:09') datenum('28:19:16') 700 
datenum('28:20:38') datenum('28:20:43') 700 
datenum('28:34:39') datenum('28:34:41') 700 
datenum('28:37:19') datenum('28:37:19') 700 
datenum('28:37:23') datenum('28:37:23') 700 
datenum('28:40:33') datenum('28:40:34') 700 
datenum('28:44:35') datenum('28:45:34') 700 
datenum('28:45:37') datenum('28:46:15') 700 
datenum('28:46:18') datenum('28:46:35') 700 
datenum('28:47:48') datenum('28:47:50') 700 
datenum('29:58:58') datenum('29:59:03') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return