function marks = starflags_20170817_O3_MS_marks_NOT_GOOD_AEROSOL_20170907_1412  
 % starflags file for 20170817 created by MS on 20170907_1412 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1412'); 
 daystr = '20170817';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:58:21') datenum('08:04:36') 700 
datenum('08:43:02') datenum('08:47:01') 700 
datenum('11:29:41') datenum('11:34:25') 700 
datenum('11:37:20') datenum('11:41:19') 700 
datenum('12:36:17') datenum('12:37:21') 700 
datenum('12:42:25') datenum('12:43:12') 700 
datenum('12:44:59') datenum('12:45:52') 700 
datenum('13:11:32') datenum('13:12:52') 700 
datenum('13:15:03') datenum('13:16:34') 700 
datenum('15:30:45') datenum('15:32:01') 700 
datenum('15:51:48') datenum('15:51:52') 700 
datenum('15:51:56') datenum('15:53:03') 700 
datenum('16:12:35') datenum('16:15:39') 700 
datenum('16:16:55') datenum('16:18:14') 700 
datenum('16:54:43') datenum('16:54:45') 700 
datenum('16:54:47') datenum('16:56:26') 700 
datenum('08:39:06') datenum('08:43:09') 10 
datenum('08:46:58') datenum('08:48:27') 10 
datenum('15:47:29') datenum('15:51:47') 10 
datenum('15:51:53') datenum('15:51:54') 10 
datenum('15:53:04') datenum('16:03:29') 10 
datenum('16:39:45') datenum('16:51:14') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return