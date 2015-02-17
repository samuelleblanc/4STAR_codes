function flagfilename = select_flagfile(daystr,R)

switch daystr
    case '20130806'
        if strcmp(R,'0')
            flagfilename='20130806_starflag_man_created20140407_2108by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130806_starflag_man_created20141013_1213by_JL.mat';
        end
    case '20130807'
        if strcmp(R,'0') | strcmp(R,'1')
            flagfilename='20130807_starflag_man_created20140407_2045by_JL.mat';
        end
    case '20130808'
        if strcmp(R,'0')
            flagfilename='20130808_starflag_man_created20140413_1739by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130808_starflag_man_created20141013_1215by_JL.mat';
        end
    case '20130812'
        if strcmp(R,'0')
            flagfilename='20130812_starflag_man_created20140413_1756by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130812_starflag_man_created20141111_1434by_JL.mat';
            %flagfilename='20130812_starflag_man_created20141013_1241by_JL.mat';
        end
    case '20130814'
        if strcmp(R,'0')
        %if strcmp(R,'0') | strcmp(R,'1')
            flagfilename='20130814_starflag_man_created20140413_1810by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130814_starflag_man_created20141107_1648by_JL.mat'; %best manual update
            %flagfilename='20130814_starflag_man_created20141107_1535by_JL.mat'; %good auto screening needs slight tweaking
        end
    case '20130816'
        if strcmp(R,'0')
            flagfilename='20130816_starflag_man_created20140413_1714by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130816_starflag_man_created20141014_1116by_JL.mat';
        end
    case '20130819'
        if strcmp(R,'0')
            flagfilename='20130819_starflag_man_created20140408_1602by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130819_starflag_man_created20141014_1142by_JL.mat';
        end
    case '20130821'
        if strcmp(R,'0')
            flagfilename='20130821_starflag_man_created20140413_1851by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130821_starflag_man_created20141014_1521by_JL.mat';
        end
    case '20130823'
        flagfilename=[];
    case '20130826'
        flagfilename=[];
    case '20130827'
        flagfilename=[];
    case '20130830'
        flagfilename=[];
    case '20130902'
        if strcmp(R,'0')
            flagfilename='20130902_starflag_man_created20140414_1116by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130902_starflag_man_created20141015_1103by_JL.mat';
        end
    case '20130904'
        if strcmp(R,'0')
            flagfilename='20130904_starflag_man_created20140414_1151by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130904_starflag_man_created20141015_1117by_JL.mat';
        end
    case '20130906'
        if strcmp(R,'0')
            flagfilename='20130906_starflag_man_created20140407_1231by_MK.mat';
        elseif strcmp(R,'1')
            flagfilename='20130906_starflag_man_created20141015_1157by_JL.mat';
        end
    case '20130907'
        if strcmp(R,'0')
            flagfilename='20130907_starflag_man_created20140407_1232by_MK.mat';
        elseif strcmp(R,'1')
            flagfilename='';
        end
    case '20130909'
        if strcmp(R,'0')
            flagfilename='20130909_starflag_man_created20140414_1240by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130909_starflag_man_created20141015_1335by_JL.mat';
        end
    case '20130911'
        if strcmp(R,'0')
            flagfilename='20130911_starflag_man_created20140414_1046by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130911_starflag_man_created20141012_1254by_JL.mat';
        end
    case '20130913'
        if strcmp(R,'0')
            flagfilename='20130913_starflag_man_created20140414_1339by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130913_starflag_man_created20141015_2021by_JL.mat';
        end
    case '20130916'
        if strcmp(R,'0')
            flagfilename='20130916_starflag_man_created20140413_1401by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130916_starflag_man_created20141015_1932by_JL.mat';
        end
    case '20130917'
        if strcmp(R,'0') | strcmp(R,'1')
            flagfilename='20130917_starflag_man_created20140413_1404by_JL.mat';
        end
    case '20130918'
        if strcmp(R,'0')
            flagfilename='20130918_starflag_man_created20140413_1912by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130918_starflag_man_created20141111_0911by_JL.mat';
            %flagfilename='20130918_starflag_man_created20141110_1611by_JL.mat';
            %flagfilename='20130918_starflag_man_created20141015_1428by_JL.mat';
        end
    case '20130921'
        if strcmp(R,'0')
            flagfilename='20130921_starflag_man_created20140414_0626by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130921_starflag_man_created20141015_1413by_JL.mat';
        end
    case '20130923'
        if strcmp(R,'0')
            flagfilename='20130923_starflag_man_created20140414_1548by_JL.mat';
        elseif strcmp(R,'1')
            flagfilename='20130923_starflag_man_created20141015_1532by_JL.mat';
        end
end


