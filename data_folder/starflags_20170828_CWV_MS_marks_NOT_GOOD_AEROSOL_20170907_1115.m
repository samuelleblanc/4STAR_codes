function marks = starflags_20170828_CWV_MS_marks_NOT_GOOD_AEROSOL_20170907_1115  
 % starflags file for 20170828 created by MS on 20170907_1115 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1115'); 
 daystr = '20170828';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:24:27') datenum('08:00:30') 700 
datenum('08:00:43') datenum('08:02:49') 700 
datenum('08:39:00') datenum('08:52:26') 700 
datenum('09:29:09') datenum('09:29:09') 700 
datenum('09:36:22') datenum('09:36:22') 700 
datenum('10:36:21') datenum('10:36:24') 700 
datenum('10:37:32') datenum('10:37:33') 700 
datenum('10:46:41') datenum('10:46:49') 700 
datenum('10:46:53') datenum('10:48:04') 700 
datenum('11:44:42') datenum('11:44:52') 700 
datenum('11:46:45') datenum('11:46:47') 700 
datenum('11:46:52') datenum('11:47:07') 700 
datenum('11:47:12') datenum('11:48:04') 700 
datenum('11:48:08') datenum('11:50:21') 700 
datenum('11:50:26') datenum('11:51:22') 700 
datenum('12:13:11') datenum('12:15:46') 700 
datenum('12:33:35') datenum('12:49:49') 700 
datenum('12:49:52') datenum('12:50:05') 700 
datenum('12:50:19') datenum('12:51:54') 700 
datenum('12:56:37') datenum('12:59:22') 700 
datenum('13:08:36') datenum('13:10:44') 700 
datenum('16:21:36') datenum('16:21:36') 700 
datenum('16:35:04') datenum('16:35:22') 700 
datenum('16:36:15') datenum('16:36:20') 700 
datenum('16:40:45') datenum('16:40:45') 700 
datenum('16:40:47') datenum('16:40:47') 700 
datenum('16:40:53') datenum('16:40:53') 700 
datenum('16:45:02') datenum('16:45:04') 700 
datenum('16:49:54') datenum('16:50:02') 700 
datenum('16:50:09') datenum('17:10:15') 700 
datenum('17:10:57') datenum('17:22:48') 700 
datenum('17:22:57') datenum('17:23:01') 700 
datenum('17:30:22') datenum('17:30:44') 700 
datenum('13:22:37') datenum('13:23:11') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return