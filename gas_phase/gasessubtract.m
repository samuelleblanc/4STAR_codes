%% Details of the function:
% NAME:
%   gasessubtract
% 
% PURPOSE:
%   retrieval of gases amounts using best fit amounts for: 
%   h20,o2,co2,ch4,o3,o4,no2; these amounts are being
%   subtracted from tau_aero spectrum (Rayleigh corrected)
% 
%
% CALLING SEQUENCE:
%  function [tau_sub gas] = gasessubtract(starsun,model_atmosphere)
%
% INPUT:
%  - starsun: starsun struct from starwarapper
%  - model_atmosphere: needed to decide which coef set to use
% 
% 
% OUTPUT:
%  - tau_sub: subtracted tau_aero spectrum
%  - gas: gases struct that includes all retrieved values
%  - gas.O3conc and gas.NO2conc are in DU and are retrieved products
%  - note that currently NO2 is not optimized as well!
%  - other quantities in gas struct are still subject to further check
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%
% NEEDED FILES:
%  - *.xs read by loadCrosSsections.m file 
%
% EXAMPLE:
%  - [tau_sub gas] = gasessubtract(starsun,model_atmosphere);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MSR), NASA Ames,July 25th, 2014
% 2014-08-07 MSR: cleaned subroutine
% 2014-08-14 MSR: no2 subtraction is constant (no2 retrieval not optimized)
% -------------------------------------------------------------------------
%% function routine

function [tau_sub gas] = gasessubtract(starsun,model_atmosphere)
%----------------------------------------------------------------------
 showfigure = 0;
 Loschmidt=2.686763e19;                   % molec/cm3*atm
 colorfig = [0 0 1; 1 0 0; 1 0 1;1 1 0;0 1 1];
 % load cross-sections
 loadCrossSections;
%----------------------------------------------------------------------
%% set wavelength ranges for best fit calc

wvis = starsun.w(1:1044);
wnir = starsun.w(1045:end);
%
% find wavelength range for vis/nir gases bands
% h2o
 nm_0685 = interp1(wvis,[1:length(wvis)],0.680,  'nearest');
 nm_0750 = interp1(wvis,[1:length(wvis)],0.750,  'nearest');
 nm_0780 = interp1(wvis,[1:length(wvis)],0.781,  'nearest');
 nm_0870 = interp1(wvis,[1:length(wvis)],0.869,  'nearest');
 nm_0880 = interp1(wvis,[1:length(wvis)],0.8820, 'nearest');%0.8823
 nm_0990 = interp1(wvis,[1:length(wvis)],0.9940, 'nearest');%0.994
 nm_1040 = interp1(starsun.w,[1:length(starsun.w)],1.038,  'nearest');
 nm_1240 = interp1(starsun.w,[1:length(starsun.w)],1.245,  'nearest');
 nm_1300 = interp1(starsun.w,[1:length(starsun.w)],1.241,  'nearest');% 1.282
 nm_1520 = interp1(starsun.w,[1:length(starsun.w)],1.555,  'nearest');
 % o2
 nm_0684 = interp1(wvis,[1:length(wvis)],0.684,  'nearest');
 nm_0695 = interp1(wvis,[1:length(wvis)],0.695,  'nearest');
 nm_0757 = interp1(wvis,[1:length(wvis)],0.756,  'nearest');
 nm_0768 = interp1(wvis,[1:length(wvis)],0.780,  'nearest');
 % co2
 nm_1555 = interp1(starsun.w,[1:length(starsun.w)],1.555,  'nearest');
 nm_1630 = interp1(starsun.w,[1:length(starsun.w)],1.630,  'nearest');
 % o3 (with h2o and o4)
 nm_0490 = interp1(wvis,[1:length(wvis)],0.490,  'nearest');
 nm_0675 = interp1(wvis,[1:length(wvis)],0.6823,  'nearest');%0.675
 
 % no2 (with o3 and o4)
 nm_0400 = interp1(wvis,[1:length(wvis)],0.430,  'nearest');
 nm_0500 = interp1(wvis,[1:length(wvis)],0.490,  'nearest');
 
 wln_vis1 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880)); 
 wln_vis2 = find(wvis<=wvis(nm_0870)&wvis>=wvis(nm_0780)); 
 wln_vis3 = find(wvis<=wvis(nm_0750)&wvis>=wvis(nm_0685)); 
 wln_vis4 = find(wvis<=wvis(nm_0695)&wvis>=wvis(nm_0684)); 
 wln_vis5 = find(wvis<=wvis(nm_0768)&wvis>=wvis(nm_0757)); 
 wln_vis6 = find(wvis<=wvis(nm_0675)&wvis>=wvis(nm_0490)); 
 wln_vis7 = find(wvis<=wvis(nm_0500)&wvis>=wvis(nm_0400)); 
 wln_nir1 = find(starsun.w<=starsun.w(nm_1240)&starsun.w>=starsun.w(nm_1040)); 
 wln_nir2 = find(starsun.w<=starsun.w(nm_1520)&starsun.w>=starsun.w(nm_1300)); 
 wln_nir3 = find(starsun.w<=starsun.w(nm_1630)&starsun.w>=starsun.w(nm_1555)); 
 
 qqvis = length(wvis);
 qqnir = length(wnir);
 pp    = length(starsun.t);
 qq    = length(starsun.w);
 rateall    =real(starsun.rate./repmat(starsun.f,1,qq)./tr(starsun.m_ray, starsun.tau_ray)); % rate adjusted for the Rayleigh component
 tau_OD=real(-log(rateall./repmat(starsun.c0,pp,1))./repmat(starsun.m_aero,1,qq));% total optical depth
 
