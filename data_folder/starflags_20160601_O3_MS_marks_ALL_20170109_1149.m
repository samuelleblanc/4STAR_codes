function marks = starflags_20160601_O3_MS_marks_ALL_20170109_1149  
 % starflags file for 20160601 created by MS on 20170109_1149 to mark ALL conditions 
 version_set('20170109_1149'); 
 daystr = '20160601';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:58:57') datenum('02:00:57') 700 
datenum('02:03:10') datenum('02:04:54') 700 
datenum('03:02:38') datenum('03:05:32') 700 
datenum('03:12:39') datenum('03:13:38') 700 
datenum('03:17:41') datenum('03:18:47') 700 
datenum('03:18:54') datenum('03:18:54') 700 
datenum('03:18:56') datenum('03:19:01') 700 
datenum('03:19:06') datenum('03:20:10') 700 
datenum('03:24:08') datenum('03:25:59') 700 
datenum('03:29:37') datenum('03:31:50') 700 
datenum('03:37:59') datenum('03:39:48') 700 
datenum('03:58:09') datenum('03:59:40') 700 
datenum('04:02:14') datenum('04:03:19') 700 
datenum('04:08:08') datenum('04:09:21') 700 
datenum('04:12:58') datenum('04:14:25') 700 
datenum('04:18:17') datenum('04:19:24') 700 
datenum('04:41:21') datenum('04:42:26') 700 
datenum('04:48:42') datenum('04:51:04') 700 
datenum('04:54:56') datenum('04:55:59') 700 
datenum('04:56:48') datenum('04:59:15') 700 
datenum('05:03:38') datenum('05:06:24') 700 
datenum('05:10:40') datenum('05:12:24') 700 
datenum('05:16:48') datenum('05:20:27') 700 
datenum('05:38:42') datenum('05:40:06') 700 
datenum('05:47:31') datenum('05:48:32') 700 
datenum('05:56:28') datenum('06:00:17') 700 
datenum('06:04:05') datenum('06:07:41') 700 
datenum('06:09:32') datenum('06:18:39') 700 
datenum('06:20:26') datenum('06:39:53') 700 
datenum('07:02:48') datenum('07:05:39') 700 
datenum('07:05:42') datenum('07:11:27') 700 
datenum('06:09:32') datenum('06:18:39') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return