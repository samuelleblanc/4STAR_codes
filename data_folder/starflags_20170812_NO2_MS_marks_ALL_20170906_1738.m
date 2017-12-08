function marks = starflags_20170812_NO2_MS_marks_ALL_20170906_1738  
 % starflags file for 20170812 created by MS on 20170906_1738 to mark ALL conditions 
 version_set('20170906_1738'); 
 daystr = '20170812';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('07:21:02') datenum('08:19:34') 700 
datenum('08:27:19') datenum('08:36:18') 700 
datenum('09:07:28') datenum('09:09:07') 700 
datenum('10:10:59') datenum('10:12:44') 700 
datenum('10:57:41') datenum('10:58:40') 700 
datenum('10:59:14') datenum('10:59:54') 700 
datenum('11:28:58') datenum('11:32:06') 700 
datenum('12:07:19') datenum('12:11:15') 700 
datenum('13:07:47') datenum('13:11:19') 700 
datenum('13:25:14') datenum('13:47:05') 700 
datenum('14:33:03') datenum('14:54:17') 700 
datenum('14:57:47') datenum('15:07:39') 700 
datenum('15:11:28') datenum('15:17:44') 700 
datenum('13:48:04') datenum('14:18:24') 10 
datenum('15:17:47') datenum('15:23:34') 10 
datenum('15:29:59') datenum('15:33:28') 10 
datenum('15:39:39') datenum('15:46:20') 10 
datenum('16:15:25') datenum('16:16:24') 10 
datenum('16:21:16') datenum('16:32:10') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return