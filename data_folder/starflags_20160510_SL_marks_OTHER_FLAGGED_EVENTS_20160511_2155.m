function marks = starflags_20160510_SL_marks_OTHER_FLAGGED_EVENTS_20160511_2155  
 % starflags file for 20160510 created by SL on 20160511_2155 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160511_2155'); 
 daystr = '20160510';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('01:25:33') datenum('22:59:31') 02 
datenum('31:06:44') datenum('31:33:50') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return