function marks = starflags_20170821_SL_marks_OTHER_FLAGGED_EVENTS_20170826_1500  
 % starflags file for 20170821 created by SL on 20170826_1500 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20170826_1500'); 
 daystr = '20170821';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('09:27:59') datenum('11:13:02') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return