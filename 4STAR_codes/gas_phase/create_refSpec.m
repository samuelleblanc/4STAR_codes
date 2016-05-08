%% Details of the function:
% NAME:
%   create_refSpec
% 
% PURPOSE:
%   create reference spectrum for gas retrievals
%   for NO2 this must be used; for O3, need to
%   compare with current c0
% 
%
% CALLING SEQUENCE:
%  function ref_spec = create_refSpec(daystr,gas);
%
% INPUT:
%  - daystr: string date 'yyyymmdd'
%  - gas is gas str; 'O3' or 'NO2'
% 
% 
% OUTPUT:
%  - structure of reference spectrum: 
%    ref_spec.o3 - reference spectrum for o3
%    ref_spec.o3col - column amount to add to retrieved SCD before airmass
%    division
%    ref_spec.no2 - reference spectrum for no2
%    ref_spec.no2col - column amount to add to retrieved SCD before airmass
%    division
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%
% NEEDED FILES:
%  - none at input, but generally starsun.m from MLO for slant count rate
%
% EXAMPLE:
%  - ref_spec = create_refSpec('20160113','O3');
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MSR), Osan, Korea, 05-05-2016
% -------------------------------------------------------------------------
%% function routine

function ref_spec = create_refSpec(daystr,gas)
%-----------------------------------------------

%% load starsun
s = load([starpaths,daystr,'starsun.mat'],'t','w','rateslant','m_aero','m_O3','m_NO2');

% test figure;
% figure;
% plot(serial2Hh(s.t),s.m_aero,'.c');
% xlabel('time');ylabel('airmass');


% plot average and std of mean reference spectra
if strcmp(gas,'O3')
    
    wind   = [0.490 0.682];
    
    % find good index around solar noon to create averga espectrum
    ind = find((s.m_O3>=min(s.m_O3)-0.00001&s.m_O3<=min(s.m_O3)+0.00001));
    ref_spec.mean_m = nanmean(s.m_O3(ind));
    % from DB instrument at MLO - DS mode
    ref_spec.o3scdref = 243*ref_spec.mean_m;% in [DU]
    ref_spec.o3scdref = 335;
    %ref_spec.o3scdref;
    save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
    
elseif strcmp(gas,'NO2')
    
    wind   = [0.450 0.490];
    
    % find good index around solar noon to create averga espectrum
    ind = find((s.m_NO2>=min(s.m_NO2)-0.00001&s.m_NO2<=min(s.m_NO2)+0.00001));
    ref_spec.mean_m = nanmean(s.m_NO2(ind));
    % from OMI station overpass at MLO [molec/cm2]
    ref_spec.no2scdref = 2.64e15*ref_spec.mean_m;%this is total column; tropo is -0.1e15;MLO 20160113
    ref_spec.no2scdref = 8.43e15;%this is derived from MLE method
    save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    
end

% compute and plot reference spectrum

    istart = interp1(s.w,[1:length(s.w)],wind(1), 'nearest');
    iend   = interp1(s.w,[1:length(s.w)],wind(2), 'nearest');
    wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
    
    meanspec = nanmean(s.rateslant(ind,wln),1);
    stdspec  = nanstd(s.rateslant(ind,wln),[],1);
    
    figure;
    subplot(211);
    plot(s.w(wln),meanspec,'-b','linewidth',2);hold on;
    plot(s.w(wln),meanspec+3*stdspec,':k','linewidth',1);hold on;
    plot(s.w(wln),meanspec-3*stdspec,':k','linewidth',1);hold on;
    legend('mean ref spectrum','ref spec +- stdx3');
    ylabel('count rate (slant total)');title(daystr);
    subplot(212);
    plot(s.w(wln),stdspec,'-k','linewidth',2);
    legend('ref spec std');
    xlabel('wavelength');
    ylabel('count rate (slant total)');


clear s
%% use refspec to retrieve quantities at MLO:

