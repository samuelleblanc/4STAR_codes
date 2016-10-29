function s = make_starsun_single(s_in)

%% Details of the program:
% NAME:
%   make_starsun_single
%
% PURPOSE:
%  To create a structure array with variables that are of single precision
%  and reduce the size needed to store these files
%
% CALLING SEQUENCE:
%   s = make_starsun_single(s_in);
%
% INPUT:
%   s_in: (optional) starsun structure with all the variables typically saved in
%         starsun.mat or full file path of a starsun.mat file. If ommitted, will
%         ask to choose starsun.mat file
%
% OUTPUT:
%   s: structure with variables as single precision and integers instead of
%   doubles
%
% DEPENDENCIES:
%  - version_set.m
%
% NEEDED FILES:
%  - starsun.mat file compiled from raw data using allstarmat and then
%  processed with starsun
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, NASA Ames, Moffett Field, CA, 2016-10-25
% 
% -------------------------------------------------------------------------

%% Start of function
version_set('v1.0')

%% Sanitize input and load file if needed
if exist('s_in','var')
    if ~isstruct(s_in)
        % not a structure
        starsun_file = fullfile(s_in)
        s_in = load(starsun_file);
    end
else
     % not defined variable, ask to load starsun
     starsun_file = getfullname('*starsun_*.mat','starsun','Select starsun file for analysis');
     s_in = load(starsun_file);
end

%% Now prepare a list of fields that should be integers should not be changed to singles
to_uint16 = {'Str','Md','Zn','aerosolcols','viscols',...
          'nircols','visTint','nirTint','visAVG','nirAVG','visfilen','nirfilen'};
to_int16 = {'AZstep','Elstep'};
keep_double = {'t','Lat','Lon','vist','nirt'};
flds = fields(s_in);

%% Run through the fields and substitute for single precision (or int)
for i=1:length(flds);
    if isa(s_in.(flds{i}),'double')
       if strmatch(flds{i},to_uint16)
           s.(flds{i}) = uint16(s_in.(flds{i}));
       elseif strmatch(flds{i},to_int16)
           s.(flds{i}) = int16(s_in.(flds{i}));
       elseif strmatch(flds{i},keep_double)
           s.(flds{i}) = s_in.(flds{i});
       else
           s.(flds{i}) = single(s_in.(flds{i}));
       end
    else
        s.(flds{i}) = s_in.(flds{i});
    end;
end;

try;
    s.program_version = catstruct(program_version,s_in.program_version);
catch
    s.program_version = program_version;
end

return;
