function   txt = cnvt_txt_to_pc(txt)
% txt = cnvt_txt_to_pc(txt)
% converts a text string to PC format with [13 10] end-of-line marker
if ~exist('txt','var')
   while ~exist('txt','var')&&~exist(txt,'file')
   txt = getfullname('*','ascii','Select an ASCII file to convert to PC format:');
   end
   fid = fopen(txt); txt = fread(fid,'char')'; fclose(fid);
end

str_pc_ii = strfind(txt,[13 10]);
str_10_ii = strfind(txt,[10]);
str_13_ii = strfind(txt,[13]);

if length(str_10_ii)>0 || length(str_13_ii)>0
   
   if length(str_10_ii)>0 && length(str_13_ii)>0 && length(str_10_ii)~=length(str_13_ii)
      warning('Mismatched numbers of [10] and [13]. Not proper ASCII file!');
   end
   
   if length(str_10_ii)>=0 && (length(str_pc_ii)==0 && length(str_13_ii)==0)
      disp('Looks like Unix / linux / Mac OS-X text with [10] and no lone [13] or [13 10].');
      txt = strrep(txt,char(10),char([13 10]));
   end
   
   if length(str_13_ii)>=0 && (length(str_pc_ii)==0 && length(str_10_ii)==0)
      disp('Looks like OLD Mac text with [13] and no lone [10] or [13 10].');
      txt = strrep(txt,char([13]),char([13 10]));
   end
   
   if length(str_pc_ii)==length(str_10_ii) && length(str_pc_ii)==length(str_13_ii)
      disp('Looks like PC text with [13 10] and no lone [13] or [10].');
   end
else
   disp('No CR or LF found.  Single line or not ASCII?')
end


return