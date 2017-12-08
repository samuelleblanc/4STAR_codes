function marks = starflags_20170830_NO2_MS_marks_NOT_GOOD_AEROSOL_20170907_1157  
 % starflags file for 20170830 created by MS on 20170907_1157 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1157'); 
 daystr = '20170830';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:46:39') datenum('08:03:03') 700 
datenum('09:15:02') datenum('09:15:41') 700 
datenum('11:35:43') datenum('11:36:52') 700 
datenum('12:36:42') datenum('12:37:53') 700 
datenum('12:38:00') datenum('12:38:01') 700 
datenum('12:52:17') datenum('13:34:29') 700 
datenum('16:22:44') datenum('16:42:51') 700 
datenum('16:43:25') datenum('16:45:52') 700 
datenum('12:29:22') datenum('12:34:20') 10 
datenum('12:37:54') datenum('12:52:16') 10 
datenum('12:59:07') datenum('12:59:07') 10 
datenum('13:01:13') datenum('13:01:13') 10 
datenum('15:27:34') datenum('15:37:56') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return