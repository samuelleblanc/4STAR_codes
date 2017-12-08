function marks = starflags_20170801_NO2_MS_marks_NOT_GOOD_AEROSOL_20170906_1612  
 % starflags file for 20170801 created by MS on 20170906_1612 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170906_1612'); 
 daystr = '20170801';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:38:52') datenum('12:26:09') 700 
datenum('13:14:51') datenum('17:49:55') 700 
datenum('12:25:41') datenum('12:33:21') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return