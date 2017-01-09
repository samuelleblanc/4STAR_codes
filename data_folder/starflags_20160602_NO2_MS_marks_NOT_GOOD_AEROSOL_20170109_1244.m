function marks = starflags_20160602_NO2_MS_marks_NOT_GOOD_AEROSOL_20170109_1244  
 % starflags file for 20160602 created by MS on 20170109_1244 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_1244'); 
 daystr = '20160602';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:08:53') datenum('01:45:10') 700 
datenum('01:53:04') datenum('02:36:50') 700 
datenum('03:02:58') datenum('03:04:32') 700 
datenum('03:29:41') datenum('03:31:17') 700 
datenum('03:34:10') datenum('03:37:02') 700 
datenum('03:58:17') datenum('04:00:03') 700 
datenum('04:14:53') datenum('04:17:47') 700 
datenum('04:34:23') datenum('04:40:30') 700 
datenum('04:45:56') datenum('05:09:42') 700 
datenum('05:14:46') datenum('05:23:13') 700 
datenum('01:08:53') datenum('01:45:10') 10 
datenum('01:53:04') datenum('02:36:50') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return