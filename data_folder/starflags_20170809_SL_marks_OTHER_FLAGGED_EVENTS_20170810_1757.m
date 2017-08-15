function marks = starflags_20170809_SL_marks_OTHER_FLAGGED_EVENTS_20170810_1757  
 % starflags file for 20170809 created by SL on 20170810_1757 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170810_1757'); 
 daystr = '20170809';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('09:41:14') datenum('09:43:27') 02 
datenum('09:43:32') datenum('09:44:21') 02 
datenum('09:44:27') datenum('09:44:30') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return