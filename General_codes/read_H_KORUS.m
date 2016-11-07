
% read horilegs from H segments during KORUS
% and generate files for further plotting

% 20160827

daystr='20160827';

horilegs_t=[datenum('08:16:13') datenum('09:47:03'); ...
datenum('10:01:33') datenum('10:49:05'); ...
datenum('11:06:10') datenum('14:13:24'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');

% 20160830

daystr='20160830';

horilegs_t=[datenum('07:21:14') datenum('08:15:18'); ...
datenum('08:20:46') datenum('08:25:52'); ...
datenum('08:30:55') datenum('08:31:56'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160831

daystr='20160831';

horilegs_t=[datenum('11:51:05') datenum('12:31:18'); ...
datenum('12:58:15') datenum('13:14:50'); ...
datenum('13:44:37') datenum('13:54:58'); ...
datenum('14:31:20') datenum('15:30:23'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160902

daystr='20160902';

horilegs_t=[datenum('07:17:10') datenum('07:23:42'); ...
datenum('07:26:02') datenum('08:10:27'); ...
datenum('08:25:19') datenum('08:41:14'); ...
datenum('09:17:28') datenum('09:30:45'); ...
datenum('09:52:51') datenum('10:13:17'); ...
datenum('10:39:13') datenum('10:51:02'); ...
datenum('11:09:07') datenum('11:25:11'); ...
datenum('11:26:53') datenum('11:35:41'); ...
datenum('11:52:47') datenum('12:12:02'); ...
datenum('13:43:21') datenum('14:39:48'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160904

daystr='20160904';

horilegs_t=[datenum('08:11:23') datenum('08:40:27'); ...
datenum('08:45:10') datenum('08:49:31'); ...
datenum('09:28:27') datenum('09:33:21'); ...
datenum('09:55:09') datenum('10:05:27'); ...
datenum('10:59:28') datenum('11:09:10'); ...
datenum('11:21:57') datenum('11:24:32'); ...
datenum('11:27:09') datenum('11:55:15'); ...
datenum('12:08:35') datenum('13:13:09'); ...
datenum('13:33:27') datenum('13:38:24'); ...
datenum('13:40:13') datenum('14:55:31'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160906

daystr='20160906';

horilegs_t=[datenum('07:07:29') datenum('07:15:39'); ...
datenum('07:33:32') datenum('07:55:35'); ...
datenum('08:16:35') datenum('09:01:57'); ...
datenum('09:08:56') datenum('09:27:22'); ...
datenum('09:39:47') datenum('11:31:52'); ...
datenum('12:36:45') datenum('13:25:31'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);


% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


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

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160910

daystr='20160910';

horilegs_t=[datenum('07:59:13') datenum('08:29:23'); ...
datenum('08:47:14') datenum('08:57:02'); ...
datenum('09:10:59') datenum('09:20:43'); ...
datenum('10:10:34') datenum('10:20:17'); ...
datenum('10:33:07') datenum('10:38:53'); ...
datenum('10:43:26') datenum('10:55:59'); ...
datenum('11:26:49') datenum('11:34:11'); ...
datenum('11:52:19') datenum('12:04:31'); ...
datenum('12:17:12') datenum('12:27:32'); ...
datenum('13:28:04') datenum('14:22:30'); ...
datenum('14:36:23') datenum('14:46:19'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160912

daystr='20160912';

horilegs_t=[datenum('07:58:00') datenum('10:59:52'); ...
datenum('11:21:54') datenum('12:21:40'); ...
datenum('13:23:34') datenum('14:09:18'); ...
datenum('14:30:43') datenum('15:13:45'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


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

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');



% 20160918

daystr='20160918';

horilegs_t=[datenum('07:20:18') datenum('08:33:07'); ...
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

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160920

daystr='20160920';

horilegs_t=[datenum('07:11:20') datenum('07:26:18'); ...
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

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');



% 20160924

daystr='20160924';

horilegs_t=[datenum('07:01:02') datenum('08:50:39'); ...
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

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');


% 20160925

daystr='20160925';

horilegs_t=[datenum('08:15:03') datenum('08:44:34'); ...
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

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));

ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');



% 20160927

daystr='20160927';

horilegs_t=[datenum('11:55:47') datenum('16:38:42'); ...
datenum('17:07:00') datenum('17:13:31'); ...
datenum('17:59:38') datenum('18:18:53'); ...
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);

% convert t to utcHr
horilegs_utc      = zeros(size(horilegs_t,1),size(horilegs_t,2));
horilegs_utc(:,1) = t2utch(horilegs_t(:,1));
horilegs_utc(:,2) = t2utch(horilegs_t(:,2));

% load ict.csv files:

aod_ict = importdata(strcat('E:\ORACLES\ict_files\',daystr,'_ict.csv'));
gas_ict = importdata(strcat('E:\ORACLES\gas_ict\',daystr,'_gas_ict.csv'));


ict_utc = (aod_ict.data(:,1)/86400)*24;
ict_alt = aod_ict.data(:,4);
qual_flag = aod_ict.data(:,5);

% calc Ang exp 380-865

tau_rel1 = log(aod_ict.data(:,17)./aod_ict.data(:,7));
lam_rel1 = log(0.865./0.380);
Ang380_865 = -(tau_rel1./lam_rel1);

% calc Ang exp 452-865

tau_rel2 = log(aod_ict.data(:,17)./aod_ict.data(:,8));
lam_rel2 = log(0.865./0.452);
Ang452_865 = -(tau_rel2./lam_rel2);

% find vh indices for altitudes of 600-1800 m and 0-600m

ok  = [];
ok2 = [];
for i=1:length(horilegs_utc)
    % ac - above cloud data
    ok_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=1800&ict_alt>=600&qual_flag==0);
    ok = [ok;ok_];
    % tc - total column data
    ok2_ = find(ict_utc<=horilegs_utc(i,2)&ict_utc>=horilegs_utc(i,1)&ict_alt<=600&ict_alt>=0&qual_flag==0);
    ok2 = [ok2;ok2_];
end

% save .txt file

aod_dat_ac     = aod_ict.data(ok,:);
gas_dat_ac     = gas_ict.data(ok,5:18);
ac             = [aod_dat_ac,gas_dat_ac,Ang380_865(ok),Ang452_865(ok)];

aod_dat_tc     = aod_ict.data(ok2,:);
gas_dat_tc     = gas_ict.data(ok2,5:18);
tc             = [aod_dat_tc,gas_dat_tc,Ang380_865(ok2),Ang452_865(ok2)];

save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_ac.dat'),'-ASCII','ac');
save(strcat('E:\ORACLES\4STAR_AAC\',daystr,'_4star_tc.dat'),'-ASCII','tc');



