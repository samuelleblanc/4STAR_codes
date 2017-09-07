function marks = starflags_20170902_NO2_MS_marks_NOT_GOOD_AEROSOL_20170907_1022  
 % starflags file for 20170902 created by MS on 20170907_1022 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1022'); 
 daystr = '20170902';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:09:25') datenum('09:19:23') 700 
datenum('09:47:00') datenum('09:47:50') 700 
datenum('09:49:32') datenum('09:49:32') 700 
datenum('10:52:59') datenum('11:03:17') 700 
datenum('11:15:59') datenum('11:52:35') 700 
datenum('12:33:53') datenum('12:35:54') 700 
datenum('15:50:40') datenum('15:57:24') 700 
datenum('16:29:11') datenum('16:38:52') 700 
datenum('17:26:20') datenum('17:26:24') 700 
datenum('17:27:08') datenum('17:35:06') 700 
datenum('12:33:17') datenum('12:33:53') 10 
datenum('12:33:55') datenum('12:34:05') 10 
datenum('12:34:08') datenum('12:34:09') 10 
datenum('12:34:23') datenum('12:34:24') 10 
datenum('12:35:43') datenum('13:20:40') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return