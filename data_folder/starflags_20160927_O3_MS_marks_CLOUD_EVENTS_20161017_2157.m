function marks = starflags_20160927_O3_MS_marks_CLOUD_EVENTS_20161017_2157  
 % starflags file for 20160927 created by MS on 20161017_2157 to mark CLOUD_EVENTS conditions 
 version_set('20161017_2157'); 
 daystr = '20160927';  
 % tag = 3: t 
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('09:40:57') datenum('09:45:24') 03 
datenum('09:58:42') datenum('10:00:06') 03 
datenum('17:22:03') datenum('17:40:23') 03 
datenum('09:40:57') datenum('09:41:07') 700 
datenum('09:45:24') datenum('09:45:24') 700 
datenum('09:59:11') datenum('10:00:06') 700 
datenum('17:22:59') datenum('17:23:21') 700 
datenum('17:24:27') datenum('17:24:59') 700 
datenum('17:29:05') datenum('17:29:06') 700 
datenum('17:33:30') datenum('17:34:08') 700 
datenum('17:34:52') datenum('17:34:53') 700 
datenum('17:34:58') datenum('17:35:39') 700 
datenum('17:38:48') datenum('17:39:30') 700 
datenum('09:40:57') datenum('09:45:24') 10 
datenum('09:58:42') datenum('10:00:06') 10 
datenum('17:22:03') datenum('17:40:23') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return