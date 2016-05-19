function marks = starflags_20160514_O3_MS_marks_ALL_20160517_2036  
 % starflags file for 20160514 created by MS on 20160517_2036 to mark ALL conditions 
 version_set('20160517_2036'); 
 daystr = '20160514';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('05:05:12') datenum('05:20:46') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return