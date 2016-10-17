function marks = starflags_20160830_HCOH_MS_marks_OTHER_FLAGGED_EVENTS_20161017_1305  
 % starflags file for 20160830 created by MS on 20161017_1305 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20161017_1305'); 
 daystr = '20160830';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('06:20:25') datenum('06:21:05') 02 
datenum('08:32:48') datenum('08:32:50') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return