function [gas] = retrieveGases(s)
% Syntax: gas = retrieveGases(s)
%% Details of the function:
% NAME:
%   retrieveGases
% 
% PURPOSE:
%   retrieval of gases amounts using best fit amounts for: 
%   o2,co2,ch4,o3,o4,no2; vertical amounts are being subtracted
%   from AOD spectrum
% 
%
% CALLING SEQUENCE:
%  function [gas] = retrieveGases(s,gxs)
%
% INPUT:
%  - s: starsun struct from starwarapper
% 
% 
% OUTPUT:
%  - gas: gases struct that includes all retrieved values
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.  
%
% NEEDED FILES:
%  - *.xs read by loadCrosSsections.m file 
%
% EXAMPLE:
%  - [gas] = retrieveGases(s);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer (MSR), based on gasessubtract,
% Apr-2016, Auckland, NZ
% May-5-2016, KORUS-AQ,Osan,Korea, added functionality
% MS, 2016-05-10, saving std field for cwv
% MS, 2016-05-20, adding retrieveHCOH routine
% MS, 2016-10-12, changed default NO2 wavelength range to 460-490 nm
% SL, v1.1, 2018-09-20, Added verbose and messaging to the gas retrievals
% CF, v1.1, 2020-04-22, No functional changes. Added non-display lines to facilitate interrogation
% -------------------------------------------------------------------------

 version_set('1.1');
 showfigure = 0;
 
 colorfig = [0 0 1; 1 0 0; 1 0 1;1 1 0;0 1 1];
 warning('off','MATLAB:rankDeficientMatrix');
 
%% load cross-sections
gxs = get_GlobalCrossSections;
%----------------------------------------------------------------------


%% retrieve NO2

if s.toggle.verbose; disp('Starting NO2 gas retrieval'), end
 [gas.no2] = retrieveNO2(s,0.460,0.490,1,gxs);
% gas.no2.no2OD is column OD
%% retrieve O3
if s.toggle.verbose; disp('Starting O3 gas retrieval'), end
[gas.o3]  = retrieveO3(s,0.490,0.682,1,gxs);
%  
% [gas.o3]  = retrieveO3(s,0.550,0.640,1,gxs);
%----------------------------------------------------------------------
%% retrieve CO2
if s.toggle.verbose; disp('Starting CO2 gas retrieval'), end
 [gas.co2]  = retrieveCO2(s,1.555,1.630,gxs);
   
%% retrieve O2
%  TBD

%% retrieve HCOH
if s.toggle.verbose; disp('Starting HCOH gas retrieval'), end
 [gas.hcoh] = retrieveHCOH(s,0.335,0.359,1,gxs);
 
 %% Check gases
%           s.tau_aero_subtract_all = s.tau_aero_subtract -s.gas.o3.o3OD -s.gas.o3.o4OD -s.gas.o3.h2oOD  ...
%             -s.tau_NO2 -s.gas.co2.co2OD -s.gas.co2.ch4OD;
gas.no2; gas.o3; gas.co2; gas.hcoh;
% figure_(999); plot(gas.no2.visnm,gas.no2.visXs,'-',gas.o3.visnm, gas.o3.visXs, '-'); logy  
% figure_(1999); plot(s.w, [max(gas.no2.no2OD); max(gas.o3.o3OD);max(gas.o3.o4OD);max(gas.co2.co2OD);max(s.cwv.wvOD)],'-'); legend('NO2','O3','O4','CO2','H2O');logy

%% save gas data to .mat file

   Loschmidt          = 2.686763e19; %molecules/cm2
   d.no2_molec_cm2    = gas.no2.no2_molec_cm2;%gas.no2.no2DU*(Loschmidt/1000);
   d.no2err_molec_cm2 = gas.no2.no2resi;%gas.no2.no2resiDU*(Loschmidt/1000);
   d.no2DU            = d.no2_molec_cm2/(Loschmidt/1000);
   d.no2resiDU        = gas.no2.no2resi;
   d.o3DU             = gas.o3.o3DU;
   d.o3resiDU         = gas.o3.o3resiDU;
   d.hcoh_DU          = gas.hcoh.hcoh_DU;
   d.hcohresi         = gas.hcoh.hcohresi;
   d.cwv              = s.cwv.cwv940m1;
   d.cwv_std          = s.cwv.cwv940m1std;
   d.lat              = s.Lat;
   d.lon              = s.Lon;
   d.alt              = s.Alt;
   d.pst              = s.Pst;
   d.sza              = s.sza;
   d.m_aero           = s.m_aero;
   d.m_o3             = s.m_O3;
   d.m_no2            = s.m_NO2;
   d.tUTC             = serial2Hh(s.t);
   
  
   fi = strcat(datestr(s.t(1),'yyyymmdd'),'_gas_summary.mat');
   save([getnamedpath('gas_summary') fi],'-struct','d');
   
  
%---------------------------------------------------------------------
 return;
