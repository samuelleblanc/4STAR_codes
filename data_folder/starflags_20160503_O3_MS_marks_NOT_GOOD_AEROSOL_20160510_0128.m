function marks = starflags_20160503_O3_MS_marks_NOT_GOOD_AEROSOL_20160510_0128  
 % starflags file for 20160503 created by MS on 20160510_0128 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160510_0128'); 
 daystr = '20160503';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:51:46') datenum('22:51:49') 700 
datenum('22:51:51') datenum('23:05:35') 700 
datenum('23:05:38') datenum('23:06:27') 700 
datenum('23:06:35') datenum('23:06:35') 700 
datenum('26:56:25') datenum('26:57:58') 700 
datenum('27:04:57') datenum('27:05:26') 700 
datenum('27:11:34') datenum('27:12:33') 700 
datenum('27:17:20') datenum('27:19:14') 700 
datenum('30:26:58') datenum('30:28:08') 700 
datenum('30:29:00') datenum('30:30:04') 700 
datenum('30:30:08') datenum('30:30:11') 700 
datenum('31:47:22') datenum('31:53:08') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return