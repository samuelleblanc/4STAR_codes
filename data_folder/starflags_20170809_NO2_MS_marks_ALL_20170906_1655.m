function marks = starflags_20170809_NO2_MS_marks_ALL_20170906_1655  
 % starflags file for 20170809 created by MS on 20170906_1655 to mark ALL conditions 
 version_set('20170906_1655'); 
 daystr = '20170809';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('08:43:38') datenum('09:54:23') 700 
datenum('11:26:44') datenum('12:04:53') 700 
datenum('12:37:26') datenum('12:37:26') 700 
datenum('13:26:00') datenum('13:27:01') 700 
datenum('13:40:02') datenum('13:40:02') 700 
datenum('13:40:10') datenum('13:40:10') 700 
datenum('13:56:25') datenum('14:10:18') 700 
datenum('11:13:39') datenum('11:26:42') 10 
datenum('11:26:45') datenum('11:26:45') 10 
datenum('11:26:48') datenum('11:27:40') 10 
datenum('13:25:47') datenum('13:25:58') 10 
datenum('13:27:02') datenum('13:27:07') 10 
datenum('13:38:43') datenum('13:41:22') 10 
datenum('16:18:51') datenum('16:32:02') 10 
datenum('17:19:36') datenum('17:26:02') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return