function marks = starflags_20160824_SL_marks_OTHER_FLAGGED_EVENTS_20161021_1535  
 % starflags file for 20160824 created by SL on 20161021_1535 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20161021_1535'); 
 daystr = '20160824';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('10:37:51') datenum('11:51:55') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return