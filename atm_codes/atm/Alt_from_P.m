function [Alt_ft, Alt_m] = Alt_from_P(Pst)
% Alt = AltfromP(Pst)
%Pst must be in mB
% Alt is returned in feet and meters  -100 < Alt_m < 30e3, 20<= Pst <=1100 else NaN. 
% For Alt > 30 km or < 200 m 
Alt_ft = (1-(Pst./1013.25).^0.190284).*145366.45;
Alt_m = Alt_ft*12.*2.54/100;
bad_Alt = Pst>1100 | Pst<20 | Alt_m>=3e4 | Alt_m <= -100;
Alt_m(bad_Alt) = NaN;
Alt_ft(bad_Alt) = NaN;

return