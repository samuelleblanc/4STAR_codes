%% Details of the program:
% NAME:
%   convert_star_to_rd_spc
% 
% PURPOSE:
%   transfer the new star variables to the old rd_spc data structures
%   NOTE: currently only set for the FOVa and FOVp structures
%
% CALLING SEQUENCE:
%  ins=convert_star_to_rd_spc(ins)
%
% INPUT:
%  - ins: the data structure of the FOVa or FOVp
%
% OUTPUT:
%  - ins: the data structure of the FOVa or FOVp, with added legacy fields
%
% DEPENDENCIES:
%  - starwavelengths.m -> to get the wavelength arrays
%  - starpaths.m 
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, August 15th, 2014 - Happy Acadian Day!
%
% -------------------------------------------------------------------------

%% Start of code
function ins=convert_star_to_rd_spc(ins);

ins.spectra=ins.raw;

% get the pname and fname values from the filenames
[ins.pname ins.fname]=fileparts(ins.filename{1});
if ins.pname(1) ~ filesep
    % set pname to default directory in starpaths
    ins.pname=starpaths;
end

ins.time=ins.t;

% get the is vis variable
k=strfind(ins.filename,'VIS');
ins.is_vis=~isempty(k{1});


% get the wavelength array
[vis_um,nir_um]=starwavelengths(ins.t(1));
if ins.is_vis 
    ins.nm=vis_um.*1000.0;
else
    ins.nm=nir_um.*1000.0;
end;

return