function [savematfile, contents]=starsky(varargin)

% starsun(source, savematfile)
% reads 4STAR _SKY data, gets relevant variables, makes adjustments, and
% saves the results in a mat file.  
% 
% Input (leave blank or say 'ask' to prompt user interface)
%   source: either single/multiple dat file path(s) or a single mat file.
%   A string or cell. 
%   savematfile: a mat file path in a string. 
% 
% Example
%   starsky; % this prompts user interfaces 
%   starsky({'D:\4star\data\raw\20120307_013_VIS_SKYP.dat';'D:\4star\data\raw\20120307_013_NIR_SKYP.dat'}, 'D:\4star\data\99999999skysun.mat');
%   [savematfile, contents]=starsun(...) returns the path for the resulting mat-file and its contents.
% 
% Yohei, 2012/03/19, 2012/04/11, 2012/06/27, 2012/08/14, 2012/10/01
% CJF, 2012/10/05, modified to load one pair of sky scans at a time, save
% one mat file per filen, placeholder for radiance cals, preparing for sky
% scan and aeronet inversion
% Yohei, 2012/10/05, updated tracking error computation. masked lines to
% generate figures.
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set
version_set('1.0');
%********************
% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('sky', varargin{:});
disp(sourcefile)
contents=[];
if isempty(contents0);
    savematfile=[];
    disp('no sky files')
    disp('no sky files')
    
    return;
end;

%********************
% do the common tasks
%********************
% grab structures
if numel(contents0)==1 && (~isempty(strfind(contents0{1},'vis_sky'))||~isempty(strfind(contents0{1},'nir_sky')))
   if ~isempty(strfind(contents0{1},'nir_sky'))
      contents0(2) = {strrep(contents0{1},'nir','vis')};
   elseif ~isempty(strfind(contents0{1},'vis_sky'))
      contents0(2) = {strrep(contents0{1},'vis','nir')};
   end
   contents0 = contents0';
end
if numel(contents0)==1;
   if ~isempty(strfind(contents0{1},'nir_sky'))
      contents0(1) = {strrep(contents0{1},'nir','vis')};
   elseif ~isempty(strfind(contents0{1},'vis_sky'))
      contents0(1) = {strrep(contents0{1},'vis','nir')};
   end
    error('This part of starsky.m to be developed. For now both vis and nir structures must be present.');
elseif ~(any(~isempty(strfind(contents0,'nir_sky')))&any(~isempty(strfind(contents0,'nir_sky'))))
    ~isequal(sort(contents0), sort([{'vis_sky'};{'nir_sky'}]))
    error('vis_sun and nir_sun must be the sole contents for starsky.m.');
end;
load(sourcefile,contents0{:});

% add variables and make adjustments common among all data types. Also
% combine the two structures.
[mat_dir, fname, ext] = fileparts(savematfile);
[matdir,imgdir] = starpaths;
sky_str = {'skya';'skyp'}';
% clear contents0
if exist('vis_skya','var')
%     all(~isempty(strfind(contents0{1},'skya')))
%     contents0(1) = [];contents0(1) = [];
    for si = length(vis_skya):-1:1
        if ~isempty(vis_skya(si).t)
            s=starwrapper(vis_skya(si), nir_skya(si));
            disp('Ready for sky scan stuff')
            
            try
               [~,fname,~] = fileparts(s.filename{1});
               out = [strrep(fname,'_VIS_','_'),'.mat'];
               s_out = starsky_scan(s); % vis_pix restrictions in here
               %                 [~,fname,~] = fileparts(ss.filename{1});
%                s_out = ss;
%                save([mat_dir,filesep,out],'-struct','s_out');
               save(savematfile, '-struct','s_out')
               
               fig_out = [imgdir,strrep(out,'.mat','.fig')];
               if exist(fig_out,'file')
                  delete(fig_out);
               end
               saveas(gcf,fig_out);
               
               png_out = [imgdir,strrep(out,'.mat','.png')];
               if exist(png_out,'file')
                  delete(png_out);
               end
               saveas(gcf,png_out);
               
               %                 saveas(gcf,[imgdir,strrep(out,'.mat','.png')]);
            catch
               save([mat_dir,filesep,out,'.bad'],'-struct','s');
            end
%             close('all')
        end
    end
%     clear ss;
end
if exist('vis_skyp','var')
   %     all(~isempty(strfind(contents0{1},'skya')))
   %     contents0(1) = [];contents0(1) = [];
   for si = length(vis_skyp):-1:1
      if ~isempty(vis_skyp(si).t)
         s=starwrapper(vis_skyp(si), nir_skyp(si));
         disp('Ready for sky scan stuff')
         
         try
            [~,fname,~] = fileparts(s.filename{1});
            out = [strrep(fname,'_VIS_','_'),'.mat'];
            s_out = starsky_scan(s); % vis_pix restrictions in here
            %                 [~,fname,~] = fileparts(ss.filename{1});
%             s_out = ss;
            save([mat_dir,filesep,out],'-struct','s_out');
            saveas(gcf,[imgdir,strrep(out,'.mat','.fig')]);
            saveas(gcf,[imgdir,strrep(out,'.mat','.png')]);
         catch
            save([mat_dir,filesep,out,'.bad'],'-struct','s');
         end
%          close('all')
      end
   end
%    clear ss;
end
% if all(~isempty(strfind(contents0{1},'skyp')))
%     s=starwrapper(vis_skyp, nir_skyp);
%     for si = 1:length(s)
%         try
%         ss(si) = starsky_scan(s(si)); % vis_pix restrictions in here
%         [~,fname,~] = fileparts(ss(si).filename{1});
%         out = [strrep(fname,'_VIS_','_'),'.mat'];
%         s_out = ss(si);
%         save([mat_dir,filesep,out],'-struct','s_out');
%         saveas(gcf,[imgdir,strrep(out,'.mat','.fig')]);
%         saveas(gcf,[imgdir,strrep(out,'.mat','.png')]);
%         catch
%             save([mat_dir,filesep,out,'.bad'],'-struct','s_out');
%         end
%         close('all')
%     end
% end
% Put sky scan stuff here...

% [mat_dir, fname, ext] = fileparts(savematfile);
% star_light_fname = [mat_dir,filesep,datestr(star.t(1),'yyyymmdd'),'starsun_LIGHT.mat'];
% if ~exist(savematfile,'file')
%     save(savematfile, '-struct', 'ss', '-mat');
% else
%     save(savematfile, '-struct', 'ss', '-mat', '-append');
% end
% contents=[contents; fieldnames(ss)];

% star_anet_aip_process(s);


end


