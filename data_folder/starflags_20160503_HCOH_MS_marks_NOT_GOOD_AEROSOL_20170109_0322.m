function marks = starflags_20160503_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_0322  
 % starflags file for 20160503 created by MS on 20170109_0322 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0322'); 
 daystr = '20160503';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:11:39') datenum('08:45:35') 03 
datenum('22:11:39') datenum('-2:52:05') 700 
datenum('22:52:15') datenum('08:45:35') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return