function marks = starflags_20160526_O3_MS_marks_NOT_GOOD_AEROSOL_20160701_1332  
 % starflags file for 20160526 created by MS on 20160701_1332 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160701_1332'); 
 daystr = '20160526';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:33:03') datenum('06:53:31') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return