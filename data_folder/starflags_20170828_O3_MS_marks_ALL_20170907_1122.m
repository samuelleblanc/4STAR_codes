function marks = starflags_20170828_O3_MS_marks_ALL_20170907_1122  
 % starflags file for 20170828 created by MS on 20170907_1122 to mark ALL conditions 
 version_set('20170907_1122'); 
 daystr = '20170828';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:24:13') datenum('08:39:11') 700 
datenum('09:29:09') datenum('09:29:09') 700 
datenum('09:36:22') datenum('09:36:22') 700 
datenum('10:35:53') datenum('10:36:53') 700 
datenum('10:46:11') datenum('10:46:15') 700 
datenum('10:47:56') datenum('10:48:04') 700 
datenum('11:46:20') datenum('11:51:22') 700 
datenum('12:12:52') datenum('12:15:46') 700 
datenum('12:34:22') datenum('12:51:33') 700 
datenum('12:56:08') datenum('12:59:00') 700 
datenum('12:59:04') datenum('12:59:13') 700 
datenum('12:59:18') datenum('12:59:22') 700 
datenum('13:08:06') datenum('13:10:44') 700 
datenum('16:21:36') datenum('16:21:36') 700 
datenum('16:34:22') datenum('16:35:56') 700 
datenum('16:36:35') datenum('16:36:49') 700 
datenum('16:50:10') datenum('17:10:15') 700 
datenum('17:10:57') datenum('17:23:03') 700 
datenum('17:30:22') datenum('17:30:46') 700 
datenum('10:28:01') datenum('10:35:51') 10 
datenum('10:36:54') datenum('10:46:10') 10 
datenum('10:46:41') datenum('10:47:53') 10 
datenum('11:44:14') datenum('11:45:25') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return