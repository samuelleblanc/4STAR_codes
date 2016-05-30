%% Details of the function:
% NAME:
%   retrieveCO2
% 
% PURPOSE:
%   retrieves CO2 using a given (start,end) wavelength range
%   using differential cross section and linear inversion
% 
%
% CALLING SEQUENCE:
%  function [o3] = retrieveO3(s,wstart,wend)
%
% INPUT:
%  - s: starsun struct from starwarapper
%  - wstart  : wavelength range start in micron
%  - wend    : wavelength range start in micron
% 
% 
% OUTPUT:
%   co2.co2vcd = co2 vertical column density [atmxcm]
%   co2.co2resi= co2 residual;
%   co2.co2OD  = co2 optical depth
%   co2.ch4OD  = ch4 optical depth
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.
%  - loadCrossSections_global.m
%
% NEEDED FILES:
%  - *.xs under data_folder
%
% EXAMPLE:
%  - [co2] = retrieveCO2(s,1.555,1.630);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, 2016-04 based on former versions
% from gasessubtract.m
% -------------------------------------------------------------------------
%% function routine
function [co2] = retrieveCO2(s,wstart,wend)

plotting = 0;
% load cross-sections
loadCrossSections_global;
w = s.w; 
 % find wavelength range index
 istart = interp1(w,[1:length(w)],wstart, 'nearest');
 iend   = interp1(w,[1:length(w)],wend  , 'nearest');
 
 wln = find(w<=w(iend)&w>=w(istart)); 
 
 % calculate residual spectrum (Rayleigh subtracted)
 % eta = repmat(log(s.c0(wln)),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);
 
 
%% retrieve by doing linear inversion first and then fit   
%% linear inversion
 
%  basis=[ch4coef(wln), co2coef(wln), ones(length(wln),1) w(wln)'.*ones(length(wln),1)];
%  
%    ccoef=[];
%    RR=[];
%    % inversion is being done on total slant path (not Rayleigh
%    % subtracted)
%    for k=1:length(s.t);
%         meas = log(s.c0(wln)'./s.rateslant(k,(wln))');
%         coef=basis\meas;
%         recon=basis*coef;
%         RR=[RR recon];
%         ccoef=[ccoef coef];
%    end
%    
%    % save linear inversion coefficients as input to constrained retrieval
%    
%    x0=[ccoef(1,:)' ccoef(2,:)' ccoef(3,:)' ccoef(4,:)'];
%    
%    CH4conc=[];CO2conc=[];CO2resi=[];co2OD=[];
%    
   % perform constrained retrieval
  
   [CH4conc CO2conc CO2resi co2OD,tau_co2ch4_subtract] = co2corecalc_(s,ch4coef,co2coef,wln,s.tau_aero);
   co2.co2 = CO2conc./s.m_ray;       % this is vertical column amount
   co2.ch4 = CH4conc./s.m_ray;       % this is vertical column amount
   co2.co2resi= CO2resi;
   co2amount = real((CO2conc./s.m_ray)*co2coef');    % this is wavelength dependent slant OD
   ch4amount = real((CH4conc./s.m_ray)*ch4coef');    % this is wavelength dependent slant OD
   %tau_OD_fitsubtract2 = tau_OD_fitsubtract1 - real(co2amount) - real(ch4amount);   % this is wv, co2 and ch4 subtraction
   
   
   
          
   % prepare to plot spectrum OD and cross section
   
%    tau_OD = log(repmat(s.c0(wln),length(s.t),1)./s.rateslant(:,(wln)));
%    spectrum     = tau_OD-RR' + ccoef(2,:)'*basis(:,1)';
%    fit          = ccoef(1,:)'*basis(:,2)';
%    residual     = tau_OD-RR';
% 
%    if plotting
% %      plot fitted and "measured" spectrum
%          for i=1:1000:length(s.t)
%              figure(111);
%              plot(w((wln)),spectrum(i,:),'-k','linewidth',2);hold on;
%              plot(w((wln)),fit(i,:),'-r','linewidth',2);hold on;
%              plot(w((wln)),residual(i,:),':k','linewidth',2);hold off;
%              xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' co2= ',num2str(co2.co2(i)),' RMSE = ',num2str(CO2resi(i))),...
%                     'fontsize',14,'fontweight','bold');
%              ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted CO_{2} spectrum','residual');
%              set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
%              pause(1);
%          end
%    end

   % save parameters
  
    co2.co2OD    = co2amount;
    co2.ch4OD    = ch4amount;
    
  
 
 return;