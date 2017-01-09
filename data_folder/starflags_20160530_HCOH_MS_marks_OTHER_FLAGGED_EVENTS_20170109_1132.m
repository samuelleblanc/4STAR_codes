function marks = starflags_20160530_HCOH_MS_marks_OTHER_FLAGGED_EVENTS_20170109_1132  
 % starflags file for 20160530 created by MS on 20170109_1132 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170109_1132'); 
 daystr = '20160530';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:08:42') datenum('07:09:51') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return