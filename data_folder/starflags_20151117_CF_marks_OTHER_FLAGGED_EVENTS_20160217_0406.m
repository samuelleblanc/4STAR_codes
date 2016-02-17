function marks = starflags_20151117_CF_marks_OTHER_FLAGGED_EVENTS_20160217_0406  
 % starflags file for 20151117 created by CF on 20160217_0406 to mark OTHER_FLAGGED_EVENTS conditions 
 daystr = '20151117';  
 % tag = 500: hor_legs 
 % tag = 600: vert_legs 
 marks=[ 
 datenum('10:35:15') datenum('14:26:07') 500 
datenum('14:42:13') datenum('14:52:58') 600 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return