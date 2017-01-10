function marks = starflags_20160604_NO2_MS_marks_CLOUD_EVENTS_20170109_2107  
 % starflags file for 20160604 created by MS on 20170109_2107 to mark CLOUD_EVENTS conditions 
 version_set('20170109_2107'); 
 daystr = '20160604';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:51:20') datenum('23:52:23') 700 
datenum('23:52:25') datenum('23:52:26') 700 
datenum('24:42:23') datenum('24:47:49') 700 
datenum('24:48:53') datenum('24:50:34') 700 
datenum('24:50:36') datenum('24:56:29') 700 
datenum('24:57:02') datenum('24:59:47') 700 
datenum('25:17:19') datenum('25:19:26') 700 
datenum('25:58:51') datenum('26:11:08') 700 
datenum('26:16:04') datenum('26:17:54') 700 
datenum('26:17:56') datenum('26:18:01') 700 
datenum('26:18:03') datenum('26:19:01') 700 
datenum('26:19:31') datenum('26:20:17') 700 
datenum('31:29:09') datenum('31:35:11') 700 
datenum('23:51:20') datenum('23:52:26') 10 
datenum('24:42:23') datenum('24:47:52') 10 
datenum('24:48:11') datenum('24:59:47') 10 
datenum('25:17:19') datenum('25:19:26') 10 
datenum('25:58:51') datenum('26:11:08') 10 
datenum('26:16:04') datenum('26:17:54') 10 
datenum('26:17:56') datenum('26:18:01') 10 
datenum('26:18:03') datenum('26:19:01') 10 
datenum('26:19:31') datenum('26:20:17') 10 
datenum('31:29:09') datenum('31:35:11') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return