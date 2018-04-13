function [iwvl,save_wvls] = get_wvl_subset(t,instrumentname)
%% Script to get wavelength indices for creating the polyfit wavelengths
% 
% Created by SL, 2018-04-12


%%
version_set('1.0');
% control the input
if nargin==0;
    t=now;
    instrumentname = '4STAR'; % by default use 4STAR
elseif nargin<=2;
    instrumentname = '4STAR'; % by default use 4STAR
end;

switch instrumentname;
    case {'4STAR'}
        if t>datenum(2012,01,01,0,0,0) ; %from the start of 4STAR
            save_wvls  = [354.9,380.0,451.7,470.2,500.7,520,530.3,532.0,550.3,605.5,619.7,660.1,675.2,780.6,864.6,1019.9,1039.6,1064.2,1235.8,1249.9,1558.7,1626.6,1650.1];
            iwvl = [ 227    258    347    370     408     432     445     447     470     539  557     608     627     761     869    1084   1095   1109    1213    1222  1439   1492   1511];
        end;

    case{'4STARB'}
        if t>datenum(2017,01,01,0,0,0);
            save_wvls  = [355.1,380.1,452.0,469.7,500.3,520.3,530.0,532.4,550.0,605.1,620.3,660.0,675.0,779.8,865.4,1019.9,1039.6,1064.2,1235.0,1250.5,1560.2,1626.4,1650.1];
            iwvl = [ 227    258    347    369     407     432     444     447     469     538  557     607     626     759     869    1085   1095   1110    1214    1224  1443   1495   1514];
        end;
end;
return