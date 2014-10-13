function [savematfile, contents]=starsuns(varargin)

% starsun(source, savematfile)
% reads 4STAR _SUN data, gets relevant variables, makes adjustments, and
% saves the results in a mat file.
%
% Input (leave blank or say 'ask' to prompt user interface)
%   source: either single/multiple dat file path(s) or a single mat file.
%   A string or cell.
%   savematfile: a mat file path in a string.
%
% See starwrapper.m for required files.
%
% Example
%   starsun; % this prompts user interfaces
%   starsun({'D:\4star\data\raw\20120307_013_VIS_SUN.dat';'D:\4star\data\raw\20120307_013_NIR_SUN.dat'}, 'D:\4star\data\99999999starsun.mat');
%   [savematfile, contents]=starsun(...) returns the path for the resulting mat-file and its contents.
%
% Yohei, 2012/03/19, 2012/04/11, 2012/06/27, 2012/08/14, 2012/10/01,
% 2012/10/05.
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set 
version_set('1.0');

%********************
% regulate input and read source
%********************
infiles = getfullname_('*star.mat','starsuns','Select one or more starsun.mat files');
for in = 1:length(infiles)
    [~,stem,ext] = fileparts(infiles{in});
    OK = menu(['Process ', stem, ext, '?'],'Yes','No, skip','Done, EXIT');
    if OK==3
        return
    elseif OK==2
        disp(['Skipping ',stem,ext]);
    else
        tic
        [sourcefile, contents0, savematfile]=startupbusiness('sun', infiles{in});
        contents=[];
        toc
        if isempty(contents0);
            savematfile=[];
            %         return;
            disp(['No starsun file for ',infiles{in}])
        else;
            
            %********************
            % do the common tasks
            %********************
            % grab structures
            if numel(contents0)==1;
                error('This part of starsun.m to be developed. For now both vis and nir structures must be present.');
            elseif ~isequal(sort(contents0), sort([{'vis_sun'};{'nir_sun'}]))
                error('vis_sun and nir_sun must be the sole contents for starsun.m.');
            end;
            load(sourcefile,contents0{:},'program_version');
           toc 
            % add variables and make adjustments common among all data types. Also
            % combine the two structures.
            try
                s=starwrapper(vis_sun, nir_sun);
                
                %********************
                % save
                %********************
                save(savematfile, '-struct', 's', '-mat','program_version');
                contents=[contents; fieldnames(s)];
            catch
                [~,stem,ext] = fileparts(infiles{in});
                disp(['Problem with ',stem ext]);
            end
            toc
        end
    end
end
return