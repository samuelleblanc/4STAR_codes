function marks = starflags_20160530_O3_MS_marks_NOT_GOOD_AEROSOL_20170109_1120  
 % starflags file for 20160530 created by MS on 20170109_1120 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_1120'); 
 daystr = '20160530';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:16:52') datenum('07:09:51') 03 
datenum('31:08:42') datenum('07:09:51') 02 
datenum('22:40:06') datenum('-2:40:59') 700 
datenum('22:41:17') datenum('-2:42:10') 700 
datenum('22:45:13') datenum('-1:21:59') 700 
datenum('24:10:33') datenum('00:11:16') 700 
datenum('24:11:18') datenum('00:11:41') 700 
datenum('24:11:43') datenum('00:11:43') 700 
datenum('24:11:46') datenum('00:23:51') 700 
datenum('24:23:53') datenum('01:14:42') 700 
datenum('25:14:44') datenum('02:06:40') 700 
datenum('26:06:42') datenum('02:22:36') 700 
datenum('26:22:38') datenum('02:23:15') 700 
datenum('26:23:18') datenum('02:23:18') 700 
datenum('26:23:20') datenum('02:37:29') 700 
datenum('27:00:22') datenum('05:47:12') 700 
datenum('29:47:14') datenum('07:09:51') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return