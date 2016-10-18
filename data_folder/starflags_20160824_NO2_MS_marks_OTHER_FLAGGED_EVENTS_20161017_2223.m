function marks = starflags_20160824_NO2_MS_marks_OTHER_FLAGGED_EVENTS_20161017_2223  
 % starflags file for 20160824 created by MS on 20161017_2223 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20161017_2223'); 
 daystr = '20160824';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('10:37:51') datenum('11:51:55') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return