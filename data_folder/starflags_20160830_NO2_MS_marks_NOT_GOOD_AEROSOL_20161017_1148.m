function marks = starflags_20160830_NO2_MS_marks_NOT_GOOD_AEROSOL_20161017_1148  
 % starflags file for 20160830 created by MS on 20161017_1148 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1148'); 
 daystr = '20160830';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:20:25') datenum('08:32:50') 03 
datenum('06:20:25') datenum('06:21:05') 02 
datenum('08:32:48') datenum('08:32:50') 02 
datenum('06:20:25') datenum('07:10:36') 700 
datenum('07:23:05') datenum('07:24:51') 700 
datenum('07:26:24') datenum('07:30:31') 700 
datenum('07:32:22') datenum('07:32:27') 700 
datenum('07:37:08') datenum('07:43:57') 700 
datenum('07:51:33') datenum('07:51:37') 700 
datenum('08:09:53') datenum('08:09:58') 700 
datenum('08:28:01') datenum('08:32:50') 700 
datenum('06:20:35') datenum('06:20:35') 10 
datenum('06:20:39') datenum('06:20:41') 10 
datenum('06:20:44') datenum('06:20:45') 10 
datenum('06:20:48') datenum('06:20:50') 10 
datenum('06:20:53') datenum('06:20:57') 10 
datenum('06:21:01') datenum('06:21:01') 10 
datenum('06:21:04') datenum('06:21:04') 10 
datenum('07:23:05') datenum('07:24:51') 10 
datenum('08:27:47') datenum('08:32:49') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return