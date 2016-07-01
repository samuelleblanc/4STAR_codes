function marks = starflags_20160617_MS_marks_CLOUD_EVENTS_20160701_1219  
 % starflags file for 20160617 created by MS on 20160701_1219 to mark CLOUD_EVENTS conditions 
 version_set('20160701_1219'); 
 daystr = '20160617';  
 % tag = 90: cirrus 
 marks=[ 
 datenum('17:00:32') datenum('17:01:06') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return