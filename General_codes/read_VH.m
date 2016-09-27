
% read horilegs from V_H files

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



