function marks = starflags_20170807_CWV_MS_marks_CLOUD_EVENTS_20170906_1622  
 % starflags file for 20170807 created by MS on 20170906_1622 to mark CLOUD_EVENTS conditions 
 version_set('20170906_1622'); 
 daystr = '20170807';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('10:00:12') datenum('10:16:39') 10 
datenum('12:44:30') datenum('12:46:03') 10 
datenum('12:51:55') datenum('12:52:44') 10 
datenum('12:57:03') datenum('12:57:37') 10 
datenum('13:28:26') datenum('13:28:58') 10 
datenum('13:30:07') datenum('13:34:18') 10 
datenum('13:38:53') datenum('13:41:31') 10 
datenum('19:13:53') datenum('19:33:52') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return