% plot spectra
% figure;plot(starsun.w,tau_OD(end-10000,:),'-b');
% hold on;plot(starsun.w,starsun.tau_a_avg(end-10000,:),'--r');
% %hold on;plot(wvis,-log(spc_vis_lamp(2252,:)),'--c');
% legend('lampOD','tau-aero');xlabel('wavelength');ylabel('vertical OD');

% figure;plot([wvis wnir],tau_OD(end-500,:),'-b');
% hold on;plot([wvis wnir],starsun.tau_a_avg(end-500,:),'--r');
% %hold on;plot(wvis,-log(spc_vis_lamp(2252,:)),'--c');
% legend('total OD (Rayleigh sub)','tau-aero (constant subtraction)');xlabel('wavelength');ylabel('vertical OD');

% make subtraction array
tau_OD_wvsubtract  = tau_OD;
%spectrum          = tau_OD(:,wln);
%
%-------------------------------------
% for loop over 5 wavelength range
% this version loops only over 940 nm band
% this is the only values that will be saved
% gasessubtractFull calculates each band
%----------------------------------------
for wrange=1;%[1,2,3,4,5];
switch wrange
    case 1 
    % 940 nm analysis
        lab  = 'cwv940';
        lab2 = 'U940';
        labresi = 'resi940';
        wln  = wln_vis1;
%       wln_ind2 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880));
%       cwv_ind1 = find(wvis<=wvis(nm_0990)&wvis>=wvis(nm_0880));
%       Tw_wln   = find(wvis(wln_ind2)<=0.9945&wvis(wln_ind2)>=0.8823);
        ind = [77:103];% 0.94-0.96
        
    case 2 
    %800 nm analysis
       
        lab  ='cwv800';
        lab2 ='U800';
        labresi = 'resi800';
        wln  = wln_vis2;
        ind = [26:103];%0.80-0.845 nm
        
    case 3 
    %700 nm analysis
        lab  = 'cwv700';
        lab2 = 'U700';
        lab3 = 'band680o2';
        labresi = 'resi700';
        wln  = wln_vis3;
        ind=[32:58];%0.715-0.735 nm
     case 4 
     %1100 nm analysis
         lab  = 'cwv1100';
         lab2 = 'U1100';
         lab3 = 'band1100ch4';
         lab4 = 'band1100o4';
         labresi = 'resi1100';
         wln  = wln_nir1;
         ind=[36:72];%1.1-1.16 nm
     case 5 
     %1400 nm analysis
         lab  = 'cwv1400';
         lab2 = 'U1400';
         lab3 = 'band1400ch4';
         lab4 = 'band1400co2';
         lab5 = 'band1400o4';
         labresi = 'resi1400';
         wln  = wln_nir2;
         ind=[35:105];%1.35-1.45 nm
end % switch

