function marks = starflags_20170807_MS_marks_OTHER_FLAGGED_EVENTS_20170817_2303  
 % starflags file for 20170807 created by MS on 20170817_2303 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170817_2303'); 
 daystr = '20170807';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('09:28:39') datenum('10:11:09') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return