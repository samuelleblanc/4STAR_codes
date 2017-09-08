function marks = starflags_20170818_O3_MS_marks_ALL_20170908_0929  
 % starflags file for 20170818 created by MS on 20170908_0929 to mark ALL conditions 
 version_set('20170908_0929'); 
 daystr = '20170818';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('11:18:02') datenum('11:34:11') 10 
datenum('13:25:19') datenum('13:35:36') 10 
datenum('13:48:31') datenum('13:55:11') 10 
datenum('14:00:52') datenum('14:05:39') 10 
datenum('14:11:01') datenum('14:12:53') 10 
datenum('14:31:10') datenum('14:32:48') 10 
datenum('14:41:34') datenum('14:43:54') 10 
datenum('14:47:24') datenum('14:47:50') 10 
datenum('15:08:46') datenum('15:10:32') 10 
datenum('15:17:27') datenum('15:24:23') 10 
datenum('15:31:37') datenum('15:32:37') 10 
datenum('15:34:22') datenum('15:39:00') 10 
datenum('15:43:20') datenum('16:08:33') 10 
datenum('17:22:12') datenum('17:26:32') 10 
datenum('17:29:09') datenum('17:31:45') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return