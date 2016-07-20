function marks = starflags_20160614_O3_MS_marks_NOT_GOOD_AEROSOL_20160719_1245  
 % starflags file for 20160614 created by MS on 20160719_1245 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160719_1245'); 
 daystr = '20160614';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('04:11:26') datenum('04:11:57') 700 
datenum('04:12:01') datenum('21:30:13') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return