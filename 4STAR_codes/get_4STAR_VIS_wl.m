function [visw,visnote] = get_4STAR_VIS_wl(t)
% [visw,visnote] = get_4STAR_VIS_wl(t)
% return wavelengths of 4STAR VIS spectrometer.
% Use wl_20130605.txt (NASA Pandora lab wavelength registgration) if found,
% else use Zeiss manufacturer data
if nargin==0;
    t=now;
end;
if t>=datenum([2012 7 3 0 0 0]); % new VIS spectrometer since July 3, 2012
    if exist(which('wl_20130605.txt'),'file') % update for VIS spectrometer 
        s=importdata(which( 'wl_20130605.txt'), ' ', 7);
        visw=s.data(:,5)';
        visfwhm=s.data(:,6)'/1000;
        clear s;
        visnote='4STAR VIS wavelengths and FWHM as derived at GSFC in 2013; see wl_20130605.txt.';
    else
        C0=171.855;
        C1=0.811643;
        C2=-1.98521e-6;
        C3=-1.58185e-8;
        p=0:1043;
        visw=C0+C1*p+C2*p.^2+C3*p.^3;
        visw=visw/1000;
        visnote='4STAR VIS wavelengths from Zeiss the manufacturer; see specs_page1.jpg.';
    end;

else
    visw=Lambda_MCS_fit3(1:1044)/1000;
    visnote='4STAR VIS wavelengths for original (OLD) spectrometer from Zeiss the manufacturer.';
end;



return



