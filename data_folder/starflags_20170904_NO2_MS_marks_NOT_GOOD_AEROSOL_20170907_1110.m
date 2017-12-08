function marks = starflags_20170904_NO2_MS_marks_NOT_GOOD_AEROSOL_20170907_1110  
 % starflags file for 20170904 created by MS on 20170907_1110 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1110'); 
 daystr = '20170904';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:47:08') datenum('10:05:51') 700 
datenum('10:17:54') datenum('10:47:27') 700 
datenum('11:04:05') datenum('11:04:05') 700 
datenum('15:08:48') datenum('15:39:40') 700 
datenum('15:08:35') datenum('15:08:51') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return