function [h,filename]=starchart(funhandle, source, datatype, varargin)

% makes a chart to show 4STAR data.
% 
% Example
%     figure;
%     [h,filename]=starchart(@plot, '20120709','vis_sun','t','Alt','t','raw','cols',c(4));
%     figure;
%     [h,filename]=starchart(@scatter, '20120717','starsun.mat','t','Alt',24, 't','cols',c(4),'title','20120717 profiles');
% 
% See also spvis.m, spnir.m, spvisnir.m, spsun.m, ssvis.m, ssnir.m, ssvisnir.m, sssun.m.
% Yohei, 2013/06/07, 2013/07/25

% development
% figure handles are sometimes misaligned, resulting in incorrect labels
% and legend.
% update the help lines. structures are to be assigned as datatype, and are not accepted as x, y, etc. fields are.
% Organize the messy lines for decorating. 
% if easy, check the dimension consistency between x and y perhaps, before trimming.

%********************
% identify data source and type(s)
%********************
% Three kinds of source are accepted. 
% (1) the base workspace - leave datatype empty.
% (2) a star....mat file containing values - leave datatype empty.
% (3) a star.mat file containing structures - load requested structures and
%     fill datatype with their names
% In the rest of the code, (1), (2) and (3) are distinguished by means of
% exist(source) and isempty(datatype).
loaded={};
if ismember(lower(source), {'base'; 'workspace'});
    source='base'; % all variables are to be loaded from the base workspace.
    datatype='';
elseif ischar(datatype) && numel(datatype)>3 && strcmp(lower(datatype(end-3:end)), '.mat'); % a processed file, for example starsun.mat
    source=starfinder(datatype(1:end-4), source);
    datatype='';
    matobj=matfile(source);
else; % a star.mat file
    % identify the source mat-file
    source=starfinder('star', source);
    % load the requested structures
    if ischar(datatype);
        datatype={datatype}; % this variable is frequently referred to later
    end;
    if iscell(datatype);
        loaded=load(source, datatype{:});
    end;
    datatype=fieldnames(loaded);
    % re-order the loaded structures and assign pre-set marker properties
    datatype0={'SUN', 'ZEN', 'SKYA', 'SKYP', 'FOVA', 'FOVP', 'FORJ' 'PARK'};
    datatype0=[strcat('vis_', lower(datatype0))'; strcat('nir_', lower(datatype0))'; 'track'];
    mkr=[repmat('.+>^<vop',1,2) 'x']; % marker
    clr=[repmat([0 0 0; 1 0 0; 0 0 1; 0 1 1; 0 0.5 0; 0 1 0; 1 0.5 0; 0.5 0.25 0],2,1); [0 0 0]];
    mkrsize_plot=ones(size(datatype0))*6;
    mkrsize_scatter=[repmat([24 repmat(72, 1, (numel(datatype0)-1)/2-1)],1,2) 24];
    [~,ia,ib]=intersect(datatype,datatype0);
    [~,sorti]=sort(ib);
    datatype=datatype(ia(sorti));
    mkr=mkr(ib(sorti));
    clr=clr(ib(sorti),:);
    mkrsize_plot=mkrsize_plot(ib(sorti));
    mkrsize_scatter=mkrsize_scatter(ib(sorti));
    clear datatype0 ib sorti;
    % prepare for iterations
    varargin0=varargin;
end;

%********************
% load data
%********************
% prepare to load
ish0=ishold;
id='MATLAB:load:variableNotFound';
warn=warning('query',id);
if isequal(warn.state, 'on');
    warning('off',id);
