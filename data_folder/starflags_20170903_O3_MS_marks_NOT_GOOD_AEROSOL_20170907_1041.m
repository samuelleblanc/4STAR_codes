function marks = starflags_20170903_O3_MS_marks_NOT_GOOD_AEROSOL_20170907_1041  
 % starflags file for 20170903 created by MS on 20170907_1041 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1041'); 
 daystr = '20170903';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:42:18') datenum('08:43:10') 700 
datenum('09:42:51') datenum('09:58:39') 700 
datenum('12:48:04') datenum('12:48:04') 700 
datenum('14:58:18') datenum('15:17:05') 700 
datenum('15:50:20') datenum('16:03:17') 700 
datenum('18:05:28') datenum('18:05:28') 700 
datenum('18:49:32') datenum('18:49:32') 700 
datenum('19:07:48') datenum('19:08:28') 700 
datenum('13:18:47') datenum('13:22:42') 10 
datenum('14:58:13') datenum('14:58:42') 10 
datenum('14:58:58') datenum('14:59:01') 10 
datenum('14:59:11') datenum('14:59:13') 10 
datenum('14:59:18') datenum('14:59:18') 10 
datenum('14:59:26') datenum('14:59:26') 10 
datenum('15:00:05') datenum('15:00:05') 10 
datenum('16:28:36') datenum('16:34:59') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return