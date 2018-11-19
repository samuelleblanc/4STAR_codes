function infopath = info_path
% infopath = info_path
% Returns the path to the GitHub data folder where starinfo, Co, and other
% necessary 4STAR, AATS, etc files are saved for Github repository.
infopath = [fileparts(which('info_path')),filesep];

return