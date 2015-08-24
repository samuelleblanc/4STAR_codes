function evalstarinfo(daystr, keyword)

% looks at the specified starinfo for a line starting with the specified
% keyword, and evaluates it.
% The same task can be achieved with importdata for most starinfo files,
% but not all (e.g., starinfo20130225.m).
% Yohei, 2013/03/19.

% identify the file
if iscell(daystr);
    daystr=char(daystr);
end;
starinfofile=fullfile(starpaths, ['starinfo' daystr '.m']);
starinfofile0=starinfofile;
if exist(starinfofile)~=2;
    starinfofile=fullfile(starpaths, starinfofile);
    if ~exist(starinfofile)
        starinfofile=fullfile(starpaths, ['starinfo' daystr '.m']);
        if ~exist(starinfofile)
            error([starinfofile0 ' does not exist.']);
        end;
    end;
end;

% look for a line starting with the keyword
try;
    run(starinfofile);  
catch;
    s.dummy=true;
    eval(starinfofile);
end;
if exist(keyword);
    eval(['assignin(''caller'',keyword, ' keyword ');']);
else
    warning(['No line has ' keyword '. Nothing was evaluated.']);
end;
% fid=fopen(starinfofile);
% s=fgetl(fid);
% count=0;
% while ~isempty(s);
%     if ~isempty(strmatch(keyword,s));
%         if count==1;
%             disp(s0);
%             disp(s);
%         elseif count>1
%             disp(s);
%         end;
%         evalin('caller',['daystr=''' daystr ''';']);
%         evalin('caller',s);
%         s0=s;
%         count=count+1;
%     end;
%     s=fgetl(fid);
% end;
% if count>1;
%     warning([num2str(count) ' lines have ' keyword '. Only the first line was evaluated.']);
% elseif count==0;
%     warning(['No line has ' keyword '. Nothing was evaluated.']);
% end;
% fclose(fid);