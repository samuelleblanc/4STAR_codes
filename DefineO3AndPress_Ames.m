if (julian(day, month,year,12) == julian(27,8,2012,12))
    press=ones(n,1)*1013;
    O3_col_start=.290;  %from OMI for Ames lat,lon for 8/27
elseif (julian(day, month,year,12) == julian(28,8,2012,12))
    press=ones(n,1)*1013;
    O3_col_start=.286;  %interpolated from OMI for Ames lat,lon for 8/27 and 8/29
elseif (julian(day, month,year,12) == julian(29,8,2012,12))
    press=ones(n,1)*1013;
    O3_col_start=.283;  %from OMI for Ames lat,lon for 8/29
elseif (julian(day, month,year,12) == julian(30,8,2012,12))
    press=ones(n,1)*1013;
    O3_col_start=.288; %from OMI for Ames lat,lon for 8/30
elseif (julian(day, month,year,12) == julian(08,4,2013,12))
    press=ones(n,1)*1013;
    O3_col_start=.322; %from OMI for Ames lat,lon for 8/30
elseif (julian(day, month,year,12) == julian(09,4,2013,12))
    press=ones(n,1)*1013;
    O3_col_start=.305; %from OMI for Ames lat,lon for 8/30
elseif (julian(day, month,year,12) == julian(26,6,2013,12))
    press=ones(n,1)*1013;
    O3_col_start=.306; %from OMI for Ames lat,lon for 6/25
else
    press=ones(n,1)*1013;
    O3_col_start=.290; %default
    NO2_col=5.4e15;     %nolec/cm2 guess
end
