function marks = starflags_20160914_CWV_MS_marks_ALL_20161017_1550  
 % starflags file for 20160914 created by MS on 20161017_1550 to mark ALL conditions 
 version_set('20161017_1550'); 
 daystr = '20160914';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:01:18') datenum('15:57:40') 03 
datenum('08:01:18') datenum('08:01:26') 700 
datenum('08:19:42') datenum('08:19:46') 700 
datenum('08:38:02') datenum('08:38:06') 700 
datenum('08:56:22') datenum('08:56:26') 700 
datenum('09:14:42') datenum('09:14:46') 700 
datenum('09:57:09') datenum('09:57:14') 700 
datenum('10:15:29') datenum('10:15:34') 700 
datenum('10:35:21') datenum('10:35:25') 700 
datenum('10:41:55') datenum('10:41:57') 700 
datenum('10:43:41') datenum('10:43:51') 700 
datenum('11:21:50') datenum('11:24:19') 700 
datenum('11:25:05') datenum('11:25:10') 700 
datenum('11:32:36') datenum('11:34:39') 700 
datenum('11:44:03') datenum('11:45:31') 700 
datenum('11:46:42') datenum('11:46:46') 700 
datenum('12:05:02') datenum('12:05:06') 700 
datenum('12:17:44') datenum('12:17:49') 700 
datenum('12:29:03') datenum('12:30:55') 700 
datenum('12:32:39') datenum('12:32:44') 700 
datenum('12:43:56') datenum('12:44:05') 700 
datenum('12:44:11') datenum('12:44:23') 700 
datenum('12:44:28') datenum('13:04:33') 700 
datenum('13:11:23') datenum('13:11:28') 700 
datenum('13:29:44') datenum('13:29:48') 700 
datenum('13:48:04') datenum('13:48:08') 700 
datenum('14:08:52') datenum('14:08:56') 700 
datenum('14:32:17') datenum('14:32:22') 700 
datenum('14:50:38') datenum('14:50:42') 700 
datenum('15:08:58') datenum('15:09:02') 700 
datenum('15:27:18') datenum('15:27:22') 700 
datenum('15:45:38') datenum('15:45:42') 700 
datenum('15:57:28') datenum('15:57:40') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return