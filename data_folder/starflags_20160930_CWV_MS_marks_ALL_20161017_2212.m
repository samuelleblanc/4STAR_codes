function marks = starflags_20160930_CWV_MS_marks_ALL_20161017_2212  
 % starflags file for 20160930 created by MS on 20161017_2212 to mark ALL conditions 
 version_set('20161017_2212'); 
 daystr = '20160930';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:10:29') datenum('16:16:52') 03 
datenum('10:10:29') datenum('10:22:06') 700 
datenum('10:35:10') datenum('10:35:15') 700 
datenum('10:51:37') datenum('10:57:34') 700 
datenum('10:59:19') datenum('10:59:30') 700 
datenum('11:14:52') datenum('11:14:56') 700 
datenum('11:33:15') datenum('11:33:19') 700 
datenum('11:51:36') datenum('11:51:41') 700 
datenum('12:09:58') datenum('12:10:03') 700 
datenum('12:32:30') datenum('12:32:34') 700 
datenum('12:50:51') datenum('12:50:55') 700 
datenum('12:51:02') datenum('12:51:03') 700 
datenum('12:52:06') datenum('12:52:08') 700 
datenum('13:25:58') datenum('13:26:03') 700 
datenum('13:39:51') datenum('13:40:01') 700 
datenum('13:58:18') datenum('13:58:23') 700 
datenum('14:28:02') datenum('14:28:06') 700 
datenum('14:50:32') datenum('14:50:37') 700 
datenum('15:08:56') datenum('15:09:00') 700 
datenum('15:46:44') datenum('15:46:49') 700 
datenum('15:48:00') datenum('15:48:24') 700 
datenum('15:48:30') datenum('15:48:35') 700 
datenum('15:48:47') datenum('15:48:47') 700 
datenum('15:48:56') datenum('15:48:56') 700 
datenum('15:50:24') datenum('15:50:24') 700 
datenum('15:50:29') datenum('15:51:18') 700 
datenum('15:57:12') datenum('15:57:28') 700 
datenum('16:10:03') datenum('16:10:03') 700 
datenum('16:12:58') datenum('16:13:08') 700 
datenum('16:13:43') datenum('16:13:47') 700 
datenum('16:15:41') datenum('16:15:41') 700 
datenum('16:16:45') datenum('16:16:52') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return