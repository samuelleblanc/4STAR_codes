function marks = starflags_20160511_CWV_MS_marks_OTHER_FLAGGED_EVENTS_20170109_0459  
 % starflags file for 20160511 created by MS on 20170109_0459 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170109_0459'); 
 daystr = '20160511';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:12:31') datenum('07:17:07') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return