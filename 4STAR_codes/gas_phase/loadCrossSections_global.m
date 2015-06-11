 %  load cross-sections
 %% load gases cross-sections
 % HITRAN convolved with 4STAR (we might want to create LUT for various
 % alt) for CO2/H2O/CH4/O4, Richards et al. 2010 for O4, Vandaele et al.,
 % 1997 for NO2, Bogumil et al., 2003 for O3
 % MS, 2015-05-01, added HCOH and BrO cross sections
 %----------------------------------------------------------------------
 %function s= loadCrossSections
     Loschmidt=2.686763e19;             % molec/cm3*atm
     vis.nm = load(fullfile(starpaths,'visLambda.txt'));
     nir.nm = load(fullfile(starpaths,'nirLambda.txt'));
     
     % h2o
     watervis = importdata(fullfile(starpaths,'H2O_1013mbar273K_vis.xs'));
     water.visnm     = watervis.data(:,1);
     water.visXs     = watervis.data(:,2);
     water.visInterp = interp1(water.visnm, water.visXs, vis.nm,'pchip','extrap');
     waternir = importdata(fullfile(starpaths,'H2O_1013mbar273K_nir.xs'));
     water.nirnm     = waternir.data(:,1);
     water.nirXs     = waternir.data(:,2);
     water.nirInterp = interp1(water.nirnm, water.nirXs, nir.nm,'pchip','extrap');
     
     % o2
     o2vis  = importdata(fullfile(starpaths,'O2_1013mbar273K_vis4star.xs'));
     o2.visnm     = o2vis.data(:,1);
     o2.visXs     = o2vis.data(:,2);
     o2.visInterp = interp1(o2.visnm, o2.visXs, vis.nm,'pchip','extrap');
     o2nir  = importdata(fullfile(starpaths,'O2_1013mbar273K_nir4star.xs'));
     o2.nirnm     = o2nir.data(:,1);
     o2.nirXs     = o2nir.data(:,2);
     o2.nirInterp = interp1(o2.nirnm, o2.nirXs, nir.nm,'pchip','extrap');
     
     % co2
     co2vis = importdata(fullfile(starpaths,'CO2_1013mbar273K_vis4star.xs'));
     co2.visnm     = co2vis.data(:,1);
     co2.visXs     = co2vis.data(:,2);
     co2.visInterp = interp1(co2.visnm, co2.visXs, vis.nm,'pchip','extrap');
     co2nir = importdata(fullfile(starpaths,'CO2_1013mbar273K_nir4star.xs'));
     co2.nirnm     = co2nir.data(:,1);
     co2.nirXs     = co2nir.data(:,2);
     co2.nirInterp = interp1(co2.nirnm, co2.nirXs, nir.nm,'pchip','extrap');
     
     % ch4
     ch4nir = importdata(fullfile(starpaths,'CH4_1013mbar273K_nir4star.xs'));
     ch4.nirnm     = ch4nir.data(:,1);
     ch4.nirXs     = ch4nir.data(:,2);
     ch4.nirInterp = interp1(ch4.nirnm, ch4.nirXs, nir.nm,'pchip','extrap');
     
     % o4
     o4vis  = importdata(fullfile(starpaths,'O4_CIA_296K_vis.xs'));
     o4.visnm     = o4vis.data(:,1);
     o4.visXs     = o4vis.data(:,2);
     o4.visInterp = interp1(o4.visnm, o4.visXs, vis.nm,'pchip','extrap');
     o4nir  = importdata(fullfile(starpaths,'O4_CIA_296K_nir.xs'));
     o4.nirnm     = o4nir.data(:,1);
     o4.nirXs     = o4nir.data(:,2);
     o4.nirInterp = interp1(o4.nirnm, o4.nirXs, nir.nm,'pchip','extrap');
     
     % no2-220K
     no2vis = importdata(fullfile(starpaths,'no2_220K_vanDaele4star_vis.xs'));
     no2_220.visnm     = no2vis.data(:,1);
     no2_220.visXs     = no2vis.data(:,2);
     no2_220.visInterp = interp1(no2_220.visnm, no2_220.visXs, vis.nm,'pchip','extrap');
     clear no2vis
     
     % no2-298K
     no2vis = importdata(fullfile(starpaths,'no2_298K_vanDaele4star_vis.xs'));
     no2_298.visnm     = no2vis.data(:,1);
     no2_298.visXs     = no2vis.data(:,2);
     no2_298.visInterp = interp1(no2_298.visnm, no2_298.visXs, vis.nm,'pchip','extrap');
     clear no2vis
     
     % no2
     no2vis = load(fullfile(starpaths,'no2_vis4star.txt'));
     no2.visnm     = no2vis(:,1);
     no2.visXs     = no2vis(:,2);
     no2.visInterp = interp1(no2.visnm, no2.visXs, vis.nm,'pchip','extrap');
     
     % o3
     o3vis  = load(fullfile(starpaths,'O3_223K_convTech5.txt'));
     o3.visnm     = o3vis(:,1);
     o3.visXs     = o3vis(:,2);
     o3.visInterp = interp1(o3.visnm, o3.visXs, vis.nm,'pchip','extrap');
     % hcoh
     hcohvis = load(fullfile(starpaths,'xs\HCHO_293K4STAR.txt'));
     hcoh.visnm     = hcohvis(:,1);
     hcoh.visXs     = hcohvis(:,2);
     hcoh.visInterp = interp1(hcoh.visnm, hcoh.visXs, vis.nm,'pchip','extrap');
     % bro
     brovis = load(fullfile(starpaths,'xs\BrO_243K_AIR4star.txt'));
     bro.visnm     = brovis(:,1);
     bro.visXs     = brovis(:,2);
     bro.visInterp = interp1(bro.visnm, bro.visXs, vis.nm,'pchip','extrap');
     % ch4
     ch4coef = ([zeros(length(water.visInterp ),1); ch4.nirInterp])*Loschmidt;% convert to atmxcm
     % h2o
     h2ocoef = ([water.visInterp; water.nirInterp])*Loschmidt;% convert to atmxcm
     % co2
     co2coef = ([co2.visInterp; co2.nirInterp])*Loschmidt;% convert to atmxcm
     % o2
     o2coef = ([o2.visInterp;o2.nirInterp])*Loschmidt;% convert to atmxcm
     % o4
     o4coef = ([o4.visInterp;o4.nirInterp])*(Loschmidt^2);% convert to (atmxcm)^2
     % no2-220K
     no2_220Kcoef = ([no2_220.visInterp; zeros(length(water.nirInterp ),1)])*Loschmidt;% convert to atmxcm
     % no2-298K
     no2_298Kcoef = ([no2_298.visInterp; zeros(length(water.nirInterp ),1)])*Loschmidt;% convert to atmxcm
     % no2diff (298-220)
     no2coefdiff = no2_220Kcoef - no2_298Kcoef;
     % no2
     no2coef = ([no2.visInterp; zeros(length(water.nirInterp ),1)])*Loschmidt;% convert to atmxcm
     % o3
     o3coef = ([o3.visInterp; zeros(length(water.nirInterp ),1)])*Loschmidt;% convert to atmxcm
     % bro
     brocoef = ([bro.visInterp; zeros(length(water.nirInterp ),1)])*Loschmidt;% convert to atmxcm
     % hcoh
     hcohcoef = ([hcoh.visInterp; zeros(length(water.nirInterp ),1)])*Loschmidt;% convert to atmxcm
     
