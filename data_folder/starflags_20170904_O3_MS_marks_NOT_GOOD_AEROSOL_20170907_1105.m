function marks = starflags_20170904_O3_MS_marks_NOT_GOOD_AEROSOL_20170907_1105  
 % starflags file for 20170904 created by MS on 20170907_1105 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1105'); 
 daystr = '20170904';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:47:08') datenum('10:06:21') 700 
datenum('10:18:39') datenum('10:18:45') 700 
datenum('10:18:51') datenum('10:21:00') 700 
datenum('11:04:05') datenum('11:04:05') 700 
datenum('15:09:24') datenum('15:14:14') 700 
datenum('15:14:19') datenum('15:39:40') 700 
datenum('10:19:46') datenum('10:47:50') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return