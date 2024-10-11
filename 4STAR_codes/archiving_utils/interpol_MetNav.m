function s = interpol_MetNav(s,filename);
%% Function to read out the met nav ict files and interpolate to the star structure.

if ~exist(filename)
    filename = uiopen('*.ict')
end
out = ictread(filename);
dv = datevec(s.t(1));
out.datetime = datenum(datetime(dv(1),1,0)+days(out.t));

match_vars = {{'Pst','Press_Ambient'},
              {'Tst','Temp_Ambient'},
              {'Lat','Latitude'},
              {'Lon','Longitude'},
              {'Alt','GPS_Altitude'},
              {'pitch','Pitch_Angle'},
              {'roll','Roll_Angle'},
              {'Headng','True_Heading'},
              {'Alt_pressure','Pressure_Altitude'},
              {'RH','Relative_Humidity_Ambient'}};

for i=1:length(match_vars)
    igood = find(out.(match_vars{i}{2})>-9999.0);
    var = out.(match_vars{i}{2})(igood);
   s.(match_vars{i}{1}) = interp1(out.datetime(igood),out.(match_vars{i}{2})(igood),s.t,'pchip',var(1));    
end

