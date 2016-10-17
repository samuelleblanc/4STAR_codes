function marks = starflags_20160830_O3_MS_marks_NOT_GOOD_AEROSOL_20161017_1255  
 % starflags file for 20160830 created by MS on 20161017_1255 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1255'); 
 daystr = '20160830';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:20:25') datenum('08:32:50') 03 
datenum('06:20:25') datenum('06:21:05') 02 
datenum('08:32:48') datenum('08:32:50') 02 
datenum('06:20:25') datenum('07:10:36') 700 
datenum('07:22:36') datenum('07:25:20') 700 
datenum('07:26:24') datenum('07:30:31') 700 
datenum('07:32:22') datenum('07:32:27') 700 
datenum('07:37:08') datenum('07:43:57') 700 
datenum('07:51:33') datenum('07:51:37') 700 
datenum('08:09:53') datenum('08:09:58') 700 
datenum('08:27:31') datenum('08:32:50') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return