end;
qq=numel(varargin);
skipit=false(1,qq);
ist=false(1,qq);
isw=false(1,qq);
isspectrum=false(1,qq);
dim=NaN(2,qq);
str=repmat({''},1,qq);
axisproperties=[];
axisproperties0=lower(fieldnames(get(gca)));
parameters={'tlim' 'not assigned';  'rows' 'not assigned';    'cols' 'not assigned';    'xlabel' '';    'ylabel' '';    'slabel' '';    'clabel' '';    'title' '';    'filename' '';    'savefigure' false}; % the name and initial value of special parameters
% start iteration if the source is a star.mat file
for j=1:max([1 numel(datatype)]); % as many iterations as datatype if the source is a star.mat; just one if the base workspace or a starmat.sun
    if ~isempty(datatype); % a star.mat file
        fn=fieldnames(loaded.(datatype{j}));
    end;
    if j>1;
        varargin=varargin0;
    end;
    % load each input variable
    for i=1:qq;
        if skipit(i); % do nothing
        elseif isnumeric(varargin{i}); % numbers from the base workspace; this is an option even when source is an existing mat-file
            dim(:,i)=size(varargin{i})';
            str(i)={','};
        elseif ischar(varargin{i}); % a character array is given; see if it is among the axis properties and special pastrrameters; if not try loading the variable; if loading fails, then leave the character array as it is
            [tf,loc]=ismember(lower(varargin{i}), parameters(:,1));
            [tfa,loca]=ismember(lower(varargin{i}), axisproperties0);
            if tf || tfa; % the string refers to an axis property or special parameter; pair it up with the value assigned in the subsequent variable
                if i==qq;
                    error([varargin{i} ' must be accompanied by a value.']);
                else;
                    if tf;
                        parameters{loc,2}=varargin{i+1};
                    elseif tfa;
                        axisproperties=[axisproperties; axisproperties0(loca) varargin{i+1}];
                    end;
                    skipit([i i+1])=true;
                end;
            elseif exist(source)==2; % try loading, if the source is an existing file
                fn0=varargin{i};
                if isempty(datatype); % a processed file, for example starsun.mat
                    if ~ismember(varargin{i}, loaded) && ~isempty(whos(matobj, varargin{i})); % yet to be loaded and available in the source mat-file
                        load(source, varargin{i}); % load it
                        loaded=[loaded; varargin{i}]; % marked as loaded
                    end;
                    if ismember(varargin{i}, loaded); % the requested variable is already loaded
                        eval(['varargin{i} = ' varargin{i} ';']); % assign it now
                        dim(:,i)=size(varargin{i})';
                    end;
                else; % a star.mat file
                    if ismember(varargin{i}, fn);
                        varargin{i}=cat(1,loaded.(datatype{j}).(varargin{i})); % cat is needed for structures with more than one element, for example vis_skya
                        dim(:,i)=size(varargin{i})';
                    end;
                end;
                if all(isfinite(dim(:,i))); % if numbers have been substituted for the variable name (skip if varargin{i} is a plot modifier), prepare for decorating the figure later
                    str{i}=starfieldname2label(fn0); % get a label for the variable
                    if strcmp(fn0, 't'); 
                        ist(i)=true;
                    elseif strcmp(fn0, 'w');
                        isq(i)=true;
                    end;
                end;
                clear fn0;
            end;
            clear tf loc tfa loca;
        end;
    end;
    clear i;
    if any(dim(1,:)>1) && ~exist('t'); % at least one variable has more than one row which this code assumes to correspond to time (t)
        if isempty(datatype); 
            load(source, 't');
        elseif ismember('t', fn);
            t=cat(1,loaded.(datatype{j}).t);
        end;
    end;
    if any(dim(2,:)>1);
        if ~exist('w');
            if isempty(datatype); % the requested variable is not a structure and is available in the source file.
                load(source, 'w');
            elseif ismember('w', fn);
                w=loaded.(datatype{j}).w;
            end;
        end;
        if exist('w');
            isspectrum(dim(2,:)==numel(w))=true;
            isspectrum(dim(1,:)==numel(w))=true;
            wtrimmed{j}=w; % trimmed later
        end;
    end;
    
    %********************
    % trim data if requested
    %********************
    dimtrimmed(:,:,j)=dim(:,:);
    tlim=parameters{strcmp('tlim', parameters(:,1)),2};
    rows=parameters{strcmp('rows', parameters(:,1)),2};
    if isnumeric(tlim) && size(tlim,2)==2; % range(s) of time period given
        if isnumeric(rows);
            error('tlim and rows must not be given at the same time.');
        end;
        rows=incl(t, tlim);
    end;
    if isnumeric(rows);
        multi=find(dim(1,:)>1);
        for i=multi;
            varargin{i}=varargin{i}(rows,:);
            dimtrimmed(1,i,j)=numel(rows);
        end;
    end;
    cols=parameters{strcmp('cols', parameters(:,1)),2};
    if isnumeric(cols);
        multi=find(dim(2,:)>1);
        for i=multi;
            varargin{i}=varargin{i}(:,cols);
            dimtrimmed(2,i,j)=numel(cols);
        end;
        if any(isspectrum);
            for j=1:numel(wtrimmed)
                wtrimmed{j}=wtrimmed{j}(cols);
            end;
        end;
    end;
    clear i multi t w; 
    
    %********************
    % plot
    %********************
    % plot now
    hj0=feval(funhandle, varargin{~skipit});
    % bundle plot handles
    if j==1;
        h=hj0;
        hj=ones(size(hj0))*j;
        hn0=numel(h);
        hold on;
    else
        h=[h; hj0];
        hj=[hj; ones(size(hj0))*j];
    end;
