function marks = starflags_20160604_O3_MS_marks_NOT_GOOD_AEROSOL_20170109_2102  
 % starflags file for 20160604 created by MS on 20170109_2102 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_2102'); 
 daystr = '20160604';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('00:03:40') datenum('00:04:25') 700 
datenum('03:10:00') datenum('03:13:05') 700 
datenum('04:06:49') datenum('04:14:45') 700 
datenum('04:17:44') datenum('04:21:05') 700 
datenum('04:25:34') datenum('04:28:52') 700 
datenum('04:31:04') datenum('04:37:44') 700 
datenum('04:41:04') datenum('04:50:12') 700 
datenum('04:56:58') datenum('05:00:37') 700 
datenum('05:16:49') datenum('05:18:52') 700 
datenum('05:48:49') datenum('05:49:49') 700 
datenum('04:41:04') datenum('04:50:12') 10 
datenum('05:16:49') datenum('05:18:52') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return