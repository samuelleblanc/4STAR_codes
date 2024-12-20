%% Details of the program:
% NAME:
%   compare_response_small_sphere
% 
% PURPOSE:
%   Compare the zenith radiance calibrations taken from the small sphere.
%   Calibrations pertain to measurements of the 6in small sphere
%
% CALLING SEQUENCE:
%   compare_response_small_sphere
%
% INPUT:
%  - none
% 
% OUTPUT:
%  - various plots
%
% DEPENDENCIES:
%  - save_fig.m 
%  - startup_plotting.m (for making good looking plots)
%  - version_set.m (for m script version tracking)
%
% NEEDED FILES:
%  - resp.mat files for the following calibration days:
%    - 20140804
%    - 20140825
%    - 20140914
%    - 20140920
%    - 20140926
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, August 1st, 2014
% Modified (v1.1): by Samuel LeBlanc, NASA Ames, October 17th, 2014
%                  - ported from compare_response.m
%                  - added response comparisons for small_sphere
%                  calibrations
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, 2014-11-12
%                  - changed startup to startup_plotting.m
% -------------------------------------------------------------------------

%% Start of function
function compare_response_small_sphere
startup_plotting
version_set('1.2');

% setting the standard variables
dir='C:\Users\sleblan2\Research\4STAR\cal\';
l='\';

dates=['20140804';'20140825';'20140914';'20140920';'20140926'];

%% Load files
d1=load([dir dates(1,:)  '_small_sphere_rad_responses.mat'],'vis','nir');
d2=load([dir dates(2,:)  '_small_sphere_rad_responses.mat'],'vis','nir');
d3=load([dir dates(3,:)  '_small_sphere_rad_responses.mat'],'vis','nir');
d4=load([dir dates(4,:)  '_small_sphere_rad_responses.mat'],'vis','nir');
d5=load([dir dates(5,:)  '_small_sphere_rad_responses.mat'],'vis','nir');

%% Plotting of response functions

LL=1;
   figure(LL);
   set(LL,'Position',[50 200 1400 800]);
   %vis resp
   ax1=subplot(2,2,1);
   plot(d1.vis.nm, d1.vis.resp, ...
        d2.vis.nm, d2.vis.resp, ...
        d3.vis.nm, d3.vis.resp, ...
        d4.vis.nm, d4.vis.resp, ...
        d5.vis.nm, d5.vis.resp, '-');
   title(['VIS response for small spheres']);
   xlabel('Wavelength [nm]');
   ylabel('Response [Cnts/(W m^{-2} \mum^{-1} sr^{-1})^{-1}]');
   xlim([300 1050]);
   legend(dates,'Location','Best');
   grid on;
   
   %nir resp
   ax2=subplot(2,2,2);
   plot(d1.nir.nm, d1.nir.resp, ...
        d2.nir.nm, d2.nir.resp, ...
        d3.nir.nm, d3.nir.resp, ...
        d4.nir.nm, d4.nir.resp, ...
        d5.nir.nm, d5.nir.resp,'-');
   title(['NIR response for small spheres']);
   xlabel('Wavelength [nm]');
   ylabel('Response [Cnts/(W m^{-2} \mum^{-1} sr^{-1})^{-1}]');
   legend(dates,'Location','Best');
   xlim([950 1700]);
   grid on;
   
   %vis resp differences
   ax3=subplot(2,2,3);
   ref_resp=d2.vis.resp;
   plot(d1.vis.nm, (d1.vis.resp-ref_resp)./ref_resp.*100., ...
        d2.vis.nm, (d2.vis.resp-ref_resp)./ref_resp.*100., ...
        d3.vis.nm, (d3.vis.resp-ref_resp)./ref_resp.*100., ...
        d4.vis.nm, (d4.vis.resp-ref_resp)./ref_resp.*100., ...
        d5.vis.nm, (d5.vis.resp-ref_resp)./ref_resp.*100., '-');
   title(['VIS response change']);
   xlabel('Wavelength [nm]');
   ylabel('Response Change [%]');
   xlim([300 1050]);
   grid on;
   
   %nir resp
   ax4=subplot(2,2,4);
   ref_resp=d2.nir.resp;
   plot(d1.nir.nm, (d1.nir.resp-ref_resp)./ref_resp.*100., ...
        d2.nir.nm, (d2.nir.resp-ref_resp)./ref_resp.*100., ...
        d3.nir.nm, (d3.nir.resp-ref_resp)./ref_resp.*100., ...
        d4.nir.nm, (d4.nir.resp-ref_resp)./ref_resp.*100., ...
        d5.nir.nm, (d5.nir.resp-ref_resp)./ref_resp.*100., '-');
   title(['NIR response change']);
   xlabel('Wavelength [nm]');
   ylabel('Response Change [%]');
   xlim([950 1700]);
   grid on;
   
   linkaxes([ax1,ax3],'x');
   linkaxes([ax2,ax4],'x');
   
   fi=[dir 'resp_comp_small_sphere'];
   save_fig(LL,fi,true);
end
