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
function [co2] = retrieveCO2(s,wstart,wend,gxs)

plotting = 0;
% load cross-sections
loadCrossSections_global;

 % find wavelength range index
 istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
 iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
 
 wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
 
 % calculate residual spectrum (Rayleigh subtracted)
 % eta = repmat(log(s.c0(wln)),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);
 
 
%% retrieve by doing linear inversion first and then fit   
%% linear inversion
 
%  basis=[ch4coef(wln), co2coef(wln), ones(length(wln),1) s.w(wln)'.*ones(length(wln),1)];
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
  
   [CH4conc CO2conc CO2resi co2OD,tau_co2ch4_subtract] = co2corecalc(s,ch4coef,co2coef,wln,s.tau_aero);
   co2.co2 = CO2conc./s.m_ray;       % this is vertical column amount
   co2.ch4 = CH4conc./s.m_ray;       % this is vertical column amount
   co2.co2resi= CO2resi;
   co2.co2OD = real( co2.co2 *co2coef');    % this is wavelength dependent slant OD %cjf: I think vertical, not slant
   co2.ch4OD = real(co2.ch4*ch4coef');    % this is wavelength dependent slant OD %cjf: I think vertical, not slant
   %tau_OD_fitsubtract2 = tau_OD_fitsubtract1 - real(co2amount) - real(ch4amount);   % this is wv, co2 and ch4 subtraction

 return;