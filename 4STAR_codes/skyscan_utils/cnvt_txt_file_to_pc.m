function out = cnvt_txt_file_to_pc(in,prompt)
% out = cnvt_txt_file_to_pc(in,prompt)
% Opens file "in" assumed to be ASCII and converts contents to PC-format by
% replacing lone [10] or [13] to [13 10].
% By default, overwrites existing file, replacing with new version.
if ~exist('prompt','var')
   prompt = false;
else
   prompt = prompt==1;
end
if ~exist('in','var')||~exist(in,'file')
   while ~exist('in','var')||~exist(in,'file')
      in = getfullname('*','ascii','Select an ASCII file to convert to PC format:');
   end
end
   pid = fopen(in);
   txt = char(fread(pid,'char')');
   fclose(pid);
   % test to make sure this is really an ASCII file.  Shouldn't have any 
   pc_txt = cnvt_txt_to_pc(txt);
   [inpath, infile,ext] = fileparts(in);
   if prompt
      blah = uiputfile(inpath, 'Select name of PC converted output.',[infile, ext, '.txt']);
      [~,blah, ext] = fileparts(blah);
      out = [inpath,filesep,blah,ext];
   else
      out = in;
   end
   if ~strcmp(txt,pc_txt)
      pod = fopen(out,'w'); fwrite(pod,pc_txt); fclose(pod);
   end

return