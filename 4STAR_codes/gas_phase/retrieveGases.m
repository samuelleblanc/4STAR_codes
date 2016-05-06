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
%  function [gas] = retrieveGases(s)
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
% -------------------------------------------------------------------------
%% function routine

function [gas] = retrieveGases(s)
%----------------------------------------------------------------------
 version_set('1.0');
 showfigure = 0;
 
 colorfig = [0 0 1; 1 0 0; 1 0 1;1 1 0;0 1 1];
 
%% load cross-sections
   loadCrossSections_global;
%----------------------------------------------------------------------


%% retrieve NO2

 %[gas.no2] = retrieveNO2(s,0.450,0.490,1);

%% retrieve O3

 [gas.o3]  = retrieveO3(s,0.490,0.682,1);
 
%----------------------------------------------------------------------
%% retrieve CO2

 [gas.co2]  = retrieveCO2(s,1.555,1.630);
   
%% retrieve O2
%  TBD

%% retrieve HCOH
%  TBD
             
%% save gas data to .mat file

   Loschmidt          = 2.686763e19; %molecules/cm2
   d.no2_molec_cm2    = gas.no2.no2_molec_cm2;%gas.no2.no2DU*(Loschmidt/1000);
   d.no2err_molec_cm2 = gas.no2.no2resi;%gas.no2.no2resiDU*(Loschmidt/1000);
   d.no2DU            = d.no2_molec_cm2/(Loschmidt/1000);
   %d.no2resiDU       = gas.no2.no2resiDU;
   d.o3DU             = gas.o3.o3DU;
   d.o3resiDU         = gas.o3.o3resiDU;
   d.cwv              = s.cwv.cwv940m1;
   d.lat              = s.Lat;
   d.lon              = s.Lon;
   d.alt              = s.Alt;
   d.sza              = s.sza;
   d.tUTC             = serial2Hh(s.t);
   
  
   fi = strcat(datestr(s.t(1),'yyyymmdd'),'_gas_summary.mat');
   save([starpaths fi],'-struct','d');
   
  
%---------------------------------------------------------------------
 return;
