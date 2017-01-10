function marks = starflags_20160614_O3_MS_marks_NOT_GOOD_AEROSOL_20170110_0532  
 % starflags file for 20160614 created by MS on 20170110_0532 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170110_0532'); 
 daystr = '20160614';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('04:11:18') datenum('04:11:25') 03 
datenum('04:11:58') datenum('04:11:59') 03 
datenum('04:12:10') datenum('04:12:13') 03 
datenum('04:11:18') datenum('21:30:13') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return