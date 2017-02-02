function datestr = extract_date_from_starname(str);
% function that extracts the datestr from the star file name
% starts with string (str) output from fileparts
b = regexp(str,'\d*','Match');
if length(b)>1;
    for i=1:length(b);
        if length(b{i})==8;
            datestr = b{i};
        end;
    end
else
    datestr= b{1};
end;
return;