% upload data points:
dat1 = load([starpaths,'20160111starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
dat2 = load([starpaths,'20160112starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
dat3 = load([starpaths,'20160113starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');

if strcmp(gas,'O3')
    ref_spec.o3refspec = meanspec;
    save([starpaths, daystr,'O3refspec.mat'],'-struct','ref_spec');
    % retrieve O3
    [o3_1] = retrieveO3(dat1,wind(1),wind(2),1);
    [o3_2] = retrieveO3(dat2,wind(1),wind(2),1);
    [o3_3] = retrieveO3(dat3,wind(1),wind(2),1);
    
elseif strcmp(gas,'NO2')
    ref_spec.no2refspec = meanspec;
    save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    % retrieve NO2
    [no2_1] = retrieveNO2(dat1,wind(1),wind(2),1);
    [no2_2] = retrieveNO2(dat2,wind(1),wind(2),1);
    [no2_3] = retrieveNO2(dat3,wind(1),wind(2),1);
end

%% plot retrieved values versus airmass
if strcmp(gas,'O3')
    
    figure(11);
    plot(dat1.m_O3,o3_1.o3SCD,'.b');hold on;
    plot(dat2.m_O3,o3_2.o3SCD,'.c');hold on;
    plot(dat3.m_O3,o3_3.o3SCD,'.g');hold on;
    xlabel('airmass');ylabel('O3 relative SCD');
    
elseif strcmp(gas,'NO2')
    
    figure(22);
    plot(dat1.m_NO2,no2_1.no2SCD,'.b');hold on;
    plot(dat2.m_NO2,no2_2.no2SCD,'.c');hold on;
    plot(dat3.m_NO2,no2_3.no2SCD,'.g');hold on;
    xlabel('airmass');ylabel('NO2 relative SCD');
end

%% deduce reference spectrum gas amount to be added (compare to OMI)
if strcmp(gas,'O3')
    
        % bin airmass 1-5 into 100 bins
        x = [dat1.m_O3(dat1.m_O3<=8.5&dat1.m_O3>=3);
             dat2.m_O3(dat2.m_O3<=8.5&dat2.m_O3>=3);
             dat3.m_O3(dat3.m_O3<=8.5&dat3.m_O3>=3)];
        y = [o3_1.o3SCD(dat1.m_O3<=8.5&dat1.m_O3>=3);
             o3_2.o3SCD(dat2.m_O3<=8.5&dat2.m_O3>=3);
             o3_3.o3SCD(dat3.m_O3<=8.5&dat3.m_O3>=3)];
        binEdge = linspace(min(x),max(x),100);
        [n,bin] = histc(x,binEdge);

        % find lower 2% in each bin
        for i=1:length(n)-1
            pnts = y(x<=binEdge(i+1)&x>=binEdge(i));
            p2(i) = quantile(pnts,0.50);
        end
        figure(11)
        hold on;
        plot(binEdge(1:end-1),p2,'.r');
        axis([0 8.5 -400 1000]);

        % fit line
        in = ~isnan(p2);
        [Sf,fit] = polyfit(binEdge(in==1),p2(in==1),1);

        % plot on data
        figure(11);
        plot([0:0.1:8.5],polyval(Sf,[0:0.1:8.5]),'-k','linewidth',2);
        axis([0 8.5 -400 1800]);
        
elseif strcmp(gas,'NO2')
        % bin airmass 1-5 into 100 bins
        x = [dat1.m_NO2(dat1.m_NO2<=6.5&dat1.m_NO2>=3);
             dat2.m_NO2(dat2.m_NO2<=6.5&dat2.m_NO2>=3);
             dat3.m_NO2(dat3.m_NO2<=6.5&dat3.m_NO2>=3)];
        y = [no2_1.no2SCD(dat1.m_NO2<=6.5&dat1.m_NO2>=3);
             no2_2.no2SCD(dat2.m_NO2<=6.5&dat2.m_NO2>=3);
             no2_3.no2SCD(dat3.m_NO2<=6.5&dat3.m_NO2>=3)];
        binEdge = linspace(min(x),max(x),100);
        [n,bin] = histc(x,binEdge);

        % find lower 2% in each bin
        for i=1:length(n)-1
            pnts = y(x<=binEdge(i+1)&x>=binEdge(i));
            p2(i) = quantile(pnts,0.02);
        end
        figure(22)
        hold on;
        plot(binEdge(1:end-1),p2,'.r');
        axis([0 6.5 -2e16 5e16]);

        % fit line
        in = ~isnan(p2);
        [Sf,fit] = polyfit(binEdge(in==1),p2(in==1),1);

        % plot on data
        figure(22);
        plot([0:0.1:6.5],polyval(Sf,[0:0.1:6.5]),'-k','linewidth',2);
end

%% save parameters to struct .mat file
if strcmp(gas,'O3')
    ref_spec.o3scdref=abs(Sf(2));%313.5DU
    save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'NO2')
    ref_spec.no2scdref = abs(Sf(2));%7.795e15;%this is median8.43e15;%this is derived from MLE method 2%
    save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
end
