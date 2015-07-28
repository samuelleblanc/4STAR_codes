function Lambda = Lambda_MCS_sn081100_tec5(Pixel)
% Lambda = Lambda_MCS_SN081100_tec5(Pixel)
% Returns 4STAR Lambda for given Pixel index
% Uses cubic polynomial fit for MCS with index>=1

% Lambda=206.412+0.799856.*Pixel-5.1811e-6.*Pixel.^2-1.41576e-8.*Pixel.^3;
%%
% Pixel(Pixel<11) = 11;
% Pixel(Pixel>1040) = 1040;
% These coefficients are for zero-indexed pixels, but Matlab uses
% 1-indexing. So adjust the supplied indices by subtracting one.
Cn = [171.855, 0.811643, -1.98521e-6, -1.58185e-8];
% CN = [171.043,0.811647, -1.93775e-6, -1.58185e-8];
% PP = [1:1044]
pp = Pixel-1;
Lambda = Cn(1) + Cn(2).*pp + Cn(3).*pp.^2 + Cn(4).*pp.^3 ;
% LL = CN(1) + CN(2).*PP + CN(3).*PP.^2 + CN(4).*PP.^3 ;

%%