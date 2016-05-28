function marks = starflags_20160511_CWV_MS_marks_ALL_20160523_0126  
 % starflags file for 20160511 created by MS on 20160523_0126 to mark ALL conditions 
 version_set('20160523_0126'); 
 daystr = '20160511';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:34:27') datenum('02:34:45') 700 
datenum('02:35:39') datenum('02:35:45') 700 
datenum('02:35:48') datenum('02:35:48') 700 
datenum('02:35:51') datenum('02:35:54') 700 
datenum('02:36:01') datenum('02:36:11') 700 
datenum('02:36:14') datenum('02:36:17') 700 
datenum('02:39:43') datenum('02:39:51') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return