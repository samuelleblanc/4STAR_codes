function result = isadir(dirpath)

%ISADIR replaces "isdir" and "isfolder" for 2013b and earlier.
% Returns true or false if dirpath contains strings representing valid
% directories or folders.  Arguement dirpath may be a char or cell array of
% chars.
%
%ISADIR  True if argument is a directory.
%   ISADIR(DIR) returns a 1 if DIR is a directory and 0 otherwise.
%   C. Flynn 2018-11-26

result = false;
if ~isempty(dirpath)
    if iscell(dirpath)
        if length(dirpath)==1
            result = isadir(dirpath{1});
        else
            result = [isadir(dirpath{1}), isadir(dirpath(2:end))];
        end
    else
        result = isempty(findstr(dirpath,'*'))&&isempty(findstr(dirpath,'?'))&&length(dir(dirpath))>=2;
    end
end
% result = exist(dirpath,'dir') == 7;
return
