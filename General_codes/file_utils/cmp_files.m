function same = cmp_files(in1, in2)
if ~exist('in1','var')||~exist(in1,'file')
   in1 = getfullname;
end
if ~exist('in2','var')||~exist(in2,'file')
   in2 = getfullname;
end
same = true;
chunk = 1e4;
% Next read in a chunk at a time and if different exit with same = false.
in1_fid = fopen(in1); in2_fid = fopen(in2);
while in1_fid>0 && in2_fid>0 &~feof(in1_fid) && ~feof(in2_fid) && same
   chunk1 = fread(in1_fid, chunk); chunk2 = fread(in2_fid, chunk); 
   if length(chunk1)~=length(chunk2) || ~all(chunk1==chunk2)
      same = false;
   end   
end
fclose(in1_fid); fclose(in2_fid);

return