%return;
     % plot cross sections
%     figure;plot(vis.nm,water.visInterp,'-b');hold on;plot(nir.nm,water.nirInterp,'-r');hold on;
%     hold on;
%     % plot conv water vapor and sample spectrum
%     waterOD = -log(Tw); % after Rayleigh and aerosol subtraction
%     x = repmat(starsun.m_H2O_avg,1,length(wln)).*(U);
%     acoef = repmat((afit_H2O(wln,1))',length(starsun.t),1);
%     bcoef = repmat((bfit_H2O(wln,1))',length(starsun.t),1);
%     %Twcalc  =  exp(-afit_H2O(:,1).*(x0).^bfit_H2O(:,1));
%     Twcalc  =  exp(-acoef.*(x).^bcoef);
%     waterODcalc = -log(Twcalc);
%     % waterODcalc = acoef.*(x).^bcoef;
%     % plot calcuated versus measured
%     figure;
%     plot(wvis(wln),waterOD    (end,:),'-b');hold on;   % measured
%     plot(wvis(wln),waterODcalc(end,:),'--r');hold on;   % calculated from coef
%     xlabel('wavelength');ylabel('water vapor OD');legend('measured','calculated from coef');
%     %
%     figure;plot(vis.nm,1e21*water.visInterp,'-b');hold on;plot(nir.nm,5e20*water.nirInterp,'-r');hold on;
%     plot(1000*wvis(wln),waterOD(end-10,:)/20,'--c');
%     plot(1000*starsun.w,starsun.tau_aero(end-10,:)/20,'--g');
%     legend('water vapor cross section vis','water vapor cross section nir','waterOD-modLAngley','waterOD-tauaero');
%     % plot sample ground spectrum
%     hold off;
%     axis([300 1700 0 0.15]);xlabel('wavelength [nm]');legend('water vapor conv vis (scaled)','water vapor conv nir (scaled)','4star ground spectrum');