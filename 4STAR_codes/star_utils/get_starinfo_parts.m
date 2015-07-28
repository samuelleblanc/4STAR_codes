function [sinfo] = get_starinfo_parts(starinfo,daystr)
try
eval(['run ',starinfo])
catch
end
wh = whos;
for fld = 1:length(wh)
    field = char(wh(fld).name);
    sinfo.(field) = eval(field);
end

return