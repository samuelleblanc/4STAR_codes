function marks = starflags_20160526_CF_marks_OTHER_FLAGGED_EVENTS_20160601_1538  
 % starflags file for 20160526 created by CF on 20160601_1538 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160601_1538'); 
 daystr = '20160526';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('02:33:03') datenum('02:57:17') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return