
% read horilegs from H segments during KORUS
% and generate files for further plotting

% 20160501

daystr='20160501';

horilegs_t=[datenum('2016-05-01 22:30:00') datenum('2016-05-01 23:06:03'); ...
datenum('2016-05-01 23:47:41') datenum('2016-05-02 00:38:03'); ...
datenum('2016-05-02 00:46:51') datenum('2016-05-02 01:15:49'); ...
datenum('2016-05-02 01:22:36') datenum('2016-05-02 01:39:19'); ...
datenum('2016-05-02 01:43:57') datenum('2016-05-02 02:07:26'); ...
datenum('2016-05-02 02:12:14') datenum('2016-05-02 02:29:37'); ...
datenum('2016-05-02 02:31:07') datenum('2016-05-02 02:57:48'); ...
datenum('2016-05-02 03:39:16') datenum('2016-05-02 04:19:15'); ...
datenum('2016-05-02 04:28:39') datenum('2016-05-02 04:58:14'); ...
datenum('2016-05-02 05:04:36') datenum('2016-05-02 05:12:11'); ...
datenum('2016-05-02 05:15:03') datenum('2016-05-02 05:39:04'); ...
datenum('2016-05-02 05:49:12') datenum('2016-05-02 05:59:02')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160503

daystr='20160503';

horilegs_t=[datenum('2016-05-03 23:49:16') datenum('2016-05-04 00:36:03'); ...
datenum('2016-05-04 00:51:38') datenum('2016-05-04 01:29:34'); ...
datenum('2016-05-04 01:31:55') datenum('2016-05-04 01:59:08'); ...
datenum('2016-05-04 02:13:26') datenum('2016-05-04 02:48:25'); ...
datenum('2016-05-04 03:23:46') datenum('2016-05-04 03:58:27'); ...
datenum('2016-05-04 04:12:15') datenum('2016-05-04 04:54:43'); ...
datenum('2016-05-04 04:56:50') datenum('2016-05-04 05:36:23'); ...
datenum('2016-05-04 05:39:24') datenum('2016-05-04 05:57:38'); ...
datenum('2016-05-04 05:59:32') datenum('2016-05-04 06:24:25')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');


% 20160504

daystr='20160504';

horilegs_t=[datenum('2016-05-04 22:50:03') datenum('2016-05-04 22:59:33'); ...
datenum('2016-05-04 23:02:44') datenum('2016-05-04 23:07:15'); ...
datenum('2016-05-04 23:41:17') datenum('2016-05-05 00:15:56'); ...
datenum('2016-05-05 00:37:10') datenum('2016-05-05 01:12:21'); ...
datenum('2016-05-05 01:14:28') datenum('2016-05-05 01:58:09'); ...
datenum('2016-05-05 02:03:38') datenum('2016-05-05 02:38:07')];


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160506

daystr='20160506';

horilegs_t=[datenum('2016-05-06 23:43:33') datenum('2016-05-07 00:52:23'); ...
datenum('2016-05-07 01:12:17') datenum('2016-05-07 01:17:10'); ...
datenum('2016-05-07 01:20:52') datenum('2016-05-07 01:57:46'); ...
datenum('2016-05-07 01:59:49') datenum('2016-05-07 02:33:00'); ...
datenum('2016-05-07 02:35:02') datenum('2016-05-07 03:16:54'); ...
datenum('2016-05-07 03:27:44') datenum('2016-05-07 04:07:55'); ...
datenum('2016-05-07 04:11:12') datenum('2016-05-07 04:40:02'); ...
datenum('2016-05-07 04:42:27') datenum('2016-05-07 05:15:13'); ...
datenum('2016-05-07 05:27:52') datenum('2016-05-07 06:02:37')];


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160510

daystr='20160510';

horilegs_t=[datenum('2016-05-10 23:03:42') datenum('2016-05-10 23:10:25'); ...
datenum('2016-05-10 23:43:49') datenum('2016-05-11 00:22:27'); ...
datenum('2016-05-11 01:19:56') datenum('2016-05-11 01:26:38'); ...
datenum('2016-05-11 01:35:47') datenum('2016-05-11 03:10:55'); ...
datenum('2016-05-11 03:18:41') datenum('2016-05-11 04:37:17'); ...
datenum('2016-05-11 04:38:38') datenum('2016-05-11 05:02:56'); ...
datenum('2016-05-11 05:04:05') datenum('2016-05-11 05:26:49'); ...
datenum('2016-05-11 05:35:42') datenum('2016-05-11 05:51:17'); ...
datenum('2016-05-11 05:53:12') datenum('2016-05-11 06:05:05')];


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160511

daystr='20160511';

horilegs_t=[datenum('2016-05-11 23:07:24') datenum('2016-05-11 23:13:19'); ...
datenum('2016-05-11 23:47:50') datenum('2016-05-12 00:18:37'); ...
datenum('2016-05-12 00:33:23') datenum('2016-05-12 01:49:17'); ...
datenum('2016-05-12 01:58:46') datenum('2016-05-12 02:23:02'); ...
datenum('2016-05-12 03:06:25') datenum('2016-05-12 03:35:04'); ...
datenum('2016-05-12 03:51:51') datenum('2016-05-12 04:15:59'); ...
datenum('2016-05-12 04:37:23') datenum('2016-05-12 04:48:54'); ...
datenum('2016-05-12 04:53:03') datenum('2016-05-12 05:17:28'); ...
datenum('2016-05-12 05:25:01') datenum('2016-05-12 06:08:19')];


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160512

daystr='20160512';

horilegs_t=[datenum('2016-05-12 23:19:10') datenum('2016-05-12 23:46:19'); ...
datenum('2016-05-12 23:56:36') datenum('2016-05-13 00:04:45'); ...
datenum('2016-05-13 00:15:06') datenum('2016-05-13 00:32:28'); ...
datenum('2016-05-13 01:00:19') datenum('2016-05-13 01:07:12'); ...
datenum('2016-05-13 01:13:27') datenum('2016-05-13 02:16:47'); ...
datenum('2016-05-13 02:29:41') datenum('2016-05-13 02:46:08'); ...
datenum('2016-05-13 02:59:53') datenum('2016-05-13 03:11:50'); ...
datenum('2016-05-13 03:29:08') datenum('2016-05-13 03:38:50')];


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160516

daystr='20160516';

horilegs_t=[datenum('2016-05-16 23:00:21') datenum('2016-05-16 23:06:51'); ...
datenum('2016-05-16 23:41:36') datenum('2016-05-17 00:16:06'); ...
datenum('2016-05-17 00:28:45') datenum('2016-05-17 00:42:38'); ...
datenum('2016-05-17 00:45:36') datenum('2016-05-17 00:54:42'); ...
datenum('2016-05-17 01:00:32') datenum('2016-05-17 01:23:29'); ...
datenum('2016-05-17 01:24:49') datenum('2016-05-17 02:06:12'); ...
datenum('2016-05-17 02:09:09') datenum('2016-05-17 02:48:20'); ...
datenum('2016-05-17 03:28:57') datenum('2016-05-17 04:02:25'); ...
datenum('2016-05-17 04:28:05') datenum('2016-05-17 04:56:53'); ...
datenum('2016-05-17 04:59:38') datenum('2016-05-17 05:31:54'); ...
datenum('2016-05-17 05:33:42') datenum('2016-05-17 06:11:14')];


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160517

daystr='20160517';

horilegs_t=[datenum('2016-05-17 23:51:59') datenum('2016-05-18 00:41:52'); ...
datenum('2016-05-18 00:58:42') datenum('2016-05-18 02:12:56'); ...
datenum('2016-05-18 02:15:15') datenum('2016-05-18 02:43:08'); ...
datenum('2016-05-18 02:45:49') datenum('2016-05-18 03:13:17'); ...
datenum('2016-05-18 03:47:05') datenum('2016-05-18 04:17:32'); ...
datenum('2016-05-18 04:32:09') datenum('2016-05-18 04:43:38'); ...
datenum('2016-05-18 04:49:56') datenum('2016-05-18 04:53:21'); ...
datenum('2016-05-18 04:55:20') datenum('2016-05-18 06:51:23')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160519

daystr='20160519';

horilegs_t=[datenum('2016-05-19 23:09:58') datenum('2016-05-19 23:15:16'); ...
datenum('2016-05-19 23:53:04') datenum('2016-05-20 00:35:12'); ...
datenum('2016-05-20 00:51:07') datenum('2016-05-20 02:08:10'); ...
datenum('2016-05-20 02:10:43') datenum('2016-05-20 02:49:57'); ...
datenum('2016-05-20 03:26:00') datenum('2016-05-20 03:56:37'); ...
datenum('2016-05-20 04:13:47') datenum('2016-05-20 04:20:38'); ...
datenum('2016-05-20 04:25:25') datenum('2016-05-20 04:54:26'); ...
datenum('2016-05-20 04:57:42') datenum('2016-05-20 05:29:53'); ...
datenum('2016-05-20 05:29:53') datenum('2016-05-20 06:04:38'); ...
datenum('2016-05-20 06:12:22') datenum('2016-05-20 06:21:45')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160521

daystr='20160521';

horilegs_t=[datenum('2016-05-21 23:01:18') datenum('2016-05-21 23:05:52'); ...
datenum('2016-05-21 23:37:32') datenum('2016-05-22 00:12:34'); ...
datenum('2016-05-22 00:31:12') datenum('2016-05-22 04:50:24'); ...
datenum('2016-05-22 04:58:01') datenum('2016-05-22 05:13:38'); ...
datenum('2016-05-22 06:42:47') datenum('2016-05-22 07:43:55')];

% convert t to utcHr
% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160524
daystr='20160524';

horilegs_t=[datenum('2016-05-24 22:59:03') datenum('2016-05-24 23:04:55'); ...
datenum('2016-05-24 23:44:51') datenum('2016-05-25 01:10:45'); ...
datenum('2016-05-25 01:46:13') datenum('2016-05-25 02:53:46'); ...
datenum('2016-05-25 02:57:50') datenum('2016-05-25 04:55:40'); ...
datenum('2016-05-25 05:05:30') datenum('2016-05-25 05:40:05'); ...
datenum('2016-05-25 05:56:19') datenum('2016-05-25 06:17:06'); ...
datenum('2016-05-25 06:18:53') datenum('2016-05-25 06:38:43')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160526

daystr='20160526';

horilegs_t=[datenum('2016-05-26 03:08:11') datenum('2016-05-26 03:14:04'); ...
datenum('2016-05-26 03:15:37') datenum('2016-05-26 03:21:53'); ...
datenum('2016-05-26 03:49:06') datenum('2016-05-26 04:21:32'); ...
datenum('2016-05-26 04:24:46') datenum('2016-05-26 04:51:52'); ...
datenum('2016-05-26 04:54:55') datenum('2016-05-26 05:25:53'); ...
datenum('2016-05-26 05:29:34') datenum('2016-05-26 05:37:23'); ...
datenum('2016-05-26 05:41:04') datenum('2016-05-26 05:47:33'); ...
datenum('2016-05-26 05:48:42') datenum('2016-05-26 06:11:01'); ...
datenum('2016-05-26 06:12:46') datenum('2016-05-26 06:16:37'); ...
datenum('2016-05-26 06:47:32') datenum('2016-05-26 06:50:38')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160529

daystr='20160529';

horilegs_t=[datenum('2016-05-29 23:20:24') datenum('2016-05-29 23:42:15'); ...
datenum('2016-05-29 23:45:32') datenum('2016-05-29 23:53:15'); ...
datenum('2016-05-30 00:06:45') datenum('2016-05-30 00:11:55'); ...
datenum('2016-05-30 00:39:06') datenum('2016-05-30 01:15:58'); ...
datenum('2016-05-30 01:35:20') datenum('2016-05-30 02:16:20'); ...
datenum('2016-05-30 02:19:18') datenum('2016-05-30 02:24:36'); ...
datenum('2016-05-30 02:28:29') datenum('2016-05-30 02:53:36'); ...
datenum('2016-05-30 03:22:55') datenum('2016-05-30 03:55:34'); ...
datenum('2016-05-30 04:16:03') datenum('2016-05-30 06:21:17'); ...
datenum('2016-05-30 07:00:38') datenum('2016-05-30 07:04:12')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160530

daystr='20160530';

horilegs_t=[datenum('2016-05-30 22:57:34') datenum('2016-05-30 23:04:02'); ...
datenum('2016-05-30 23:35:00') datenum('2016-05-31 00:27:46'); ...
datenum('2016-05-31 00:44:57') datenum('2016-05-31 01:21:46'); ...
datenum('2016-05-31 01:26:37') datenum('2016-05-31 01:58:48'); ...
datenum('2016-05-31 02:04:55') datenum('2016-05-31 02:09:05'); ...
datenum('2016-05-31 02:10:08') datenum('2016-05-31 02:34:04'); ...
datenum('2016-05-31 02:40:06') datenum('2016-05-31 02:49:12'); ...
datenum('2016-05-31 02:51:13') datenum('2016-05-31 03:01:47'); ...
datenum('2016-05-31 03:02:46') datenum('2016-05-31 03:08:16'); ...
datenum('2016-05-31 03:35:02') datenum('2016-05-31 03:52:33'); ...
datenum('2016-05-31 04:32:09') datenum('2016-05-31 05:07:50'); ...
datenum('2016-05-31 05:46:18') datenum('2016-05-31 06:00:29'); ...
datenum('2016-05-31 06:02:12') datenum('2016-05-31 06:14:48')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160601

daystr='20160601';

horilegs_t=[datenum('2016-06-01 23:03:17') datenum('2016-06-01 23:08:04'); ...
datenum('2016-06-01 23:39:51') datenum('2016-06-02 00:09:33'); ...
datenum('2016-06-02 00:20:26') datenum('2016-06-02 01:04:12'); ...
datenum('2016-06-02 01:05:56') datenum('2016-06-02 01:41:32'); ...
datenum('2016-06-02 01:44:25') datenum('2016-06-02 02:49:48'); ...
datenum('2016-06-02 03:29:48') datenum('2016-06-02 04:06:33'); ...
datenum('2016-06-02 04:16:41') datenum('2016-06-02 04:41:20'); ...
datenum('2016-06-02 04:44:45') datenum('2016-06-02 05:03:15'); ...
datenum('2016-06-02 05:08:26') datenum('2016-06-02 06:09:31')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160602

daystr='20160602';

horilegs_t=[datenum('2016-06-02 23:01:59') datenum('2016-06-02 23:06:23'); ...
datenum('2016-06-02 23:41:31') datenum('2016-06-03 00:13:44'); ...
datenum('2016-06-03 00:28:08') datenum('2016-06-03 01:06:51'); ...
datenum('2016-06-03 01:08:20') datenum('2016-06-03 01:42:58'); ...
datenum('2016-06-03 01:44:54') datenum('2016-06-03 02:08:27'); ...
datenum('2016-06-03 02:18:02') datenum('2016-06-03 02:50:06'); ...
datenum('2016-06-03 02:54:04') datenum('2016-06-03 02:58:08'); ...
datenum('2016-06-03 03:28:15') datenum('2016-06-03 04:03:33'); ...
datenum('2016-06-03 04:31:33') datenum('2016-06-03 04:55:19'); ...
datenum('2016-06-03 05:09:47') datenum('2016-06-03 06:10:17'); ...
datenum('2016-06-03 06:49:38') datenum('2016-06-03 06:54:53')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160604

daystr='20160604';

horilegs_t=[datenum('2016-06-04 23:05:53') datenum('2016-06-04 23:09:21'); ...
datenum('2016-06-04 23:22:06') datenum('2016-06-04 23:26:30'); ...
datenum('2016-06-04 23:37:08') datenum('2016-06-04 23:41:19'); ...
datenum('2016-06-04 23:51:42') datenum('2016-06-04 23:55:59'); ...
datenum('2016-06-05 00:28:14') datenum('2016-06-05 00:47:52'); ...
datenum('2016-06-05 01:05:58') datenum('2016-06-05 01:31:12'); ...
datenum('2016-06-05 01:32:55') datenum('2016-06-05 01:39:45'); ...
datenum('2016-06-05 01:43:06') datenum('2016-06-05 03:58:40'); ...
datenum('2016-06-05 04:09:51') datenum('2016-06-05 05:04:29'); ...
datenum('2016-06-05 05:06:56') datenum('2016-06-05 05:09:21'); ...
datenum('2016-06-05 05:13:39') datenum('2016-06-05 06:38:05'); ...
datenum('2016-06-05 06:41:22') datenum('2016-06-05 06:45:34'); ...
datenum('2016-06-05 07:11:29') datenum('2016-06-05 07:17:01')];

% convert t to utcHr
% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160608

daystr='20160608';

horilegs_t=[datenum('2016-06-08 23:24:33') datenum('2016-06-08 23:28:22'); ...
datenum('2016-06-09 00:04:03') datenum('2016-06-09 00:27:09'); ...
datenum('2016-06-09 00:47:11') datenum('2016-06-09 02:56:50'); ...
datenum('2016-06-09 02:59:19') datenum('2016-06-09 03:03:22'); ...
datenum('2016-06-09 03:34:57') datenum('2016-06-09 04:05:22'); ...
datenum('2016-06-09 04:17:07') datenum('2016-06-09 04:58:01'); ...
datenum('2016-06-09 04:58:55') datenum('2016-06-09 05:41:37'); ...
datenum('2016-06-09 05:43:50') datenum('2016-06-09 06:28:20'); ...
datenum('2016-06-09 06:32:24') datenum('2016-06-09 06:33:53')];

% convert t to utcHr
% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');

% 20160609

daystr='20160609';

horilegs_t=[datenum('2016-06-09 23:02:49') datenum('2016-06-09 23:08:22'); ...
datenum('2016-06-09 23:40:53') datenum('2016-06-10 00:14:38'); ...
datenum('2016-06-10 00:53:13') datenum('2016-06-10 01:57:19'); ...
datenum('2016-06-10 02:03:20') datenum('2016-06-10 02:09:24'); ...
datenum('2016-06-10 02:13:24') datenum('2016-06-10 02:59:53'); ...
datenum('2016-06-10 03:03:15') datenum('2016-06-10 03:11:35'); ...
datenum('2016-06-10 03:41:01') datenum('2016-06-10 04:10:13'); ...
datenum('2016-06-10 04:20:13') datenum('2016-06-10 04:58:35'); ...
datenum('2016-06-10 04:59:42') datenum('2016-06-10 05:36:34'); ...
datenum('2016-06-10 05:41:54') datenum('2016-06-10 06:24:40'); ...
datenum('2016-06-10 06:29:05') datenum('2016-06-10 06:30:53')];

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);% this is in meters
%qual_flag = aod_ict.data(:,5);


% find vh indices for altitudes of below 500m
ok  = [];

for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
    ok = [ok;ok_];
end

% save .txt file

aod_dat_tc     = aod_ict.data(ok,:);
gas_dat_tc     = gas_ict.data(ok,:);

save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');


% 20160614

% daystr='20160614';
% 
% horilegs_t=[datenum('0000-06-14 06:31:44') datenum('0000-06-14 07:33:54'); ...
% datenum('0000-06-14 07:39:47') datenum('0000-06-14 13:29:21'); ...
% datenum('0000-06-14 14:25:56') datenum('0000-06-14 16:52:17'); ...
% datenum('0000-06-14 17:17:42') datenum('0000-06-14 21:05:05')];
% 
% % convert t to utcHr
% horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
% horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
% horilegs_utc(:,2) = t2utch(horilegs_t(:,2));
% 
% % load ict.csv files:
% 
% aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
% gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));
% 
% ict_utc = (aod_ict.data(:,1)/86400)*24;
% ict_alt = aod_ict.data(:,4);% this is in meters
% %qual_flag = aod_ict.data(:,5);
% 
% 
% % find vh indices for altitudes of below 500m
% ok  = [];
% 
% for i=1:length(horilegs_utc)
%     
%     ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
%     ok = [ok;ok_];
% end
% 
% % save .txt file
% 
% aod_dat_tc     = aod_ict.data(ok,:);
% gas_dat_tc     = gas_ict.data(ok,:);
% 
% save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
% save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');
% 
% % 20160617
% 
% daystr='20160617';
% 
% horilegs_t=[datenum('2016-06-17 17:27:53') datenum('2016-06-17 17:34:05'); ...
% datenum('2016-06-17 17:54:39') datenum('2016-06-17 18:01:31'); ...
% datenum('2016-06-17 18:23:11') datenum('2016-06-17 18:29:18'); ...
% datenum('2016-06-17 18:43:34') datenum('2016-06-17 18:50:08'); ...
% datenum('2016-06-17 19:01:23') datenum('2016-06-17 19:06:13'); ...
% datenum('2016-06-17 19:13:17') datenum('2016-06-17 19:19:29'); ...
% datenum('2016-06-17 19:49:57') datenum('2016-06-17 19:57:14'); ...
% datenum('2016-06-17 20:18:40') datenum('2016-06-17 20:25:09'); ...
% datenum('2016-06-17 20:43:31') datenum('2016-06-17 20:57:47'); ...
% datenum('2016-06-17 21:26:26') datenum('2016-06-17 21:29:38'); ...
% datenum('2016-06-17 21:46:17') datenum('2016-06-17 22:00:15')];
% 
% % convert t to utcHr
% horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
% horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
% horilegs_utc(:,2) = t2utch(horilegs_t(:,2));
% 
% % load ict.csv files:
% 
% aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
% gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));
% 
% ict_utc = (aod_ict.data(:,1)/86400)*24;
% ict_alt = aod_ict.data(:,4);% this is in meters
% %qual_flag = aod_ict.data(:,5);
% 
% 
% % find vh indices for altitudes of below 500m
% ok  = [];
% 
% for i=1:length(horilegs_utc)
%     
%     ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
%     ok = [ok;ok_];
% end
% 
% % save .txt file
% 
% aod_dat_tc     = aod_ict.data(ok,:);
% gas_dat_tc     = gas_ict.data(ok,:);
% 
% save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
% save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');
% 
% % 20160618
% 
% daystr='20160618';
% 
% horilegs_t=[datenum('2016-06-18 17:12:25') datenum('2016-06-18 17:45:10'); ...
% datenum('2016-06-18 17:58:28') datenum('2016-06-18 20:39:24'); ...
% datenum('2016-06-18 20:43:21') datenum('2016-06-18 20:49:45'); ...
% datenum('2016-06-18 20:58:44') datenum('2016-06-18 21:20:32'); ...
% datenum('2016-06-18 22:23:04') datenum('2016-06-18 22:34:41')];
% 
% % convert t to utcHr
% horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
% horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
% horilegs_utc(:,2) = t2utch(horilegs_t(:,2));
% 
% % load ict.csv files:
% 
% aod_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_R0aod.csv'));
% gas_ict = importdata(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_R0gas.csv'));
% 
% ict_utc = (aod_ict.data(:,1)/86400)*24;
% ict_alt = aod_ict.data(:,4);% this is in meters
% %qual_flag = aod_ict.data(:,5);
% 
% 
% % find vh indices for altitudes of below 500m
% ok  = [];
% 
% for i=1:length(horilegs_utc)
%     
%     ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=500);
%     ok = [ok;ok_];
% end
% 
% % save .txt file
% 
% aod_dat_tc     = aod_ict.data(ok,:);
% gas_dat_tc     = gas_ict.data(ok,:);
% 
% save(strcat('E:\MichalsData\KORUS-AQ\aod_ict\',daystr,'_aod_tc.dat'),'-ASCII','aod_dat_tc');
% save(strcat('E:\MichalsData\KORUS-AQ\gas_ict\',daystr,'_gas_tc.dat'),'-ASCII','gas_dat_tc');
% 
% 
% 
% 
