function marks = starflags_20160827_SL_marks_NOT_GOOD_AEROSOL_20161010_1232  
 % starflags file for 20160827 created by SL on 20161010_1232 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161010_1232'); 
 daystr = '20160827';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:59:48') datenum('07:59:57') 700 
datenum('08:19:13') datenum('08:19:18') 700 
datenum('08:37:33') datenum('08:37:38') 700 
datenum('08:55:53') datenum('08:55:58') 700 
datenum('09:14:14') datenum('09:14:18') 700 
datenum('09:32:34') datenum('09:32:39') 700 
datenum('09:50:54') datenum('09:50:59') 700 
datenum('09:59:31') datenum('09:59:33') 700 
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
datenum('09:59:30') datenum('09:59:33') 10 
datenum('14:27:56') datenum('14:28:27') 10 
datenum('14:28:33') datenum('14:28:43') 10 
datenum('14:29:24') datenum('14:29:24') 10 
datenum('14:29:27') datenum('14:29:31') 10 
datenum('14:29:38') datenum('14:30:21') 10 
datenum('14:30:23') datenum('14:30:31') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return