function marks = starflags_20160517_MS_marks_OTHER_FLAGGED_EVENTS_20160520_2349  
 % starflags file for 20160517 created by MS on 20160520_2349 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160520_2349'); 
 daystr = '20160517';  
 % tag = 900: dust 
 marks=[ 
 datenum('00:00:37') datenum('00:07:27') 900 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return