function marks = starflags_20160920_CF_marks_OTHER_FLAGGED_EVENTS_20160924_1530  
 % starflags file for 20160920 created by CF on 20160924_1530 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160924_1530'); 
 daystr = '20160920';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('14:59:10') datenum('15:00:11') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return