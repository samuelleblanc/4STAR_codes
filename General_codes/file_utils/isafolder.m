function result = isafolder(dirpath)

%ISDIR is not recommended. Use ISFOLDER instead.
%
%ISDIR  True if argument is a directory.
%   ISDIR(DIR) returns a 1 if DIR is a directory and 0 otherwise.
%
%   See also FINFO, MKDIR.

%   P. Barnard 1-10-95
%   Copyright 1984-2017 The MathWorks, Inc.
result = false;
if ~isempty(dirpath)
    result = length(dir(dirpath))>=2 && length(dir([dirpath,filesep]))>=2;
%    result = isfolder(dirpath);
end
% result = exist(dirpath,'dir') == 7;
return