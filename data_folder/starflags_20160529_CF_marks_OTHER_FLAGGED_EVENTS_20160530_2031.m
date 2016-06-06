function marks = starflags_20160529_CF_marks_OTHER_FLAGGED_EVENTS_20160530_2031  
 % starflags file for 20160529 created by CF on 20160530_2031 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160530_2031'); 
 daystr = '20160529';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('22:09:17') datenum('22:57:39') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return