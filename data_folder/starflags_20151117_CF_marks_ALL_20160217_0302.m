function marks = starflags_20151117_CF_marks_ALL_20160217_0302  
 % starflags file for 20151117 created by CF on 20160217_0302 to mark ALL conditions 
 daystr = '20151117';  
 % tag = 1: unknown 
 % tag = 10: unspecified_clouds 
 % tag = 90: cirrus 
 marks=[ 
 datenum('10:13:45') datenum('10:29:59') 01 
datenum('14:30:00') datenum('14:30:59') 10 
datenum('16:20:01') datenum('16:25:59') 10 
datenum('16:33:00') datenum('16:35:59') 10 
datenum('14:43:30') datenum('14:53:09') 90 
datenum('15:43:34') datenum('16:19:52') 90 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return