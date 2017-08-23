function [savematfile, contents]=starskies(varargin)

% starskies(source, savematfile)
% same as "starsky" but permits multiple mat files to be selected.
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
% Samuel, v1.0, 2013/10/13, added version control of this m-script via version_set 
version_set('1.0');
%********************
% regulate input and read source
%********************
infiles = getfullname('*star.mat','starmats','Select one or more star.mat files');
if ischar(infiles)
   infiles = {infiles};
end
contentx = {'nir_skya';'nir_skyp';'vis_skya';'vis_skya'}
for in = 1:length(infiles)
    [sourcefile, contents0, savematfile]=startupbusiness('sky', infiles{in});
    disp(sourcefile)
    contents=[];
    if isempty(contents0);
        savematfile=[];
        disp('no sky files')
        disp('no sky files')
    else
        clear nir_skya nir_skyp vis_skya vis_skyp
        load(sourcefile,contents0{:});
        if numel(contents0)==1;
            error('This part of starsky.m to be developed. For now both vis and nir structures must be present.');
        elseif ~(any(~isempty(strfind(contents0,'nir_sky')))&any(~isempty(strfind(contents0,'nir_sky'))))
            ~isequal(sort(contents0), sort([{'vis_sky'};{'nir_sky'}]))
            error('vis_sun and nir_sun must be the sole contents for starsky.m.');
        end;
        [mat_dir, fname, ext] = fileparts(savematfile);
        [matdir,imgdir] = starpaths;
        sky_str = {'skya';'skyp'}';
        if exist('vis_skya','var')
            for si = length(vis_skya):-1:1
                if ~isempty(vis_skya(si).t)
                    s=starwrapper(vis_skya(si), nir_skya(si));
                    disp('Ready for sky scan stuff')                    
                    try
                        [~,fname,~] = fileparts(s.filename{1});
                        out = [strrep(fname,'_VIS_','_'),'.mat'];
                        ss = starsky_scan(s); % vis_pix restrictions in here
                        %                 [~,fname,~] = fileparts(ss.filename{1});
                        s_out = ss;
                        save([mat_dir,filesep,out],'-struct','s_out');
                        saveas(gcf,[imgdir,strrep(out,'.mat','.fig')]);
                        saveas(gcf,[imgdir,strrep(out,'.mat','.png')]);
                    catch
                        save([mat_dir,filesep,out,'.bad'],'-struct','s');
                    end
                    close('all')
                end
            end
            clear ss;
        end
        if exist('vis_skyp','var')
            for si = length(vis_skyp):-1:1
                if ~isempty(vis_skyp(si).t)
                    s=starwrapper(vis_skyp(si), nir_skyp(si));
                    disp('Ready for sky scan stuff')
                    try
                        [~,fname,~] = fileparts(s.filename{1});
                        out = [strrep(fname,'_VIS_','_'),'.mat'];
                        ss = starsky_scan(s); % vis_pix restrictions in here
                        s_out = ss;
                        save([mat_dir,filesep,out],'-struct','s_out');
                        saveas(gcf,[imgdir,strrep(out,'.mat','.fig')]);
                        saveas(gcf,[imgdir,strrep(out,'.mat','.png')]);
                    catch
                        save([mat_dir,filesep,out,'.bad'],'-struct','s');
                    end
                    close('all')
                end
            end
            clear ss;
        end
    end
end
return