%
% upload a and b parameters (from LBLRTM - new spec FWHM)
 if model_atmosphere==1||model_atmosphere==2 %!!! check if xs should be related to calibration or measurement location 
     xs_ = 'H2O_cross_section_FWHM_new_spec_all_range_Tropical3400m.mat';
     xs  = load(fullfile(starpaths, xs_));
 else
     xs_ = 'H2O_cross_section_FWHM_new_spec_all_range_midLatWinter6850m.mat';
     xs  = load(fullfile(starpaths, xs_));
 end
 %
 % interpolate H2O parameters to whole wln grid
 % this is not used here; altitude interpolated is used
 H2Oa = interp1(xs.wavelen,xs.cs_sort(:,1),(starsun.w)*1000,'nearest','extrap');
 H2Ob = interp1(xs.wavelen,xs.cs_sort(:,2),(starsun.w)*1000,'nearest','extrap');
 % transform H2Oa nan to zero
 H2Oa(isnan(H2Oa)==1)=0;
 % transform H2Oa inf to zero
 H2Oa(isinf(H2Oa)==1)=0;
 % transform H2Oa negative to zero
 H2Oa(H2Oa<0)=0;
 % transform H2Ob to zero if H2Oa is zero
 H2Ob(H2Oa==0)=0;
 H2O_conv=1244.12; %converts cm-atm in pr cm or g/cm2.  the conversion factor has units of [cm^3/g]. 
 
%------------------------------------------------------------

%% fmincon conversion

% main fit routine for all water vapor ranges
%%
% load altitude dependent coef.
     alt0    = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum0m.mat'));
     alt1000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum1000m.mat'));
     alt2000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum2000m.mat'));
     alt3000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum3000m.mat'));
     alt4000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum4000m.mat'));
     alt5000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum5000m.mat'));
     alt6000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatwsum6000m.mat'));
     alt7000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer7000m.mat'));
     alt8000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer8000m.mat'));
     alt9000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer9000m.mat'));
     alt10000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer10000m.mat'));
     alt11000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer11000m.mat'));
     alt12000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer12000m.mat'));
     alt13000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer13000m.mat'));
     alt14000 = load(fullfile(starpaths,'H2O_cross_section_FWHM_new_spec_all_range_midLatSummer14000m.mat'));



      zkm_LBLRTM_calcs=[0:14];
      afit_H2O=[alt0.cs_sort(:,1) alt1000.cs_sort(:,1) alt2000.cs_sort(:,1) alt3000.cs_sort(:,1) alt4000.cs_sort(:,1) alt5000.cs_sort(:,1) alt6000.cs_sort(:,1) alt7000.cs_sort(:,1) alt8000.cs_sort(:,1) alt9000.cs_sort(:,1)...
                alt10000.cs_sort(:,1) alt11000.cs_sort(:,1) alt12000.cs_sort(:,1) alt13000.cs_sort(:,1) alt14000.cs_sort(:,1)];
      bfit_H2O=[alt0.cs_sort(:,2) alt1000.cs_sort(:,2) alt2000.cs_sort(:,2) alt3000.cs_sort(:,2) alt4000.cs_sort(:,2) alt5000.cs_sort(:,2) alt6000.cs_sort(:,2) alt7000.cs_sort(:,2) alt8000.cs_sort(:,2) alt9000.cs_sort(:,2)...
                alt10000.cs_sort(:,2) alt11000.cs_sort(:,2) alt12000.cs_sort(:,2) alt13000.cs_sort(:,2) alt14000.cs_sort(:,2)];
      cfit_H2O=ones(length(xs.wavelen),length(zkm_LBLRTM_calcs));
      
      afit_allH2O=[alt0.cs_sort(1:1556,1) alt1000.cs_sort(1:1556,1) alt2000.cs_sort(1:1556,1) alt3000.cs_sort(1:1556,1) alt4000.cs_sort(1:1556,1) alt5000.cs_sort(1:1556,1) alt6000.cs_sort(1:1556,1) alt7000.cs_sort(1:1556,1) alt8000.cs_sort(1:1556,1) alt9000.cs_sort(1:1556,1)...
                alt10000.cs_sort(1:1556,1) alt11000.cs_sort(1:1556,1) alt12000.cs_sort(1:1556,1) alt13000.cs_sort(1:1556,1) alt14000.cs_sort(1:1556,1)];
      bfit_allH2O=[alt0.cs_sort(1:1556,2) alt1000.cs_sort(1:1556,2) alt2000.cs_sort(1:1556,2) alt3000.cs_sort(1:1556,2) alt4000.cs_sort(1:1556,2) alt5000.cs_sort(1:1556,2) alt6000.cs_sort(1:1556,2) alt7000.cs_sort(1:1556,2) alt8000.cs_sort(1:1556,2) alt9000.cs_sort(1:1556,2)...
                alt10000.cs_sort(1:1556,2) alt11000.cs_sort(1:1556,2) alt12000.cs_sort(1:1556,2) alt13000.cs_sort(1:1556,2) alt14000.cs_sort(1:1556,2)];
