function marks = starflags_20160526_CF_marks_NOT_GOOD_AEROSOL_20160601_1558  
 % starflags file for 20160526 created by CF on 20160601_1558 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160601_1558'); 
 daystr = '20160526';  
 % tag = 2: before_or_after_flight 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:33:13') datenum('02:53:20') 02 
datenum('02:53:28') datenum('02:54:14') 02 
datenum('02:54:22') datenum('02:54:49') 02 
datenum('02:55:00') datenum('02:55:00') 02 
datenum('02:55:06') datenum('02:55:28') 02 
datenum('02:56:04') datenum('02:56:07') 02 
datenum('02:56:18') datenum('02:57:16') 02 
datenum('02:33:13') datenum('02:54:49') 700 
datenum('02:55:00') datenum('02:57:16') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return