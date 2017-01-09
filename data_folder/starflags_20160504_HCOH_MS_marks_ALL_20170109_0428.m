function marks = starflags_20160504_HCOH_MS_marks_ALL_20170109_0428  
 % starflags file for 20160504 created by MS on 20170109_0428 to mark ALL conditions 
 version_set('20170109_0428'); 
 daystr = '20160504';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('21:53:25') datenum('05:43:50') 03 
datenum('21:53:25') datenum('03:49:37') 700 
datenum('27:49:40') datenum('03:51:20') 700 
datenum('27:51:23') datenum('05:43:50') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return