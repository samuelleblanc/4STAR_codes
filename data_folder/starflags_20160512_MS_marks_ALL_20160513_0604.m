function marks = starflags_20160512_MS_marks_ALL_20160513_0604  
 % starflags file for 20160512 created by MS on 20160513_0604 to mark ALL conditions 
 version_set('20160513_0604'); 
 daystr = '20160512';  
 % tag = 90: cirrus 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:26:53') datenum('03:10:16') 700 
datenum('03:20:42') datenum('03:21:15') 700 
datenum('03:22:17') datenum('03:22:22') 700 
datenum('03:22:47') datenum('03:22:47') 700 
datenum('03:22:49') datenum('03:22:52') 700 
datenum('03:22:54') datenum('03:22:54') 700 
datenum('03:23:30') datenum('03:23:38') 700 
datenum('03:24:28') datenum('03:24:28') 700 
datenum('03:24:30') datenum('03:30:43') 700 
datenum('03:34:26') datenum('03:34:27') 700 
datenum('-1:21:40') datenum('-1:28:32') 90 
datenum('-1:43:11') datenum('-1:49:11') 90 
datenum('-1:49:18') datenum('00:25:25') 90 
datenum('00:25:32') datenum('00:54:03') 90 
datenum('01:18:04') datenum('01:18:37') 90 
datenum('01:19:40') datenum('01:19:40') 90 
datenum('01:19:42') datenum('01:19:43') 90 
datenum('01:19:45') datenum('01:19:46') 90 
datenum('01:19:58') datenum('01:19:58') 90 
datenum('01:20:01') datenum('01:20:01') 90 
datenum('01:20:03') datenum('01:20:38') 90 
datenum('01:23:45') datenum('01:23:45') 90 
datenum('01:23:48') datenum('01:23:48') 90 
datenum('01:23:52') datenum('01:23:52') 90 
datenum('01:24:59') datenum('01:24:59') 90 
datenum('01:28:29') datenum('01:38:07') 90 
datenum('01:38:14') datenum('01:50:50') 90 
datenum('03:30:49') datenum('03:30:49') 90 
datenum('03:30:57') datenum('03:30:59') 90 
datenum('03:31:29') datenum('03:31:31') 90 
datenum('03:34:25') datenum('03:34:25') 90 
datenum('03:34:28') datenum('03:34:29') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return