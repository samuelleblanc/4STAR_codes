function make_daod_plots();
%Quick function to plot out the different daods for KORUS

daylist={'20160426' '20160501' '20160503' '20160504' '20160506' '20160510' '20160511' '20160512' '20160516' '20160517' '20160519' '20160521' '20160524' '20160526' '20160529' '20160530' '20160601' '20160602' '20160604' '20160608' '20160609' '20160614' '20160617' '20160618'} ; %put one day string
fp_out = 'C:\Users\sleblan2\Research\KORUS-AQ\plot\window_deposition\';
for i=1:length(daylist);
    daystr=daylist{i};
    infofile_ = ['starinfo_' daystr '.m'];
    infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
    s='';s.dummy = '';
    s = infofnt(s);
    
    if isfield(s,'AODuncert_mergemark_file');
        disp(['Loading the AOD uncertainty correction file: ' s.AODuncert_mergemark_file])
        d = load(s.AODuncert_mergemark_file);
        add_uncert = true; correct_aod = false;
        no_daod = false;
    elseif isfield(s,'AODuncert_constant_extra');
        disp(['Applying constant AOD factor to existing AOD'])
        d.dAODs = repmat(s.AODuncert_constant_extra,[10000,1]);
        add_uncert = true;
        d.time = linspace(s.flight(1),s.flight(2),10000);
        no_daod = false;
    else
        d.dAODs = [NaN NaN];
        d.time = s.flight;
        no_daod = true;
    end;
    
    figure;
    plot(d.time,d.dAODs(:,1).*NaN);
    hold on;
    if ~no_daod;
    ll = {'380';'452';'501';'520';'532';'550';'606';'620';'675';'781';'865';'1020';'1040';'1064';'1236';'1559';'1627'};
    cm = hsv(17);
    colormap(cm);
    
    for j=1:17;
        plot(d.time,d.dAODs(:,j),'color',cm(j,:));
    end;
    dynamicDateTicks;
    grid on;
    lcolorbar(ll','TitleString','wvl [nm]');
    xlabel('UTC time');
    ylabel('dAOD');
    title(['KORUS ' daystr ' window deposition impact']);
    else;
        legend('No window deposition correction')
    end;
   save_fig(gcf(),[fp_out 'KORUS_dAOD_' daystr],0);
end;






end