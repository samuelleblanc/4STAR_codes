function marks = starflags_20160512_CWV_MS_marks_CLOUD_EVENTS_20170109_0521  
 % starflags file for 20160512 created by MS on 20170109_0521 to mark CLOUD_EVENTS conditions 
 version_set('20170109_0521'); 
 daystr = '20160512';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('03:22:45') datenum('03:23:30') 03 
datenum('03:23:33') datenum('03:24:32') 03 
datenum('03:24:34') datenum('03:24:34') 03 
datenum('03:24:36') datenum('03:24:38') 03 
datenum('03:24:48') datenum('03:24:50') 03 
datenum('03:24:53') datenum('03:24:53') 03 
datenum('03:24:34') datenum('03:24:34') 700 
datenum('03:24:48') datenum('03:24:48') 700 
datenum('03:24:53') datenum('03:24:53') 700 
datenum('03:22:45') datenum('03:23:30') 10 
datenum('03:23:33') datenum('03:24:32') 10 
datenum('03:24:34') datenum('03:24:34') 10 
datenum('03:24:36') datenum('03:24:38') 10 
datenum('03:24:48') datenum('03:24:50') 10 
datenum('03:24:53') datenum('03:24:53') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return