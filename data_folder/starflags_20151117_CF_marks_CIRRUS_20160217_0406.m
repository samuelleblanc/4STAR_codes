function marks = starflags_20151117_CF_marks_CIRRUS_20160217_0406  
 % starflags file for 20151117 created by CF on 20160217_0406 to mark CIRRUS conditions 
 daystr = '20151117';  
 % tag = 10: unspecified_clouds 
 % tag = 90: cirrus 
 % tag = 500: hor_legs 
 marks=[ 
 datenum('12:31:32') datenum('12:31:32') 10 
datenum('12:31:34') datenum('12:31:34') 10 
datenum('12:17:49') datenum('12:17:50') 90 
datenum('12:21:01') datenum('12:21:01') 90 
datenum('12:31:32') datenum('12:31:32') 90 
datenum('12:31:34') datenum('12:31:34') 90 
datenum('12:17:49') datenum('12:17:50') 500 
datenum('12:21:01') datenum('12:21:01') 500 
datenum('12:31:32') datenum('12:31:32') 500 
datenum('12:31:34') datenum('12:31:34') 500 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return