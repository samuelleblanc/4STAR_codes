% Yohei, 2004-07-20
% Sets INTEX parameters.
% See also INinfield.m.

% prefix
prefix='IN'; % Added 2006-05-02.  Yohei.

if ~exist('flightnumber');
    warning('Flight number not specified.');
elseif isnumeric(flightnumber);
    if flightnumber<10
        flightnumber=['0' num2str(flightnumber)];
    else
        flightnumber=num2str(flightnumber);
    end;
end;
daystrlist={'20040626' '20040629' '20040701' '20040706' '20040708' ...
        '20040710' '20040712' '20040715' '20040718' '20040720' ...
        '20040722' '20040725' '20040728' '20040731' '20040802' ...
        '20040806' '20040807' '20040811' '20040813' '20040814'}; % measurement date.  For example, '20040701'.  If there is more than one component in this variable, iterate with "for kk=1:length(daystrlist)"
daystrlist(99)={'20040626'};
ext={'dma';'opc1';'aps';'nep';'dat';'air'};
if exist('flightnumber');
    daystr=char(daystrlist(str2num(flightnumber)));
    foldername=['Flight' flightnumber '_' char(daystrlist(str2num(flightnumber)))];
    datenum1=datenum([str2num(daystr(1:4)) str2num(daystr(5:6)) str2num(daystr(7:8))]);
    datestr1=datestr(datenum1,29);
    rawfiles=[];rawfilesday2=[];matfilesv1=[];matfilesv1b=[];matfilesv1c=[];matfilesv1d=[];matfilesv2=[];matfilesv3=[];matfilesv4=[];maskfiles=[];
    % to check if the flight lasted over midnight
    datenumday2=datenum1+1;
    daystrday2=datestr(datenumday2,30);
    daystrday2=daystrday2(1:8);
end

% Where is the data and where should the processed files go?
% [parentpath,dataroot] = intexpath;
parentpath=fullfile(paths, 'intex');
dataroot=fullfile(parentpath, 'data');
dataroot = fullfile(parentpath,'data');
% source directory for Jingchuan's raw data.
sourcedir=fullfile(dataroot,'raw'); 
% directory for the version 1 MAT-files
savematfiledirv1=fullfile(dataroot,'v1mat'); 
% directory for mask files.  can be the same as that for the version 1
% MAT-files.
savemaskdir=fullfile(dataroot,'v1mat'); 
% directory for the version 2 MAT-files
savematfiledirv2=fullfile(dataroot,'v2mat'); 
% directory for the version 3 MAT-files
savematfiledirv3=fullfile(dataroot,'v3mat'); % Yohei, 2004-11-27 for NASA submission in January 2005.  See INmakev3.m.
% directory for the version 4 MAT-files
savematfiledirv4=fullfile(dataroot,'v4mat'); % Yohei, 2005-09-29 for NASA submission in October 2005.  See INopcmakev4.m.
% directory for files to be submitted
savesubmitdir=fullfile(dataroot,'submit'); 
% directory for spreadsheets, etc.
saveothersdir=fullfile(dataroot,'others'); 
% download directory 
downloaddir=fullfile(dataroot,'download'); % Yohei, 2005-01-26 for the nav files. 
% the parameters below are used in INwebmaintext2html.m.  they are here just for records.
frame_ho=fullfile(parentpath,'internaluse','web_preparation', ...
    'frame_ho.html');
