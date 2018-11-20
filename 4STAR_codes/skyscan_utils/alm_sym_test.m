function [good_almA, good_almB] = alm_sym_test(star)
% [good_almA, good_almB] = alm_sym_test(star)
% Tests almucantar CW and CCW for symmetry

SA = star.SA;
good_almA = star.good_almA & ~any(isNaN(star.skyrad(:,star.aeronetcols)),2);
good_almB = star.good_almB & ~any(isNaN(star.skyrad(:,star.aeronetcols)),2);
almA_ii = find(good_almA);
almB_ii = find(good_almB);
if star.isALM && ~isempty(almA_ii)&&~isempty(almB_ii)
    [inA, inB] = nearest(star.SA(almA_ii), star.SA(almB_ii));
    Az_A = mod(star.Az_sky(almA_ii(inA))-star.sunaz((almA_ii(inA))),180);
    Az_B = mod(star.Az_sky(almB_ii(inB))-star.sunaz((almB_ii(inB))),180);
    az_180 = Az_A>175 & Az_B>175;
    SA_A = star.SA(almA_ii(inA)); SA_B = star.SA(almB_ii(inB));
    rad_A = star.skyrad(almA_ii(inA),star.aeronetcols);
    rad_B = star.skyrad(almB_ii(inB),star.aeronetcols);
    rad_sym = abs((rad_A - rad_B)./((rad_A + rad_B)./2));
    
    % AERONET requires <20% except for Az=180 which is <5%
    sym = ~any(rad_sym(:,1:end-1)>0.20,2);
    sym(az_180) = ~any(rad_sym(az_180,1:end-1)>0.05,2);
    good_almA(almA_ii(inA(~sym))) = false;
    good_almB(almB_ii(inB(~sym))) = false;
    
    bad = zeros(size(SA_A)); bad(sym) = NaN;
    figure_(3101);
    ss(1)=subplot(3,1,1);
    plot(SA_A, rad_A,'-o', SA_B, rad_B,'-+',SA_A + bad, rad_A,'rx');
    title('Alm symmetry test')
    ss(2)=subplot(3,1,2);
    plot(SA_A,100.*rad_sym(:,1:end-1),'-o',SA_A+bad,100.*rad_sym(:,1:end-1),'rx');
    ylabel('% diff'); xlabel('scattering angle [deg]');
    ss(3)=subplot(3,1,3);
    plot(SA_A,SA_A-SA_B,'-rx');
    ylabel('SA diff'); xlabel('scattering angle [deg]');
    linkaxes(ss,'x');
    
end
return