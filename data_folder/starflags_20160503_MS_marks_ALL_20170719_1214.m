function marks = starflags_20160503_MS_marks_ALL_20170719_1214  
 % starflags file for 20160503 created by MS on 20170719_1214 to mark ALL conditions 
 version_set('20170719_1214'); 
 daystr = '20160503';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('22:52:14') datenum('23:06:06') 700 
datenum('22:11:39') datenum('24:26:48') 10 
datenum('24:38:15') datenum('24:38:15') 10 
datenum('24:41:58') datenum('24:41:59') 10 
datenum('25:08:18') datenum('32:45:35') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return