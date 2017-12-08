function marks = starflags_20170821_NO2_MS_marks_ALL_20170908_1657  
 % starflags file for 20170821 created by MS on 20170908_1657 to mark ALL conditions 
 version_set('20170908_1657'); 
 daystr = '20170821';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:56:52') datenum('10:57:28') 700 
datenum('17:37:38') datenum('17:53:00') 700 
datenum('11:07:50') datenum('11:18:04') 10 
datenum('12:42:08') datenum('13:06:08') 10 
datenum('13:24:41') datenum('13:26:05') 10 
datenum('13:34:06') datenum('13:36:26') 10 
datenum('15:45:17') datenum('16:41:31') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return