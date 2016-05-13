function marks = starflags_20160511_O3_MS_marks_NOT_GOOD_AEROSOL_20160513_0544  
 % starflags file for 20160511 created by MS on 20160513_0544 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160513_0544'); 
 daystr = '20160511';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('02:34:01') datenum('02:36:17') 700 
datenum('02:39:14') datenum('02:40:18') 700 
datenum('02:48:53') datenum('02:49:57') 700 
datenum('03:36:05') datenum('03:36:08') 700 
datenum('03:37:05') datenum('03:37:09') 700 
datenum('06:25:54') datenum('06:26:27') 700 
datenum('06:27:32') datenum('06:27:43') 700 
datenum('06:27:47') datenum('06:27:57') 700 
datenum('06:28:05') datenum('06:28:32') 700 
datenum('06:28:45') datenum('06:29:04') 700 
datenum('06:29:10') datenum('06:29:16') 700 
datenum('06:29:19') datenum('06:29:22') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return