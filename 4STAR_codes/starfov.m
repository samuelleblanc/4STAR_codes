function [savematfile, contents]=starfov(varargin)

% starfov(source, savematfile)
% reads 4STAR _FOVA and _FOVP data, gets relevant variables, makes
% adjustments, and saves the results in a mat file.
%
% Input (leave blank or say 'ask' to prompt user interface)
%   source: either single/multiple dat file path(s) or a single mat file.
%   A string or cell.
%   savematfile: a mat file path in a string.
%
% Example
%   starfov; % this prompts user interfaces
%   starfov({'D:\4star\data\raw\20120308_047_VIS_FOVA.dat';'D:\4star\data\raw\20120308_046_NIR_FOVP.dat'},
%   'D:\4star\data\99999999starfov.mat');% enter all fov files you want to
%   process, and output starfov.mat filename
%   [savematfile, contents]=starfov(...) returns the path for the resulting mat-file and its contents.
%
% Yohei, 2012/03/19, 2012/04/11, 2012/06/27
% MS: 20130805 FOVa-13 (20130805_013_VIS_FOVA.dat,20130805_013_NIR_FOVA.dat), 
%              FOVp-12 (20130805_012_VIS_FOVP.dat,20130805_012_NIR_FOVP.dat) are for SEAC4RS
% local path: 'E:\SEAC4RS\20130805\'
% MS: 2014-08-22: corrected line 108 to include rate and darkstd only; line 120 to take
% only note(first line) for dimension consistancy
% SL: v1.0, 2014-10-13: added version control of this m script via version_set
% SL: v1.1, 2015-08-27: added toggle use for starwrapper, default to not
% run temp correction
version_set('1.1');
%********************
% regulate input and read source
%********************
[sourcefile, contents0, savematfile]=startupbusiness('fov', varargin{:});
contents=[];
if isempty(contents0);
    savematfile=[];
    return;
end;

