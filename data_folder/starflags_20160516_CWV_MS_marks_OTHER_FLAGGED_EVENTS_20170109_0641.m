function marks = starflags_20160516_CWV_MS_marks_OTHER_FLAGGED_EVENTS_20170109_0641  
 % starflags file for 20160516 created by MS on 20170109_0641 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170109_0641'); 
 daystr = '20160516';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('07:16:45') datenum('07:19:18') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return