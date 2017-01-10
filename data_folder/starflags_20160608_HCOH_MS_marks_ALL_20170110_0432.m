function marks = starflags_20160608_HCOH_MS_marks_ALL_20170110_0432  
 % starflags file for 20160608 created by MS on 20170110_0432 to mark ALL conditions 
 version_set('20170110_0432'); 
 daystr = '20160608';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('21:55:53') datenum('07:32:23') 03 
datenum('21:55:53') datenum('03:14:55') 700 
datenum('27:14:58') datenum('07:32:23') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return