mtpath=fullfile(parentpath,'internaluse','web_preparation');
% the parameters below are used in INsas.m.  they are here just for records.
figsavedir=fullfile(parentpath,'figures','fig');
pngsavedir=fullfile(parentpath,'figures');
pngsmallsavedir=fullfile(parentpath,'figures','small');
% file paths
if exist('flightnumber');
    for j=1:length(ext);
        if j==2 & str2num(flightnumber)==11;
            rawfiles=[rawfiles; 
                {fullfile(sourcedir,foldername, ...
                        [daystr 'fixed.' char(ext(j))])}];
        else
            rawfiles=[rawfiles; 
                {fullfile(sourcedir,foldername, ...
                        [daystr '.' char(ext(j))])}];
        end;
        rawfilesday2=[rawfilesday2; 
            {fullfile(sourcedir,foldername, ...
                    [daystrday2 '.' char(ext(j))])}]; % see below for irregular raw file names
        if exist(char(rawfilesday2(j)))==2; % Yohei, 2004-12-14, moved from INinfield.m.
            rawfiles(j,1)={fullfile(sourcedir,foldername, [daystr daystrday2 '.' char(ext(j))])};
        end;
        matfilesv1=[matfilesv1; 
            {fullfile(savematfiledirv1,foldername, ...
                    [daystr char(ext(j)) '.mat'])}];
        matfilesv1b=[matfilesv1b; 
            {fullfile(savematfiledirv1,foldername, ...
                    [daystr char(ext(j)) 'v1b.mat'])}]; % Yohei, 2004-11-27 for NASA submission in January 2005.  See INmakev3.m.  See below for irregular file names.
        if j==2;
            matfilesv1c=[{''};{fullfile(savematfiledirv1,foldername, ...
                        [daystr char(ext(j)) 'v1c.mat'])}]; % Yohei, 2005-09-29 for NASA submission in October 2005.  See INopcmakev4.m.  See below for irregular file names.
            matfilesv1d=[{''};{fullfile(savematfiledirv1,foldername, ...
                        [daystr char(ext(j)) 'v1d.mat'])}]; % Yohei, 2006-07-06 for new papers.  See INopcmakev4new.m.  See below for irregular file names.
        end;
        matfilesv2=[matfilesv2; 
            {fullfile(savematfiledirv2,foldername, ...
                    [daystr char(ext(j)) 'v2.mat'])}];
        if j<=5; % no air v3 file exists.
            matfilesv3=[matfilesv3; % Yohei, 2004-11-27 for NASA submission in January 2005.  See INmakev3.m.
                {fullfile(savematfiledirv3,foldername, ...
                        [daystr char(ext(j)) 'v3.mat'])}];
        elseif j==6;
            matfilesv3=[matfilesv3; 
                {fullfile(savematfiledirv3,foldername, ...
                        [daystr 'navv3.mat'])}]; % Yohei, 2005-08-12 for nav files.
        end;
        matfilesv4=[matfilesv4; 
            {fullfile(savematfiledirv4,foldername, ...
                    [daystr char(ext(j)) 'v4.mat'])}]; % Yohei, 2005-09-29 for OPC files.
        maskfiles=[maskfiles; 
            {fullfile(savemaskdir,foldername, ...
                    [daystr char(ext(j)) '.mask'])}];
    end;
    navrawfile={fullfile(downloaddir, 'nav_20050124', ...
            ['nav_dc8_' daystr '_r0.ict'])}; % Yohei, 2005-01-26 for nav files.
    o3rawfile={fullfile(downloaddir, 'AVERY.MELODY', ...
            ['O3_DC8_' daystr '_r1.ict'])}; % Yohei, 2005-10-17.  See INnavmakev3.m.
    navmatfilev3={fullfile(savematfiledirv3,foldername, ...
            [daystr 'navv3.mat'])}; % Yohei, 2005-01-25 for nav files.
    if flightnumber>=4
        dlhrawfile={fullfile(downloaddir, 'watervapor_20050126', ...
                ['DLH_DC8_' daystr '_r1.ict'])}; % Yohei, 2005-01-26 for the watervapor files.
    end;
    % deal with fixed raw files
    % Yohei, 2004-12-14.  Below is the list of irregular raw files, in the
    % order of flight number, extension, and additional string in the file
    % names. 
    % 	1, air, "raw"
    % 	3, aps nep dat air, "fixed"
    % 	4, air, "fixed"
    % 	6, nep, "fixed"
    % 	8, nep, "fixed"
    % 	9, air, "fixed"
    % 	11, opc, "fixed" and "truncated"
    % 	13, air, "fixed" and "newfixed"
    % The flight 11 OPC irregular files, however, does not seem to have been
    % used to generate the version 1 file in the field, and therefore ignored
    % here.
    
    if str2num(flightnumber)==3; % aps
        rawfiles(3)={fullfile(sourcedir,foldername, [daystr 'fixed.' char(ext(3))])};
    end;
    if str2num(flightnumber)==3 | str2num(flightnumber)==8; % nep
        rawfiles(4)={fullfile(sourcedir,foldername, [daystr 'fixed.' char(ext(4))])};
    elseif str2num(flightnumber)==6 
        rawfiles(4)={fullfile(sourcedir,foldername, [daystr 'newfixed.' char(ext(4))])};
    end;
    if str2num(flightnumber)==3; % dat
        rawfiles(5)={fullfile(sourcedir,foldername, [daystr 'fixed.' char(ext(5))])};
    end;
    if str2num(flightnumber)==3 | str2num(flightnumber)==4 | str2num(flightnumber)==9; % air
        rawfiles(6)={fullfile(sourcedir,foldername, [daystr 'fixed.' char(ext(6))])};
    elseif str2num(flightnumber)==13; 
        rawfiles(6)={fullfile(sourcedir,foldername, [daystr 'newfixed.' char(ext(6))])};
    end;
    
    % deal with irregular v1b file names
    % Below reflect the files Vera generated after revising the time stamps.
    % These files have not been influenced by any mask and should be regarded
    % as version 1b.
    if str2num(flightnumber)==1 | str2num(flightnumber)== 2 | str2num(flightnumber)==4 | str2num(flightnumber)==5 | str2num(flightnumber)==6; % dma
        matfilesv1b(1)={fullfile(savematfiledirv1,foldername,[daystr char(ext(1)) '_newtime.mat'])};
    else
        matfilesv1b(1)={fullfile(savematfiledirv1,foldername,[daystr char(ext(1)) '_newnotes.mat'])};
    end;
    matfilesv1b(6)={fullfile(savematfiledirv1,foldername,[daystr char(ext(6)) '_timecorr.mat'])};
end
