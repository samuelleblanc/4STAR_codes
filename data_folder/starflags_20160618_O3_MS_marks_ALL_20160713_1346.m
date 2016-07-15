function marks = starflags_20160618_O3_MS_marks_ALL_20160713_1346  
 % starflags file for 20160618 created by MS on 20160713_1346 to mark ALL conditions 
 version_set('20160713_1346'); 
 daystr = '20160618';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('15:53:28') datenum('16:10:38') 700 
datenum('19:31:01') datenum('19:31:01') 700 
datenum('19:31:03') datenum('19:31:13') 700 
datenum('19:31:15') datenum('19:33:02') 700 
datenum('19:33:05') datenum('19:33:09') 700 
datenum('19:34:53') datenum('19:36:03') 700 
datenum('20:02:24') datenum('20:04:29') 700 
datenum('20:37:19') datenum('20:40:17') 700 
datenum('20:58:45') datenum('21:00:35') 700 
datenum('21:00:38') datenum('21:00:46') 700 
datenum('21:14:35') datenum('21:16:21') 700 
datenum('21:21:57') datenum('21:23:00') 700 
datenum('21:50:38') datenum('21:52:10') 700 
datenum('22:09:14') datenum('22:09:17') 700 
datenum('22:09:20') datenum('22:10:20') 700 
datenum('22:30:16') datenum('22:32:05') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return