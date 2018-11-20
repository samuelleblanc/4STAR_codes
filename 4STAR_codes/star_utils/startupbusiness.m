function [sourcefile, contents, savematfile,instrumentname]=startupbusiness(datatype, source, savematfile);
% STARTUPBUSINESS, called at the beginning of a 4STAR processing code (e.g.,
% starsun.m, starfov.m), regulates the input and reads source data.
% Yohei, 2012/04/11, 2012/06/27
% CJF: v1.0, 2012/10/05, modified to include filen in saved mat file
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set 
% SL: v1.1, 2016/08/23, added control and handling of the instrument name
% SL: v1.2, 2017/05/27, 
version_set('1.1');
%********************
% regulate input
%********************
% initialize variables
sourcefile='';
contents={};

% source 
if nargin<1 || isempty(datatype)
   datatype = '';
end
if nargin<2 || isempty(source)
    source='ask';
end;
% cjf: Modified to include filen, to be used when datetype has "sky"
[sourcefile, ext, daystr,filen,instrumentname]=starsource(source, datatype);

% Load sky scans 2x2, not 1x1.
if numel(sourcefile)==1 && (~isempty(strfind(sourcefile{1},'VIS_SKY'))||~isempty(strfind(sourcefile{1},'NIR_SKY')))
   if ~isempty(strfind(sourcefile{1},'NIR_SKY'))
      sourcefile(2) = {strrep(sourcefile{1},'NIR','VIS')};
   elseif ~isempty(strfind(sourcefile{1},'VIS_SKY'))
      sourcefile(2) = {strrep(sourcefile{1},'VIS','NIR')};
   end
   sourcefile = sourcefile';
end

if isempty(sourcefile);
    savematfile=0;
    return;
end;

% cjf: adding filen to savematfile if datatype has sky
if ~isempty(strfind(datatype,'sky'))
    skyn = ['_',filen,'_'];
else
    skyn = [];
end
% destination
if nargin<3 || isempty(savematfile) || isequal(savematfile, 'ask'); % if savematfile is not given, generate a default name and ask to modify it
    savematfile=[instrumentname '_' daystr skyn 'star' datatype '.mat'];
end;
% savematfile=stardestination(savematfile);
if isequal(savematfile, 0);
    return;
elseif isequal(savematfile, sourcefile);
    error('Select a savematfile different from sourcefile.');
end;

%********************
% read source
%********************
if isequal(lower(ext), '.dat'); % run allstarmat.m only if dat file(s) are input
    tempsavematfile=fullfile(starpaths, 'temporary_startupbusiness.mat');
    [sourcefile,contents0]=allstarmat(sourcefile, tempsavematfile);
else
    sourcefile=char(sourcefile);
    matobj=matfile(sourcefile);
    ll=whos(matobj);
    ll=struct2cell(ll);
    contents0=ll(1,:);
    clear ll;
end;
for i=1:numel(contents0);
    if~isempty(regexp(contents0{i}, ['.*' datatype '.*']));
        contents=[contents; contents0(i)];
    end;
end;
clear contents0;
if isempty(contents);
    warning([sourcefile ' does not have "' datatype '" in any of its data fields. Ignored.']);
    return;
end;