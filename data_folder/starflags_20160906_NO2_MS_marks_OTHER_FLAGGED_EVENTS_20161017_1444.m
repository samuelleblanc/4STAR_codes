function marks = starflags_20160906_NO2_MS_marks_OTHER_FLAGGED_EVENTS_20161017_1444  
 % starflags file for 20160906 created by MS on 20161017_1444 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20161017_1444'); 
 daystr = '20160906';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('14:47:36') datenum('14:47:53') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return