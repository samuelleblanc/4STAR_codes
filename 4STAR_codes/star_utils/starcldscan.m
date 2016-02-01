function [savematfile, contents]=starcldscan(varargin)
%% Details of the program:
% NAME:
%   starscldscan
%
% PURPOSE:
%  To analyze the cloud scan 4STAR data, gets the relevant variables, makes
%  the appropriate adjustements and saves it to a mat file
%
% INPUT:
%  varargin:
%     - source: full path (in string) of star.mat file, 
%               or raw '.dat' files in a cell of format {'';''}
%     - savemafile: full path of the starcldscan.mat savemat file
%     - if blank, or 'ask' prompts user interface
%  toggle input ...
%
% OUTPUT:
%  savemat file
%  plots?
%
% DEPENDENCIES:
%  - version_set.m
%  - startup_plotting
%  - ...
%
% NEEDED FILES:
%  - raw or star.mat data
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written (v1.0): Samuel LeBlanc, St John's, Newfoundland, 2015-11-24
%                 - imported and modified by starsky.m
% Modified:
%
% -------------------------------------------------------------------------
version_set('1.0');

%********************
% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('cldp', varargin{:});
disp(sourcefile)
contents=[];
if isempty(contents0);
    savematfile=[];
    disp('no cldp files')
    return;
end;

%********************
% do the common tasks
%********************
% grab structures
if numel(contents0)==1 && (~isempty(strfind(contents0{1},'vis_cldp'))||~isempty(strfind(contents0{1},'nir_cldp')))
   if ~isempty(strfind(contents0{1},'nir_cldp'))
      contents0(2) = {strrep(contents0{1},'nir','vis')};
   elseif ~isempty(strfind(contents0{1},'vis_cldp'))
      contents0(2) = {strrep(contents0{1},'vis','nir')};
   end
   contents0 = contents0';
end
if numel(contents0)==1;
   if ~isempty(strfind(contents0{1},'nir_cldp'))
      contents0(1) = {strrep(contents0{1},'nir','vis')};
   elseif ~isempty(strfind(contents0{1},'vis_cldp'))
      contents0(1) = {strrep(contents0{1},'vis','nir')};
   end
    error('This part of starcldscan.m to be developed. For now both vis and nir structures must be present.');
elseif ~(any(~isempty(strfind(contents0,'nir_cldp')))&any(~isempty(strfind(contents0,'nir_cldp'))))
    ~isequal(sort(contents0), sort([{'vis_cldp'};{'nir_cldp'}]))
    error('vis_sun and nir_sun must be the sole contents for starcldscan.m.');
end;
load(sourcefile,contents0{:});

% add variables and make adjustments common among all data types. Also
% combine the two structures.
[mat_dir, fname, ext] = fileparts(savematfile);
[matdir,imgdir] = starpaths;
cld_str = {'clda';'cldp'}';
if exist('vis_cldp','var')
   %     all(~isempty(strfind(contents0{1},'skya')))
   %     contents0(1) = [];contents0(1) = [];
   for si = length(vis_cldp):-1:1
      if ~isempty(vis_cldp(si).t)
         s=starwrapper(vis_cldp(si), nir_cldp(si));
         disp('Ready for Cloud scan stuff')
         
         try
            [~,fname,~] = fileparts(s.filename{1});
            out = [strrep(fname,'_VIS_','_'),'.mat'];
            s_out = star_cld_scan(s); % vis_pix restrictions in here
            %                 [~,fname,~] = fileparts(ss.filename{1});
%             s_out = ss;
            save([mat_dir,filesep,out],'-struct','s_out');
            saveas(gcf,[imgdir,strrep(out,'.mat','.fig')]);
            saveas(gcf,[imgdir,strrep(out,'.mat','.png')]);
         catch
            save([mat_dir,filesep,out,'.bad'],'-struct','s');
         end
      end
   end
end

end


