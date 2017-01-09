function marks = starflags_20160516_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_0704  
 % starflags file for 20160516 created by MS on 20170109_0704 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0704'); 
 daystr = '20160516';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:13:08') datenum('07:19:18') 03 
datenum('31:16:45') datenum('07:19:18') 02 
datenum('22:13:08') datenum('07:19:18') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return