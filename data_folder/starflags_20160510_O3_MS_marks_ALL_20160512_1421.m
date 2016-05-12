function marks = starflags_20160510_O3_MS_marks_ALL_20160512_1421  
 % starflags file for 20160510 created by MS on 20160512_1421 to mark ALL conditions 
 version_set('20160512_1421'); 
 daystr = '20160510';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:06:06') datenum('23:06:28') 700 
datenum('23:37:22') datenum('27:27:06') 700 
datenum('27:51:27') datenum('27:52:08') 700 
datenum('27:55:25') datenum('27:55:54') 700 
datenum('28:36:12') datenum('28:38:07') 700 
datenum('31:20:58') datenum('31:33:49') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return