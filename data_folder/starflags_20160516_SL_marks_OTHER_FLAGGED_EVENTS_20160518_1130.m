function marks = starflags_20160516_SL_marks_OTHER_FLAGGED_EVENTS_20160518_1130  
 % starflags file for 20160516 created by SL on 20160518_1130 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160518_1130'); 
 daystr = '20160516';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('22:13:08') datenum('22:55:48') 02 
datenum('31:07:31') datenum('31:19:18') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return