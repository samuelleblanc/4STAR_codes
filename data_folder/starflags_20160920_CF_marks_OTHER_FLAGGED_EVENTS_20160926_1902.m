function marks = starflags_20160920_CF_marks_OTHER_FLAGGED_EVENTS_20160926_1902  
 % starflags file for 20160920 created by CF on 20160926_1902 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160926_1902'); 
 daystr = '20160920';  
 % tag = 500: hor_legs 
 marks=[ 
 datenum('07:11:51') datenum('07:26:06') 500 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return