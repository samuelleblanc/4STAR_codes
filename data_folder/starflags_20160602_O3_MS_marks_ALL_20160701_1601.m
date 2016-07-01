function marks = starflags_20160602_O3_MS_marks_ALL_20160701_1601  
 % starflags file for 20160602 created by MS on 20160701_1601 to mark ALL conditions 
 version_set('20160701_1601'); 
 daystr = '20160602';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:00:17') datenum('07:23:19') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return