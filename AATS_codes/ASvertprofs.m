function [times, alt, comment] = ASvertprofs(flightnumber, profile_type)

ASparam(flightnumber);
filename=fullfile(paths, 'arctas', ['AS' foldername 'vertprofs.txt']);
[startt,stopt,starthr, stophr, startalt,stopalt]=textread(filename,'%n%n%n%n%n%n%*[^\n]','delimiter',' ');
times=[startt stopt];
alt=[startalt stopalt];
comment=textread(filename,'%*n %*n %*n %*n %*n %*n %s','delimiter','\n');
if nargin>=2
    rr=strmatch(lower(profile_type), comment);
    times=times(rr,:);
    alt=alt(rr,:);
    comment=comment(rr,:);
end;