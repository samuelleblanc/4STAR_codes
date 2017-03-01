function ASparam(f)

% Return ARCTAS general and flight-specific
% file/folder paths.  "f" can be a flight
% number (e.g., 10), string ('10'), or foldername
% ('Flight10_20080419').  A blank input ('') or
% 'general' returns the general parameters only.
% THIS CODE WRITES OVER SOME WORKSPACE VARIABLES. 
% Yohei, 2008-06-09

%*****************************************************************
% Return MIRAGE general parameters regardless of input flight number / folder name 
%*****************************************************************
% prefix
prefix='AS';
% extensions
ext={'dma';'opc1';'aps1';'nep';'dat';'air';'aats'};
% Where is the data and where should the processed files go?
[rootpath, codepath] = paths;
dataroot = fullfile(rootpath,'arctas','data');
% source directory for AATS and Jingchuan's raw data.
sourcedir=fullfile(dataroot,'raw'); 
% directory for the version 1 MAT-files
savematfiledirv1=fullfile(dataroot,'v1mat'); 
% directory for mask files.  can be the same as that for the version 1
% MAT-files.
savemaskdir=fullfile(dataroot,'v1mat'); 
% directory for the version 2 MAT-files
savematfiledirv2=fullfile(dataroot,'v2mat'); 
% directory for the version 3 MAT-files
savematfiledirv3=fullfile(dataroot,'v3mat'); 
% directory for files to be submitted
savesubmitdir=fullfile(dataroot,'submit'); 
% download directory 
downloaddir=fullfile(dataroot,'download'); 
% the parameters below are used in ASsas.m.
figsavedir=fullfile(rootpath,'arctas','figures','fig');
pngsavedir=fullfile(rootpath,'arctas','figures');
pngsmallsavedir=fullfile(rootpath,'arctas','figures','small');

%*****************************************************************
% Get the flight number / folder name  
%*****************************************************************
dd=dir(sourcedir);
daystr0=[];
flightnumber0=[];
foldernames0=[];
for i=1:length(dd);
    if exist(fullfile(sourcedir, dd(i).name))==7 & length(dd(i).name)>8
        daystr0=[daystr0; dd(i).name(end-7:end)];
        flightnumber0=[flightnumber0; dd(i).name(7:8)];
        foldernames0=[foldernames0;{dd(i).name}];
    end;
end;
if nargin<1;
    % ask for the raw folder from a list; cancel
    % to give the general output
    [dummy,iv]=sort(str2num(daystr0));
    foldernames0=foldernames0(flipud(iv));
    [s,v] = listdlg('PromptString','Select a folder:',...
        'SelectionMode','single',...
        'ListString',foldernames0,...
        'InitialValue', 1);
    if v==0;
        foldername='';
    else
        foldername=char(foldernames0(s));
    end;
elseif ~isempty(f);
    foldername=f; % this covers the cases where f is empty, non-flight-number or day-str string; these cases are taken care of below. 
    if ischar(f); 
        s2n=str2num(f);
        if ~isempty(s2n)
            f=s2n;
        elseif strmatch(f, 'general');
            foldername='';
        end;
    end;
    if isnumeric(f); 
        n2s=num2str(f);
        if f<10;
            n2s=['0' n2s];
        end;
        if f==0; % return general parameters only
            foldername='';
        elseif f>20000000; % day string
            idx=strmatch(n2s, daystr0);
            lidx=length(idx);
            if lidx==1;
                foldername=char(foldernames0(idx));
            elseif lidx==0;
                error(['No folder exists for the day ' n2s ' under ' sourcedir '.']);
            elseif lidx>1;
                error(['More than one folder exist for the day ' n2s ' under ' sourcedir '.']);
            end;
        else; % flight
            idx=strmatch(n2s, flightnumber0);
            lidx=length(idx);
            if lidx==1;
                foldername=char(foldernames0(idx));
            elseif lidx==0;
                error(['No folder exists for the flight ' n2s ' under ' sourcedir '.']);
            elseif lidx>1;
                error(['More than one folder exist for the flight ' n2s ' under ' sourcedir '.']);
            end;
        end;
    end;
else
    foldername='';
end;
clear flightnumber;
if length(foldername)>=8;
    flightnumber=str2num(foldername(7:8));
    if isempty(flightnumber); % ground or lab test
        clear flightnumber;
    end;
end;

