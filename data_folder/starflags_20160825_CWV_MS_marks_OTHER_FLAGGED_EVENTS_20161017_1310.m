function marks = starflags_20160825_CWV_MS_marks_OTHER_FLAGGED_EVENTS_20161017_1310  
 % starflags file for 20160825 created by MS on 20161017_1310 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20161017_1310'); 
 daystr = '20160825';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('10:28:42') datenum('10:46:16') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return