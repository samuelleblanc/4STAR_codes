function marks = starflags_20160604_HCOH_MS_marks_ALL_20170109_2223  
 % starflags file for 20160604 created by MS on 20170109_2223 to mark ALL conditions 
 version_set('20170109_2223'); 
 daystr = '20160604';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:12:22') datenum('07:35:11') 03 
datenum('22:12:22') datenum('07:35:11') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return