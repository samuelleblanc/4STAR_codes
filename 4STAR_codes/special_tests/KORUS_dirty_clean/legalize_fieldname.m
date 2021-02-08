function newname = legalize_fieldname(oldname)
% Replaces illegal characters in names of structure elements.
if ((oldname(1)>47)&(oldname(1)<58))
oldname = ['n_',oldname];
end
newname = strrep(oldname,' ','');
newname = strrep(newname,'.','');
newname = strrep(newname,',','');
newname = strrep(newname,'<=','le_');
newname = strrep(newname,'>=','ge_');
newname = strrep(newname,'<','lt_');
newname = strrep(newname,'>','gt_');
newname = strrep(newname,'==','eeq_');
newname = strrep(newname,'=','eq_');
%newname = strrep(newname,'-','_dash_');
newname = strrep(newname,'-','_');
newname = strrep(newname,'+','plus_');
newname = strrep(newname,'(','lpar_');
newname = strrep(newname,')','rpar_');
newname = strrep(newname,'#','hash_');
newname = strrep(newname,'/','fslash_');
newname = strrep(newname,'\','bslash_');
newname = strrep(newname,'^','caret_');
newname = strrep(newname,'%','pct_');
newname = strrep(newname,'[','lbrak_');
newname = strrep(newname,']','rbrak_');
newname = strrep(newname, '°','deg_');

if newname(1) == '_'
    newname = ['ubar_',newname(2:end)];
end

return