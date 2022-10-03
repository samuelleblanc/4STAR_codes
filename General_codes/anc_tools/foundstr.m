function  found = foundstr(strarr, str)
if iscell(str)
    str = str{:};
end
result = strfind(strarr, str);
if numel(result)==0
    found = false;
else
found = false(size(result));
end
if length(result)==1
    found = true;
else
    for n = 1:length(result)
        found(n) = ~isempty(result{n});
    end
end
return

