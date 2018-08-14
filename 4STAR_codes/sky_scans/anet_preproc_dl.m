function [lv, tests] = anet_preproc_dl(star)
% test = anet_preproc_dl(star)
% Apply pre-processing criteria from Holben PDF to sky scans.
% returns a data level of 1, 1.5, and 2.0
% Due to requirement for duplicated measurements only ALM can ever be
% assigned level 2.
lv = 1;

if isfield(star.toggle,'sky_SA_min')
    SA_min = star.toggle.sky_SA_min;
else
    SA_min = 3.5;
end
% minimum acceptable elevation angle, equiv to airmass about 10
if isfield(star.toggle,'sky_El_min')
    El_min = star.toggle.sky_El_min;
else
    El_min = 6; %  ~= airmass<10
end
% Check tau_aero(440) > 0.4
% tau_aero = star.tau_aero(star.Str==1 & star.Zn == 0,star.aeronetcols);
% if size(star.tau_aero,1)>1
%     tau_aero = mean(star.tau_aero(star.Str==1 & star.Zn == 0,star.aeronetcols),1);
% else
%     tau_aero = star.tau_aero(star.aeronetcols);
% end
% Just in case we didn't actually select a 440nm measurement, compute an
% estimate from an angstrom exponent from the nearest two wavelengths.
tau_aero = star.AOD;
[~,tau_ii] = sort(abs(star.w(star.aeronetcols)-.44));
tau_ang = ang_exp(tau_aero(star.aeronetcols(tau_ii(1))), tau_aero(star.aeronetcols(tau_ii(2))),...
    star.w(star.aeronetcols(tau_ii(1))), star.w(star.aeronetcols(tau_ii(2))));
tests.tau_440 = ang_coef(tau_aero(star.aeronetcols(tau_ii(1))), tau_ang, star.w(star.aeronetcols(tau_ii(1))),0.44);


SA = star.SA;
% Exclude scattering angles <3.5 and any saturated or NaN values
if star.isALM
    almA_ii = find(star.good_almA&~any(isNaN(star.skyrad(:,star.aeronetcols)),2)...
        & SA>=SA_min & star.El_gnd>=El_min);
    almB_ii = find(star.good_almB&~any(isNaN(star.skyrad(:,star.aeronetcols)),2)...
        & SA>=SA_min & star.El_gnd>=El_min);
    if isempty(almA_ii) || isempty(almB_ii)
        alm_ii = [almA_ii;almB_ii];
        Az = mod(star.Az_sky(alm_ii)-star.sunaz(alm_ii),180);
        az_180 = Az>175;
        SA_alm = star.SA(alm_ii);
        rad_alm = star.skyrad(alm_ii,star.aeronetcols);
        % AERONET requires <20% except for Az=180 which is <5%

        tests.N_SA_lt_6 = length(unique(round(SA_alm(SA_alm>=3.5&SA_alm<6))));
        tests.N_SA_lt_30 = length(unique(round(SA_alm(SA_alm>=6&SA_alm<30))));
        tests.N_SA_lt_80 = length(unique(round(SA_alm(SA_alm>=30&SA_alm<80))));
        tests.N_SA_gte_80 = length(unique(round(SA_alm(SA_alm>=80))));
        tests.N_SA = length(unique(round(SA_alm(SA_alm>=3.5))));
        tests.sel_max = max(star.sunel);
        tests.sza_min = min(90-star.sunel);
    else
        [inA, inB] = nearest(star.SA(almA_ii), star.SA(almB_ii));
        Az_A = mod(star.Az_sky(almA_ii(inA))-star.sunaz((almA_ii(inA))),180);
        Az_B = mod(star.Az_sky(almB_ii(inB))-star.sunaz((almB_ii(inB))),180);
        az_180 = Az_A>175 & Az_B>175;
        SA_A = star.SA(almA_ii(inA)); SA_B = star.SA(almB_ii(inB));
        rad_A = star.skyrad(almA_ii(inA),star.aeronetcols);
        rad_B = star.skyrad(almB_ii(inB),star.aeronetcols);
        rad_sym = abs((rad_A - rad_B)./((rad_A + rad_B)./2));
        
        % AERONET requires <20% except for Az=180 which is <5%
%         sym = ~any(rad_sym(:,1:end-1)>0.20,2);
%         sym(az_180) = ~any(rad_sym(az_180,1:end-1)>0.05,2);
%         
%         SA_A = SA_A(sym); SA_B = SA_B(sym);
%         rad_A = rad_A(sym,:); rad_B = rad_B(sym,:);
%         rad_sym = rad_sym(sym,:);
        tests.N_SA_lt_6 = length(unique(round(SA_A(SA_A>=3.5&SA_A<6))));
        tests.N_SA_lt_30 = length(unique(round(SA_A(SA_A>=6&SA_A<30))));
        tests.N_SA_lt_80 = length(unique(round(SA_A(SA_A>=30&SA_A<80))));
        tests.N_SA_gte_80 = length(unique(round(SA_A(SA_A>=80))));
        tests.N_SA = length(unique(round(SA_A(SA_A>=3.5))));
        tests.sel_max = max(star.sunel);
        tests.sza_min = min(90-star.sunel);
        ! Check that SA > 80 is really a requirement for lv 1.5
        if (tests.N_SA_lt_6>0) & (tests.N_SA_lt_30>0) &  (tests.N_SA_lt_80>0) & ...
                (tests.N_SA_gte_80>0) & (tests.N_SA >= 10)
            lv = 1.5;
        end
        
        % Solar El must be < 40 to ensure large enough range of scattering angle in
        % ALM scan
        
        if (tests.N_SA_lt_6>=2) & (tests.N_SA_lt_30>=5) &  (tests.N_SA_lt_80>=4) &  ...
                (tests.N_SA_gte_80>=3) & (tests.N_SA >= 21) & tests.tau_440 > 0.4 ...
                & max(tests.sel_max)<40;
            lv = 2;
        end        
    end
elseif star.isPPL
    ppl_ii = find(star.good_ppl & ~any(isNaN(star.skyrad(:,star.aeronetcols)),2)&...
        SA>=SA_min & star.El_gnd>=El_min);
    SA_ = star.SA(ppl_ii);
    % rad_ppl = star.skyrad(ppl_ii,star.aeronetcols);
    tests.N_SA_lt_6 = length(unique(round(SA_(SA_>=3.5&SA_<6))));
    tests.N_SA_lt_30 = length(unique(round(SA_(SA_>=6&SA_<30))));
    tests.N_SA_lt_80 = length(unique(round(SA_(SA_>=30&SA_<80))));
    tests.N_SA_gte_80 = length(unique(round(SA_(SA_>=80))));
    tests.N_SA = length(unique(round(SA_(SA_>=3.5))));
    if (tests.N_SA_lt_6>0) && (tests.N_SA_lt_30>0) &&  (tests.N_SA_lt_80>0) && ...
            (tests.N_SA_gte_80>0) && (tests.N_SA >= 10)
        lv = 1.5;
    end
    
    else
        warning('Not a sky scan?');
        lv = 0;
        tests = [];
        
end
return