%%
% start iterative fits
%---------------------
swv_opt=[];
wv_residual = [];

for i = 1:length(starsun.t)
    
       % choose right altitude coef
        if ~isNaN(starsun.Altavg(i))
              kk=find(starsun.Altavg(i)/1000>=zkm_LBLRTM_calcs);
              if starsun.Altavg(i)/1000<=0 kk=1; end            %handles alts slightly less than zero
              kz=kk(end);
              
        % alternative method
%         kzy=floor(interp1(zkm_LBLRTM_calcs,1:numel(zkm_LBLRTM_calcs), starsun.Altavg/1000));
%         kzy(kzy<1 | ~isfinite(kzy))=1;
        else 
             kz=1; 
        end
       % !!! can use co2/ch4/o2 xs altitude dependance similarly
       %
       %  x0 = [300 10000 10000 0.75 0.8 -2 -0.1]; % this is initial guess
       if wrange==3
           x0 = [5000 50000 0.75 0.8 -2];% last 3 are baseline poly coef
       elseif wrange==4
           x0 = [5000 100 0.75 0.8 -2];
       elseif wrange==5
           x0 = [5000 1000 1000 1000 0.75 0.8 -2];
       else
           x0 = [5000 0.75 0.8 -2];
       end
       % meas 
       y =     tau_OD(i,wln);%this is total OD (divided by airmass)
       meas = [starsun.w(wln)' y'];
       Xdat = meas(:,1);
       % param
       ac = real(afit_H2O(wln,kz)); ac(isNaN(ac)) = 0; ac(ac<0) = 0; ac(isinf(ac)) = 0;
       bc = real(bfit_H2O(wln,kz)); bc(isNaN(bc)) = 0; bc(bc<0) = 0; bc(isinf(bc)) = 0;
       PAR  = [ac bc];
       PAR3 = [ac bc o2coef(wln)];
       PAR4 = [ac bc ch4coef(wln)];
       PAR5 = [ac bc ch4coef(wln) co2coef(wln) o4coef(wln)];
       % Set Options
       options = optimset('Algorithm','sqp','LargeScale','off','TolFun',1e-12,'Display','notify-detailed','TolX',1e-6,'MaxFunEvals',1000);%optimset('Algorithm','interior-point','TolFun',1e-12);%optimset('MaxIter', 400);
       
       % bounds
       if wrange==3
           lb = [0 0 -10 -10 -10];
           ub = [10000   10000 20 20 20];
           U_ = [NaN NaN NaN NaN NaN];
       elseif wrange==4
           lb = [0 0 -10 -10 -10];
           ub = [50000 10000 20 20 20];
           U_ = [NaN NaN NaN NaN NaN];
       elseif wrange==5
           lb = [0 0 0 0 -10 -10 -10];
           ub = [50000 10000 10000 10000 20 20 20];
           U_ = [NaN NaN NaN NaN NaN NaN];
       else
           lb = [0 -10 -10 -10];
           ub = [10000 20 20 20];%max(max(real(U)));
           U_ = [NaN NaN NaN NaN];
       end
       
       if x0(1)>=ub(1)
           x0(1) = ub(1)/2;
       elseif x0(1)<0
           x0(1) = lb(1);
       elseif isNaN(x0(1))
           x0(1) = lb(1);
       end
       
       %ynan = isNaN(y); realy = isreal(y);
       % check spectrum validity for conversion
       ypos = logical(y>=0);ylarge = logical(y>=5);
       if ~isNaN(y(1)) && isreal(y) && sum(ypos)>length(wln)-15 && sum(ylarge)<10 && sum(isinf(y))==0
           if wrange==3
            [U_,fval,exitflag,output]  = fmincon('H2OO2resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR3);
           elseif wrange==4
            ylarge = logical(y>=2);
            if sum(ylarge)<10
            [U_,fval,exitflag,output]  = fmincon('H2OCH4resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR4);
            end
           elseif wrange==5
            ylarge = logical(y>=2);
            if sum(ylarge)<10
            [U_,fval,exitflag,output]  = fmincon('H2OCH4CO2O4resi',x0,[],[],[],[],lb,ub, [], options, meas,PAR5);
            end
           else
            ylarge = logical(y>=2);
            if sum(ylarge)<10
            [U_,fval,exitflag,output]  = fmincon('H2Oresi',x0,[],[],[],[],lb,ub, [], options, meas,PAR);
            end
           end
                    if ( isNaN(U_(1)) || ~isreal(U_(1)) || U_(1)<0 )
                        if wrange==3||wrange==4
                            U_ = [NaN NaN NaN NaN NaN];
                            swv_opt = [swv_opt; U_];
                            wv_residual = [wv_residual;NaN];
                        elseif wrange==5
                            U_ = [NaN NaN NaN NaN NaN NaN NaN];
                            swv_opt = [swv_opt; U_];
                            wv_residual = [wv_residual;NaN];
                        else
                            U_ = [NaN NaN NaN NaN];
                            swv_opt = [swv_opt; U_];
                            wv_residual = [wv_residual;NaN];
                        end

                    else
                        if wrange==3||wrange==4
                            swv_opt = [swv_opt; real(U_)];
                            wv_residual = [wv_residual;real(fval)];
                        elseif wrange==5
                            swv_opt = [swv_opt; real(U_)];
                            wv_residual = [wv_residual;real(fval)];
                        else
                            swv_opt = [swv_opt; real(U_)];
                            wv_residual = [wv_residual;real(fval)];
                        end
                        cwv_opt_ = (real(U_(1))/H2O_conv);%/starsun.m_H2O_avg(i); 
                        cwv_opt_round = round(cwv_opt_*100)/100;
                       %[x,fval,exitflag,output,lambda,grad] =  fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
                       % plot fitted figure
                       if wrange==3
                           yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(o2coef(wln).*real(U_(2)))).*exp(-(real(U_(3)) + real(U_(4))*Xdat + real(U_(5))*Xdat.^2));
                           yopt  = real(-log(yopt_));
                           ysub  = real(-log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(o2coef(wln).*real(U_(2))))));
                       elseif wrange==4
                           yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2)))).*exp(-(real(U_(3)) + real(U_(4))*Xdat + real(U_(5))*Xdat.^2));
                           yopt  = real(-log(yopt_));
                           ysub  = real(-log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2))))));
                       elseif wrange==5
                           yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2)))).*exp(-(co2coef(wln).*real(U_(3)))).*exp(-(o4coef(wln).*real(U_(4))))...
                                    .*exp(-(real(U_(5)) + real(U_(6))*Xdat + real(U_(7))*Xdat.^2));
                           yopt  = real(-log(yopt_));
                           ysub  = -log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(ch4coef(wln).*real(U_(2)))).*exp(-(co2coef(wln).*real(U_(3)))).*exp(-(o4coef(wln).*real(U_(4)))));
                       else
                           yopt_ =  exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz)).*exp(-(real(U_(2)) + real(U_(3))*Xdat + real(U_(4))*Xdat.^2));
                           yopt  = (-log(yopt_));
                           ysub  = real(-log(exp(-afit_H2O(wln,kz).*(real(U_(1))).^bfit_H2O(wln,kz))));
                       end
                       % assign fitted spectrum to subtract
                       tau_aero_fitsubtract(i,wln) = ysub;
                       % wvODfit(i,wln) = real(yopt) + baseline(i,:)'; %(add subtracted baseline to retrieved fit)
        %                        figure(444);
        %                        plot(starsun.w(wln),y,'-b');hold on;
        %                        plot(starsun.w(wln),yopt,'--r');hold on;
        %                        plot(starsun.w(wln),ysub,'-c');hold on;
        %                        plot(starsun.w(wln),y'-ysub,'-k');hold off;
        %                        xlabel('wavelength','fontsize',12);ylabel('total slant water vapor OD','fontsize',12);
        %                        legend('measured','calculated (fit)','spectrum to subtract','subtracted spectrum');
        %                        title([datestr(starsun.t(i),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Altavg(i)) 'm' ' CWV= ' num2str(cwv_opt_round)]);
        %                        ymax = yopt + 0.2;
        %                        if max(ymax)<0 
        %                            ymaxax=1; 
        %                        else
        %                            ymaxax=max(ymax);
        %                        end;
        %                        axis([min(starsun.w(wln)) max(starsun.w(wln)) 0 ymaxax]);
        %                        pause(0.0001);


                    end
       else
           if wrange==3||wrange==4
               U_ = [NaN NaN NaN NaN NaN];
               swv_opt = [swv_opt; U_];
               wv_residual = [wv_residual;NaN];
           elseif wrange==5
               U_ = [NaN NaN NaN NaN NaN NaN NaN];
               swv_opt = [swv_opt; U_];
               wv_residual = [wv_residual;NaN];
           else
               U_ = [NaN NaN NaN NaN];
               swv_opt = [swv_opt; U_];
               wv_residual = [wv_residual;NaN];
           end
       end
% water vapor subtraction per altitude (based on 940 nm band)
    if wrange==1
    % subtract water vapor for all but o3 region
    %afit_H2Os(:,kz) = afit_H2O(:,kz); % these had error of scalar
    afit_H2Os = afit_H2O(:,kz); afit_H2Os(isNaN(afit_H2Os)) = 0; afit_H2Os(afit_H2Os<0) = 0; afit_H2Os(isinf(afit_H2Os)) = 0;
    bfit_H2Os = bfit_H2O(:,kz); bfit_H2Os(isNaN(bfit_H2Os)) = 0; bfit_H2Os(bfit_H2Os<0) = 0; bfit_H2Os(isinf(bfit_H2Os)) = 0;
    % afit_H2Os(1:nm_0675,kz) = 0;  bfit_H2Os(1:nm_0675,kz) = 0;
    afit_H2Os(1:nm_0675) = 0;  bfit_H2Os(1:nm_0675) = 0;
    
    %afit_H2Os(1:nm_0675,kz) = zeros([1:nm_0675],1);  bfit_H2Os(1:nm_0675,kz) = zeros([1:nm_0675],1);
    wvamount = -log(exp(-afit_H2Os.*(real(swv_opt(i,1))).^bfit_H2Os));
    tau_OD_wvsubtract(i,:) = tau_OD(i,:)-wvamount';
    end
end
   cwv_opt = (swv_opt(:,1)/H2O_conv);%./starsun.m_H2O_avg;  %conversion from slant path to vertical
   if wrange==3 || wrange==4
       cwv.(lab3) = swv_opt(:,2);%./starsun.m_ray_avg; % this is [atm x cm]     !! check if needs to be divided with airmass
   elseif wrange==5
       cwv.(lab3) = swv_opt(:,2);%./starsun.m_ray_avg; % this is [atm x cm]     !! check if needs to be divided with airmass
       cwv.(lab4) = swv_opt(:,3);%./starsun.m_ray_avg; % this is [atm x cm]     !! check if needs to be divided with airmass
       cwv.(lab5) = swv_opt(:,4);%./starsun.m_ray_avg; % this is [atm x cm]     !! check if needs to be divided with airmass
   end
    
    % save in each wavelength range retrieval
    cwv.(lab)     = cwv_opt;
    %cwv.(lab2)    = avg_U1;
    cwv.(labresi) = wv_residual;

end % end for loop over all wavelength range cases
% assign wv subtracted array to OD
  tau_OD_fitsubtract1 = tau_OD_wvsubtract;  % 1 is only wv subtracted (no O3 region)
%% subtract/retrieve CO2
    wln = wln_nir3;
   [CH4conc CO2conc CO2resi co2OD] = co2corecalc(starsun,ch4coef,co2coef,wln,tau_OD);
   gas.band1600co2 = CO2conc;%./starsun.m_ray_avg;% slant converted to vertical
   gas.band1600ch4 = CH4conc;%./starsun.m_ray_avg;% slant converted to vertical
   gas.band1600resi= CO2resi;
   co2amount = CO2conc*co2coef';
   ch4amount = CH4conc*ch4coef';
   tau_OD_fitsubtract2 = tau_OD_fitsubtract1 - co2amount - ch4amount;   % this is wv, co2 and ch4 subtraction
%     figure;
%     plot(starsun.w,tau_OD(end-500,:),'-b');hold on;
%     plot(starsun.w,tau_OD(end-500,:)-co2amount(end-500,:),'--g');xlabel('wavelength');ylabel('OD');
%     plot(starsun.w,tau_OD(end-500,:)-ch4amount(end-500,:),'--c');xlabel('wavelength');ylabel('OD');
%     plot(starsun.w,tau_OD(end-500,:)-co2amount(end-500,:)-ch4amount(end-500,:),'--k');xlabel('wavelength');ylabel('OD');
%     legend('total OD','OD after CO2 subtraction','OD after CH4 subtraction','OD after CO2+CH4 subtraction');
   %tau_aero_fitsubtract = tau_OD_wvsubtract - co2amount - ch4amount;
   %tau_aero_fitsubtract(:,wln_nir3) = tau_OD(:,wln_nir3) - co2subtract;
   %spec_subtract(:,wln_nir3) = co2spec;
%%
%% subtract/retrieve O2
% for ii=2
%     if ii==1
%         wln = wln_vis4;
%     elseif ii==2
      wln = wln_vis5;
%     end
% !!! to improve use modc0 in o2 region? and shift/stretch
    O2conc = []; O2resi = [];
   [O2conc O2resi o2OD] = o2corecalc(starsun,o2coef,wln,tau_OD);
%    if ii==1
%        gas.band680o2  = O2conc./starsun.m_ray_avg;% slant converted to vertical
%        gas.band680resi= O2resi;
%        gas.band680OD  = o2OD;
%    elseif ii==2
       gas.band760o2  = O2conc;%./starsun.m_ray_avg;% slant converted to vertical
       gas.band760resi= O2resi;
       gas.band760OD  = o2OD;
%    end
% end
o2amount = -log(exp(-(real(O2conc)*o2coef')));%O2conc*o2coef';
tau_OD_fitsubtract3 = tau_OD_fitsubtract2 - o2amount;% o2 subtraction
% figure;
% plot(starsun.w,tau_OD(end-500,:),'-b');hold on;
% plot(starsun.w,tau_OD(end-500,:)-o2amount(end-500,:),'--c');xlabel('wavelength');ylabel('OD');
% legend('total OD','OD after O2 subtraction');
%tau_aero_fitsubtract(:,wln_vis5) = tau_OD(:,wln_vis5) - o2subtract;
%tau_aero_fitsubtract(:,wln_vis5) = o2subtract(:,wln_vis5);
%spec_subtract(:,wln_vis5) = o2spec;
%%
%% subtract/retrieve O3/h2o/o4 region
   wln = wln_vis6;
   O3conc=[];H2Oconc=[];O4conc=[];O3resi=[];o3OD=[];
   [O3conc H2Oconc O4conc O3resi o3OD] = o3corecalc(starsun,o3coef,o4coef,h2ocoef,wln,tau_OD);
   gas.o3  = O3conc;%in DU./starsun.m_o3_avg;  % slant converted to vertical
   gas.o4  = O4conc;%./starsun.m_ray_avg; % slant converted to vertical
   gas.h2o = H2Oconc;%./starsun.m_h2o_avg;% slant converted to vertical
   gas.o3resi= sqrt(O3resi/length(wln_vis6));
   gas.o3OD  = o3OD;                    % this is to be subtracted from slant path;
   
   o3amount = -log(exp(-(real(O3conc/1000)*o3coef')));%(O3conc/1000)*o3coef';
   o4amount = -log(exp(-(real(O4conc)*o4coef')));%O4conc*o4coef';
   h2ocoefVIS = zeros(qq,1); h2ocoefVIS(wln_vis6) = h2ocoef(wln_vis6);
   h2oamount= -log(exp(-(real(H2Oconc)*h2ocoefVIS')));%H2Oconc*h2ocoefVIS';
   %tau_OD_fitsubtract = tau_OD - o3amount - o4amount -h2oamount;
   tau_OD_fitsubtract4 = tau_OD_fitsubtract3 - o3amount - o4amount -h2oamount;% subtraction of remaining gases in o3 region
%    figure;
%    plot(starsun.w,tau_OD(end-500,:),'-b');hold on;
%    plot(starsun.w,tau_OD(end-500,:)-o3amount(end-500,:),'--r');xlabel('wavelength');ylabel('OD');
%    plot(starsun.w,tau_OD(end-500,:)-o4amount(end-500,:),'--c');xlabel('wavelength');ylabel('OD');
%    plot(starsun.w,tau_OD(end-500,:)-h2oamount(end-500,:),'--g');xlabel('wavelength');ylabel('OD');
%    plot(starsun.w,tau_OD(end-500,:)-o3amount(end-500,:)-o4amount(end-500,:)-h2oamount(end-500,:),'-k','linewidth',1.5);hold on;
%    plot(starsun.w,starsun.tau_a_avg(end-500,:),'-m','linewidth',1.5);
%    xlabel('wavelength');ylabel('OD');
%   
%    legend('total OD','OD after O3 subtraction','OD after O4 subtraction','OD after H2O subtraction','OD after O3+O4+H2O subtraction','tau-aero');
%    
   %tau_aero_fitsubtract(:,wln_vis6) = tau_OD(:,wln_vis6) - o3subtract;
   %spec_subtract(:,wln_vis6)        = o3subtract(:,wln_vis6);
%%
%% subtract/retrieve NO2/O3/O4 region
   wln = wln_vis7;
   NO2conc = []; NO2resi=[];
   [NO2conc NO2resi no2OD tau_OD_fitsubtract5] = no2corecalc(starsun,no2coef,o4coef,o3coef,wln,tau_OD_fitsubtract4);%tau_OD
   % no2OD is the spectrum portion to subtract
   gas.no2  = NO2conc;%in [DU]
   gas.no2resi= sqrt(NO2resi/length(wln_vis7));
   gas.no2OD  = no2OD;                    % this is to be subtracted from total OD;
   %no2amount = (NO2conc)*no2coef';
   %no2amount = (1.86e-4)*repmat(no2coef',pp,1);  % constant value
   %tau_OD_fitsubtract5 = tau_OD_fitsubtract4 - no2amount;
   tau_sub = tau_OD_fitsubtract4;%tau_OD_fitsubtract5;
   %tau_sub(:,1:nm_0490) = starsun.tau_a_avg(:,1:nm_0490);
   tau_sub(:,1:nm_0490) = tau_OD(:,1:nm_0490);
%    figure;
%    plot(starsun.w,tau_OD(end-500,:),'-b');hold on;
%    plot(starsun.w,tau_OD(end-500,:)-no2amount(end-500,:),'--y');xlabel('wavelength');ylabel('OD');
%    legend('total OD','OD after NO2 subtraction');
   %tau_aero_fitsubtract(:,wln_vis7) = tau_OD(:,wln_vis7) - no2subtract;
   %spec_subtract(:,wln_vis6)        = o3subtract(:,wln_vis6);
%% end fmincon
%%
% plot subtraction results
% comment out to increase speed
% for k=1:500:length(starsun.t)
%    figure(1111);
%    plot(starsun.w,tau_OD(k,:),'-b','linewidth',2);hold on;
%    plot(starsun.w,tau_OD_fitsubtract1(k,:),'--r','linewidth',2);hold on;%wv
%    plot(starsun.w,tau_OD_fitsubtract2(k,:),'--g','linewidth',2);hold on;%co2+ch4
%    plot(starsun.w,tau_OD_fitsubtract3(k,:),'--c','linewidth',2);hold on;%o2
%    plot(starsun.w,tau_OD_fitsubtract4(k,:),'--y','linewidth',2);hold on;%o3+o4+h2o
%    plot(starsun.w,tau_sub(k,:),'--m','linewidth',2);hold on;%no2
%    plot([wvis wnir],starsun.tau_a_avg(k,:),':k','linewidth',2);hold off;
%    xlabel('wavelength');ylabel('OD');legend('total OD','wv (940 nm) subtraction','co2+ch4 subtraction','o2 subtraction','o3+o4+h2o subtraction','no2 subtraction','tau-aero');
%    xlabel('wavelength','fontsize',12);ylabel('OD','fontsize',12);
%                        title([datestr(starsun.t(k),'yyyy-mm-dd HH:MM:SS') ' Alt= ' num2str(starsun.Altavg(k)) 'm']);
%                        ymax = yopt + 0.2;
%                        if max(ymax)<0 
%                            ymaxax=1; 
%                        else
%                            ymaxax=max(ymax);
%                        end;
%                       axis([0.35 1.65 0 ymaxax]);
%                       pause(0.0001);
% end
%%
%---------------------------------------------------------------------
 return;
