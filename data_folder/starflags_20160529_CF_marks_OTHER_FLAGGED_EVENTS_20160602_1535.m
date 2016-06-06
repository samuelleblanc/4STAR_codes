function marks = starflags_20160529_CF_marks_OTHER_FLAGGED_EVENTS_20160602_1535  
 % starflags file for 20160529 created by CF on 20160602_1535 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160602_1535'); 
 daystr = '20160529';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('22:09:29') datenum('22:31:47') 02 
datenum('22:31:54') datenum('22:50:40') 02 
datenum('22:50:46') datenum('23:00:05') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return