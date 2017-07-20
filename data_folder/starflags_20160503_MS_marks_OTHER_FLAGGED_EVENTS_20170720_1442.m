function marks = starflags_20160503_MS_marks_OTHER_FLAGGED_EVENTS_20170720_1442  
 % starflags file for 20160503 created by MS on 20170720_1442 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170720_1442'); 
 daystr = '20160503';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('22:11:39') datenum('22:29:59') 02 
datenum('31:30:00') datenum('32:45:35') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return