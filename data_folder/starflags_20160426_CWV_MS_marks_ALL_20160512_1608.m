function marks = starflags_20160426_CWV_MS_marks_ALL_20160512_1608  
 % starflags file for 20160426 created by MS on 20160512_1608 to mark ALL conditions 
 version_set('20160512_1608'); 
 daystr = '20160426';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:51:15') datenum('10:51:16') 700 
datenum('12:38:36') datenum('12:41:30') 700 
datenum('13:00:28') datenum('13:01:46') 700 
datenum('13:12:17') datenum('13:12:27') 700 
datenum('13:12:50') datenum('13:15:36') 700 
datenum('13:23:36') datenum('13:24:08') 700 
datenum('13:30:12') datenum('13:30:28') 700 
datenum('13:59:12') datenum('13:59:16') 700 
datenum('13:59:37') datenum('13:59:49') 700 
datenum('13:59:52') datenum('14:00:48') 700 
datenum('14:00:51') datenum('14:00:51') 700 
datenum('14:00:57') datenum('14:01:01') 700 
datenum('14:01:07') datenum('14:01:21') 700 
datenum('14:01:29') datenum('14:01:52') 700 
datenum('14:01:56') datenum('14:02:15') 700 
datenum('14:02:40') datenum('14:03:53') 700 
datenum('14:06:13') datenum('14:06:13') 700 
datenum('14:06:19') datenum('14:06:40') 700 
datenum('17:02:23') datenum('17:28:26') 700 
datenum('25:52:38') datenum('25:52:44') 700 
datenum('25:57:05') datenum('25:57:06') 700 
datenum('26:00:55') datenum('26:19:32') 700 
datenum('26:21:16') datenum('26:22:39') 700 
datenum('28:26:54') datenum('28:30:35') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return