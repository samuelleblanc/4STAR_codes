function [savematfile, contents]=allstarmat(source, savematfile, varargin)

% consolidates 4STAR data from dat file(s) to a mat file.
%
% Input (leave blank or say 'ask' to prompt user interface)
%   source: single/multiple dat file path(s), in a string or cell. 
%   savematfile: a mat file path in a string. 
% 
% allstarmat(..., '-append') looks into an existing destination file and
% updates it only with new source files - faster than a regular run.    
%
% Examples
%   allstarmat; % this will prompt user interfaces
%   allstarmat({'D:\4star\data\raw\20120307_013_VIS_SUN.dat';'D:\4star\data\raw\20120307_013_NIR_SUN.dat'},'D:\4star\data\99999999star.mat')
%   [savematfile, contents]=allstarmat(...) returns the path for the resulting mat-file and its contents.
%
% Yohei, 2011/10/24, 2012/04/11, 2012/06/27, 2013/02/13
% CJF: 2012/10/05
% CJF: 2013/12/05: edited lines 145 and following to strip empty records
% SL (v1.0): 2014/10/15: added version control of this m-script via version_set and program_version
% SL v1.1: 2016/08/23: handling of the new filename format with instrument name in file
version_set('1.1');
%********************
% control input
%********************
% source
if nargin<1 || isempty(source)
    source='ask';
end;
[filenames, ext, daystr,~,instrumentname]=starsource(source, '.dat');
if isempty(filenames);
    return;
end;

%% destination
if nargin<2 || isempty(savematfile) || isequal(savematfile, 'ask'); % if savematfile is not given, generate a default name and ask to modify it
    savematfile=[instrumentname '_' daystr 'star.mat'];
end;
savematfile=stardestination(savematfile);
if isequal(savematfile, 0);
    return;
end;

%% additional input
append=0;
if nargin>=3;
    if ~isempty(strmatch(lower(varargin(1)), {'append' '-append'})) & exist(savematfile)==2;
        append=1;
    elseif ~isempty(strmatch(lower(varargin(1)), {'append' '-append'})) & exist(savematfile)~=2;
        error([savematfile ' does not exist.']);
    else
        warning(['Additional input ignored.']);
    end;
end;

%% preparation to append, if requested
filen00=[];
if append;
    s00=load(savematfile);
    fn00=fieldnames(s00);
    for fn=1:length(fn00);
        eval(['ss00=s00.' char(fn00(fn)) ';']);
        if isfield(ss00, 'filen');
            for ii=1:length(ss00)
                filen00=[filen00; ss00(ii).filen];
            end;
        end;
        eval([char(fn00(fn)) '=ss00;']);
    end
    filen00=unique(filen00);
    clear ii s00 fn00 ss00 ss00 fn
end;

%********************
%% read files and consolidate data
%********************
contents=[];
note=['Consolidated on ' datestr(now,31) ' using allstarmat.m.'];
filenames=sort(filenames);
for i=1:length(filenames);
    cf0=char(filenames(i));
    [folder0, cf, ext0]=fileparts(cf0);
    cf=[cf ext0];
    clear folder0 ext0;
    if length(cf)>16;
        [daystr,filen,dtype,instrumentname]=starfilenames2daystr({cf},1);
        filen = str2num(filen);
        %filen=str2num(cf(10:12));
        if isempty(find(filen==filen00)); % don't re-read the files listed in filen00
            %type=lower(cf(14:end-4));
            type=lower(dtype);
            try
                s=starter(cf0); % read the raw file.
                if ~isempty(s.t) && ((isfield(s, 'raw') && ~isempty(s.raw)) || (isfield(s, 'fname') && ~isempty(strfind(lower(s.fname), 'track')))); % time is given, and either raw isn't empty or it's a track file
                    contents=[contents;{type}];
                    if isequal(type(end-2:end), 'sun') || isequal(type(end-2:end), 'zen')  || isequal(type(end-3:end), 'park') || isequal(type(end-3:end), 'forj') || isequal(type(end-4:end), 'track');
                        s.filename=filenames(i);
                        s.filen=repmat(filen, size(s.t));
                        if exist(type)~=1
                            s.note={note};
                            eval([type '=s;']);
                        else
                            eval(['fn=fieldnames(' type ');']);
                            for ff=1:length(fn);
                                cff=char(fn(ff));
                                if ~isequal(cff, 'note');
                                    eval([type '.' cff '=[' type '.' cff ';s.' cff '];']);
                                end;
                            end;
                        end;
                    else; % For each of FOVA, FOVP, SKYA, SKYP and MANUAL, create a multi-element structure.
                        s.filename=filenames(i);
                        s.filen=filen;
                        s.note={note};
                        ntype=0;
                        if exist(type)
                            eval(['ntype=numel(' type ');']);
                        end;
                        if ntype>=filen;
                            eval(['s0=' type '(' num2str(filen) ');']);
                            if ~isempty(s0.t);
                                warning('allstarmat.m assumes no duplicate file index from multiple days.');
                                error('(This error message is just to get out of here.)');
                            end;
                        end;
                        eval([type '(' num2str(filen) ')=s;']); % this leaves some component of the structure blank, which nonetheless seems to barely increase the final file size.
                        clear s0 idx fn ntype
                    end;
                else
                    warning([cf ' contains no data. Ignored.']);
                end;
            catch;
                warning(['Unable to read ' cf '.']);
            end
        end;
    elseif length(cf)>2;
        warning(['Unable to read ' cf '.']);
    end;
end;
contents=unique(contents)';
clear cf cf0 ff cff filen fn i s type note;


%********************
%% save
%********************
for ii=1:length(contents);
    %cjf: fls and following for loop were introduced to remove empty filename elements
    % Yohei, 2013/02/13, masks the lines, in order to better keep track of FOV records 
    % CJF: unmasks and made changes to accommodate FOV and track files.  
    fls = length(eval(contents{ii}));
    for fi = fls:-1:1
        try
        if isempty(eval([contents{ii},'(',sprintf('%d',fi),').t']))
            eval([contents{ii},'(',sprintf('%d',fi),') = [];']);
        end
        catch
            disp('Error in s struct?');
        end
           
    end
        
    if ii==1 && append==0;
        save(savematfile, contents{ii},'-mat', '-v7','program_version');
    else
        save(savematfile, contents{ii},'-mat', '-append','program_version');
    end;
end;

return