function [nirw,nirnote] = get_4STAR_NIR_wl(t)
% [visw,visnote] = get_4STAR_NIR_wl(t)
% return wavelengths of 4STAR NIR spectrometer.
% Uses manufacturer supplied data after flipping to put smallest wavelength first 

nirw=fliplr(lambda_swir(1:512))/1000;
nirnote='4STAR NIR wavelengths from Lambda the manufacturer.';


return



