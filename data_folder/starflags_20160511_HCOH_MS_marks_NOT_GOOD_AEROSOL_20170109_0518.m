function marks = starflags_20160511_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_0518  
 % starflags file for 20160511 created by MS on 20170109_0518 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0518'); 
 daystr = '20160511';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('21:59:22') datenum('07:17:07') 03 
datenum('31:12:31') datenum('07:17:07') 02 
datenum('21:59:22') datenum('07:17:07') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return