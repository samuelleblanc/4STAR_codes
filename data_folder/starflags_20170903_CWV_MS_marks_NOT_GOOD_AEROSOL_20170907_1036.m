function marks = starflags_20170903_CWV_MS_marks_NOT_GOOD_AEROSOL_20170907_1036  
 % starflags file for 20170903 created by MS on 20170907_1036 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1036'); 
 daystr = '20170903';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:42:32') datenum('08:43:10') 700 
datenum('09:43:32') datenum('09:55:27') 700 
datenum('09:55:40') datenum('09:58:14') 700 
datenum('12:48:04') datenum('12:48:04') 700 
datenum('13:19:56') datenum('13:22:14') 700 
datenum('14:56:53') datenum('15:16:47') 700 
datenum('15:50:48') datenum('16:02:51') 700 
datenum('16:29:20') datenum('16:29:20') 700 
datenum('16:33:38') datenum('16:34:18') 700 
datenum('18:49:32') datenum('18:49:32') 700 
datenum('19:08:19') datenum('19:08:26') 700 
datenum('14:43:10') datenum('14:47:58') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return