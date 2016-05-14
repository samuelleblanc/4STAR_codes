function marks = starflags_20160513_O3_MS_marks_NOT_GOOD_AEROSOL_20160513_2259  
 % starflags file for 20160513 created by MS on 20160513_2259 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160513_2259'); 
 daystr = '20160513';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('05:19:15') datenum('05:19:53') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return