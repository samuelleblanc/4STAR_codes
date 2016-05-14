function marks = starflags_20160513_MS_marks_CLOUD_EVENTS_20160513_2304  
 % starflags file for 20160513 created by MS on 20160513_2304 to mark CLOUD_EVENTS conditions 
 version_set('20160513_2304'); 
 daystr = '20160513';  
 % tag = 90: cirrus 
 marks=[ 
 datenum('04:29:38') datenum('04:31:17') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return