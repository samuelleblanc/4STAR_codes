function marks = starflags_20170903_NO2_MS_marks_NOT_GOOD_AEROSOL_20170907_1048  
 % starflags file for 20170903 created by MS on 20170907_1048 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1048'); 
 daystr = '20170903';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:42:18') datenum('08:43:10') 700 
datenum('09:43:00') datenum('09:58:34') 700 
datenum('12:48:04') datenum('12:48:04') 700 
datenum('13:19:20') datenum('13:22:27') 700 
datenum('14:58:26') datenum('15:17:18') 700 
datenum('15:50:20') datenum('16:03:26') 700 
datenum('18:05:28') datenum('18:05:28') 700 
datenum('18:49:32') datenum('18:49:32') 700 
datenum('19:07:50') datenum('19:08:28') 700 
datenum('16:32:59') datenum('16:34:48') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return