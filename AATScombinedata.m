% This code combines two or more AATS mat files. Run
% plot_re4_COAST_Oct2011.m and save the contents, prior to running this
% code. 
% Yohei, 2012/03/11

% set parameters
filenamelist={'R03Mar12ABaats.mat' 'R05Mar12AAaats.mat' 'R07Mar12AAaats.mat' 'R06Mar12ADaats.mat' 'R07Mar12ABaats.mat' 'R08Mar12AAaats.mat' 'R09Mar12ABaats.mat' 'R09Mar12ACaats.mat'};
filenamelist={'R09Mar12ABaats.mat' 'R09Mar12ACaats.mat'};
filenamelist={'R28May12AB.mat' 'R28May12AE.mat' 'R28May12AF.mat'};
filenamelist={'R01Jun12AA.mat' 'R01Jun12AE.mat'};
filenamelist={'20120822AAaats.mat' '20120822ABaats.mat'};
filenamelist={'AATS_12Feb2013_am.mat' 'AATS_12Feb2013_pm.mat'};
filenamelist={'AATS_18Feb2013_am.mat' 'AATS_18Feb2013_pm.mat'};
filenamelist={'AATS_25Feb2013_morning.mat' 'AATS_25Feb2013_afternoon.mat'};
filenamelist={'20130618aatsAC.mat' '20130618aatsAD.mat'};
filenamelist={'20130812aatsAA.mat' '20130812aatsAC.mat'};
filenamelist={'20130904aatsAD.mat' '20130904aatsAE.mat'};
filenamelist={'20130905aatsAA.mat' '20130905aatsAB.mat'};
filenamelist={'20131030aatsAA.mat' '20131030aatsAB.mat' '20131030aatsAC.mat' '20131030aatsAD.mat'};
filenamelist={'20140122aatsAA.mat' '20140122aatsAB.mat' '20140122aatsAC.mat'};
filenamelist={'20140219aatsAA.mat' '20140219aatsAB.mat' '20140219aatsAC.mat'};
filenamelist={'20140224aatsAA.mat' '20140224aatsAB.mat' '20140225aatsAA.mat'};
filenamelist={'20140318aatsAA.mat' '20140318aatsAB.mat' '20140318aatsAC.mat'};
filenamelist={'20140320aatsAA.mat' '20140320aatsAB.mat' '20140320aatsAC.mat'};
filenamelist={'20140324aatsAA.mat' '20140324aatsAB.mat' '20140324aatsAC.mat' '20140325aatsAA.mat'};
filenamelist={'20140407aatsAA.mat' '20140407aatsAB.mat' '20140407aatsAC.mat' '20140407aatsAD.mat'};
% filenamelist={'20140123aatsAA.mat' '20140123aatsAB.mat' '20140123aatsAC.mat' '20140123aatsAD.mat'};
% filenamelist={'20120828aatsAA.mat' '20120829aatsAA.mat'};
% filenamelist={'20120829aatsAA.mat' '20120829aatsAB.mat'};
% filenamelist={'20120830aatsAB.mat' '20120830aatsAC.mat'};

% filenamelist={'R23Mar12ABaats.mat'}; % 'R05Mar12AAaats.mat' 'R07Mar12AAaats.mat' 'R06Mar12ADaats.mat' 'R07Mar12ABaats.mat' 'R08Mar12AAaats.mat' 'R09Mar12ABaats.mat' 'R09Mar12ACaats.mat'};
sourcefolder=fullfile(paths, '4star', 'data', 'v1mat');
sourcefolder=starpaths;

% go through each mat file
for i=1:length(filenamelist);
    filename=fullfile(sourcefolder, [char(filenamelist(i))]);
    if i==1;
        load(filename);
        aatst=UT/24+datenum(year,month,day);
    else
        a=load(filename);
        a.aatst=a.UT/24+datenum(a.year,a.month,a.day);
        p=length(a.UT);
        fn=fieldnames(a);
        for ff=1:length(fn);
            eval(['variable=a.' char(fn(ff)) ';']);
            if exist(char(fn(ff)))==0;
                warning([char(fn(ff)) ' not saved.']);
            elseif size(variable,2)==p;
                eval([char(fn(ff)) '=[' char(fn(ff)) ' a.' char(fn(ff)) '];']);
            elseif size(variable,2)==0;
                eval([char(fn(ff)) '=[' char(fn(ff)) ' a.' char(fn(ff)) '];']);
            elseif size(variable,1)==p;
                eval([char(fn(ff)) '=[' char(fn(ff)) '; a.' char(fn(ff)) '];']);
            end;
        end;
    end;
end;
% tempsavefilename=fullfile(sourcefolder, ['tempaats.mat']);
% save(tempsavefilename, '-mat');

% get the list of the days covered by the data
days=unique(floor(aatst));
    daystr=datestr(days(1),30);
    daystr=daystr(1:8);
    t=aatst;
    savefilename=fullfile(sourcefolder, [daystr 'aats.mat']);
    save(savefilename, '-mat');

% save now
% fn={'aatst';'UT';'data'};
% for iii=1:length(days);
%     if iii>1;
%         load(tempsavefilename);
%     end;
%     cc=find(aatst>=days(iii)&aatst<days(iii)+1);
%     aats.t=aatst(cc);
%     aats.t=aats.t(:);
%     for ff=1:length(fn);
%         eval(['variable=a.' char(fn(ff)) ';']);
%         if size(variable,2)==p;
%             eval([char(fn(ff)) '=[' char(fn(ff)) '(:, cc)];']);
%         elseif size(variable,1)==p;
%             eval([char(fn(ff)) '=[' char(fn(ff)) '(cc, :)];']);
%         end;
%     end;
%     daystr=datestr(days(iii),30);
%     daystr=daystr(1:8);
%     savefilename=fullfile(sourcefolder, [daystr 'aats.mat']);
%     if exist(savefilename)==2;
%         ButtonName = questdlg([savefilename ' exists. Overwrite?'], ...
%             'Overwrite', ...
%             'Yes','No', 'No');
%         if isequal(ButtonName, 'No');
%             error('Stop here.');
%             return;
%         end;
%     end;
%     clear a;
%     t=aats.t;
%     save(savefilename, '-mat');
% end;
