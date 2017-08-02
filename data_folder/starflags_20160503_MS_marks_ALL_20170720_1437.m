function marks = starflags_20160503_MS_marks_ALL_20170720_1437  
 % starflags file for 20160503 created by MS on 20170720_1437 to mark ALL conditions 
 version_set('20170720_1437'); 
 daystr = '20160503';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:52:14') datenum('23:06:06') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return