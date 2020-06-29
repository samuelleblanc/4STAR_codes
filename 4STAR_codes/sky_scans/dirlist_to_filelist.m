function [fulllist,flist] = dirlist_to_filelist(dlist,pname);
% Converts a directory list and pathname (returned by dir_) to a file list
% array of char with full path spec.
if ~isavar('pname')
   if isfield(dlist,'folder')
      pname = [dlist.folder,filesep]; pname = strrep(pname, [filesep filesep], filesep);
   end
end
% flist = string;fulllist = {};
if length(dlist)==1
   flist(1) = {[pname, char(dlist.name)]};
else
   for d = length(dlist):-1:1
      if strcmp(dlist(d).name,'.')||strcmp(dlist(d).name,'..')
         dlist(d) = [];
      end
   end
   for d = length(dlist):-1:1
      fulllist(d) = {[pname, char(dlist(d).name)]};
      flist(d) = string(dlist(d).name);
   end
end
return
  