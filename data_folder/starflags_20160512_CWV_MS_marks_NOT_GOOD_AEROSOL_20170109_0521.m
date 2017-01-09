function marks = starflags_20160512_CWV_MS_marks_NOT_GOOD_AEROSOL_20170109_0521  
 % starflags file for 20160512 created by MS on 20170109_0521 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0521'); 
 daystr = '20160512';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:12:28') datenum('03:40:37') 03 
datenum('27:38:51') datenum('03:40:37') 02 
datenum('23:12:28') datenum('-1:12:36') 700 
datenum('23:30:52') datenum('-1:30:56') 700 
datenum('23:49:12') datenum('-1:49:17') 700 
datenum('23:49:48') datenum('-1:49:48') 700 
datenum('23:49:54') datenum('00:07:47') 700 
datenum('24:25:26') datenum('00:25:31') 700 
datenum('24:35:54') datenum('00:35:54') 700 
datenum('24:36:16') datenum('00:54:01') 700 
datenum('25:01:28') datenum('01:01:33') 700 
datenum('25:19:48') datenum('01:19:53') 700 
datenum('25:38:09') datenum('01:38:13') 700 
datenum('25:49:14') datenum('01:49:14') 700 
datenum('25:50:36') datenum('02:26:53') 700 
datenum('26:27:03') datenum('02:27:03') 700 
datenum('26:27:12') datenum('02:58:54') 700 
datenum('27:20:43') datenum('03:21:15') 700 
datenum('27:23:31') datenum('03:23:32') 700 
datenum('27:24:33') datenum('03:24:35') 700 
datenum('27:24:39') datenum('03:24:48') 700 
datenum('27:24:51') datenum('03:40:37') 700 
datenum('27:22:45') datenum('03:23:30') 10 
datenum('27:23:33') datenum('03:24:32') 10 
datenum('27:24:34') datenum('03:24:34') 10 
datenum('27:24:36') datenum('03:24:38') 10 
datenum('27:24:48') datenum('03:24:50') 10 
datenum('27:24:53') datenum('03:24:53') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return