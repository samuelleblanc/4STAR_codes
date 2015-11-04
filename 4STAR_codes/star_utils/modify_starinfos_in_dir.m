function modify_starinfos_in_dir;

[dirlist, pname] = dir_list('starinfo2*.m');

for d = 1:length(dirlist)
   
   modify_starinfo([pname, dirlist(d).name]);
end

return