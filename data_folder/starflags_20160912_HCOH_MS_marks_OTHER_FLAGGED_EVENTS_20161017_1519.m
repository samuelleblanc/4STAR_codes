function marks = starflags_20160912_HCOH_MS_marks_OTHER_FLAGGED_EVENTS_20161017_1519  
 % starflags file for 20160912 created by MS on 20161017_1519 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20161017_1519'); 
 daystr = '20160912';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('15:58:09') datenum('15:59:26') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return