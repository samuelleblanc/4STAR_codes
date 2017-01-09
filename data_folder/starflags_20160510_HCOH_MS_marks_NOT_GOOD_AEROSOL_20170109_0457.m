function marks = starflags_20160510_HCOH_MS_marks_NOT_GOOD_AEROSOL_20170109_0457  
 % starflags file for 20160510 created by MS on 20170109_0457 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20170109_0457'); 
 daystr = '20160510';  
 % tag = 3: t 
 % tag = 700: bad_aod 
 marks=[ 
 datenum('01:25:33') datenum('07:33:50') 03 
datenum('01:25:33') datenum('-23:25:44') 700 
datenum('01:26:31') datenum('-23:26:31') 700 
datenum('01:26:39') datenum('-23:26:52') 700 
datenum('01:26:57') datenum('-23:53:38') 700 
datenum('01:53:40') datenum('-23:55:58') 700 
datenum('01:56:01') datenum('-21:02:44') 700 
datenum('03:02:46') datenum('07:33:14') 700 
datenum('31:33:16') datenum('07:33:27') 700 
datenum('31:33:29') datenum('07:33:50') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return