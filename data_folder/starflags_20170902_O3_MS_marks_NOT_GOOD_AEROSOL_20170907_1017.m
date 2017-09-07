function marks = starflags_20170902_O3_MS_marks_NOT_GOOD_AEROSOL_20170907_1017  
 % starflags file for 20170902 created by MS on 20170907_1017 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1017'); 
 daystr = '20170902';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:09:17') datenum('09:19:18') 700 
datenum('11:15:57') datenum('11:52:35') 700 
datenum('12:33:43') datenum('12:35:44') 700 
datenum('15:50:47') datenum('15:57:24') 700 
datenum('16:29:11') datenum('16:39:01') 700 
datenum('17:26:24') datenum('17:26:24') 700 
datenum('17:27:08') datenum('17:35:08') 700 
datenum('09:47:50') datenum('09:47:50') 10 
datenum('09:49:32') datenum('09:49:34') 10 
datenum('10:52:49') datenum('11:03:17') 10 
datenum('12:39:13') datenum('13:24:38') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return