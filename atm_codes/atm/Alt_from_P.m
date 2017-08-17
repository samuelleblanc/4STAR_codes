function [Alt_ft, Alt_m] = Alt_from_P(Pst)
% Alt = AltfromP(Pst)
%Pst must be in mB
% Alt is returned in feet and meters
Alt_ft = (1-(Pst./1013.25).^0.190284).*145366.45;
Alt_m = Alt_ft*12.*2.54/100;

return