function rad = FOV_3star
% Reads 3STAR csv data file and "ErrorData" to obtain FOV scans.
% Would be nice to have the actual El values in order to convert the Az
% angles into scattering angle
fov_file = getfullname('*.csv','bio_raw', 'Select the radiometer file with FOV measurements');
bid = fopen(fov_file); [~,fov_fname,fx] = fileparts(fov_file);
AA = textscan(bid, ['%s %s %f %f %f',repmat(' %f',[1,38]),' %*[^\n]'],'delimiter',',','headerlines',1);
fclose(bid);
DT = datenum(AA{1},'mm/dd/yyyy HH:MM:SS');
% figure; plot(DT, [AA{5},AA{6},AA{7},AA{8},AA{9},AA{10}],'.');
% dynamicDateTicks
% legend('Li 320','Li340','Li380','Li412','Li443','Li490')
rad.time = DT; 
rad.wl = [320,340,380,412,443,490,510,532,555,589,625,670,683,710,780,875,1020,1245,1640];
rad.Li = [AA{5},AA{6},AA{7},AA{8},AA{9},AA{10},AA{11},AA{12},AA{13},AA{14},AA{15},AA{16},AA{17},AA{18},AA{19},AA{20},AA{21},AA{22},AA{23}];
AA(5:23) = [];
rad.Lt = [AA{5},AA{6},AA{7},AA{8},AA{9},AA{10},AA{11},AA{12},AA{13},AA{14},AA{15},AA{16},AA{17},AA{18},AA{19},AA{20},AA{21},AA{22},AA{23}];

err_file= getfullname('ErrorData*.txt','bio_err','Select the error file');
err_id = fopen(err_file);[~,err_fname,ex] =fileparts(err_file);
BB = textscan(err_id,'%f %f %f %s %*s %f %*s %f %*s %f %*s %f %*[^\n]','delimiter',',');
fclose(err_id);
B_date = datenum(double(BB{1}),double(BB{2}),double(BB{3}));
datestr(B_date(1))
B_time_ = datenum(BB{4}); 
B_time =B_time_ - floor(B_time_(1)) + B_date;
datestr(B_time(1))
datestr(B_time(end));
bio_err.time = B_time;
bio_err.Az_true = BB{7}; 
bio_err.El_true = BB{8};


err_ij = interp1(bio_err.time, (1:length(bio_err.time)),rad.time,'nearest');
rad.Az_true = bio_err.Az_true(err_ij);
rad.El_true = bio_err.El_true(err_ij);

El_scan_i = find(rad.El_true<-30 & abs(rad.Az_true) < 2,1,'first');
El_scan_j = find(rad.El_true>30 & abs(rad.Az_true) < 2,1,'last');
El = (El_scan_i:El_scan_j)';
Az_scan_i = find(rad.Az_true<-30 & abs(rad.El_true) < 2,1,'first');
Az_scan_j = find(rad.Az_true>30 & abs(rad.El_true) < 2,1,'last');
Az = (Az_scan_i:Az_scan_j)';
figure_(1); 
ss(1) = subplot(2,1,1); dynamicDateTicks
plot(rad.time, rad.Li,'.');
ss(2) = subplot(2,1,2); dynamicDateTicks
plot(rad.time(El),rad.El_true(El), 'go',...
    rad.time(Az),rad.Az_true(Az), 'cx',...
    rad.time,rad.Az_true,'.', rad.time, rad.El_true,'.');
legend('El','Az')
linkaxes(ss,'x');

rad.Li_Az_mid = sum(rad.Li(Az,:) .* (rad.Az_true(Az)*ones([1,19])))./sum(rad.Li(Az,:));
rad.Li_El_mid = sum(rad.Li(El,:) .* (rad.El_true(El)*ones([1,19])))./sum(rad.Li(El,:));
rad.Lt_Az_mid = sum(rad.Lt(Az,:) .* (rad.Az_true(Az)*ones([1,19])))./sum(rad.Lt(Az,:));
rad.Lt_El_mid = sum(rad.Lt(El,:) .* (rad.El_true(El)*ones([1,19])))./sum(rad.Lt(El,:));

rad.El_rnd = round(rad.El_true*100)./100; 
El_rnd = round(rad.El_true(El)*100)./100; 
El_rnd = unique(El_rnd);
    Es = rad.El_rnd(El);
    Lis = rad.Li(El,:);Lts = rad.Lt(El,:);
for E =length(El_rnd):-1:1
    rad.Li_El(E,:) = mean(Lis(Es==El_rnd(E),:));
    rad.Lt_El(E,:) = mean(Lts(Es==El_rnd(E),:));
end

