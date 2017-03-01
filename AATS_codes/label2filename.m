function str=label2filename(str0)

% Yohei, 2009/02/25

str=str0;
kakkostart=findstr(str, '(');
kakkostop=findstr(str, ')');
per=findstr(str, '/');
for i=1:length(kakkostart);
    str=[str(1:kakkostart(i)-1) str(kakkostop(i)+1:end)];
end;
for i=1:length(per);
    try
        str=[str(1:per(i)-1) 'per' str(per(i)+1:end)];
    end;
end;

replacecharacter=' ,./#()+-­*[]><@&^:%\{}';
replacement='_';
for i=1:length(replacecharacter);
    str(find(str==replacecharacter(i)))=replacement; % replace unacceptable characters with replacements
end;
ng=findstr(str, replacement);
ok=ones(size(str));
ok(ng)=0;
str=str(find(ok==1));