% 12/04/2013 MK
% Calls starflag.m with mode 2 manual aerosol-cloud screening
% Mode = 2 "in-depth" flagging of aerosol (e.g. smoke or dust) and
% clouds (e.g. low clouds or cirrus); starflag.m is called as stand-alone
% (i.e. outside of starsun.m) and produces YYYYMMDD_starflag_man_createdYYYYMMDD_HHMM_by_Op.mat
% and starflags_YYYYMMDD_marks_not_aerosol_created_YYYYMMDD_by_Op.m
% and starflags_YYYYMMDD_marks_smoke_created_YYYYMMDD_by_Op.m etc...

%
clear
close all

[flags]=starflag('20151118',2,[]);

