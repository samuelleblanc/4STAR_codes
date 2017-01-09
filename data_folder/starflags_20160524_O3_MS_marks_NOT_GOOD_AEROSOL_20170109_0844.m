function marks = starflags_20160524_O3_MS_marks_NOT_GOOD_AEROSOL_20170109_0844  
 % starflags file for 20160524 created by MS on 20170109_0844 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0844'); 
 daystr = '20160524';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:56:37') datenum('22:57:26') 700 
datenum('23:08:11') datenum('23:16:37') 700 
datenum('25:13:17') datenum('25:20:05') 700 
datenum('27:56:57') datenum('27:58:43') 700 
datenum('28:27:09') datenum('28:28:25') 700 
datenum('28:51:22') datenum('30:20:27') 700 
datenum('31:05:25') datenum('31:21:03') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return