end;
if isequal(warn.state, 'on');
    warning('on',id);
end;
clear warn;
if ~ish0;
    hold off;
end;
if isempty(datatype); % a processed file, for example starsun.mat
    clear(loaded{:});
end;
clear rows cols dim fn id ish0 j loaded skipit source varargin varargin0 warn w matobj;

%********************
% decorate the figure
%********************
% This complicated section modifies axes properties, put labels and a
% legend, and, in a case with spectra, change plot colors.  
% Assumptions include:
% The rows of variables, where there are more than one, correspond to time
% (t). The columns of variables, if they are as many as wavelengths if
% available, correspond to wavelengths.

% relate variables to axes
idx=[];
for i=1:qq;
    if ~isempty(str{i});
        idx=[idx i];
    end;
end;
if isempty(idx);
    xidx=[];
    yidx=[];
elseif isequal(funhandle, @scatter);
    xidx=1;
    yidx=2;
elseif numel(idx)==1 || min(diff(idx))>1;
    xidx=[];
    yidx=idx;
else
    xidx=idx(1:2:end);
    yidx=idx(2:2:end);
end;
clear i idx;
% adjust axes
if all(ist(xidx)) && ~isempty(xidx);
    dateticky('x','keeplimits');
end;
if all(ist(yidx)) && ~isempty(yidx);
    dateticky('y','keeplimits');
end;
if all(isw(xidx)) && ~isempty(xidx);
    gglwa;
else
    ggla;
end;
grid on;
% modify axis properties
for i=1:size(axisproperties,1);
    %if axisproperties{i,1}=='YLim'; 
    %    if isnan(axisproperties{i,2})==1;
    %        axisproperties{i,2}=[0 100];
    %    end;
    %end;            
    set(gca, axisproperties{i,1}, axisproperties{i,2}); 
end;
% put labels
xstr=parameters{strcmp('xlabel', parameters(:,1)),2};
if ~isempty(xstr);
    xlabel(xstr,'interpreter','none');
    uxstr={xstr};
else
    [uxstr, uxi]=unique(str(xidx),'first');
    [uxstr, uxi]=setdiff(uxstr(uxi), {','});
    [~,uxii]=sort(uxi);
    uxstr=uxstr(uxii);
    xstr='';
    for i=1:numel(uxstr);
        xstr=[xstr, uxstr{i}, ', '];
    end;
    xlabel(xstr(1:end-2),'interpreter','none');
    clear uxi uxii uxi2;
end;
ystr=parameters{strcmp('ylabel', parameters(:,1)),2};
if ~isempty(ystr);
    ylabel(ystr,'interpreter','none');
    uystr={ystr};
else
    [uystr, uyi]=unique(str(yidx),'first');
    [uystr, uyi]=setdiff(uystr(uyi), {','});
    [~,uyii]=sort(uyi);
    uystr=uystr(uyii);
    ystr='';
    for i=1:numel(uystr);
        ystr=[ystr, uystr{i}, ', '];
    end;
    ylabel(ystr(1:end-2),'interpreter','none');
    clear uyi uyii uyi2;
end;
tstr=parameters{strcmp('title', parameters(:,1)),2};
if ~isempty(tstr);
    title(tstr,'interpreter','none');