%********************
% do the core calculations
%********************
%toggle.applytempcorr = false;
for ff=1:length(contents0);
    % grab each structure
    s0=load(sourcefile, contents0{ff});
    eval(['s0=s0.' contents0{ff} ';']);
    p=numel(s0);
    for i=1:p;
        s=s0(i);
        if ~isempty(s.t);
            
            % add variables and make adjustments common among all data types
            [s.daystr, s.filen, s.datatype, s.instrumentname]=starfilenames2daystr(s.filename, 1);
            s=starwrapper(s); %,toggle);
            
            % normalize the count rate
            rows_before_initial_sun=4;
            rows_after_finan_sun=0;
            rows_initial_sun=5:14;
            rows_finan_sun=-9:0; % count from the end
            % determine the rows corresponding to direct sun
            % measurements, first from the pre-set indices
            %                 s.sunrows=[rows_before_initial_sun+1 pp-rows_after_finan_sun];
            pp=length(s.t);
            s.sunrows=[rows_initial_sun pp+rows_finan_sun];
            % and, second, from the quad signals
            dqlr=diff(s.QdVlr./s.QdVtot);
            dqtb=diff(s.QdVtb./s.QdVtot);
            ch=find(abs(dqlr)>0.1 | abs(dqtb)>0.1);
            ch=intersect(ch, find(s.Str>0));
            if length(ch)==2;
                sunrows_fromquad=[1:ch(1) (ch(2)+1):pp];
                sunrows_fromquad=intersect(sunrows_fromquad, find(s.Str>0));
                if ~isequal(sunrows_fromquad,  s.sunrows);
                    warning('Quad signals not consistent with pre-set FOV sequences. Check data or fine-tune starfov.m.');
                end;
            else
                warning('Unable to detect FOV sequences from quad signals. Fine-tune starfov.m.');
            end;
            s.sunt=s.t(s.sunrows);
            s.sunrate=s.rate(s.sunrows,:);
            %s.nrate=s.rate./repmat(nanmean1(s.sunrate),pp,1);
            s.nrate=s.rate./repmat(nanmean(s.sunrate),pp,1);
            
            % calculate sun's position and the scattering angles
            %             [zen, s.sunaz, soldst, ha, dec, s.sunel, am] = sunae(s.Lat, s.Lon, s.t);
            %             s.sunaz=360-s.sunaz; !!! check with Connor, Roy. Yohei believes the definition of azimuthal angle is opposite between 4STAR and sunae.m.
            %             az_offset=interp1(s.t(s.sunrows), s.AZ_deg(s.sunrows)-s.sunaz(s.sunrows), s.t); !!! an inexact expression
            %             el_offset=interp1(s.t(s.sunrows), s.El_deg(s.sunrows)-s.sunel(s.sunrows), s.t); !!! an inexact expression
            s.saz=interp1(s.t(s.sunrows), s.AZ_deg(s.sunrows), s.t); !!! an inexact expression
            s.sel=interp1(s.t(s.sunrows), s.El_deg(s.sunrows), s.t); !!! an inexact expression
            s.saz(s.Str==0)=NaN; % "irrelevant" - see Roy's note in FOV_scans_4STARA.m.
            s.sel(s.Str==0)=NaN;
            az_offset=interp1(s.t(s.sunrows), s.AZ_deg(s.sunrows)-s.saz(s.sunrows), s.t); !!! an inexact expression
            el_offset=interp1(s.t(s.sunrows), s.El_deg(s.sunrows)-s.sel(s.sunrows), s.t); !!! an inexact expression
            %             s.hsa=s.AZ_deg-s.sunaz-az_offset; !!! an inexact expression
            %             s.hsa=sin(s.El_deg/180*pi).*(s.AZ_deg-s.sunaz-az_offset); !!! an inexact expression
            %             s.vsa=s.El_deg-s.sunel-el_offset; !!! an inexact expression
            s.hsa=cos(s.El_deg/180*pi).*(s.AZ_deg-az_offset-s.saz); !!! an inexact expression
            s.vsa=s.El_deg-s.sel; !!! an inexact expression
            
            % shuffle the fields, just for convenience
            fn=fieldnames(s);
            perm=[];
            viplist={'t' 'w' 'rate'}; % for convenience, these frequently-used properties come at the top of the structure
            for vv=1:length(viplist);
                perm=[perm strmatch(viplist(vv),fn,'exact')];
            end;
            perm=[perm setdiff(1:length(fn), perm)];
            s=orderfields(s, perm);
            clear perm pp visw nirw vv
            
            % relocate miscellenaous data
            %misclist={'darkstd' 'rate_noFORJcorr' 'forjunc'};
            misclist={'darkstd' 'rate'};
            smisc.t=s.t;
            for ii=1:length(misclist);
                fn=misclist{ii};
                if isfield(s, fn);
                    eval(['smisc.' fn '= s.' fn ';']);
                end;
            end;
            s=rmfield(s, misclist);
            clear fn ii
            
            % store the updated element of the structure
            s.note=['Processed on ' datestr(now,31) ' with starfov.m. ' s.note{1,:}];
            s1(i)=s;
        end
    end
    %% run through and clear out unnessecary variables for the FOV then save
    fields_to_keep = {'t';'w';'raw';'AZstep';'Elstep';'AZ_deg';'El_deg';'QdVlr';...
                       'QdVtb';'QdVtot';'AZcorr';'ELcorr';'row_labels';'AVG';...
                       'header';'filename';'filen';'note';'daystr';'datatype';'instrumentname';...
                       'sunrate';'nrate';'saz' ;'sel';'ratetot';'vsa';'Az_deg';'Az_sky';'El_sky'};
    flds = fields(s1);
    for fc= 1:length(flds)
        if ~any(strcmp(flds(fc),fields_to_keep))
            s1 = rmfield(s1,flds{fc});
        end
    end
    eval([contents0{ff} '=s1;']);
    clear s1;
    if ~exist(savematfile)
        save(savematfile, contents0{ff}, '-mat', '-v7.3');
    else
        save(savematfile, contents0{ff}, '-mat', '-v7.3', '-append');
    end
    contents=[contents; contents0(ff)];
    eval(['clear ' contents0{ff}]); % clear the variable just saved
end
clear i s ff viplist