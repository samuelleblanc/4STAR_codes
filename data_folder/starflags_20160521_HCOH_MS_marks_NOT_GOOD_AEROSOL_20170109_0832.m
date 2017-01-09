function marks = starflags_20160521_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_0832  
 % starflags file for 20160521 created by MS on 20170109_0832 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0832'); 
 daystr = '20160521';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('03:57:58') datenum('08:34:09') 03 
datenum('32:28:04') datenum('08:34:09') 02 
datenum('03:57:58') datenum('08:34:09') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return