%% Details of the function:
% NAME:
%   create_refSpec
% 
% PURPOSE:
%   create reference spectrum for gas retrievals
%   for NO2 this must be used; for O3, this is
%   also best
% 
%
% CALLING SEQUENCE:
%  function ref_spec = create_refSpec(daystr,gas);
%
% INPUT:
%  - daystr: string date 'yyyymmdd'
%  - gas is gas str; 'O3' , 'NO2', or 'HCOH'
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
% Modified:
% MS, 2016-05-18, Flying over Korea
% MS, 2016-10-10, added wln to saved refSpec
% MS, 2016-10-11, changed wln range of NO2
% MS, 2017-07-22, edited for MLO 2017
% MS, 2017-08-23, updated O3 from MLO DB
% MS, 2018-09-12, updated refSpec for MLO Aug-2018
% MS, 2018-10-02, updated O3 reference amount to MLO DB value
% MS, 2018-11-07, updated refSpec for MLO Feb-2018
% SL, 2022-05-08, MLO, updated reSpec for MLO May-2022
% SL, 2022-10-26, MLO, added 4STARB analysis (and instrumentname to the call)
% -------------------------------------------------------------------------
%% function routine

function ref_spec = create_refSpec(daystr,gas,instrumentname)
%-----------------------------------------------
if ~exist('instrumentname'), instrumentname = '4STAR'; end

