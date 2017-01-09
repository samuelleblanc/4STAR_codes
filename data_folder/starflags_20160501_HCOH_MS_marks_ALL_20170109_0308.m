function marks = starflags_20160501_HCOH_MS_marks_ALL_20170109_0308  
 % starflags file for 20160501 created by MS on 20170109_0308 to mark ALL conditions 
 version_set('20170109_0308'); 
 daystr = '20160501';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:21:38') datenum('07:08:51') 03 
datenum('22:21:38') datenum('05:13:00') 700 
datenum('29:13:03') datenum('05:22:15') 700 
datenum('29:22:18') datenum('05:26:48') 700 
datenum('29:26:51') datenum('06:34:22') 700 
datenum('30:34:25') datenum('06:46:35') 700 
datenum('30:46:38') datenum('07:08:51') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return