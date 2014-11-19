% Modified Langley calculation
% Based on old AATS method
% and AOD derivation by baseline
%
% 
% Michal 2013/02/20
% MS: 2014/11/18, changed ,rate_noFORJcorr field to rate

%********************
% set parameters
%********************
daystr='20130712';
stdev_mult=2;%:0.5:3; % screening criteria, as multiples for standard deviation of the rateaero.
col=408; % for screening. this should actually be plural - code to be developed
cols=[225   258   347   408   432   539   627   761   869   969]; % for plots
savefigure=0;

%********************
% generate a new cal
%********************
if isequal(daystr, '20120722'); % TCAP July 2012
    source='20120722Langleystarsun.mat';
else
    %source=[daystr 'starsun.mat'];
    source=[daystr 'starsunLangley.mat'];
end;
file=fullfile(starpaths, source);
load(file, 't', 'w', 'rateaero', 'm_aero', 'm_H2O','m_ray','m_NO2','m_O3','tau_aero','tau_O3','tau_NO2','tau_O4','tau_ray','rate');
starinfofile=fullfile(starpaths, ['starinfo' daystr(1:8) '.m']);
s=importdata(starinfofile);
s1=s(strmatch('langley',s));
eval(s1{:});
% chose Langley period values
ok=incl(t,langley);
% load water vapor coef
% load H2O a and b parameters
% watvapcoef =load('C:\MatlabCodes\data\cross_sections_uv_vis_swir_all.mat');  % 3.4km MidLatSummer
watvapcoef =load('C:\MatlabCodes\data\H2O_cross_section_FWHM_new_spec_all_range_Tropical3400m.mat');    % 3.4km Tropical MLO
%watvapcoef =load('C:\MatlabCodes\data\H2O_cross_section_FWHM_new_spec_all_range_midLatWinter6850m.mat');    % 6.85km MidLatWinter for 20130214
% watvapcoef =load('C:\MatlabCodes\data\H2O_cross_section_FWHM_new_spec_all_range_midLatwin6000m.mat');    % 6.0km MidLatWinter for 20130212
% watvapcoef =load('C:\MatlabCodes\data\H2O_cross_section_FWHM_new_spec_all_range_midLatWinter6000m_c.mat'); % 6.0km-3coef. MidLatwinter

 
 % interpolate H2O parameters to whole wln grid
 wvis = w(1:1044);
 % H2Oa = watvapcoef.h2oa(1:1044);
 % H2Ob = watvapcoef.h2ob(1:1044);
 H2Oa = watvapcoef.cs_sort(1:1044,1);
 H2Ob = watvapcoef.cs_sort(1:1044,2);
 % transform H2Oa nan to zero
 H2Oa(isnan(H2Oa)==1)=0;
 % transform H2Oa inf to zero
 H2Oa(isinf(H2Oa)==1)=0;
 % transform H2Oa negative to zero
 H2Oa(H2Oa<0)=0;
 % transform H2Ob to zero if H2Oa is zero
 H2Ob(H2Oa==0)=0;
 % plot parameter values
    %  figure;
    %  ax(1)=subplot(2,1,1);plot(wvis,H2Oa,'-b');legend('H2O a parameter');
    %  ax(2)=subplot(2,1,2);plot(wvis,H2Ob,'-r');legend('H2O b parameter');
    %  linkaxes(ax,'x');
%
% estimate tau_aero for water vapor region by using baseline fit
qq = length(wvis);
pp = length(t);
iwln = find(wvis<=0.9945&wvis>=0.8823);
order=1;                            % order of baseline polynomial fit
poly=zeros(length(wvis(iwln)),pp);  % calculated polynomial
polycoef=zeros(pp,(order)+1);       % polynomial coefficients
order_in=1;
thresh_in=0.01;
for i=1:length(ok)
% function (fn) can be: 'sh','ah','stq','atq'
% for gui use (visualization) write:
% [poly2_,poly2_c_,iter,order,thresh,fn]=backcor(sun.wvis(wln_ind),sun.tau_aero(goodTime(i),wln_ind));
[poly_,polycoef_,iter,order,thresh,fn] = backcor(wvis(iwln),tau_aero(ok(i),iwln),order_in,thresh_in,'atq');% backcor(wavelength,signal,order,threshold,function);
poly(:,i)=poly_;          % calculated polynomials
polycoef(i,:)=polycoef_'; % polynomial coefficients

