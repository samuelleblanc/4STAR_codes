function plotLangley(daystr,suffix,mod)
%--------------------------------------
% routine to plot c0 values from a given Langley*.dat file
% for both VIS/NIR
% daystr is in the form of 'yyyymmdd'
% suffix is the special string that describes the measurement: 
% e.g., 'refined_Langley_MLO'
% mod is 'refined' or 'modified' langley
%--------------------------------------------------------------------------

% Michal Segal-Rozenhaimer, 2016-01-09, MLO

% upload files and read
%----------------------

visName = strcat(daystr,'_VIS_C0_',suffix);
nirName = strcat(daystr,'_NIR_C0_',suffix);
visc0 = importdata(strcat(starpaths,visName,'.dat'));
nirc0 = importdata(strcat(starpaths,nirName,'.dat'));

% plot c0
%--------
if strcmp(mod,'refined')
        figure(1);
        subplot(211); plot(visc0.data(:,2),visc0.data(:,3),'-b','linewidth',2);
        ylabel('c0 count rate');xlim([300 1000]);legend('VIS spectrometer');title(daystr);
        subplot(212); plot(nirc0.data(:,2),nirc0.data(:,3),'-r','linewidth',2);
        xlabel('wavelength');ylabel('c0 count rate');xlim([1000 1700]);legend('SWIR spectrometer');
        
elseif strcmp(mod,'modified')
    
        figure(1);
        plot(visc0.data(:,2),visc0.data(:,3),'-b','linewidth',2);
        xlabel('wavelength');ylabel('modified c0 count rate');xlim([300 1000]);legend('VIS spectrometer');title(daystr);

end



% save figure
%-------------
fi=[strcat(starpaths, 'figs\', daystr, suffix)];
save_fig(1,fi,false);

% test NAAMES c0
% 20151118_VIS_C0_sunrise_refined_Langley_on_C130_screened_3.0x