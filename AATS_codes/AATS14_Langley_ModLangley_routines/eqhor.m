function [azimuth, altitude]=eqhor(day,month,year, ut, ra, declination, geog_long, geog_lat);
gst=utgst (day, month, year, ut);
