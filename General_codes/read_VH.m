
% read horilegs from V_H files

% 20160827

daystr='20160827';

horilegs=[datenum('08:16:13') datenum('09:47:03'); ...
datenum('10:01:33') datenum('10:49:05'); ...
datenum('11:06:10') datenum('14:13:24'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-1500 m

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1500&ict_alt>=700&qual_flag==0);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');

% 20160908

daystr='20160908';

horilegs_t=[datenum('07:33:10') datenum('09:03:13'); ...
datenum('09:34:08') datenum('10:55:29'); ...
datenum('11:22:23') datenum('11:32:26'); ...
datenum('12:08:11') datenum('12:12:51'); ...
datenum('12:34:05') datenum('12:44:14'); ...
datenum('13:47:54') datenum('13:58:30'); ...
datenum('14:12:13') datenum('14:17:23'); ...
datenum('14:32:00') datenum('14:45:09'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-1500 m

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1500&ict_alt>=700&qual_flag==0);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');

% 20160914

daystr='20160914';

horilegs_t=[datenum('08:11:40') datenum('08:40:54'); ...
datenum('09:38:59') datenum('09:45:11'); ...
datenum('11:29:06') datenum('11:33:25'); ...
datenum('11:51:08') datenum('12:07:08'); ...
datenum('13:21:59') datenum('13:33:32'); ...
datenum('14:31:28') datenum('15:31:55'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-1500 m

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1500&ict_alt>=700);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');


% 20160918

daystr='20160918';

horilegs=[datenum('07:20:18') datenum('08:33:07'); ...
datenum('08:41:47') datenum('08:49:59'); ...
datenum('10:44:11') datenum('11:01:05'); ...
datenum('11:04:00') datenum('11:18:54'); ...
datenum('11:43:02') datenum('11:53:02'); ...
datenum('12:12:51') datenum('14:43:19'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-2000 m (here 669 vs. 944 for 1500
% vs. 2000)

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=2000&ict_alt>=700&qual_flag==0);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');

% 20160920

daystr='20160920';

horilegs=[datenum('07:11:20') datenum('07:26:18'); ...
datenum('07:29:57') datenum('08:21:27'); ...
datenum('08:47:51') datenum('08:53:33'); ...
datenum('09:22:07') datenum('10:15:17'); ...
datenum('10:30:29') datenum('10:45:32'); ...
datenum('12:17:44') datenum('12:25:25'); ...
datenum('12:58:44') datenum('13:10:08'); ...
datenum('13:41:49') datenum('14:29:02'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-1500m

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1500&ict_alt>=700&qual_flag==0);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');


% 20160924

daystr='20160924';

horilegs=[datenum('07:01:02') datenum('08:50:39'); ...
datenum('09:22:02') datenum('09:29:17'); ...
datenum('09:55:17') datenum('10:00:45'); ...
datenum('10:24:13') datenum('10:41:21'); ...
datenum('11:18:48') datenum('11:31:54'); ...
datenum('12:40:19') datenum('12:43:18'); ...
datenum('13:03:48') datenum('13:11:25'); ...
datenum('13:14:29') datenum('13:31:46'); ...
datenum('13:51:37') datenum('15:13:03'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-1500m

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1500&ict_alt>=700&qual_flag==0);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');

% 20160925

daystr='20160925';

horilegs=[datenum('08:15:03') datenum('08:44:34'); ...
datenum('08:47:24') datenum('09:25:38'); ...
datenum('09:30:04') datenum('09:52:10'); ...
datenum('10:02:17') datenum('10:09:03'); ...
datenum('10:11:36') datenum('10:35:02'); ...
datenum('12:01:05') datenum('12:48:10'); ...
datenum('12:52:56') datenum('13:09:28'); ...
datenum('15:35:49') datenum('15:52:57'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-1500m

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1500&ict_alt>=700&qual_flag==0);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');


% 20160927

daystr='20160927';

horilegs=[datenum('11:55:47') datenum('16:38:42'); ...
datenum('17:07:00') datenum('17:13:31'); ...
datenum('17:59:38') datenum('18:18:53'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));

ict_utc = (ict.data(:,1)/86400)*24;
ict_alt = ict.data(:,4);
qual_flag = ict.data(:,5);

% find vh indices for altitudes of 700-1500m

ok = [];
for i=1:length(horilegs_utc)
    
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1500&ict_alt>=700&qual_flag==0);
    ok = [ok;ok_];
end

% save .txt file

dat = ict.data(ok,:);

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_aac.dat'),'-ASCII','dat');



