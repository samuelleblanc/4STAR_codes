function marks = starflags_20160524_O3_MS_marks_NOT_GOOD_AEROSOL_20160701_1323  
 % starflags file for 20160524 created by MS on 20160701_1323 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160701_1323'); 
 daystr = '20160524';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:56:37') datenum('22:57:29') 700 
datenum('23:08:18') datenum('23:16:39') 700 
datenum('23:36:08') datenum('31:21:03') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return