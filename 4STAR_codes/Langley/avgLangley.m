function avgLangley(dates)

% function that averages Langley files from
% different date files and saves an avg. file
% example: avgLangley({'20140917' '20141002'})
% MS: 2015-02-03, added avg for ARISE c0
% MS: 2016-02-01, added c0 mean for MLO
%---------------------------------------------
% written by MS, 2014-11-18, NASA Ames

%% load files
%filesuffix='modified_Langley_at_MLO_screened_2.0x';% c0mod for SEAC4RS
filesuffix='modified_Langley_MLO';                     % c0/mod for ARISE/MLO
filesuffix='refined_Langley_MLO_wFORJcorr';            % c0 for ARISE/MLO
for i=1:length(dates)
    lab = strcat('L',dates{i});
    dat.vis.(lab) = importdata(strcat(dates{i}, '_VIS_C0_',filesuffix, '.dat'));
    dat.nir.(lab) = importdata(strcat(dates{i}, '_NIR_C0_',filesuffix, '.dat'));
    % smooth specific spectra
    if strcmp(dates{i},'20130709')
        dat.vis.(lab).data(:,3) = smooth(dat.vis.(lab)(:,3));
        dat.nir.(lab).data(:,3) = smooth(dat.nir.(lab)(:,3));
    end
end
%%

%% calc avg and std
Langdatavis = zeros(length(dat.vis.(lab).data(:,3)),length(dates));
Langdatanir = zeros(length(dat.nir.(lab).data(:,3)),length(dates));
for i=1:length(dates)
    lab = strcat('L',dates{i});
    Langdatavis(:,i) = dat.vis.(lab).data(:,3);
    Langdatanir(:,i) = dat.nir.(lab).data(:,3);
end

LangAvgVis = nanmean(Langdatavis,2);
LangStdVis = nanstd (Langdatavis,[],2);
LangStdVis_rel = 100*(LangStdVis./LangAvgVis);
%LangStdVis_rel = 100*((Langdatavis(:,1) - Langdatavis(:,2) )./Langdatavis(:,2) );
LangAvgNir = nanmean(Langdatanir,2);
LangStdNir = nanstd (Langdatanir,[],2);
LangStdNir_rel = 100*(LangStdNir./LangAvgNir);
%%

%% test plot
wlnvis = dat.vis.(lab).data(:,2);
wlnnir = dat.nir.(lab).data(:,2);
figure;
for i=1:length(dates)
    lab = strcat('L',dates{i});
    plot(wlnvis,Langdatavis(:,i),'-','color',[0.9 0.1+i/5 i/10],'linewidth',2);hold on;
    %axis([900 990 0 200]);
    axis([300 1000 0 700]);
end
xlabel('wavelength');ylabel('counts');
legend(dates);
% vis
figure;
subplot(211);
plot(wlnvis,LangAvgVis,'-b','linewidth',1.5);              hold on;
plot(wlnvis,LangAvgVis + LangStdVis,'--r','linewidth',1.5);hold on;
plot(wlnvis,LangAvgVis - LangStdVis,'--r','linewidth',1.5);hold on;
xlabel('wavelength');ylabel('counts');legend(['Avg Langley ' dates{1} ' - ' dates{end}], 'Std Langley');
axis([300 1000 0 1000]);
axis([800 1000 0 200]);
subplot(212)
plot(wlnvis,LangStdVis_rel,'.b');
xlabel('wavelength');ylabel('relative std (%)');
axis([300 1000 -30 30]);
axis([800 1000 -30 30]);
% nir
figure;
subplot(211)
plot(wlnnir,LangAvgNir,'-b','linewidth',1.5);           hold on;
plot(wlnnir,LangAvgNir + LangStdNir,'--r','linewidth',1.5);hold on;
plot(wlnnir,LangAvgNir - LangStdNir,'--r','linewidth',1.5);hold on;
xlabel('wavelength');ylabel('counts');legend(['Avg Langley ' dates{1} ' - ' dates{end}], 'Std Langley');
axis([min(dat.nir.(lab).data(:,2)) max(dat.nir.(lab).data(:,2)) -5 15]);
subplot(212)
plot(wlnnir,LangStdNir_rel,'.b');
xlabel('wavelength');ylabel('relative std (%)');
axis([1000 1700 0 50]);
%%

%% save to new c0 file
%vis
source = [dates{1} '-' dates{end}];
filesuffix2save = 'refined_Langley_at_MLO_screened_2.0std_averagethru20160113';
filesuffix2save = 'refined_Langley_at_MLO_screened_2.0std_averagethru20160113_wFORJcorr';
visfilename=fullfile(starpaths, [dates{1} '_VIS_C0_' filesuffix2save '.dat']);
additionalnotes='Refined Langley processed excluding "bump" region at ~2.5 airmass for each of the days (20160109-20160113)';
additionalnotes='Refined Langley processed excluding "bump" region at ~2.5 airmass for each of the days (20160109-20160113, excluding 20160111) with FORJ correction';
starsavec0(visfilename, source, additionalnotes, wlnvis , LangAvgVis', LangStdVis');


%nir
source = [dates{1} '-' dates{end}];
filesuffix2save = 'refined_Langley_at_MLO_screened_2.0std_averagethru20160113';
filesuffix2save = 'refined_Langley_at_MLO_screened_2.0std_averagethru20160113_wFORJcorr';
nirfilename=fullfile(starpaths, [dates{1} '_NIR_C0_' filesuffix2save '.dat']);
additionalnotes='Refined Langley processed excluding "bump" region at ~2.5 airmass for each of the days (20160109-20160113)';
additionalnotes='Refined Langley processed excluding "bump" region at ~2.5 airmass for each of the days (20160109-20160113, excluding 20160111) with FORJ correction';
starsavec0(nirfilename, source, additionalnotes, wlnnir , LangAvgNir', LangStdNir');

% modified
source = [dates{1} '-' dates{end}];
filesuffix2save = 'modified_Langley_at_MLO_screened_2.0std_averagethru20160113';
visfilename=fullfile(starpaths, [dates{1} '_VIS_C0_' filesuffix2save '.dat']);
additionalnotes='Modified Langley processed for 0.8823-0.9945 micron region';
starsavec0(visfilename, source, additionalnotes, wlnvis , LangAvgVis', LangStdVis');
%%

