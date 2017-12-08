function marks = starflags_20170813_SL_marks_OTHER_FLAGGED_EVENTS_20170826_1416  
 % starflags file for 20170813 created by SL on 20170826_1416 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170826_1416'); 
 daystr = '20170813';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:15:43') datenum('07:56:48') 02 
datenum('16:56:30') datenum('16:56:53') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return