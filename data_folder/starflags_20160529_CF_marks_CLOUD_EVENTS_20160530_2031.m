function marks = starflags_20160529_CF_marks_CLOUD_EVENTS_20160530_2031  
 % starflags file for 20160529 created by CF on 20160530_2031 to mark CLOUD_EVENTS conditions 
 version_set('20160530_2031'); 
 daystr = '20160529';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('02:40:20') datenum('02:41:34') 10 
datenum('02:41:41') datenum('02:43:06') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return