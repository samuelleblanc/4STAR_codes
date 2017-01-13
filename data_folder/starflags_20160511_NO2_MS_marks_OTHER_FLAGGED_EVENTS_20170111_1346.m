function marks = starflags_20160511_NO2_MS_marks_OTHER_FLAGGED_EVENTS_20170111_1346  
 % starflags file for 20160511 created by MS on 20170111_1346 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170111_1346'); 
 daystr = '20160511';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:12:31') datenum('07:17:07') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return