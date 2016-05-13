function marks = starflags_20160506_CWV_MS_marks_ALL_20160512_1846  
 % starflags file for 20160506 created by MS on 20160512_1846 to mark ALL conditions 
 version_set('20160512_1846'); 
 daystr = '20160506';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:50:31') datenum('22:53:43') 700 
datenum('25:50:42') datenum('25:50:42') 700 
datenum('25:51:36') datenum('25:51:41') 700 
datenum('26:36:03') datenum('26:36:22') 700 
datenum('27:11:24') datenum('27:11:24') 700 
datenum('27:11:26') datenum('27:11:28') 700 
datenum('27:18:40') datenum('27:18:44') 700 
datenum('27:20:25') datenum('27:20:44') 700 
datenum('28:29:00') datenum('28:29:15') 700 
datenum('30:03:06') datenum('30:03:08') 700 
datenum('30:05:38') datenum('30:05:40') 700 
datenum('30:55:35') datenum('30:55:38') 700 
datenum('30:55:51') datenum('30:55:58') 700 
datenum('31:01:01') datenum('31:01:01') 700 
datenum('31:01:33') datenum('31:01:35') 700 
datenum('31:01:39') datenum('31:01:41') 700 
datenum('31:01:44') datenum('31:02:04') 700 
datenum('31:07:08') datenum('31:07:24') 700 
datenum('31:07:31') datenum('31:09:48') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return