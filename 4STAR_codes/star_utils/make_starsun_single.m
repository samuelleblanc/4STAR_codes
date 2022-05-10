function s = make_starsun_single(s)

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
%   s: (optional) starsun structure with all the variables typically saved in
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
%Connor, v2.0, 2017/07/23, converted all to single unless exempted 
% since integers restrict arithmetic 
%size
% 
% -------------------------------------------------------------------------

%% Start of function
version_set('v2.0')

%% Sanitize input and load file if needed
if exist('s','var')
    if ~isstruct(s)
        % not a structure
        starsun_file = fullfile(s)
        s = load(starsun_file);
    end
else
     % not defined variable, ask to load starsun
     starsun_file = getfullname('*starsun_*.mat','starsun','Select starsun file for analysis');
     s = load(starsun_file);
end

%% Now prepare a list of fields that should be integers should not be changed to singles
% to_uint16 = {'Str','Md','Zn','aerosolcols','viscols',...
%           'nircols','visTint','nirTint','visAVG','nirAVG','visfilen','nirfilen'};
% to_int16 = {'AZstep','Elstep'};
keep_double = {'t','Lat','Lon','vist','nirt','langley1','langley2','langley','ground','flight'};
flds = fields(s);

%% Run through the fields and substitute for single precision (or int)
for i=1:length(flds);
    if isa(s.(flds{i}),'double') && ~any(strcmp(flds{i},keep_double))
%        if strmatch(flds{i},to_uint16)
%            s.(flds{i}) = uint16(s_in.(flds{i}));
%        elseif strmatch(flds{i},to_int16)
%            s.(flds{i}) = int16(s_in.(flds{i}));
%        elseif strmatch(flds{i},keep_double)
%            s.(flds{i}) = s_in.(flds{i});
%        else
           s.(flds{i}) = single(s.(flds{i}));
%        end
%     else
%         s.(flds{i}) = s_in.(flds{i});
    end;
end;

try;
    s.program_version = catstruct(program_version,s_in.program_version);
catch
    s.program_version = program_version;
end

return;
