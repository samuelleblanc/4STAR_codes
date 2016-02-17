function [visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(t)

% returns the 4STAR wavelengths in um. Changes in the spectrometers and/or
% their wavelengths calibration should be noted in this code, and all other
% 4STAR codes should obtain the wavelengths from this code. See also
% starc0.m.
% Yohei, 2011/11/06, 2012/05/18, 2012/05/28, 2012/07/05.
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set 
version_set('1.0');

% development
% Values change with renewed calibration and assessment. Update this file
% accordingly, to return the values appropriate for for time of the
% measurement (the input t).  

% trivial parameters
savefigure=0;

% center wavelengths
if nargin==0;
    t=now;
end;
if t>=datenum([2012 7 3 0 0 0]); % new VIS spectrometer since July 3, 2012
    if now>=datenum([2013 6 5 0 0 0]); % update for VIS spectrometer 
        s=importdata(which( 'wl_20130605.txt'), ' ', 7);
        visw=s.data(:,5)';
        visfwhm=s.data(:,6)'/1000;
        clear s;
        visnote='Wavelengths and FWHM as derived at GSFC in 2013; see wl_20130605.txt.';
    else
        C0=171.855;
        C1=0.811643;
        C2=-1.98521e-6;
        C3=-1.58185e-8;
        p=0:1043;
        visw=C0+C1*p+C2*p.^2+C3*p.^3;
        visw=visw/1000;
        visnote='Wavelengths from Zeiss the manufacturer; see specs_page1.jpg.';
    end;
    nirw=fliplr(lambda_swir(1:512))/1000;
    nirnote='Wavelengths from Lambda the manufacturer.';
else
    visw=Lambda_MCS_fit3(1:1044)/1000;
    visnote='Wavelengths from Lambda the manufacturer.';
    nirw=fliplr(lambda_swir(1:512))/1000;
    nirnote='Wavelengths from Lambda the manufacturer.';
end;

% FWHM (full width at half maximum)
if nargout>2;
    if t>=datenum([2012 7 2 12 0 0]); % new VIS spectrometer since July 3, 2012
        if now>=datenum([2013 6 5 0 0 0]); % update for VIS spectrometer
            % visfwhm is updated above.
        else
            warning('Update the FWHM for the new VIS spec.');
            visfwhm=zeros(1,1044);
            visnote=[visnote ' VIS FWHM to be updated.'];
        end;
        fwhmfile='4STAR_FWHM_fits_from_monoscan_27.mat';
        load(which(fwhmfile));
        nirfwhm=interp1(outs(:,1)/1000, outs(:,3), nirw);
        nirnote=[nirnote ' FWHM from ' fwhmfile '.'];
    else
        fwhmfile='4STAR_FWHM_fits_from_monoscan_27.mat';
        load(which(fwhmfile));
        visfwhm=interp1(outs(:,1)/1000, outs(:,2), visw);
        visnote=[visnote ' FWHM from ' fwhmfile '.'];
        nirfwhm=interp1(outs(:,1)/1000, outs(:,3), nirw);
        nirnote=[nirnote ' FWHM from ' fwhmfile '.'];
        if savefigure
            figure;
            h1=semilogx(outs(:,1)/1000,outs(:,2), 'o',outs(:,1)/1000,outs(:,3), 'o');
            hold on;
            h2=semilogx(visw,visfwhm,'.',nirw,nirfwhm,'.');
            gglwa;
            ylabel('Full Width at Half Maximum (nm)');
            lh=legend([h1(1) h2(1)], fwhmfile,'Interpolated');
            set(lh,'fontsize',12,'location','best','interpreter','none');
            starsas(['starFWHM' fwhmfile(1:end-4) '.fig, ' mfilename '.m']);
        end;
    end;
end;