% 2009-05-07, CJF: yields wavelength for the Nth pixel of the PGS 1.7 

function lambda = lambda_swir(n)
% Lambda = Lambda_swir(Pixel)
% Returns lambda of pixel for swir array


lambda = NaN(size(n));
subrange = n<=1;
lambda(subrange) = 1703.01;
suprange = n>=512;
lambda(suprange) = 949.79;
valid = (n>1)&(n<512);
% These values from Tech5 or Zeiss are only valid for our specific PGS 1.7
C = [1705.36, -1.17144, -6.67563e-4, 6.67718e-7, -1.05217e-9];
lambda(valid) = C(1) + C(2).*n(valid) + C(3).*(n(valid).^2) + C(4).*(n(valid).^3)+ C(5).*(n(valid).^4);
