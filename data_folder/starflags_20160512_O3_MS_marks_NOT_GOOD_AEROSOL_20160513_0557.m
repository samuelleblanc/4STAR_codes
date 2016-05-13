function marks = starflags_20160512_O3_MS_marks_NOT_GOOD_AEROSOL_20160513_0557  
 % starflags file for 20160512 created by MS on 20160513_0557 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160513_0557'); 
 daystr = '20160512';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:58:28') datenum('02:58:54') 700 
datenum('03:20:16') datenum('03:21:40') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return