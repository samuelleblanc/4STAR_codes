function marks = starflags_20160524_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_0855  
 % starflags file for 20160524 created by MS on 20170109_0855 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0855'); 
 daystr = '20160524';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:56:37') datenum('07:41:53') 03 
datenum('31:21:04') datenum('07:41:53') 02 
datenum('22:56:37') datenum('07:41:53') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return