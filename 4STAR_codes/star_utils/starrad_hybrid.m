%% PURPOSE:
%   Create a radiometrically calibrated sky radiance measurements from
%   4STAR flight data (SUN) in hybrid sun-looking and sky-looking mode makes adjustments, and saves the results in a mat file.
%
% CALLING SEQUENCE:
%   [savematfile, contents]=starrad_hybrid(varargin)
%
% INPUT:
%   varargin: file path to be read in, leave blank or 'ask' for interactive file selection, 
%             either single/multiple dat file path(s) or a single starsun mat file.
%             in format of a string or cell. 
%             Can use savematfile, a mat file path in a string.put in 'star.mat' or raw '.dat' files  
% 
% OUTPUT:
%  - mat file saves
%
% DEPENDENCIES:
%  - version_set.m : for version control of this file
%  - startupbusiness
%  - starwrapper;
%  - subset_high_signal_no_sat
%  - catstruct.m
%  - parse_struct.m
%
% NEEDED FILES:
%  SKY_RESP files
%
% EXAMPLE:
%   starrad_hybrid; % this prompts user interfaces
%   starrad_hybrid({'D:\4star\data\raw\20120307_013_VIS_SUN.dat';'D:\4star\data\raw\20120307_013_NIR_SUN.dat'}, 'D:\4star\data\99999999starrad_hybrid.mat');
%   [savematfile, contents]=starrad_hybrid(...) returns the path for the resulting mat-file and its contents.
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames / Santa Cruz, 2025/07/01 - Happy Canada Day
%          - Based on starzen from Yohei Shinozuka, NASA Ames, 2012/03/19
%          - Developped for use with AirSHARP, helping bridge the gap for C-AIR
% Modified: 
% -------------------------------------------------------------------------
function [savematfile, contents]=starrad_hybrid(varargin)
version_set('1.0');
run_starwrapper = false;
toggle = update_toggle; % use the default toggles that are set

if (~isempty(varargin));
    [toggle_in,vars] = parse_struct(varargin{:});
    toggle = catstruct(toggle,toggle_in);
else
    vars = varargin;
end


%********************
%% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('', vars{:});
contents=[];
if isempty(contents0);
    savematfile=[];
    return;
end;

savematfile = strrep(savematfile, 'star', 'starrad_hybrid');
toRemove = {'rateaero';'rateslant';'ratetot';'rawcorr';'rawmean';'rawstd';
            'tau_CO2_CH4_N2O';'tau_CO2_CH4_N2O_abserr';'tau_NO2';'tau_NO2_err';
            'tau_O3';'tau_O3_err';'tau_O4';'tau_O4_err';'tau_aero';'tau_aero_err';
            'tau_aero_err1';'tau_aero_err2';'tau_aero_err3';'tau_aero_err4';
            'tau_aero_err5';'tau_aero_err6';'tau_aero_err7';'tau_aero_err8';
            'tau_aero_err9';'tau_aero_err10';'tau_aero_err11';'tau_aero_noscreening';
            'tau_aero_polynomial';'tau_r_err';'tau_ray';'tau_tot_slant';
            'tau_tot_vert';'tau_tot_vertical';'gas';'flags';'c0';'c0err';'c0mod';
            'track_err';'darkstd'};
contents0(ismember(contents0, toRemove)) = [];

%********************
%% do the common tasks
%********************
% grab structures
if numel(contents0)==1;
    error('This part of starrad_hybrid.m to be developed. For now both vis and nir structures must be present.');
elseif ~(any(~isempty(strfind(contents0,'nir_sun')))&any(~isempty(strfind(contents0,'nir_sun'))))
    ~isequal(sort(contents0), sort([{'vis_sun'};{'nir_sun'}]))
    error('vis_sun and nir_sun must be the sole contents for starrad_hybrid.m.');
end;
s = load(sourcefile,contents0{:},'program_version');

if run_starwrapper
% add variables and make adjustments common among all data types. Also
% combine the two structures.
s = starwrapper(vis_sun, nir_sun,toggle);
end


%% Do specific Sky radiance tasks
% get the skyresp
[visresp, nirresp, visnoteresp, nirnoteresp, ~, ~, visaeronetcols, niraeronetcols, visresperr, nirresperr] = starskyresp(nanmean(s.t(1)),s.instrumentname);
s.skyresp = [visresp,nirresp];

disp('...applying response function to get the radiances (rad)')
s.i_sky = [find(s.Md==7)-6;find(s.Md==7)-5;find(s.Md==7)-4]; % issue with the mode for these hybrid measurements. 
s.i_sky = s.i_sky(s.i_sky>1);
s.rad = zeros(length(s.i_sky),length(s.w));
disp(['... found ' num2str(length(s.i_sky)) ' number of radiance points in starsun'])
for i=1:length(s.i_sky)
    s.rad(i,:)=s.rate(s.i_sky(i),:)./s.skyresp; 
end

% run through the sets of integration times to get the highest signal, without saturation
% if s.toggle.subsetting_Tint
%     s = subset_high_signal_no_sat(s);
%     % now apply a principal component analysis to filter out some noise issues
%     if s.toggle.pca_filter
%          s = pca_rads(s);
%     end
% end

%% Save results
% [mat_dir, fname, ext] = fileparts(savematfile);
% star_light_fname = [mat_dir,filesep,datestr(star.t(1),'yyyymmdd'),'starsun_LIGHT.mat'];
if exist('program_version','var');
   s.program_version = catstruct(program_version,evalin('base','program_version'));
end;
if ~exist(savematfile,'file')
    save(savematfile, '-struct', 's', '-mat');
else
    save(savematfile, '-struct', 's', '-mat', '-append');
end
contents=[contents; fieldnames(s)];

% star_anet_aip_process(s);


end