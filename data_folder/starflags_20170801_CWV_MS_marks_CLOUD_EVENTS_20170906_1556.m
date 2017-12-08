function marks = starflags_20170801_CWV_MS_marks_CLOUD_EVENTS_20170906_1556  
 % starflags file for 20170801 created by MS on 20170906_1556 to mark CLOUD_EVENTS conditions 
 version_set('20170906_1556'); 
 daystr = '20170801';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('16:48:39') datenum('16:48:43') 10 
datenum('17:23:49') datenum('17:23:51') 10 
datenum('17:25:33') datenum('17:25:35') 10 
datenum('17:38:55') datenum('17:38:55') 10 
datenum('17:39:03') datenum('17:39:03') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return