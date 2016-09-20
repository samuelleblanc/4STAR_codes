function marks = starflags_20160918_SL_marks_OTHER_FLAGGED_EVENTS_20160920_1358  
 % starflags file for 20160918 created by SL on 20160920_1358 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160920_1358'); 
 daystr = '20160918';  
 % tag = 2: before_or_after_flight 
 % tag = 500: hor_legs 
 % tag = 600: vert_legs 
 marks=[ 
 datenum('05:55:25') datenum('07:04:11') 02 
datenum('07:20:04') datenum('08:33:05') 500 
datenum('08:41:32') datenum('08:50:06') 500 
datenum('08:53:33') datenum('09:08:39') 500 
datenum('09:43:20') datenum('09:57:04') 500 
datenum('12:12:29') datenum('13:48:18') 500 
datenum('07:05:01') datenum('07:20:41') 600 
datenum('08:33:07') datenum('08:41:33') 600 
datenum('09:14:46') datenum('09:43:23') 600 
datenum('11:18:31') datenum('11:40:31') 600 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return