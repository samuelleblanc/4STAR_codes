function avgLangley(dates)

% function that averages Langley files from
% different date files and saves an avg. file
%---------------------------------------------
% written by MS, 2014-11-18, NASA Ames

%% load files
filesuffix='modified_Langley_at_MLO_screened_2.0x';
for i=1:length(dates)
    lab = strcat('L',dates{i});
    dat.(lab) = importdata(strcat(dates{i}, '_VIS_C0_',filesuffix, '.dat'));
    % smooth specific spectra
    if strcmp(dates{i},'20130709')
        dat.(lab).data(:,3) = smooth(dat.(lab).data(:,3));
    end
end
%%

%% calc avg and std
Langdata = zeros(length(dat.(lab).data(:,3)),length(dates));
for i=1:length(dates)
    lab = strcat('L',dates{i});
    Langdata(:,i) = dat.(lab).data(:,3);
end

LangAvg = mean(Langdata,2);
LangStd = std (Langdata,[],2);
%%

%% test plot
wln = dat.(lab).data(:,2);
figure;
for i=1:length(dates)
    lab = strcat('L',dates{i});
    plot(wln,Langdata(:,i),'-','color',[0.9 0.1 i/5]);hold on;
    axis([900 990 0 200]);
end
legend(dates);
figure;
plot(wln,LangAvg,'-b','linewidth',1.5);           hold on;
plot(wln,LangAvg + LangStd,'--r','linewidth',1.5);hold on;
plot(wln,LangAvg - LangStd,'--r','linewidth',1.5);hold on;
xlabel('wavelength');ylabel('counts');legend(['Avg Langley ' dates{1} ' - ' dates{end}], 'Std Langley');
axis([min(dat.(lab).data(:,2)) max(dat.(lab).data(:,2)) 0 1000]);
%%

%% save to new c0 file
source = [dates{1} '-' dates{end}];
filesuffix2save = 'modified_Langley_at_MLO_screened_2.0std_averagethru20130711.dat';
visfilename=fullfile(starpaths, [dates{1} '_VIS_C0_' filesuffix2save '.dat']);
additionalnotes='Modified Langley processed for 0.8823-0.9945 micron region';
starsavec0(visfilename, source, additionalnotes, wln , LangAvg', LangStd');
%%

