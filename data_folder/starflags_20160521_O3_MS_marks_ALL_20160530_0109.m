function marks = starflags_20160521_O3_MS_marks_ALL_20160530_0109  
 % starflags file for 20160521 created by MS on 20160530_0109 to mark ALL conditions 
 version_set('20160530_0109'); 
 daystr = '20160521';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('03:57:58') datenum('05:23:34') 700 
datenum('23:59:52') datenum('24:07:36') 700 
datenum('24:10:00') datenum('30:15:27') 700 
datenum('30:17:41') datenum('31:09:28') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return