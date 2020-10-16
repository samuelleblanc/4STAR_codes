function pptname_out = merge_ppts_for_day(path,daystr,instrumentname,suffix)
%% Details of the program:
% PURPOSE:
%  To combine multiple ppts into a single one, based on the daystr and
%  instrumentname
%
% INPUT:
%  path: full path of the multiple ppts.
%  daystr: string representing the day of the data (format: yyyymmdd)
%  instrumentname: (defaults to 4STAR), name of instrument in the title of
%                   the files
%  suffix: (defaults to _allSKY) End notes for the new ppt name file
%
% OUTPUT:
%  pptname_out: the name of the output ppt
%
% DEPENDENCIES:
%  - version_set.m (for version control of the script)
%
% NEEDED FILES:
%  - ppts to merge
%
% EXAMPLE:
%  n/a
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, Santa Cruz, 2020-03-30, sheltered-in-place during COVID-19 pandemic
%
% -------------------------------------------------------------------------

%% start of function
version_set('v1.0')

if nargin<4;
   suffix = '_allSKY'; % by default use 'allSKY'
end

if nargin<3;
    instrumentname = '4STAR'; % by default use 4STAR
end;

pptname_out = [path filesep instrumentname '_' daystr suffix '.ppt'];
pname = [instrumentname '_' daystr suffix '.ppt'];

h_ppt = actxserver('PowerPoint.Application');
% open an existing presentation file
if isafile(pptname_out)
   Presentation = h_ppt.Presentations.Open(pptname_out);
else
   Presentation = h_ppt.Presentation.Add;
end
flist = dir(fullfile([path filesep '*' instrumentname '_' daystr '*.ppt']));
if isempty(flist)
    flist = dir(fullfile([path filesep '*' daystr '*.ppt']));
end
try
    Presentation.SaveAs(pptname_out);
catch
    for k=h_ppt.Presentations.Count:-1:1
       if strcmp(h_ppt.Presentations.Item(k).name,pname)
           if strfind(h_ppt.Presentations.Item(k).readonly,'True')
              h_ppt.Presentations.Item(k).Close;
           end
       end       
    end  
    for k=h_ppt.Presentations.Count:-1:1
         if strcmp(h_ppt.Presentations.Item(k).name,pname)
             Presentation = h_ppt.Presentations.Item(k);
         end
    end
end
j=0;
for i=1:length(flist)
    if strcmp(pptname_out,[flist(i).folder filesep flist(i).name]); continue; end;
    if flist(i).name(1)=='~'; continue; end;
    disp(['Merging file: ' flist(i).folder filesep flist(i).name])
    jj = Presentation.Slides.InsertFromFile([flist(i).folder filesep flist(i).name],j);
    j = j + jj;
end
Presentation.SaveAs(pptname_out);
Presentation.Close;
return