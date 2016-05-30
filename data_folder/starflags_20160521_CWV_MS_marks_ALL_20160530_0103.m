function marks = starflags_20160521_CWV_MS_marks_ALL_20160530_0103  
 % starflags file for 20160521 created by MS on 20160530_0103 to mark ALL conditions 
 version_set('20160530_0103'); 
 daystr = '20160521';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('03:58:10') datenum('03:58:28') 700 
datenum('03:58:30') datenum('04:00:15') 700 
datenum('24:07:50') datenum('24:10:00') 700 
datenum('25:02:55') datenum('25:04:12') 700 
datenum('25:04:14') datenum('25:06:09') 700 
datenum('25:06:11') datenum('25:06:12') 700 
datenum('25:06:14') datenum('25:07:18') 700 
datenum('25:19:58') datenum('25:20:00') 700 
datenum('25:52:02') datenum('25:52:08') 700 
datenum('26:01:27') datenum('26:01:38') 700 
datenum('26:20:07') datenum('26:20:26') 700 
datenum('26:20:29') datenum('26:20:57') 700 
datenum('26:21:00') datenum('26:21:31') 700 
datenum('26:21:34') datenum('26:21:35') 700 
datenum('26:21:39') datenum('26:22:08') 700 
datenum('26:40:15') datenum('26:40:20') 700 
datenum('26:40:23') datenum('26:40:23') 700 
datenum('26:51:25') datenum('26:51:28') 700 
datenum('26:57:44') datenum('26:57:44') 700 
datenum('27:18:32') datenum('27:18:34') 700 
datenum('27:20:40') datenum('27:20:45') 700 
datenum('27:46:39') datenum('27:46:48') 700 
datenum('27:51:58') datenum('27:52:04') 700 
datenum('28:19:55') datenum('28:19:55') 700 
datenum('28:20:56') datenum('28:20:57') 700 
datenum('28:21:23') datenum('28:28:04') 700 
datenum('29:22:06') datenum('29:22:10') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return