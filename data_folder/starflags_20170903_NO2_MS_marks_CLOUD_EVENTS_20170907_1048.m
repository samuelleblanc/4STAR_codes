function marks = starflags_20170903_NO2_MS_marks_CLOUD_EVENTS_20170907_1048  
 % starflags file for 20170903 created by MS on 20170907_1048 to mark CLOUD_EVENTS conditions 
 version_set('20170907_1048'); 
 daystr = '20170903';  
 % tag = 10: unspecified_clouds 
 marks=[ 
 datenum('16:32:59') datenum('16:34:48') 10 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return