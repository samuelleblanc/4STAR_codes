function marks = starflags_20160618_KP_marks_OTHER_FLAGGED_EVENTS_20160711_1224  
 % starflags file for 20160618 created by KP on 20160711_1224 to mark OTHER_FLAGGED_EVENTS conditions 
 version_set('20160711_1224'); 
 daystr = '20160618';  
 % tag = 2: before_or_after_flight 
 % tag = 600: vert_legs 
 % tag = 800: smoke 
 marks=[ 
 datenum('20:50:37') datenum('20:50:57') 800 
datenum('20:51:00') datenum('20:51:43') 800 
datenum('20:51:45') datenum('20:54:31') 800 
datenum('21:01:37') datenum('21:24:05') 800 
datenum('15:40:58') datenum('16:59:00') 02 
datenum('22:34:38') datenum('22:37:31') 02 
datenum('21:53:32') datenum('22:18:55') 600 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return