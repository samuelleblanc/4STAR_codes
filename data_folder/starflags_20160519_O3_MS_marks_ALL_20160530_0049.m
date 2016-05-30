function marks = starflags_20160519_O3_MS_marks_ALL_20160530_0049  
 % starflags file for 20160519 created by MS on 20160530_0049 to mark ALL conditions 
 version_set('20160530_0049'); 
 daystr = '20160519';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:45:01') datenum('01:46:00') 700 
datenum('02:48:09') datenum('02:49:12') 700 
datenum('03:31:52') datenum('03:32:50') 700 
datenum('04:31:44') datenum('04:32:48') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return