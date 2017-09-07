function marks = starflags_20170819_NO2_MS_marks_ALL_20170907_1459  
 % starflags file for 20170819 created by MS on 20170907_1459 to mark ALL conditions 
 version_set('20170907_1459'); 
 daystr = '20170819';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:42:36') datenum('09:41:25') 700 
datenum('10:09:29') datenum('10:10:44') 700 
datenum('10:21:07') datenum('10:55:51') 700 
datenum('11:00:49') datenum('11:13:21') 700 
datenum('11:53:18') datenum('11:54:21') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return