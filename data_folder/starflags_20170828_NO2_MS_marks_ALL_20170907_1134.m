function marks = starflags_20170828_NO2_MS_marks_ALL_20170907_1134  
 % starflags file for 20170828 created by MS on 20170907_1134 to mark ALL conditions 
 version_set('20170907_1134'); 
 daystr = '20170828';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:24:13') datenum('08:39:11') 700 
datenum('09:29:09') datenum('09:29:09') 700 
datenum('09:36:22') datenum('09:36:22') 700 
datenum('10:46:08') datenum('10:48:04') 700 
datenum('11:46:09') datenum('11:51:22') 700 
datenum('12:12:52') datenum('12:15:46') 700 
datenum('12:34:05') datenum('12:51:47') 700 
datenum('12:56:01') datenum('12:59:22') 700 
datenum('13:08:05') datenum('13:10:44') 700 
datenum('16:50:34') datenum('17:10:15') 700 
datenum('17:10:57') datenum('17:23:03') 700 
datenum('17:30:22') datenum('17:30:46') 700 
datenum('10:35:43') datenum('10:38:43') 10 
datenum('16:34:11') datenum('16:34:19') 10 
datenum('16:34:29') datenum('16:34:29') 10 
datenum('16:34:31') datenum('16:35:50') 10 
datenum('16:36:40') datenum('16:36:42') 10 
datenum('16:39:13') datenum('16:40:01') 10 
datenum('16:40:15') datenum('16:41:16') 10 
datenum('16:41:23') datenum('16:41:23') 10 
datenum('16:44:32') datenum('16:45:34') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return