rad.Az_rnd = round(rad.Az_true*100)./100; 
Az_rnd = round(rad.Az_true(Az)*100)./100; 
Az_rnd = unique(Az_rnd);
    As = rad.Az_rnd(Az);
    Lis = rad.Li(Az,:);Lts = rad.Lt(Az,:);
for A =length(Az_rnd):-1:1
    rad.Li_Az(A,:) = mean(Lis(As==Az_rnd(A),:));
    rad.Lt_Az(A,:) = mean(Lts(As==Az_rnd(A),:));
end

for ch = 19:-1:1
    x_ = abs(Az_rnd - rad.Li_Az_mid(ch))<4;
    [P] = polyfit(Az_rnd(x_),rad.Li_Az(x_,ch),1);
    rad.Li_Az_I(ch) = polyval(P,rad.Li_Az_mid(ch));
    rad.Li_Az_m(ch) = P(1)./rad.Li_Az_I(ch);

    x_ = abs(El_rnd - rad.Li_El_mid(ch))<4;
    [P] = polyfit(El_rnd(x_),rad.Li_El(x_,ch),1);
    rad.Li_El_I(ch) = polyval(P,rad.Li_El_mid(ch));
    rad.Li_El_m(ch) = P(1)./rad.Li_El_I(ch);
    
    x_ = abs(Az_rnd - rad.Lt_Az_mid(ch))<4;
    [P] = polyfit(Az_rnd(x_),rad.Lt_Az(x_,ch),1);
    rad.Lt_Az_I(ch) = polyval(P,rad.Lt_Az_mid(ch));
    rad.Lt_Az_m(ch) = P(1)./rad.Lt_Az_I(ch);

    x_ = abs(El_rnd - rad.Lt_El_mid(ch))<4;
    [P] = polyfit(El_rnd(x_),rad.Lt_El(x_,ch),1);
    rad.Lt_El_I(ch) = polyval(P,rad.Lt_El_mid(ch));
    rad.Lt_El_m(ch) = P(1)./rad.Lt_El_I(ch);
end

figure_(4); 
axl(1) = subplot(2,2,1); lin = plot(Az_rnd, rad.Li_Az,'.');recolor(lin,rad.wl);
hold('on'); plot(rad.Li_Az_mid, rad.Li_Az_I,'*'); hold('off')
ylabel('Li')
axl(2) = subplot(2,2,3); lin = plot(Az_rnd, rad.Lt_Az,'.');recolor(lin,rad.wl)
hold('on'); plot(rad.Lt_Az_mid, rad.Lt_Az_I,'*');hold('off')
xlabel('Az scan'); ylabel('Lt')

axl(3) = subplot(2,2,2); lin = plot(El_rnd, rad.Li_El,'.');recolor(lin,rad.wl);
tl = title(err_fname); set(tl,'interp','none');
hold('on'); plot(rad.Li_El_mid, rad.Li_El_I,'*'); hold('off') 
axl(4) = subplot(2,2,4); lin = plot(El_rnd, rad.Lt_El,'.');recolor(lin,rad.wl)
hold('on'); plot(rad.Lt_El_mid, rad.Lt_El_I,'*');hold('off')
xlabel('El scan'); 
linkaxes(axl,'xy');

saveas(4,strrep(fov_file,'raw_fov.csv','.fig'));
menu('Zoom into figure as desired, click OK to save PNG file.','OK');
saveas(4,strrep(fov_file,'raw_fov.csv','.png'));


figure_(5);
ax2(1) = subplot(2,2,1); 
lin = plot(Az_rnd, rad.Li_Az./(ones(size(Az_rnd))*rad.Li_Az_I),'-');
recolor(lin,[1:19]);
tl = title([fov_fname,fx]); set(tl,'interp','none');
ylabel('Li')
ax2(2) = subplot(2,2,3); 
lin = plot(Az_rnd, rad.Lt_Az./(ones(size(Az_rnd))*rad.Lt_Az_I),'-');
recolor(lin,[1:19]);
xlabel('Az scan'); ylabel('Lt')

ax2(3) = subplot(2,2,2); 
lin = plot(El_rnd, rad.Li_El./(ones(size(El_rnd))*rad.Li_El_I),'-');
recolor(lin,[1:19]);
tl = title([err_fname,ex]); set(tl,'interp','none');
ax2(4) = subplot(2,2,4); 
lin = plot(El_rnd, rad.Lt_El./(ones(size(El_rnd))*rad.Lt_El_I),'-');
recolor(lin,[1:19]);
xlabel('El scan'); 
linkaxes(ax2,'xy');

saveas(4,strrep(fov_file,'normalized_fov.csv','.fig'));

menu('Zoom into figure as desired, click OK to save PNG file.','OK');
saveas(4,strrep(fov_file,'normalized_fov.csv','.png'));

return