function marks = starflags_20160530_NO2_MS_marks_CLOUD_EVENTS_20170109_1123  
 % starflags file for 20160530 created by MS on 20170109_1123 to mark CLOUD_EVENTS conditions 
 version_set('20170109_1123'); 
 daystr = '20160530';  
 % tag = 10: unspecified_clouds 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:53:58') datenum('23:55:00') 700 
datenum('25:14:27') datenum('25:46:06') 700 
datenum('29:26:11') datenum('29:26:11') 700 
datenum('29:27:12') datenum('29:27:12') 700 
datenum('29:27:47') datenum('29:27:49') 700 
datenum('29:27:57') datenum('29:28:39') 700 
datenum('29:28:51') datenum('29:28:52') 700 
datenum('29:29:02') datenum('29:29:02') 700 
datenum('29:29:07') datenum('29:29:12') 700 
datenum('29:29:14') datenum('29:29:14') 700 
datenum('29:29:16') datenum('29:29:18') 700 
datenum('29:29:23') datenum('29:30:14') 700 
datenum('29:30:16') datenum('29:30:21') 700 
datenum('29:30:23') datenum('29:30:23') 700 
datenum('29:30:25') datenum('29:30:26') 700 
datenum('29:30:32') datenum('29:30:32') 700 
datenum('23:53:58') datenum('23:55:00') 10 
datenum('25:14:27') datenum('25:46:06') 10 
datenum('29:25:49') datenum('29:26:09') 10 
datenum('29:26:11') datenum('29:26:12') 10 
datenum('29:27:12') datenum('29:27:12') 10 
datenum('29:27:47') datenum('29:27:49') 10 
datenum('29:27:55') datenum('29:28:40') 10 
datenum('29:28:51') datenum('29:28:52') 10 
datenum('29:29:02') datenum('29:29:03') 10 
datenum('29:29:07') datenum('29:29:12') 10 
datenum('29:29:14') datenum('29:29:18') 10 
datenum('29:29:21') datenum('29:30:26') 10 
datenum('29:30:32') datenum('29:31:42') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return