end;    
if isequal(funhandle, @plot);
    if numel(uystr)==1 && numel(uxstr)~=1;
        lstr=uxstr;
    else
        lstr=uystr;
    end;
    % account for the handles and set colors
    hidx=[];
    hs=1;
    for i=1:numel(yidx);
        % figure out how many handles are dedicated to each pair of x and y
        hn=1;
        if ~isempty(xidx); % if x is explicitly assigned (i.e., not filled with the index)
            dt=dimtrimmed(:,[xidx(i) yidx(i)]);
            hn=min(setdiff(dt(:), 1));
            if hn==max(dt(:));
                hn=1;
            end;
            clear dt;
        end;
        % check if each x,y pair represents spectra
        if isequal(funhandle, @plot) && (isspectrum(yidx(i)) || isspectrum(xidx(i)));
            hidx0=hs:hs+hn-1;
            for j=1:numel(wtrimmed); % this iteration is needed for a star.mat if the mat-file ever has wavelengths
                lstr0=setspectrumcolor(h(hidx0+hn0*(j-1)), wtrimmed{j});
            end;
            lstr=[lstr(1:i-1) lstr0 lstr(i+1:end)];
        else
            hidx0=hs;
        end;
        % store the index for legend
        hidx=[hidx hidx0];
        % prepare for the next iteration
        hs=hs+hn;
    end;
    if hs-1~=hn0;
        error('Handles unaccounted.');
    end;
    clear cols;
    % change marker properties for star.mat structures
    if ~isempty(datatype) && numel(mkrsize_plot)>1;
        for j=1:numel(mkrsize_plot); % this iteration is needed for a star.mat
            set(h(hj==j), 'marker',mkr(j),'markersize',mkrsize_plot(j));
            if numel(yidx)==1;
                set(h(hj==j), 'color',clr(j,:));
            end;
        end;
        if numel(hidx)==1; % rewrite legend contents
            [uniB,uniI] = unique(hj,'first');
            lstr=upper(datatype(uniB));
            hidx=uniI;
            clear uniB uniI;
        end;
    end;
    % put a legend
    lh=legend(h(hidx),lstr);
    set(lh,'fontsize',12,'interpreter','none','location','best');
    if numel(xidx)<=1 && numel(yidx)<=1 && numel(lstr)<=1 && numel(datatype)<=1;
        set(lh,'visible','off');
    end;
    % return filename
    filename=parameters{strcmp('filename', parameters(:,1)),2};
    if isempty(filename);
        filename=['star' tstr(regexp(tstr,'\w')) xstr(regexp(xstr,'\w')) ystr(regexp(ystr,'\w'))];
    end;
elseif isequal(funhandle, @scatter);
    % change marker properties for star.mat structures
    if ~isempty(datatype) && numel(mkrsize_scatter)>1;
        for j=1:numel(mkrsize_scatter); % this iteration is needed for a star.mat
            set(h(hj==j), 'marker',mkr(j));
            if isequal(str{3}, ',');
                set(h(hj==j), 'SizeData',mkrsize_scatter(j));
            end;
            if isequal(str{4}, ',')
                set(h(hj==j), 'MarkerFaceColor',clr(j,:));
            end;
        end;
    end;
    % label for size and color
    sstr=parameters{strcmp('slabel', parameters(:,1)),2};
    if isempty(sstr) && ~isequal(str{3}, ',');
        sstr=str{3};
    end;
    if ~isempty(sstr);
        lh=legend(['Marker sized by ' sstr]);
        set(lh,'fontsize',12,'interpreter','none','location','best');
    elseif ~isempty(datatype) && isequal(str{3}, ','); % rewrite legend contents
        lh=legend(h(unique(hj)), datatype(unique(hj)));
        set(lh,'fontsize',12,'interpreter','none','location','best');
    end;
    cstr=parameters{strcmp('clabel', parameters(:,1)),2};
    if isempty(cstr);
        cstr=str{4};
    end;
    ch=colorbarlabeled(cstr);
    yl=get(ch,'ylabel');
    set(yl, 'interpreter','none');
    % adjust color bar
    if all(ist(4));
        datetick(ch, 'y','keeplimits');
    end;
    % return filename
    filename=parameters{strcmp('filename', parameters(:,1)),2};
    if isempty(filename);
        filename=['star' tstr(regexp(tstr,'\w')) xstr(regexp(xstr,'\w')) ystr(regexp(ystr,'\w')) sstr(regexp(sstr,'\w')) cstr(regexp(cstr,'\w'))];
    end;
end;

%********************
% save the figure if requested
%********************
if parameters{strcmp('savefigure', parameters(:,1)),2};
    [st,i]=dbstack;
    starsas([filename '.fig, ' st(end).name '.m']);
end;