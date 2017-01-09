function marks = starflags_20160512_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_0531  
 % starflags file for 20160512 created by MS on 20170109_0531 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0531'); 
 daystr = '20160512';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:12:28') datenum('03:40:37') 03 
datenum('27:38:51') datenum('03:40:37') 02 
datenum('23:12:28') datenum('03:40:37') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return