function marks = starflags_20170824_NO2_MS_marks_ALL_20170828_0829  
 % starflags file for 20170824 created by MS on 20170828_0829 to mark ALL conditions 
 version_set('20170828_0829'); 
 daystr = '20170824';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:09:16') datenum('10:09:16') 700 
datenum('11:17:09') datenum('11:19:46') 10 
datenum('11:23:57') datenum('11:25:01') 10 
datenum('12:20:18') datenum('12:27:47') 10 
datenum('14:43:50') datenum('14:48:48') 10 
datenum('14:51:16') datenum('14:54:47') 10 
datenum('14:57:08') datenum('14:58:13') 10 
datenum('15:25:05') datenum('15:26:00') 10 
datenum('16:13:08') datenum('16:13:48') 10 
datenum('16:47:10') datenum('17:21:44') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return