%% load starsun
if strcmp(daystr,'20170605')
    
    s = load(['F:\MLO2017\','4STAR_20170531starsun_am.mat'],'t','w','rateslant','m_aero','m_O3','m_NO2');
    
elseif strcmp(daystr,'20170604')
    
     s = load(['F:\MLO2017\','4STAR_20170604starsun_pm.mat'],'t','w','rateslant','m_aero','m_O3','m_NO2');
     
elseif strcmp(daystr,'20170605')
    
     s = load(['F:\MLO2017\','4STAR_20170605starsun_am.mat'],'t','w','rateslant','m_aero','m_O3','m_NO2');
     
elseif strcmp(daystr,'20180811')||strcmp(daystr,'20180812')||strcmp(daystr,'20180813')
    
     s = load(['C:\Users\msegalro\campaigns\MLO\Aug_2018\','4STAR_', daystr, 'starsun.mat'],'t','w','rateslant','m_aero','m_O3','m_NO2');
    
elseif strcmp(daystr,'20180209')||strcmp(daystr,'20180210')||strcmp(daystr,'20180212')
    if exist(['C:\Users\msegalro\campaigns\MLO\Feb_2018\','4STAR_', daystr, 'starsun_nogases.mat'])
        fname = ['C:\Users\msegalro\campaigns\MLO\Feb_get 2018\','4STAR_', daystr, 'starsun_nogases.mat'];
    else
        fname = getfullname(['4STAR_', daystr, 'starsun*.mat']);    
    end
    s = load(fname,'t','w','rateslant','m_aero','m_O3','m_NO2');
else
    if exist([starpaths,daystr,'starsun.mat'])
        fname = [starpaths,daystr,'starsun.mat']
    else
        fname = getfullname([instrumentname '_', daystr, 'starsun*.mat']);
    end
    s = load(fname,'t','w','rateslant','m_aero','m_O3','m_NO2');
    [visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(s.t);
    s.w = [visw,nirw];
    s.instrumentname = instrumentname;
end

% test figure;
% figure;
% plot(serial2Hh(s.t),s.m_aero,'.c');
% xlabel('time');ylabel('airmass');


% plot average and std of mean reference spectra
if strcmp(gas,'O3')
    
    wind   = [0.490 0.682];
    
    % find good index around solar noon to create average espectrum
    ind = find((s.m_O3>=min(s.m_O3)-0.00001&s.m_O3<=min(s.m_O3)+0.00001));
    ref_spec.mean_m = nanmean(s.m_O3(ind));
    % from DB instrument at MLO - DS mode
    if strcmp(daystr,'20160113')
        ref_spec.o3scdref = 243*ref_spec.mean_m;% in [DU]
        ref_spec.o3scdref = 335;% derived from MLE method
    elseif strcmp(daystr,'20160702')||strcmp(daystr,'20160703')
        ref_spec.o3scdref = 259*ref_spec.mean_m;% in [DU]
    elseif strcmp(daystr,'20160825')
        ref_spec.o3scdref = 275*ref_spec.mean_m;% in [DU]
    elseif strcmp(daystr,'20170531') || strcmp(daystr,'20170604') || strcmp(daystr,'20170605')
        ref_spec.o3scdref = 279*ref_spec.mean_m;  % in [DU] this is from OMI and might be overestimated; DB not available
        ref_spec.o3scdref = 263.5*ref_spec.mean_m;% in [DU] this is from MLE
        ref_spec.o3scdref = 277*ref_spec.mean_m;  % in [DU] this is from MLO DB
    elseif strcmp(daystr,'20180811') || strcmp(daystr,'20180812')
        ref_spec.o3scdref = 270*ref_spec.mean_m;  % in [DU] this is from DB in MLO
    elseif strcmp(daystr,'20180813')
        ref_spec.o3scdref = 275*ref_spec.mean_m;  % in [DU] this is from DB in MLO
    elseif strcmp(daystr,'20180209') || strcmp(daystr,'20180210')|| strcmp(daystr,'20180212')
        ref_spec.o3scdref = 262*ref_spec.mean_m;  % in [DU] this is from DB in MLO
    elseif strcmp(daystr,'20220508')
        ref_spec.o3scdref = 269.4*ref_spec.mean_m;  % in [DU] this is from pandora in MLO
    elseif strcmp(daystr,'20220511')
        ref_spec.o3scdref = 265.3*ref_spec.mean_m;  % in [DU] this is from pandora in MLO
    elseif strcmp(daystr,'20220514')
        ref_spec.o3scdref = 283.84*ref_spec.mean_m;  % in [DU] this is from pandora in MLO
    end
    
    if strcmp(instrumentname, '4STARB')
        save([starpaths,instrumentname,'_',daystr,'O3refspec.mat'],'-struct','ref_spec');
    else
        save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
    end
elseif strcmp(gas,'NO2')
    
    %wind   = [0.450 0.490];
    wind   = [0.460 0.490];
    
    % find good index around solar noon to create averga espectrum
    ind = find((s.m_NO2>=min(s.m_NO2)-0.00001&s.m_NO2<=min(s.m_NO2)+0.00001));
    ref_spec.mean_m = nanmean(s.m_NO2(ind));
    % from OMI station overpass at MLO [molec/cm2]
    if strcmp(daystr,'20160113')
        ref_spec.no2scdref = 2.64e15*ref_spec.mean_m;%this is total column; tropo is -0.1e15;MLO 20160113
        ref_spec.no2scdref = 8.43e15;%this is derived from MLE method
    elseif strcmp(daystr,'20160702')||strcmp(daystr,'20160703')
        ref_spec.no2scdref = 3.18e15*ref_spec.mean_m;%this is total column; MLO 20160702
        ref_spec.no2scdref = 2.76e15*ref_spec.mean_m;%this is derived reference amount; MLO 20160702
    elseif strcmp(daystr,'20160825')
        ref_spec.no2scdref = 3.0e15*ref_spec.mean_m;%this is omi strat based on total-trop airmass 1 during transit 
    elseif strcmp(daystr,'20170531') || strcmp(daystr,'20170604') || strcmp(daystr,'20170605')
        ref_spec.no2scdref = 2.0e15*ref_spec.mean_m;% defualt
        ref_spec.no2scdref = 2.0e15*ref_spec.mean_m;% this is from MLE
    elseif strcmp(daystr,'20180811') || strcmp(daystr,'20180812') || strcmp(daystr,'20180813')
        ref_spec.no2scdref = 2.0e15*ref_spec.mean_m;% defualt
    elseif strcmp(daystr,'20180209') || strcmp(daystr,'20180210') || strcmp(daystr,'20180212')
        ref_spec.no2scdref = 1.8452e+15*ref_spec.mean_m;% from OMI overpass on 20180212
    elseif strcmp(daystr,'20220508')
        Loschmidt= 2.686763e19; %molecules/cm2
        ref_spec.no2scdref = 8.266e-2*(Loschmidt/1000.0)*ref_spec.mean_m;% From MLO May 2022, based on pandora measurements
    elseif strcmp(daystr,'20220511')
        Loschmidt= 2.686763e19; %molecules/cm2
        ref_spec.no2scdref = 7.25617e-2*(Loschmidt/1000.0)*ref_spec.mean_m;% From MLO May 2022, based on pandora measurements
    elseif strcmp(daystr,'20220514')
        Loschmidt= 2.686763e19; %molecules/cm2
        ref_spec.no2scdref = 7.8792e-2*(Loschmidt/1000.0)*ref_spec.mean_m;% From MLO May 2022, based on pandora measurements
    end
    if strcmp(instrumentname, '4STARB')
        save([starpaths,instrumentname,'_',daystr,'NO2refspec.mat'],'-struct','ref_spec');
    else
        save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    end
    
elseif strcmp(gas,'HCOH')
    
    wind   = [0.335 0.359]; %1ppb background level in clean atmosphere
    
    % find good index around solar noon to create averga espectrum
    ind = find((s.m_NO2>=min(s.m_NO2)-0.00001&s.m_NO2<=min(s.m_NO2)+0.00001));
    ref_spec.mean_m = nanmean(s.m_NO2(ind));
    % from OMI station overpass at MLO [molec/cm2]
    ref_spec.hcohscdref = 0;%2.64e15*ref_spec.mean_m;%this is total column; tropo is -0.1e15;MLO 20160113
    %ref_spec.no2scdref = 8.43e15;%this is derived from MLE method
    if strcmp(daystr,'20220508')
        ref_spec.hcohscdref = 9.4518e+14*ref_spec.mean_m;
    end
  
    if strcmp(instrumentname, '4STARB')
        save([starpaths,instrumentname,'_',daystr,'HCOHrefspec.mat'],'-struct','ref_spec');
    else
        save([starpaths,daystr,'HCOHrefspec.mat'],'-struct','ref_spec');
    end
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
    ylabel('count rate (slant total)');title(strcat(gas, 'reference spectrum from ',daystr,' ',instrumentname));
    subplot(212);
    plot(s.w(wln),stdspec,'-k','linewidth',2);
    legend('ref spec std');
    xlabel('wavelength');
    ylabel('count rate (slant total)');


%clear s
%% use refspec to retrieve gas quantities and infer reference quantities at MLO:

% upload data points:
% MLO Jan-2016
%dat1 = load([starpaths,'20160111starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
%dat2 = load([starpaths,'20160112starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
%dat3 = load([starpaths,'20160113starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');

% MLO June-2016
%dat1 = load([starpaths,'20160702starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
%dat2 = load([starpaths,'20160703starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
%dat3 = load([starpaths,'20160704starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');

% MLO June-2017
%dat1 = load(['F:\MLO2017\','4STAR_20170531starsun_am.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
%dat2 = load(['F:\MLO2017\','4STAR_20170604starsun_pm.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');
%dat3 = load(['F:\MLO2017\','4STAR_20170605starsun_am.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray');

% MLO Aug-2018
% dat1 = load(['C:\Users\msegalro\campaigns\MLO\Aug_2018\','4STAR_20180811starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col');
% dat2 = load(['C:\Users\msegalro\campaigns\MLO\Aug_2018\','4STAR_20180812starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col');
% dat3 = load(['C:\Users\msegalro\campaigns\MLO\Aug_2018\','4STAR_20180813starsun.mat'],'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col');

% MLO Feb-2018
if strcmp(daystr(1:6),'201802')
    
dat1 = load(fname,'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col','Str','Zn','instrumentname');
dat2 = load(strrep(fname,daystr,'20180210'),'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col','Str','Zn','instrumentname');
dat3 = load(strrep(fname,daystr,'20180212'),'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col','Str','Zn','instrumentname');
elseif strcmp(daystr(1:6),'202205')
% MLO May 2022
    dat1 = load(fname,'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col','Str','Zn','instrumentname');
    dat2 = load(strrep(fname,daystr,'20220511'),'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col','Str','Zn','instrumentname');
    dat3 = load(strrep(fname,daystr,'20220514'),'t','w','m_aero','rateslant','m_O3','tau_tot_slant','toggle','m_ray','m_NO2','m_H2O','tau_ray','QdVlr','QdVtot','NO2col','Str','Zn','instrumentname');
    [visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(dat1.t);
    dat1.w = [visw,nirw];
    [visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(dat2.t);
    dat2.w = [visw,nirw];
    [visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(dat3.t);
    dat3.w = [visw,nirw];
end

if strcmp(gas,'O3')
    ref_spec.o3refspec = meanspec;
    ref_spec.o3wln     = s.w(wln);
    if strcmp(instrumentname, '4STARB')
        save([starpaths,instrumentname,'_',daystr,'O3refspec.mat'],'-struct','ref_spec');
    else
        save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
    end
    %save([starpaths, daystr,'O3refspec.mat'],'-struct','ref_spec');
    % retrieve O3
    [o3_1] = retrieveO3(dat1,wind(1),wind(2),1);
    [o3_2] = retrieveO3(dat2,wind(1),wind(2),1);
    [o3_3] = retrieveO3(dat3,wind(1),wind(2),1);
    
elseif strcmp(gas,'NO2')
    ref_spec.no2refspec = meanspec;
    ref_spec.no2wln     = s.w(wln);
    if strcmp(instrumentname, '4STARB')
        save([starpaths,instrumentname,'_',daystr,'NO2refspec.mat'],'-struct','ref_spec');
    else
        save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    end
    %save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    % retrieve NO2
    [no2_1] = retrieveNO2(dat1,wind(1),wind(2),1);
    [no2_2] = retrieveNO2(dat2,wind(1),wind(2),1);
    [no2_3] = retrieveNO2(dat3,wind(1),wind(2),1);
elseif strcmp(gas,'HCOH')
    ref_spec.hcohrefspec = meanspec;
    ref_spec.hcohwln     = s.w(wln);
    if strcmp(instrumentname, '4STARB')
        save([starpaths,instrumentname,'_',daystr,'HCOHrefspec.mat'],'-struct','ref_spec');
    else
        save([starpaths,daystr,'HCOHrefspec.mat'],'-struct','ref_spec');
    end
    %save([starpaths,daystr,'HCOHrefspec.mat'],'-struct','ref_spec');
    % retrieve HCOH
    [hcoh_1] = retrieveHCOH(dat1,wind(1),wind(2),1);
    [hcoh_2] = retrieveHCOH(dat2,wind(1),wind(2),1);
    [hcoh_3] = retrieveHCOH(dat3,wind(1),wind(2),1);    
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
    
elseif strcmp(gas,'HCOH')
    
    figure(33);
    plot(dat1.m_NO2,hcoh_1.hcohSCD,'.b');hold on;
    plot(dat2.m_NO2,hcoh_2.hcohSCD,'.c');hold on;
    plot(dat3.m_NO2,hcoh_3.hcohSCD,'.g');hold on;
    xlabel('airmass');ylabel('HCOH relative SCD');    
end

%% deduce reference spectrum gas amount to be added (compare to OMI/DB)
if strcmp(gas,'O3')
    
        % bin airmass 1-5 into 100 bins
        % these airmass values are for MLO Jan-2016
        if strcmp(daystr,'20160113')
            x = [dat1.m_O3(dat1.m_O3<=8.5&dat1.m_O3>=3);
                 dat2.m_O3(dat2.m_O3<=8.5&dat2.m_O3>=3);
                 dat3.m_O3(dat3.m_O3<=8.5&dat3.m_O3>=3)];
            y = [o3_1.o3SCD(dat1.m_O3<=8.5&dat1.m_O3>=3);
                 o3_2.o3SCD(dat2.m_O3<=8.5&dat2.m_O3>=3);
                 o3_3.o3SCD(dat3.m_O3<=8.5&dat3.m_O3>=3)];
        elseif strcmp(daystr,'20160702') 
        % these airmass values are for MLO June-2016
            x = [dat1.m_O3(dat1.m_O3<=8.5&dat1.m_O3>=1);
                 dat2.m_O3(dat2.m_O3<=8.5&dat2.m_O3>=1)];
            y = [o3_1.o3SCD(dat1.m_O3<=8.5&dat1.m_O3>=1);
                 o3_2.o3SCD(dat2.m_O3<=8.5&dat2.m_O3>=1)];
            y = real(y); 
        elseif strcmp(daystr,'20170531')||strcmp(daystr,'20170604')||strcmp(daystr,'20170605') 
        % these airmass values are for MLO June-2017
            x = [dat1.m_O3(dat1.m_O3<=6&dat1.m_O3>=3);
                 dat2.m_O3(dat2.m_O3<=6&dat2.m_O3>=3);
                 dat3.m_O3(dat3.m_O3<=6&dat3.m_O3>=3)];
            y = [o3_1.o3SCD(dat1.m_O3<=6&dat1.m_O3>=3);
                 o3_2.o3SCD(dat2.m_O3<=6&dat2.m_O3>=3);
                 o3_3.o3SCD(dat3.m_O3<=6&dat3.m_O3>=3)];
            y = real(y);  
        elseif strcmp(daystr,'20180811')
        % these airmass values are for MLO Aug-2018
        
            x = [dat1.m_O3(dat1.m_O3<=8&dat1.m_O3>=4);
                 dat3.m_O3(dat3.m_O3<=8&dat3.m_O3>=4)];
            y = [o3_1.o3SCD(dat1.m_O3<=8&dat1.m_O3>=4);
                 o3_3.o3SCD(dat3.m_O3<=8&dat3.m_O3>=4)];
            y = real(y);   
            
         elseif strcmp(daystr,'20180812')||strcmp(daystr,'20180813') 
        % these airmass values are for MLO Aug-2018
            x = [dat1.m_O3(dat1.m_O3<=8&dat1.m_O3>=4);
                 dat2.m_O3(dat2.m_O3<=8&dat2.m_O3>=4);
                 dat3.m_O3(dat3.m_O3<=8&dat3.m_O3>=4)];
            y = [o3_1.o3SCD(dat1.m_O3<=8&dat1.m_O3>=4);
                 o3_2.o3SCD(dat2.m_O3<=8&dat2.m_O3>=4);
                 o3_3.o3SCD(dat3.m_O3<=8&dat3.m_O3>=4)];
            y = real(y); 
            
         elseif strcmp(daystr,'20180209')||strcmp(daystr,'20180210')||strcmp(daystr,'20180212') 
        % these airmass values are for MLO Feb-2018
            x = [dat1.m_O3(dat1.m_O3<=4&dat1.m_O3>=1.5);
                 dat2.m_O3(dat2.m_O3<=4&dat2.m_O3>=1.5);
                 dat3.m_O3(dat3.m_O3<=4&dat3.m_O3>=1.5)];
            y = [o3_1.o3SCD(dat1.m_O3<=4&dat1.m_O3>=1.5);
                 o3_2.o3SCD(dat2.m_O3<=4&dat2.m_O3>=1.5);
                 o3_3.o3SCD(dat3.m_O3<=4&dat3.m_O3>=1.5)];
            y = real(y); 
            
        elseif strcmp(daystr(1:6),'202205') 
        % these airmass values are for MLO May 2022
            x = [dat1.m_O3(dat1.m_O3<=4&dat1.m_O3>=1.2);
                 dat2.m_O3(dat2.m_O3<=4&dat2.m_O3>=1.2);
                 dat3.m_O3(dat3.m_O3<=4&dat3.m_O3>=1.2)];
            y = [o3_1.o3SCD(dat1.m_O3<=4&dat1.m_O3>=1.2);
                 o3_2.o3SCD(dat2.m_O3<=4&dat2.m_O3>=1.2);
                 o3_3.o3SCD(dat3.m_O3<=4&dat3.m_O3>=1.2)];
            y = real(y); 
            
        end 
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
        % these airmass values are for MLO Jan-2016
        if strcmp(daystr,'20160113')
            x = [dat1.m_NO2(dat1.m_NO2<=6.5&dat1.m_NO2>=3);
                 dat2.m_NO2(dat2.m_NO2<=6.5&dat2.m_NO2>=3);
                 dat3.m_NO2(dat3.m_NO2<=6.5&dat3.m_NO2>=3)];
            y = [no2_1.no2SCD(dat1.m_NO2<=6.5&dat1.m_NO2>=3);
                 no2_2.no2SCD(dat2.m_NO2<=6.5&dat2.m_NO2>=3);
                 no2_3.no2SCD(dat3.m_NO2<=6.5&dat3.m_NO2>=3)];
        elseif strcmp(daystr,'20160702')
             x = [dat1.m_NO2(dat1.m_NO2<=8&dat1.m_NO2>=1);
                  dat2.m_NO2(dat2.m_NO2<=8&dat2.m_NO2>=1);
                  dat3.m_NO2(dat3.m_NO2<=8&dat3.m_NO2>=1)];
             y = [no2_1.no2SCD(dat1.m_NO2<=8&dat1.m_NO2>=1);
                  no2_2.no2SCD(dat2.m_NO2<=8&dat2.m_NO2>=1);
                  no2_3.no2SCD(dat3.m_NO2<=8&dat3.m_NO2>=1)];
              
             y(y<0) = NaN; 
             
        elseif strcmp(daystr,'20170531')||strcmp(daystr,'20170604')||strcmp(daystr,'20170605') 
        % these airmass values are for MLO June-2017
            x = [dat1.m_NO2(dat1.m_NO2<=3&dat1.m_NO2>=1);
                 dat2.m_NO2(dat2.m_NO2<=3&dat2.m_NO2>=1);
                 dat3.m_NO2(dat3.m_NO2<=3&dat3.m_NO2>=1)];
            y = [no2_1.no2SCD(dat1.m_NO2<=3&dat1.m_NO2>=1);
                 no2_2.no2SCD(dat2.m_NO2<=3&dat2.m_NO2>=1);
                 no2_3.no2SCD(dat3.m_NO2<=3&dat3.m_NO2>=1)];
            y = real(y);   
            y(y<0) = NaN;
            
        elseif strcmp(daystr,'20180812')||strcmp(daystr,'20180813')
        % these airmass values are for MLO Aug-2018
            x = [dat1.m_NO2(dat1.m_NO2<=4&dat1.m_NO2>=2);
                 dat2.m_NO2(dat2.m_NO2<=4&dat2.m_NO2>=2);
                 dat3.m_NO2(dat3.m_NO2<=4&dat3.m_NO2>=2)];
            y = [no2_1.no2SCD(dat1.m_NO2<=4&dat1.m_NO2>=2);
                 no2_2.no2SCD(dat2.m_NO2<=4&dat2.m_NO2>=2);
                 no2_3.no2SCD(dat3.m_NO2<=4&dat3.m_NO2>=2)];
            y = real(y);   
            y(y<0) = NaN;
            
        elseif strcmp(daystr,'20180209')||strcmp(daystr,'20180210')||strcmp(daystr,'20180212')
        % these airmass values are for MLO Aug-2018
            x = [dat1.m_NO2(dat1.m_NO2<=5&dat1.m_NO2>=3);
                 dat2.m_NO2(dat2.m_NO2<=5&dat2.m_NO2>=3);
                 dat3.m_NO2(dat3.m_NO2<=5&dat3.m_NO2>=3)];
            y = [no2_1.no2SCD(dat1.m_NO2<=5&dat1.m_NO2>=3);
                 no2_2.no2SCD(dat2.m_NO2<=5&dat2.m_NO2>=3);
                 no2_3.no2SCD(dat3.m_NO2<=5&dat3.m_NO2>=3)];
            y = real(y);   
            y(y<0) = NaN;
        elseif strcmp(daystr(1:6),'202205')
        % these airmass values are for MLO May 2022
            x = [dat1.m_NO2(dat1.m_NO2<=5&dat1.m_NO2>=1);
                 dat2.m_NO2(dat2.m_NO2<=5&dat2.m_NO2>=1);
                 dat3.m_NO2(dat3.m_NO2<=5&dat3.m_NO2>=1)];
            y = [no2_1.no2SCD(dat1.m_NO2<=5&dat1.m_NO2>=1);
                 no2_2.no2SCD(dat2.m_NO2<=5&dat2.m_NO2>=1);
                 no2_3.no2SCD(dat3.m_NO2<=5&dat3.m_NO2>=1)];
            y = real(y);   
            y(y<0) = NaN;
        end
        
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
        
elseif strcmp(gas,'HCOH')
        % bin airmass 1-5 into 100 bins
        % these airmass values are for MLO Jan-2016
        if strcmp(daystr,'20160113')
            x = [dat1.m_NO2(dat1.m_NO2<=6.5&dat1.m_NO2>=3);
                 dat2.m_NO2(dat2.m_NO2<=6.5&dat2.m_NO2>=3);
                 dat3.m_NO2(dat3.m_NO2<=6.5&dat3.m_NO2>=3)];
            y = [hcoh_1.hcohSCD(dat1.m_NO2<=6.5&dat1.m_NO2>=3);
                 hcoh_2.hcohSCD(dat2.m_NO2<=6.5&dat2.m_NO2>=3);
                 hcoh_3.hcohSCD(dat3.m_NO2<=6.5&dat3.m_NO2>=3)];
        elseif strcmp(daystr,'20160702')
            x = [dat1.m_NO2(dat1.m_NO2<=3&dat1.m_NO2>=1);
                 dat2.m_NO2(dat2.m_NO2<=3&dat2.m_NO2>=1)];
            y = [hcoh_1.hcohSCD(dat1.m_NO2<=3&dat1.m_NO2>=1);
                 hcoh_2.hcohSCD(dat2.m_NO2<=3&dat2.m_NO2>=1)];
        elseif strcmp(daystr,'20170531')||strcmp(daystr,'20170604')||strcmp(daystr,'20170605') 
        % these airmass values are for MLO June-2017
            x = [dat1.m_NO2(dat1.m_NO2<=3&dat1.m_NO2>=1);
                 dat2.m_NO2(dat2.m_NO2<=3&dat2.m_NO2>=1);
                 dat3.m_NO2(dat3.m_NO2<=3&dat3.m_NO2>=1)];
            y = [hcoh_1.hcohSCD(dat1.m_NO2<=3&dat1.m_NO2>=1);
                 hcoh_2.hcohSCD(dat2.m_NO2<=3&dat2.m_NO2>=1);
                 hcoh_3.hcohSCD(dat3.m_NO2<=3&dat3.m_NO2>=1)];
            y = real(y);   
            y(y<0) = NaN; 
        elseif strcmp(daystr,'20180812')
        % these airmass values are for MLO Aug-2018
            x = [dat1.m_NO2(dat1.m_NO2<=5&dat1.m_NO2>=2);
                 dat2.m_NO2(dat2.m_NO2<=5&dat2.m_NO2>=2);
                 dat3.m_NO2(dat3.m_NO2<=5&dat3.m_NO2>=2)];
            y = [hcoh_1.hcohSCD(dat1.m_NO2<=5&dat1.m_NO2>=2);
                 hcoh_2.hcohSCD(dat2.m_NO2<=5&dat2.m_NO2>=2);
                 hcoh_3.hcohSCD(dat3.m_NO2<=5&dat3.m_NO2>=2)];
            y = real(y);   
            y(y<0) = NaN;  
            
        elseif strcmp(daystr,'20180209')||strcmp(daystr,'20180210')||strcmp(daystr,'20180212') 
        % these airmass values are for MLO Aug-2018
            x = [dat1.m_NO2(dat1.m_NO2<=4&dat1.m_NO2>=2);
                 dat2.m_NO2(dat2.m_NO2<=4&dat2.m_NO2>=2);
                 dat3.m_NO2(dat3.m_NO2<=4&dat3.m_NO2>=2)];
            y = [hcoh_1.hcohSCD(dat1.m_NO2<=4&dat1.m_NO2>=2);
                 hcoh_2.hcohSCD(dat2.m_NO2<=4&dat2.m_NO2>=2);
                 hcoh_3.hcohSCD(dat3.m_NO2<=4&dat3.m_NO2>=2)];
            y = real(y);   
            y(y<0) = NaN;  
                elseif strcmp(daystr(1:6),'202205')
        % these airmass values are for MLO May 2022
            x = [dat1.m_NO2(dat1.m_NO2<=5&dat1.m_NO2>=2.5);
                 dat2.m_NO2(dat2.m_NO2<=5&dat2.m_NO2>=2.5);
                 dat3.m_NO2(dat3.m_NO2<=5&dat3.m_NO2>=2.5)];
            y = [hcoh_1.hcohSCD(dat1.m_NO2<=5&dat1.m_NO2>=2.5);
                 hcoh_2.hcohSCD(dat2.m_NO2<=5&dat2.m_NO2>=2.5);
                 hcoh_3.hcohSCD(dat3.m_NO2<=5&dat3.m_NO2>=2.5)];
            y = real(y);   
            y(y<0) = NaN;
        end
        
        binEdge = linspace(min(x),max(x),100);
        [n,bin] = histc(x,binEdge);

        % find lower 2% in each bin
        for i=1:length(n)-1
            pnts = y(x<=binEdge(i+1)&x>=binEdge(i));
            p2(i) = quantile(pnts,0.02);
        end
        figure(33)
        hold on;
        plot(binEdge(1:end-1),p2,'.r');
        axis([0 8 -200 200]);

        % fit line
        in = ~isnan(p2);
        [Sf,fit] = polyfit(binEdge(in==1),p2(in==1),1);

        % plot on data
        figure(33);
        plot([0:0.1:6.5],polyval(Sf,[0:0.1:6.5]),'-k','linewidth',2);        
end

%% save parameters to struct .mat file
% save new reference amount only for MLO cases
if strcmp(gas,'O3') && (strcmp(daystr,'20160113')||strcmp(daystr,'20160702'))
    ref_spec.o3scdref=abs(Sf(2));
    %save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
    save(['C:\matlab\4STAR_codes\data_folder',daystr,'O3refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'O3') && (strcmp(daystr,'20170531')||strcmp(daystr,'20170605'))
    %ref_spec.o3scdref=abs(Sf(2));
    ref_spec.o3scdref = 277; %MLO DB
    %save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
    save(['C:\matlab\4STAR_codes\data_folder\',daystr,'O3refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'O3') && (strcmp(daystr,'20180811'))
    ref_spec.o3scdref=abs(Sf(2));
    %save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
    save(['C:\Users\msegalro\matlab\4STAR_codes\data_folder\',daystr,'O3refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'O3') && (strcmp(daystr,'20180812') || strcmp(daystr,'20180813'))
    %ref_spec.o3scdref=abs(Sf(2));%263; this seems a bit too low
    % when running it with refSpec from 0812 it gave Sf(2)=365DU...
    ref_spec.o3scdref = 270; %MLO DB
elseif strcmp(gas,'O3') && (strcmp(daystr,'20180209') || strcmp(daystr,'20180210') || strcmp(daystr,'20180212'))
    ref_spec.o3scdref = abs(Sf(2));%20180209 deduced 342 vs. 315 of DB, 20180210 353, 20180212 342
    %save([starpaths,daystr,'O3refspec.mat'],'-struct','ref_spec');
    save([getnamedpath('data_folder'),daystr,'O3refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'NO2') && (strcmp(daystr,'20160113')||strcmp(daystr,'20160702'))
    ref_spec.no2scdref = abs(Sf(2));%7.795e15;%this is median8.43e15;%this is derived from MLE method 2%
    %save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    save(['C:\matlab\4STAR_codes\data_folder',daystr,'O3refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'NO2') && (strcmp(daystr,'20170531')||strcmp(daystr,'20170604') ||strcmp(daystr,'20170605'))
    ref_spec.no2scdref = 3e15; % since MLE seem too high (~4e16)
    %save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    save(['C:\matlab\4STAR_codes\data_folder',daystr,'NO2refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'NO2') && (strcmp(daystr,'20180811')||strcmp(daystr,'20180812') ||strcmp(daystr,'20180813'))
    ref_spec.no2scdref = 3e15; % since MLE seem too high (~5e16)
    %save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    save(['C:\Users\msegalro\matlab\4STAR_codes\data_folder\',daystr,'NO2refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'NO2') && (strcmp(daystr,'20180209')||strcmp(daystr,'20180210') ||strcmp(daystr,'20180212'))
    ref_spec.no2scdref = 2.4e15; % since MLE seem too high (~4.7e16 for 20180212)
    %save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    save([getnamedpath('data_folder'),daystr,'NO2refspec.mat'],'-struct','ref_spec');
elseif strcmp(gas,'NO2') && (strcmp(daystr(1:6),'202205'))
    ref_spec.no2scdref = 2.2225e15; % since MLE seem too high (~4.7e16 for 20180212)
    %save([starpaths,daystr,'NO2refspec.mat'],'-struct','ref_spec');
    if strcmp(instrumentname,'4STARB')
        save([getnamedpath('data_folder'),instrumentname,'_',daystr,'NO2refspec.mat'],'-struct','ref_spec');
    else
        save([getnamedpath('data_folder'),daystr,'NO2refspec.mat'],'-struct','ref_spec');
    end
elseif strcmp(gas,'HCOH') && (strcmp(daystr,'20160113')||strcmp(daystr,'20160702'))
    ref_spec.hcohscdref = 0;%abs(Sf(2));% MLO supposed to be 0 or not? check. -137 from MLO; seem to be correcting the baseline? -24 from MLO 2017
    save([starpaths,daystr,'HCOHrefspec.mat'],'-struct','ref_spec');   
elseif strcmp(gas,'HCOH') && (strcmp(daystr,'20180812')||strcmp(daystr,'20180813'))
    ref_spec.hcohscdref = abs(Sf(2));% MLO supposed to be 0 or not? check. -137 from MLO; seem to be correcting the baseline? -24 from MLO 2017
    save(['C:\Users\msegalro\matlab\4STAR_codes\data_folder\',daystr,'HCOHrefspec.mat'],'-struct','ref_spec'); 
elseif strcmp(gas,'HCOH') && (strcmp(daystr,'20180209')||strcmp(daystr,'20180210') ||strcmp(daystr,'20180212'))
    ref_spec.hcohscdref = 0;%abs(Sf(2));% MLO supposed to be 0 or not? check. -137 from MLO; seem to be correcting the baseline? -24 from MLO 2017
    save([getnamedpath('data_folder'),daystr,'HCOHrefspec.mat'],'-struct','ref_spec');  
end