%*****************************************************************
% Prepare file and folder names for the given flight number 
%*****************************************************************
if isempty(foldername);
    warning('Flight number or folder name not specified.  No flight specific parameters returned.');
else
    daystr=foldername(end-7:end);
    datenum1=datenum([str2num(daystr(1:4)) str2num(daystr(5:6)) str2num(daystr(7:8))]);
    datestr1=datestr(datenum1,29);
    rawfiles=[];rawfilesday1=[];rawfilesday2=[];matfilesv1=[];matfilesv2=[];matfilesv3=[];maskfiles=[];
    % to check if the flight lasted over midnight
    datenumday2=datenum1+1;
    daystrday2=datestr(datenumday2,30);
    daystrday2=daystrday2(1:8);
    for j=1:length(ext);
        % raw files; irregular names are returned for "fixed" raw files and overnight flights
        fixedfilename=fullfile(sourcedir,foldername, [daystr 'fixed.' char(ext(j))]);
        if exist(fixedfilename)==2;
            rawfiles=[rawfiles; {fixedfilename}];
        else
            rawfiles=[rawfiles; {fullfile(sourcedir,foldername, [daystr '.' char(ext(j))])}];
        end;
        fixedfilenameday2=fullfile(sourcedir,foldername, [daystrday2 'fixed.' char(ext(j))]);
        if exist(fixedfilenameday2)==2;
            rawfilesdays=[rawfilesday2; {fixedfilenameday2}];
        else
            rawfilesday2=[rawfilesday2; {fullfile(sourcedir,foldername, [daystrday2 '.' char(ext(j))])}]; 
        end;
        if exist(char(rawfilesday2(j)))==2; 
            rawfilesday1=[rawfilesday1;rawfiles(j)]; 
            rawfiles(j,1)={fullfile(sourcedir,foldername, [daystr daystrday2 'fixed.' char(ext(j))])};
            if exist(char(rawfiles(j,1)))==0 
                rawfiles(j,1)={fullfile(sourcedir,foldername, [daystr daystrday2 '.' char(ext(j))])};
            end;
        end;
        % MAT-files version 1, 2, ...
        matfilesv1=[matfilesv1; 
            {fullfile(savematfiledirv1,foldername, ...
            [daystr char(ext(j)) '.mat'])}];
        if j==7;% AATS
            matfilesv2=[matfilesv2;
                {fullfile(savematfiledirv2,foldername, ...
                [daystr char(ext(j)) '.mat'])}];
            matfilesv3=[matfilesv3;
                {fullfile(savematfiledirv3,foldername, ...
                [daystr char(ext(j)) '.mat'])}];
        else
            matfilesv2=[matfilesv2;
                {fullfile(savematfiledirv2,foldername, ...
                [daystr char(ext(j)) 'v2.mat'])}];
        end;
        if j==4 & f==13;
            matfilesv3=[matfilesv3;
                {fullfile(savematfiledirv3,foldername, ...
                [daystr char(ext(j)) 'v3_flt13.mat'])}];
        else
            matfilesv3=[matfilesv3;
                {fullfile(savematfiledirv3,foldername, ...
                [daystr char(ext(j)) 'v3.mat'])}];
        end
        maskfiles=[maskfiles;
            {fullfile(savemaskdir,foldername, ...
            [daystr char(ext(j)) '.mask'])}];
    end;
    % FMPS files, added 2006-07-26
    fmpsrawfile={fullfile(sourcedir,foldername, [daystr '.fmps'])};
    fmpsmatfilev1={fullfile(savematfiledirv1,foldername,[daystr 'fmps.mat'])};
    fmpsmatfilev2={fullfile(savematfiledirv2,foldername,[daystr 'fmpsv2.mat'])};
    fmpsmaskfile={fullfile(savematfiledirv1,foldername,[daystr 'fmps.mask'])};
    % nav files, added 2006-10-09
    navmatfilev2={fullfile(savematfiledirv2,foldername,[daystr 'nav.mat'])};
end

%*****************************************************************
% Return output in the workspace 
%*****************************************************************
clear f dd daystr0 flightnumber0 foldernames0 i s v s2n n2s idx lidx
w=whos;
dispstr='';
for i=1:length(w);
    eval(['assignin(''caller'', w(i).name, ' w(i).name ');']);
%     dispstr=[w(i).name ', ' dispstr];
end;