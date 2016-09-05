function marks = starflags_20160830_SL_marks_BAD_AOD_20160904_1844  
 % starflags file for 20160830 created by SL on 20160904_1844 to mark BAD_AOD conditions 
 version_set('20160904_1844'); 
 daystr = '20160830';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:20:25') datenum('07:10:36') 700 
datenum('07:10:41') datenum('07:10:41') 700 
datenum('07:10:44') datenum('07:10:45') 700 
datenum('07:23:05') datenum('07:24:51') 700 
datenum('07:26:24') datenum('07:30:31') 700 
datenum('07:32:22') datenum('07:32:27') 700 
datenum('07:37:08') datenum('07:43:57') 700 
datenum('07:51:33') datenum('07:51:37') 700 
datenum('08:09:53') datenum('08:09:58') 700 
datenum('08:20:18') datenum('08:20:19') 700 
datenum('08:27:41') datenum('08:27:45') 700 
datenum('08:28:01') datenum('08:32:50') 700 
datenum('06:20:35') datenum('06:20:35') 10 
datenum('06:20:39') datenum('06:20:41') 10 
datenum('06:20:44') datenum('06:20:44') 10 
datenum('06:20:47') datenum('06:20:49') 10 
datenum('06:20:53') datenum('06:20:57') 10 
datenum('06:21:00') datenum('06:21:00') 10 
datenum('06:21:04') datenum('06:21:04') 10 
datenum('07:23:05') datenum('07:24:51') 10 
datenum('08:28:01') datenum('08:32:49') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return