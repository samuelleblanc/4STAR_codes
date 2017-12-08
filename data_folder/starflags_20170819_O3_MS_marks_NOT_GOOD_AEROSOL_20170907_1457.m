function marks = starflags_20170819_O3_MS_marks_NOT_GOOD_AEROSOL_20170907_1457  
 % starflags file for 20170819 created by MS on 20170907_1457 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1457'); 
 daystr = '20170819';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:42:36') datenum('09:42:01') 700 
datenum('10:09:29') datenum('10:10:44') 700 
datenum('10:20:59') datenum('11:12:59') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return