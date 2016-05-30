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
% May-5-2016, KORUS-AQ,Osan,Korea, added functionality
% MS, 2016-05-10, saving std field for cwv
% MS, 2016-05-20, adding retrieveHCOH routine
% -------------------------------------------------------------------------
%% function routine

function [gas] = retrieveGases_(s)
%----------------------------------------------------------------------
 version_set('1.0');
 showfigure = 0;
 
 colorfig = [0 0 1; 1 0 0; 1 0 1;1 1 0;0 1 1];
 toggle = s.toggle;

%% retrieve NO2
tic; [gas.no2] = retrieveNO2_(s,0.450,0.490,1);
if toggle.verbose disp({['In retrieveNO2:'],toc}); end

%% retrieve O3
tic; [gas.o3]  = retrieveO3_(s,0.490,0.682,1);
if toggle.verbose disp({['In retrieveO3:'],toc}); end
%----------------------------------------------------------------------
%% retrieve CO2
tic; [gas.co2]  = retrieveCO2_(s,1.555,1.630);
if toggle.verbose disp({['In retrieveCO2:'],toc}); end
%% retrieve O2
%  TBD

%% retrieve HCOH
tic;[gas.hcoh] = retrieveHCOH_(s,0.335,0.359,1);
if toggle.verbose disp({['In retrieveHCOH:'],toc}); end

%% save gas data to .mat file

%% load cross-sections
%    loadCrossSections_global;
%----------------------------------------------------------------------

   Loschmidt          = 2.686763e19; %molecules/cm2
   d.no2_molec_cm2    = gas.no2.no2_molec_cm2;%gas.no2.no2DU*(Loschmidt/1000);
   d.no2err_molec_cm2 = gas.no2.no2resi;%gas.no2.no2resiDU*(Loschmidt/1000);
   d.no2DU            = d.no2_molec_cm2/(Loschmidt/1000);
   %d.no2resiDU       = gas.no2.no2resiDU;
   d.o3DU             = gas.o3.o3DU;
   d.o3resiDU         = gas.o3.o3resiDU;
   d.hcoh_DU          = gas.hcoh.hcoh_DU;
   d.hcohresi         = gas.hcoh.hcohresi;
   cwv = s.cwv;
   d.cwv              = cwv.cwv940m1;
   d.cwv_std          = cwv.cwv940m1std;
   d.lat              = s.Lat;
   d.lon              = s.Lon;
   d.alt              = s.Alt;
   d.sza              = s.sza;
   d.tUTC             = serial2hs(s.t);
   
  t = s.t;
   fi = strcat(datestr(t(1),'yyyymmdd'),'_gas_summary.mat');
   save([starpaths fi],'-struct','d');
   
  
%---------------------------------------------------------------------
 return;
