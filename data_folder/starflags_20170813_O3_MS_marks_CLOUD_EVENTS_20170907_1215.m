function marks = starflags_20170813_O3_MS_marks_CLOUD_EVENTS_20170907_1215  
 % starflags file for 20170813 created by MS on 20170907_1215 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1215'); 
 daystr = '20170813';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('14:43:10') datenum('14:47:07') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return