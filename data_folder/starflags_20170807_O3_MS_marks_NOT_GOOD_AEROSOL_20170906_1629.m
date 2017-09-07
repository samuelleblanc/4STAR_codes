function marks = starflags_20170807_O3_MS_marks_NOT_GOOD_AEROSOL_20170906_1629  
 % starflags file for 20170807 created by MS on 20170906_1629 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170906_1629'); 
 daystr = '20170807';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:30:15') datenum('10:14:33') 700 
datenum('10:41:28') datenum('10:41:28') 700 
datenum('13:40:00') datenum('13:40:00') 700 
datenum('17:22:41') datenum('17:22:41') 700 
datenum('19:02:31') datenum('19:33:54') 700 
datenum('12:38:42') datenum('12:58:58') 10 
datenum('13:27:47') datenum('13:39:58') 10 
datenum('13:40:02') datenum('13:42:07') 10 
datenum('14:42:58') datenum('15:00:05') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return