function marks = starflags_20170831_NO2_MS_marks_NOT_GOOD_AEROSOL_20170903_0147  
 % starflags file for 20170831 created by MS on 20170903_0147 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170903_0147'); 
 daystr = '20170831';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('10:23:59') datenum('10:23:59') 700 
datenum('13:22:54') datenum('13:22:54') 700 
datenum('13:24:55') datenum('13:24:55') 700 
datenum('13:26:47') datenum('13:26:49') 700 
datenum('13:27:03') datenum('13:27:05') 700 
datenum('16:36:50') datenum('16:37:48') 700 
datenum('09:36:28') datenum('09:53:59') 10 
datenum('13:17:33') datenum('13:18:41') 10 
datenum('13:21:55') datenum('13:22:49') 10 
datenum('13:22:52') datenum('13:22:52') 10 
datenum('13:22:56') datenum('13:24:53') 10 
datenum('13:24:56') datenum('13:24:58') 10 
datenum('13:25:02') datenum('13:25:02') 10 
datenum('13:25:05') datenum('13:26:37') 10 
datenum('13:26:51') datenum('13:27:02') 10 
datenum('15:51:25') datenum('16:00:59') 10 
datenum('16:01:41') datenum('16:03:43') 10 
datenum('16:06:50') datenum('16:14:05') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return