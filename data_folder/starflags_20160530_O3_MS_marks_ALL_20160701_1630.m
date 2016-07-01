function marks = starflags_20160530_O3_MS_marks_ALL_20160701_1630  
 % starflags file for 20160530 created by MS on 20160701_1630 to mark ALL conditions 
 version_set('20160701_1630'); 
 daystr = '20160530';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:40:06') datenum('22:40:59') 700 
datenum('22:45:20') datenum('22:53:13') 700 
datenum('22:56:00') datenum('31:09:51') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return