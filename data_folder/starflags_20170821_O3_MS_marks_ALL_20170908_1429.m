function marks = starflags_20170821_O3_MS_marks_ALL_20170908_1429  
 % starflags file for 20170821 created by MS on 20170908_1429 to mark ALL conditions 
 version_set('20170908_1429'); 
 daystr = '20170821';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:56:52') datenum('10:57:28') 700 
datenum('16:28:20') datenum('16:30:09') 700 
datenum('11:13:04') datenum('11:15:10') 10 
datenum('12:42:43') datenum('12:52:43') 10 
datenum('12:56:23') datenum('13:00:29') 10 
datenum('13:02:41') datenum('13:06:08') 10 
datenum('13:24:41') datenum('13:26:05') 10 
datenum('13:34:06') datenum('13:36:21') 10 
datenum('14:03:31') datenum('15:04:36') 10 
datenum('15:45:23') datenum('15:48:05') 10 
datenum('17:36:10') datenum('17:53:00') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return