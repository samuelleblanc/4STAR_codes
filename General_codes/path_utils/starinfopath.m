function pth = starinfopath
% pth = starinfopath
% Returns the path where starinfo files and starflag.mat files should be
pth = [fileparts(which('starinfo')),filesep];
return