function marks = starflags_20160517_HCOH_MS_marks_ALL_20170109_0741  
 % starflags file for 20160517 created by MS on 20170109_0741 to mark ALL conditions 
 version_set('20170109_0741'); 
 daystr = '20160517';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:21:59') datenum('07:31:36') 03 
datenum('31:30:53') datenum('07:31:36') 02 
datenum('07:21:59') datenum('-17:38:17') 700 
datenum('07:38:19') datenum('07:31:36') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return