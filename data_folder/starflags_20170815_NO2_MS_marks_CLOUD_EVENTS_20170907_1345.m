function marks = starflags_20170815_NO2_MS_marks_CLOUD_EVENTS_20170907_1345  
 % starflags file for 20170815 created by MS on 20170907_1345 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1345'); 
 daystr = '20170815';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('14:18:20') datenum('14:20:30') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return