function marks = starflags_20170819_CWV_MS_marks_NOT_GOOD_AEROSOL_20170907_1453  
 % starflags file for 20170819 created by MS on 20170907_1453 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170907_1453'); 
 daystr = '20170819';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:42:50') datenum('08:44:47') 700 
datenum('09:39:21') datenum('09:40:27') 700 
datenum('09:40:34') datenum('09:41:33') 700 
datenum('10:10:02') datenum('10:10:11') 700 
datenum('10:15:06') datenum('10:15:06') 700 
datenum('10:21:25') datenum('10:51:02') 700 
datenum('10:51:13') datenum('10:56:05') 700 
datenum('11:00:49') datenum('11:11:40') 700 
datenum('11:53:51') datenum('11:53:51') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return