function marks = starflags_20170826_NO2_MS_marks_ALL_20170828_0954  
 % starflags file for 20170826 created by MS on 20170828_0954 to mark ALL conditions 
 version_set('20170828_0954'); 
 daystr = '20170826';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:18:18') datenum('08:02:24') 700 
datenum('08:33:39') datenum('08:39:54') 700 
datenum('10:05:57') datenum('10:07:09') 700 
datenum('10:35:01') datenum('10:36:31') 700 
datenum('10:43:51') datenum('10:59:35') 700 
datenum('11:01:40') datenum('11:01:40') 700 
datenum('11:01:43') datenum('11:02:10') 700 
datenum('11:02:12') datenum('11:04:10') 700 
datenum('11:04:30') datenum('11:04:50') 700 
datenum('11:04:52') datenum('11:05:12') 700 
datenum('11:08:36') datenum('11:11:11') 700 
datenum('11:16:26') datenum('11:22:43') 700 
datenum('11:33:26') datenum('11:34:37') 700 
datenum('11:38:43') datenum('11:44:41') 700 
datenum('11:49:51') datenum('11:50:31') 700 
datenum('11:54:52') datenum('12:03:47') 700 
datenum('12:10:06') datenum('12:11:05') 700 
datenum('12:17:51') datenum('12:26:03') 700 
datenum('12:42:54') datenum('12:44:09') 700 
datenum('12:46:25') datenum('12:48:17') 700 
datenum('13:07:51') datenum('13:09:02') 700 
datenum('13:19:59') datenum('13:42:22') 700 
datenum('14:23:42') datenum('14:39:38') 700 
datenum('14:40:38') datenum('14:42:05') 700 
datenum('16:26:45') datenum('16:27:45') 700 
datenum('17:21:05') datenum('17:25:04') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return