function marks = starflags_20160830_HCOH_MS_marks_NOT_GOOD_AEROSOL_20161017_1305  
 % starflags file for 20160830 created by MS on 20161017_1305 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20161017_1305'); 
 daystr = '20160830';  
 % tag = 2: before_or_after_flight 
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('06:20:25') datenum('08:32:50') 03 
datenum('06:20:25') datenum('06:21:05') 02 
datenum('08:32:48') datenum('08:32:50') 02 
datenum('06:20:25') datenum('07:20:11') 700 
datenum('07:20:14') datenum('07:22:42') 700 
datenum('07:22:44') datenum('07:22:47') 700 
datenum('07:22:49') datenum('07:23:11') 700 
datenum('07:23:14') datenum('07:23:40') 700 
datenum('07:23:43') datenum('07:24:38') 700 
datenum('07:24:40') datenum('07:25:11') 700 
datenum('07:25:13') datenum('08:18:28') 700 
datenum('08:18:30') datenum('08:18:34') 700 
datenum('08:18:36') datenum('08:19:05') 700 
datenum('08:19:08') datenum('08:19:20') 700 
datenum('08:19:22') datenum('08:19:27') 700 
datenum('08:19:30') datenum('08:25:58') 700 
datenum('08:26:00') datenum('08:32:50') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return