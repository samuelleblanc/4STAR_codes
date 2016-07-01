function marks = starflags_20160601_O3_MS_marks_NOT_GOOD_AEROSOL_20160701_1442  
 % starflags file for 20160601 created by MS on 20160701_1442 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160701_1442'); 
 daystr = '20160601';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('21:39:34') datenum('07:25:37') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return