function marks = starflags_20170828_CWV_MS_marks_CLOUD_EVENTS_20170907_1115  
 % starflags file for 20170828 created by MS on 20170907_1115 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1115'); 
 daystr = '20170828';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('13:22:37') datenum('13:23:11') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return