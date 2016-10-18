function marks = starflags_20160827_O3_MS_marks_ALL_20161017_2230  
 % starflags file for 20160827 created by MS on 20161017_2230 to mark ALL conditions 
 version_set('20161017_2230'); 
 daystr = '20160827';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:59:48') datenum('14:30:32') 03 
datenum('07:59:48') datenum('08:02:16') 700 
datenum('08:02:19') datenum('08:11:07') 700 
datenum('08:19:13') datenum('08:19:18') 700 
datenum('08:37:33') datenum('08:37:38') 700 
datenum('08:55:53') datenum('08:55:58') 700 
datenum('09:14:14') datenum('09:14:18') 700 
datenum('09:32:34') datenum('09:32:39') 700 
datenum('09:48:46') datenum('09:50:53') 700 
datenum('09:50:55') datenum('09:50:59') 700 
datenum('09:51:03') datenum('10:53:41') 700 
datenum('11:07:51') datenum('11:07:55') 700 
datenum('11:26:11') datenum('11:26:15') 700 
datenum('11:44:31') datenum('11:44:35') 700 
datenum('12:02:51') datenum('12:02:55') 700 
datenum('12:21:11') datenum('12:21:16') 700 
datenum('12:39:31') datenum('12:39:36') 700 
datenum('12:57:51') datenum('12:57:56') 700 
datenum('13:16:11') datenum('13:16:16') 700 
datenum('13:34:32') datenum('13:34:36') 700 
datenum('13:52:52') datenum('13:52:56') 700 
datenum('14:11:12') datenum('14:11:16') 700 
datenum('14:29:32') datenum('14:29:36') 700 
datenum('14:30:32') datenum('14:30:32') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return