function marks = starflags_20160519_SL_marks_OTHER_FLAGGED_EVENTS_20160521_1543  
 % starflags file for 20160519 created by SL on 20160521_1543 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160521_1543'); 
 daystr = '20160519';  
 % tag = 2: before_or_after_flight 
 marks=[ 
 datenum('22:08:25') datenum('23:05:12') 02 
datenum('31:11:55') datenum('31:12:00') 02 
datenum('31:12:06') datenum('31:12:25') 02 
datenum('31:12:48') datenum('31:13:02') 02 
datenum('31:13:05') datenum('31:13:20') 02 
datenum('31:13:22') datenum('31:13:25') 02 
datenum('31:13:28') datenum('31:17:34') 02 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return