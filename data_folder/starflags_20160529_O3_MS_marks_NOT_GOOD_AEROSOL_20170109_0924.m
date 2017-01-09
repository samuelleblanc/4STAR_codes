function marks = starflags_20160529_O3_MS_marks_NOT_GOOD_AEROSOL_20170109_0924  
 % starflags file for 20160529 created by MS on 20170109_0924 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0924'); 
 daystr = '20160529';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:51:14') datenum('22:59:03') 700 
datenum('22:59:15') datenum('23:21:27') 700 
datenum('23:41:56') datenum('23:56:16') 700 
datenum('24:12:08') datenum('24:24:35') 700 
datenum('25:20:59') datenum('28:21:35') 700 
datenum('30:19:19') datenum('31:21:48') 700 
datenum('22:59:05') datenum('23:21:27') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return