function marks = starflags_20160530_HCOH_MS_marks_ALL_20170109_1132  
 % starflags file for 20160530 created by MS on 20170109_1132 to mark ALL conditions 
 version_set('20170109_1132'); 
 daystr = '20160530';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:16:52') datenum('07:09:51') 03 
datenum('31:08:42') datenum('07:09:51') 02 
datenum('22:16:52') datenum('00:45:14') 700 
datenum('24:45:16') datenum('07:09:51') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return