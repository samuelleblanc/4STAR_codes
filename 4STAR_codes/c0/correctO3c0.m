% correct O3c0
%-------------
% baseline correction or spline interpolation to amooth c0 values
% in the O3 500-683 nm region
%-----------------------------------------------------------------

%% upload starc0

starname = '20151104_VIS_C0_refined_Langley_at_WFF_Ground_screened_3correctO3.dat';
tmp      = importdata(strcat(starpaths,starname,'.dat'));