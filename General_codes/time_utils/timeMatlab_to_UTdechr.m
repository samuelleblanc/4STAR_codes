function[UT]=timeMatlab_to_UTdechr(t)
[yy mon dd hh mm ss]=datevec(t);
UT=hh+mm/60.+ss/3600;
