function marks = starflags_20160602_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_1257  
 % starflags file for 20160602 created by MS on 20170109_1257 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_1257'); 
 daystr = '20160602';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:00:17') datenum('07:23:19') 03 
datenum('23:00:17') datenum('04:59:52') 700 
datenum('28:59:55') datenum('07:23:19') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return