function marks = starflags_20160831_SL_marks_OTHER_FLAGGED_EVENTS_20160904_1609  
 % starflags file for 20160831 created by SL on 20160904_1609 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160904_1609'); 
 daystr = '20160831';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('05:46:33') datenum('05:46:52') 02 
datenum('15:44:42') datenum('15:45:10') 02 
datenum('15:45:16') datenum('15:45:17') 02 
datenum('15:45:24') datenum('15:47:47') 02 
datenum('15:47:52') datenum('15:48:11') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return