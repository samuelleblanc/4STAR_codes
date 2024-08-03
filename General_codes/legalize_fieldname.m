function newname = legalize_fieldname(oldname)
% Replaces illegal characters in names of structure elements.
newname = fliplr(deblank(fliplr(deblank(oldname))));
if ((newname(1)>47)&(newname(1)<58))
    newname = ['n_',newname];
end
newname = strrep(newname,' ','');
newname = strrep(newname,'.','');
newname = strrep(newname,',','');
newname = strrep(newname,':','');
newname = strrep(newname,'<=','le_');
newname = strrep(newname,'>=','ge_');
newname = strrep(newname,'<','lt_');
newname = strrep(newname,'>','gt_');
newname = strrep(newname,'==','eeq_');
newname = strrep(newname,'=','eq_');
newname = strrep(newname,'-','_dash_');
newname = strrep(newname,'+','_plus_');
newname = strrep(newname,'(','_lpar_');
newname = strrep(newname,')','_rpar_');
newname = strrep(newname,'#','_hash_');
newname = strrep(newname,'/','_fslash_');
newname = strrep(newname,'\','_bslash_');
newname = strrep(newname,'^','_caret_');
newname = strrep(newname,'%','_pct_');
newname = strrep(newname,'[','lbrak_');
newname = strrep(newname,']','rbrak_');
newname = strrep(newname, '°','deg_');
if newname(1) == '_'
    newname = ['ubar_',newname(2:end)];
end

return