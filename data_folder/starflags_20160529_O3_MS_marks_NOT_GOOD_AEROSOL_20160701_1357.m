function marks = starflags_20160529_O3_MS_marks_NOT_GOOD_AEROSOL_20160701_1357  
 % starflags file for 20160529 created by MS on 20160701_1357 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160701_1357'); 
 daystr = '20160529';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:51:14') datenum('23:00:26') 700 
datenum('23:01:32') datenum('31:42:34') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return