function marks = starflags_20170812_SL_marks_OTHER_FLAGGED_EVENTS_20170820_1047  
 % starflags file for 20170812 created by SL on 20170820_1047 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170820_1047'); 
 daystr = '20170812';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:21:02') datenum('08:19:34') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return