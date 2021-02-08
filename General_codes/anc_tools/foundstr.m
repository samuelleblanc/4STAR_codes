function  found = foundstr(strarr, str)
if iscell(str) 
    str = str{:};
end
result = strfind(strarr, str);
found = logical(zeros(size(result)));
for n = 1:length(found)
   found(n) = ~isempty(result{n});
end

return

