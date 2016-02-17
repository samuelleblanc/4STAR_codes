if (julian(day, month,year,12) == julian(24,8,2008,12))
                press=ones(n,1)*681;
                O3_col_start=.272; %.2671, .2771 from Brewer for 8/25
            elseif (julian(day, month,year,12) == julian(9,1,2016,12))
                press=ones(n,1)*681;
                O3_col_start=.249;  %MLO DB
            elseif (julian(day, month,year,12) == julian(10,1,2016,12))
                press=ones(n,1)*681;
                O3_col_start=.251; 
            elseif (julian(day, month,year,12) == julian(11,1,2016,12))
                press=ones(n,1)*681;
                O3_col_start=.245;
            elseif (julian(day,month,year,12) == julian(12,1,2016,12))
                press=ones(n,1)*681.3;
                O3_col_start=.236;
            elseif (julian(day,month,year,12) == julian(13,1,2016,12))
                press=ones(n,1)*681.3;
                O3_col_start=.243;
            elseif (julian(day,month,year,12) == julian(14,1,2016,12))
                press=ones(n,1)*681.3;
                O3_col_start=.246;
            elseif (julian(day,month,year,12) == julian(15,1,2016,12))
                press=ones(n,1)*681.3;
                O3_col_start=.230;
            elseif (julian(day,month,year,12) == julian(16,1,2016,12))
                press=ones(n,1)*681.3;
                O3_col_start=.235;
            elseif (julian(day,month,year,12) == julian(17,1,2016,12))
                press=ones(n,1)*681.3;
                O3_col_start=.244;
            elseif (julian(day,month,year,12) == julian(18,1,2016,12))
                press=ones(n,1)*681.3;
                O3_col_start=.247;
            elseif (julian(day,month,year,12) == julian(29,5,2012,12))
                press=ones(n,1)*681.3;
                O3_col_start=.281;
            elseif (julian(day,month,year,12) == julian(30,5,2012,12))
                press=ones(n,1)*681.3;
                O3_col_start=.281;
            elseif (julian(day,month,year,12) == julian(31,5,2012,12))
                press=ones(n,1)*681.3;
                O3_col_start=.284
            elseif (julian(day,month,year,12) >= julian(25,07,2013,12)) & (julian(day,month,year,12) <= julian(07,08,2013,12))
                %Palmdale
                press=ones(n,1)*925;  %guess
                O3_col_start=.300;  %guess...needs to be updated
            elseif (julian(day,month,year,12) >= julian(08,08,2013,12))
                %Houston
                press=ones(n,1)*1013;  %guess
                O3_col_start=.300;  %guess...needs to be updated
 end