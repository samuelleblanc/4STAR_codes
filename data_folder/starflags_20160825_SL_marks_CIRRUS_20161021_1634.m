function marks = starflags_20160825_SL_marks_CIRRUS_20161021_1634  
 % starflags file for 20160825 created by SL on 20161021_1634 to mark CIRRUS conditions 
 version_set('20161021_1634'); 
 daystr = '20160825';  
 % tag = 10: unspecified_clouds 
 % tag = 90: cirrus 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:39:31') datenum('10:39:40') 700 
datenum('10:40:16') datenum('10:40:20') 700 
datenum('10:42:19') datenum('10:42:29') 700 
datenum('10:45:12') datenum('10:45:16') 700 
datenum('10:45:24') datenum('10:45:24') 700 
datenum('10:46:13') datenum('10:46:18') 700 
datenum('13:14:20') datenum('13:14:25') 700 
datenum('13:13:11') datenum('13:13:12') 10 
datenum('13:14:20') datenum('13:14:23') 10 
datenum('10:33:05') datenum('10:33:48') 90 
datenum('10:34:01') datenum('10:34:09') 90 
datenum('10:36:00') datenum('10:36:12') 90 
datenum('10:36:41') datenum('10:36:41') 90 
datenum('10:37:25') datenum('10:37:41') 90 
datenum('10:37:44') datenum('10:37:45') 90 
datenum('10:37:50') datenum('10:38:06') 90 
datenum('10:38:08') datenum('10:38:08') 90 
datenum('10:38:29') datenum('10:38:40') 90 
datenum('10:39:02') datenum('10:39:40') 90 
datenum('10:39:54') datenum('10:40:20') 90 
datenum('10:40:37') datenum('10:40:48') 90 
datenum('10:41:24') datenum('10:41:38') 90 
datenum('10:41:52') datenum('10:42:39') 90 
datenum('10:44:34') datenum('10:44:43') 90 
datenum('10:44:55') datenum('10:45:46') 90 
datenum('10:46:06') datenum('10:46:18') 90 
datenum('10:49:39') datenum('11:16:07') 90 
datenum('11:16:14') datenum('11:56:03') 90 
datenum('11:56:10') datenum('12:01:33') 90 
datenum('12:04:41') datenum('12:05:13') 90 
datenum('12:13:07') datenum('12:13:24') 90 
datenum('12:30:36') datenum('12:32:43') 90 
datenum('12:32:50') datenum('12:37:31') 90 
datenum('12:40:02') datenum('12:50:57') 90 
datenum('13:05:48') datenum('13:09:23') 90 
datenum('13:09:30') datenum('13:13:12') 90 
datenum('13:14:20') datenum('13:28:14') 90 
datenum('13:28:21') datenum('13:34:42') 90 
datenum('13:53:42') datenum('14:08:58') 90 
datenum('14:09:05') datenum('14:27:18') 90 
datenum('14:27:25') datenum('14:45:38') 90 
datenum('14:45:45') datenum('14:50:30') 90 
datenum('15:02:17') datenum('15:03:58') 90 
datenum('15:04:05') datenum('15:16:02') 90 
datenum('15:25:38') datenum('15:25:50') 90 
datenum('15:25:52') datenum('15:30:28') 90 
datenum('15:48:09') datenum('16:23:03') 90 
datenum('17:50:12') datenum('17:52:05') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return