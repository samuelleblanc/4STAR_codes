function marks = starflags_20160519_HCOH_MS_marks_ALL_20170109_0800  
 % starflags file for 20160519 created by MS on 20170109_0800 to mark ALL conditions 
 version_set('20170109_0800'); 
 daystr = '20160519';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:08:25') datenum('07:17:34') 03 
datenum('22:08:25') datenum('07:17:34') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return