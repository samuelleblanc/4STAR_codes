function marks = starflags_20160512_CWV_MS_marks_NOT_GOOD_AEROSOL_20160513_0601  
 % starflags file for 20160512 created by MS on 20160513_0601 to mark NOT_GOOD_AEROSOL conditions 
 version_set('20160513_0601'); 
 daystr = '20160512';  
 % tag = 700: bad_aod 
 marks=[ 
 datenum('23:49:54') datenum('23:49:54') 700 
datenum('24:07:47') datenum('24:07:47') 700 
datenum('24:36:17') datenum('24:54:01') 700 
datenum('26:26:53') datenum('26:58:54') 700 
datenum('27:20:45') datenum('27:20:46') 700 
datenum('27:20:48') datenum('27:21:15') 700 
datenum('27:23:31') datenum('27:23:32') 700 
datenum('27:24:40') datenum('27:24:43') 700 
datenum('27:24:51') datenum('27:24:52') 700 
];  
marks(:,1:2)=marks(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
return