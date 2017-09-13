function [visw, nirw, visfwhm, nirfwhm, visnote, nirnote]=starwavelengths(t,instrumentname)

% returns the 4STAR wavelengths in um. Changes in the spectrometers and/or
% their wavelengths calibration should be noted in this code, and all other
% 4STAR codes should obtain the wavelengths from this code. See also
% starc0.m.
% Yohei, 2011/11/06, 2012/05/18, 2012/05/28, 2012/07/05.
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set
% Samuel, v1.1, 2017/05/27, added instrumentname, to use tracking of other
% instruments, namely here for 2STAR
% Samuel, v1.2, 2017/06/01, updated 2STAR coefficients from zeiss documents
version_set('1.2');

% development
% Values change with renewed calibration and assessment. Update this file
% accordingly, to return the values appropriate for for time of the
% measurement (the input t).

% trivial parameters
savefigure=0;

% center wavelengths
if nargin==0;
    t=now;
    instrumentname = '4STAR'; % by default use 4STAR
elseif nargin==1;
    instrumentname = '4STAR'; % by default use 4STAR
end;

switch instrumentname;
    case {'2STAR'}
        if t(1)>=datenum([2015 1 1 0 0 0]) % from the start of 2STAR
            C0 = 301.712;
            C1 = 3.32956;
            C2 = 0.00037127;
            C3 = -1.81758e-6;
            p = 0:255;
            visw=C0+C1*p+C2*p.^2+C3*p.^3;
            visw=visw/1000;
            visnote='Wavelengths from Zeiss MMS the manufacturer; see specs_page1.jpg.';
            nirw = [];nirnote='';
            visfwhm = [];nirfwhm= [];
        end;
    case {'4STARB'}
        if t(1)>datenum([2015 1 1 1 0 0 0]);
            C0 = 171.7;   
            C1 = 0.81254;
            C2 = -1.55568e-6;
            C3 = -1.59216e-8;
            p = 0:1043;
            visw=C0+C1*p+C2*p.^2+C3*p.^3;
            visw=visw/1000;
            visnote='Wavelengths from Zeiss the manufacturer; see 88880_Y585_136823_test-cert_20130911-130744.pdf';
            
            C0n = 1700.28;   
            C1n = -1.17334;
            C2n = -0.000655055;
            C3n = -7.06199e-7;
            C4n = -1.14153e-9;
            pn = 0:511;
            nirw=C0n+C1n*pn+C2n*pn.^2+C3n*pn.^3+C4n*pn.^4;
            nirw=nirw/1000;
            nirnote='Wavelengths from Zeiss the manufacturer; see 88880_Y585_136823_test-cert_20130911-130744.pdf';
            
            fwhmfile='4STAR_FWHM_fits_from_monoscan_27.mat';
                load(which(fwhmfile));
                visfwhm=interp1(outs(:,1)/1000, outs(:,2), visw);
                visnote=[visnote ' FWHM from ' fwhmfile '.'];
                nirfwhm=interp1(outs(:,1)/1000, outs(:,3), nirw);
                nirnote=[nirnote ' FWHM from ' fwhmfile '.'];
                warning('Update the FWHM for 4STARB using the 4STAR values');
            
        end;
        %error('4STARB wavelengths not yet implemented')
        
    otherwise % defaults to 4STAR(A) wavelengths
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
end; %case