function marks = starflags_20160529_HCOH_MS_marks_ALL_20170109_0935  
 % starflags file for 20160529 created by MS on 20170109_0935 to mark ALL conditions 
 version_set('20170109_0935'); 
 daystr = '20160529';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:09:17') datenum('07:42:34') 03 
datenum('22:09:17') datenum('07:42:34') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return