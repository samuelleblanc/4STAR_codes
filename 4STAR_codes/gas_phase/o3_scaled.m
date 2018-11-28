% Iteratively subtract OD from O3_h to yield least residuals
% over the range from 475-550 and 650-685 695-757 770-850
% relative to the polyfit through 425-475 and 770-850
% Looking at range from
function [Kk] = o3_scaled(s);

nm = 1000.*s.w;
cols = false(size(s.w)); cols(s.aerosolcols) = true;
cols(1:end-1) = cols(1:end-1)&cols(2:end); cols(2:end) = cols(1:end-1)&cols(2:end);
cols(1:end-1) = cols(1:end-1)&cols(2:end); cols(2:end) = cols(1:end-1)&cols(2:end);
cols(1:end-1) = cols(1:end-1)&cols(2:end); cols(2:end) = cols(1:end-1)&cols(2:end);
cols(1:end-1) = cols(1:end-1)&cols(2:end); cols(2:end) = cols(1:end-1)&cols(2:end);
fit_o = ((nm>425 & nm<475) | (nm>770 & nm<850))&cols;
test_o = ((nm>475 & nm<550) | (nm>650 & nm<685) | (nm>695 & nm<757) | (nm>770 & nm<850))&cols;
nm_500 = interp1(nm, [1:length(nm)],500,'nearest');
% figure; plot([1:length(s.t)],1-s.QdVtot./max(s.QdVtot),'o', [1:length(s.t)],s.QdVlr./s.QdVtot, 'x',[1:length(s.t)],s.QdVtb./s.QdVtot, '+')
sums = s.QdVtot<0.05 + abs(s.QdVlr./s.QdVtot) + abs(s.QdVtb./s.QdVtot);
% figure; plot([1:length(s.t)],sums,'o-')
suns_i = find(s.Str==1 & s.Zn==0 & sums<0.075 & s.tau_tot_vert(:,nm_500)>0.05 & s.tau_tot_vert(:,nm_500)<2) ;



K = 0.5:.05:2.5; lenK = length(K); res = [];
Kk = NaN(size(s.t)); 
for sun_i = suns_i'
   for k = 1:lenK
      rate_o = s.rateaero(sun_i,:).*tr(s.m_O3(sun_i), s.tau_O3(sun_i,:))./tr(s.m_O3(sun_i), K(k).*s.tau_O3(sun_i,:));
      tau_o=real(-log(rate_o./s.c0)./s.m_aero(sun_i));
      PP_o = polyfit(log(nm(fit_o)), log(tau_o(fit_o)), 2);
      % figure_(5001); plot(nm(test_o), tau_o(test_o),'x',nm(fit_o), tau_o(fit_o),'o',nm(test_o), exp(polyval(PP_o,log(nm(test_o)))),'r-');
      res(k) = sqrt(mean((tau_o(test_o) - exp(polyval(PP_o,log(nm(test_o))))).^2));
      % title(['K = ',sprintf('%1.2f',K), ', Res: = ',sprintf('%2.2e',res)]);
%       logy; logx;
   end
   
   % figure_(5); plot(K, res,'o-');
   [~, min_i] = min(res); first = max([1,1+floor(min_i./2)]); last = min([lenK,ceil(min_i + min_i./2)]);
   P_res = polyfit(K(first:last), res(first:last),2);
   Kk(sun_i) = min(3,roots([P_res(1).*2, P_res(2)]));
end
suns_i(Kk(suns_i)==0) = []; Kk(Kk==0) = 1; Kk(isnan(Kk))= 1;

% rate_o = s.rateaero(suns_i,:).*tr(s.m_O3(suns_i), s.tau_O3(suns_i,:))./tr(s.m_O3(suns_i), Kk(suns_i).*s.tau_O3(sun_i,:));
% tau_o=real(-log(rate_o./s.c0)./s.m_aero(sun_i));
% PP_o = polyfit(log(nm(fit_o)), log(tau_o(fit_o)), 2);
% figure_(5001); plot(nm(test_o), tau_o(test_o),'x',nm(fit_o), tau_o(fit_o),...
%     'o',nm(test_o), exp(polyval(PP_o,log(nm(test_o)))),'r-');
% resk = sqrt(mean((tau_o(test_o) - exp(polyval(PP_o,log(nm(test_o))))).^2));
% title(['K = ',sprintf('%1.2f',K), ', Res: = ',sprintf('%2.2e',res)]);
% logy; logx;

return
