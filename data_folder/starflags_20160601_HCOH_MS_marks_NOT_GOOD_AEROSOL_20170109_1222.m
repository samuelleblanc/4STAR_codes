function marks = starflags_20160601_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_1222  
 % starflags file for 20160601 created by MS on 20170109_1222 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_1222'); 
 daystr = '20160601';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('21:39:34') datenum('07:25:37') 03 
datenum('31:20:16') datenum('07:25:37') 02 
datenum('21:39:34') datenum('07:25:37') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return