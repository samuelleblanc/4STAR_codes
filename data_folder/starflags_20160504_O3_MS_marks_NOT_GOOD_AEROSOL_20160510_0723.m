function marks = starflags_20160504_O3_MS_marks_NOT_GOOD_AEROSOL_20160510_0723  
 % starflags file for 20160504 created by MS on 20160510_0723 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160510_0723'); 
 daystr = '20160504';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:31:33') datenum('00:34:34') 700 
datenum('03:42:34') datenum('03:50:02') 700 
datenum('03:50:56') datenum('03:59:05') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return