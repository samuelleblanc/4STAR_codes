function marks = starflags_20160512_HCOH_MS_marks_OTHER_FLAGGED_EVENTS_20170109_0531  
 % starflags file for 20160512 created by MS on 20170109_0531 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170109_0531'); 
 daystr = '20160512';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('03:38:51') datenum('03:40:37') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return