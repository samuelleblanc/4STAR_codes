function Lambda = Lambda_MCS_fit3(Pixel)
% Lambda = Lambda_MCS_fit3(Pixel)
% Returns 4STAR Lambda for given Pixel index
% Uses cubic polynomial fit for MCS with index>=1

Lambda=206.412+0.799856.*Pixel-5.1811e-6.*Pixel.^2-1.41576e-8.*Pixel.^3;