% plot AOD baseline interpolation and real AOD values
%   figure(1111)
%   plot(wvis(iwln),tau_aero(ok(i),iwln),'.b','markersize',8);hold on;
%   plot(wvis(iwln),poly_,'-r','linewidth',2);hold off;
%   legend('AOD','AOD baseline');title(num2str(serial2Hh(t(ok(i)))));
%   pause(0.01);
end
    
watvap_tau_aero=(real(poly))';

% run modified Langley
am = [min(m_H2O(ok)) max(m_H2O(ok))];
% adjust values for MLO 2013
%am = [3.2 11.7];     % July-08
%am = [3.2 11.8];    % July-09
%am = [3.2 7.2];     % July-10
%am = [3.2 12];      % July-11
%
tau_NO2 = repmat(tau_NO2,pp,1);
[c0_mod,residual]=modLangley(am,iwln,wvis(iwln),rate(ok,iwln),watvap_tau_aero(ok,:),...
                              tau_ray(ok,iwln),tau_O4(ok,iwln),tau_O3(ok,iwln),tau_NO2(ok,iwln),m_aero(ok),m_ray(ok),m_O3(ok),m_NO2(ok),m_H2O(ok),H2Oa(iwln),H2Ob(iwln),stdev_mult);
                          
                         
%***********************
% save new  modified c0
%***********************
% embedd c0_mod (water vapor region) within c0
c0unc=NaN(size(wvis)); % put NaN for uncertainty - to be updated later
wln = wvis;
if strcmp(daystr,'20130212');
    c0=importdata(fullfile(starpaths, '20130212_VIS_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone.dat'));
    c0vis = c0.data(:,3);
    c0mod = c0vis;
    c0mod(iwln) = c0_mod;
    % filesuffix='modified_Langley_on_G1_first_flight_screened_2x_withOMIozone';
    % filesuffix='modified_Langley_on_G1_first_flight_6km_screened_2x_withOMIozone';
    filesuffix='modified_Langley_on_G1_first_flight_6km_3c_screened_2x_withOMIozone';
    visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
elseif strcmp(daystr,'20130214')
    c0=importdata(fullfile(starpaths, '20130214_VIS_C0_refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone.dat'));
    c0vis = c0.data(:,3);
    c0mod = c0vis;
    c0mod(iwln) = c0_mod;
    % filesuffix='modified_Langley_on_G1_secondL_flight_screened_2x_withOMIozone';
    filesuffix='modified_Langley_on_G1_secondL_flight_6_85km_screened_2x_withOMIozone';
    % filesuffix='modified_Langley_on_G1_secondL_flight_6km_3c_screened_2x_withOMIozone';
    visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
else % MLO modified Langleys
    %c0file = strcat(daystr,'_VIS_C0_refined_Langley_MLO_screened_2x.dat');
    %c0file = strcat(daystr,'_VIS_C0_refined_Langley_MLO_constrained_airmass_screened_2x.dat');
    c0file = '20130708_VIS_C0_refined_Langley_at_MLO_screened_3.0x_averagethru20130712_20140718.dat';
    c0=importdata(fullfile(starpaths, c0file));
    c0vis = c0.data(:,3);
    c0mod = c0vis;
    c0mod(iwln) = c0_mod;
    % filesuffix='modified_Langley_on_G1_secondL_flight_screened_2x_withOMIozone';
    % filesuffix='modified_Langley_MLOscreened_2x';
    % filesuffix='modified_Langley_MLOscreened_constrained_airmass_2x';
    % filesuffix='modified_Langley_on_G1_secondL_flight_6km_3c_screened_2x_withOMIozone';
    filesuffix='modified_Langley_at_MLO_screened_2.0x';
    % this is for the averaged file
    % filesuffix='modified_Langley_at_MLO_screened_2.0x_averagethru20130712_20140718';
    visfilename=fullfile(starpaths, [daystr '_VIS_C0_' filesuffix '.dat']);
end

%nirfilename=fullfile(starpaths, [daystr '_NIR_C0_' filesuffix '.dat']);!
%should we run modified for NIR as well?
additionalnotes='Modified Langley processed for 0.8823-0.9945 micron region';
starsavec0(visfilename, source, additionalnotes,wln , c0mod', c0unc);
%starsavec0(nirfilename, source, additionalnotes, w(nircols), c0new(k,nircols), c0unc(:,nircols));
%
