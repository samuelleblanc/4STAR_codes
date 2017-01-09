function marks = starflags_20160601_CWV_MS_marks_OTHER_FLAGGED_EVENTS_20170109_1135  
 % starflags file for 20160601 created by MS on 20170109_1135 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170109_1135'); 
 daystr = '20160601';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:20:16') datenum('07:25:37') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return