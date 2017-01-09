function marks = starflags_20160526_O3_MS_marks_NOT_GOOD_AEROSOL_20170109_0906  
 % starflags file for 20160526 created by MS on 20170109_0906 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0906'); 
 daystr = '20160526';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:33:03') datenum('03:43:11') 700 
datenum('04:34:05') datenum('05:01:15') 700 
datenum('05:01:35') datenum('05:06:47') 700 
datenum('05:08:48') datenum('06:43:32') 700 
datenum('06:52:53') datenum('06:53:31') 700 
datenum('04:34:05') datenum('05:01:15') 10 
datenum('05:01:35') datenum('05:06:47') 10 
datenum('05:08:48') datenum('06:43:32') 10 
datenum('06:52:53') datenum('06:53:31') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return