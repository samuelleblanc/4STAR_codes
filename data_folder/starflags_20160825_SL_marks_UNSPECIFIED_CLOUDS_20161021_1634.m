function marks = starflags_20160825_SL_marks_UNSPECIFIED_CLOUDS_20161021_1634  
 % starflags file for 20160825 created by SL on 20161021_1634 to mark UNSPECIFIED_CLOUDS conditions 
 version_set('20161021_1634'); 
 daystr = '20160825';  
 % tag = 10: unspecified_clouds 
 % tag = 90: cirrus 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('13:13:15') datenum('13:14:23') 700 
datenum('13:42:13') datenum('13:42:13') 700 
datenum('13:46:25') datenum('13:46:25') 700 
datenum('19:21:34') datenum('19:22:09') 700 
datenum('19:22:13') datenum('19:22:15') 700 
datenum('19:22:22') datenum('19:22:22') 700 
datenum('13:13:11') datenum('13:14:23') 10 
datenum('13:41:52') datenum('13:46:33') 10 
datenum('15:25:51') datenum('15:25:51') 10 
datenum('19:21:34') datenum('19:22:09') 10 
datenum('19:22:13') datenum('19:22:15') 10 
datenum('19:22:22') datenum('19:22:22') 10 
datenum('13:13:11') datenum('13:13:12') 90 
datenum('13:14:20') datenum('13:14:23') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return