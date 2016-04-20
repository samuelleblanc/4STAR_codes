function [flags,screened,good,figs] = visi_screen_v11(main, varargin)
% [flags,screened,good,figs] = visi_screen_v11(main varargin)
% I have an idea how to extend this so that each plotted quantity has it's
% own time, but I'll implement this later.  For now, focussion on ACME-V
% data archival so will merely match nearest times and use existing
% visi_screen_v10.

% 'main' is a struct with  .t and .'user'.  t is a Matlab serial date
% Many optional arguments:
% 'time_choice', time_str: time_str = 'HH:MM:SS','HH.hh', or 'day of year'
% if no time choice provided, you will be prompted for a choice
% 'flags', flags: flags as a struct containing logical fields of
%       length(time) or empty as placeholders.
% 'no_mask',flag_list: cell array or list of strings matching flag fields that will not be 
%       used to mask out data values as gray.
% 'panel_N', panel_N: where N is an integer from 1:N 
%       panel_N is a struct of fields to be displayed in subplot(i,j,N)
% 'subplots', subplots: subplots is a 3-element vector providing the syntax
%       of the subplot function. If not supplied subplot(N,1,N) is assumed
% 'figs', figs: figs is a struct with fields 'tau_fig','tau2_fig','aux_fig','leg_fig'
%       each also a struct with elements .h and pos permitting the figure
%       number and position to be provided.  This is also a return field.
% returns:
%   flags: struct of logicals (from flags inarg) of length(time)
%   screened: bitwise mapping of flags not in flag_list into uint32.
%   good: good = screened==0
%   figs: output of figure numbers and positions to preserve figure layout
% 
% Visually screen times for whether certain events are true or false.
% We'll have one user-provided argument listing the conditions to flag, and
% 2N arguments (label str and time-dimensioned field of same length as tau)
% providing other fields to plot

% If the user doesn't provide a list of flags then just assume we want to
% flag "good" or "not good". clouds are clear or not clear.
% Samuel, v1.0, 2014/10/13, added version control of this m-script via version_set 
version_set('1.0');
if rem(nargin,2)~=0
    error('Problem with number of nargins.')
end
if size(time,1)==1
    time = time';
end

if size(tau,1) ==1
    tau = tau';
end

varin = [];
nflags = [];
grey = [.6,.6,.6];

while length(varargin)>1
    if ischar(varargin{1})
        varin.(char(varargin{1})) = varargin{2};
        varargin(1) = [];varargin(1) = [];
    end
end

if isfield(varin,'time_choice')
    time_choice = varin.time_choice; varin = rmfield(varin,'time_choice');
else
    time_choice = 1;
end
while isempty(find([1,2,3],time_choice))
    time_choice = menu('How should time be displayed?','HH:MM:SS','HH.hh','day of year');
end
switch time_choice
    case 1
        t = serial2hs(main.t);
        t_str = 'time [HH:MM:SS]';
    case 2
        t = serial2hs(main.t);
        t_str = 'time [HH.hh]';
    otherwise
        t = serial2doys(main.t);
        t_str = 'time (day of year)';
end

if isfield(varin,'flags')
    flags = varin.flags; varin = rmfield(varin,'flags');
else
    flags.bad = false(size(t));
end

if isstruct(flags)
    flag_names = fieldnames(flags);
    for f = length(flag_names):-1:1
        if isstruct(flags.(char(flag_names(f))))
            flags = rmfield(flags,char(flag_names(f)));
            flag_names(f) = [];
        else
            if length(flags.(char(flag_names(f))))~=length(t)
                flags.(char(flag_names(f))) = false(size(t));
            end
            if size(flags.(char(flag_names(f))),1)==1
                flags.(char(flag_names(f))) = flags.(char(flag_names(f)))';
            end
            if strcmp(char(flag_names(f)),'aerosol_init_auto') %MK modified 20140402 this flag is redundant with others; we don't need it.
               flags = rmfield(flags,char(flag_names(f)));
               flag_names(f) = [];
            end

        end
    end
    nflags = length(fieldnames(flags));
end

button = nflags;
if nflags==1
    color(1,:)= [0,1,0];
    color(2,:) =[1,0,0];
else
    figure
    color = get_colors([1:nflags]);
    close(gcf)
    color(end+1,:) = [0,0,0];
end
syms = ['o','x','+','*','s','d','v','^','<','>','p','h'];

screen = zeros(size(t),'uint32');
for bit = 1:nflags
    screen = bitset(screen, bit, flags.(char(flag_names(bit)))>0);
end

% Don't be confused.  The field flag_gray actually contains field which 
% will NOT flag fields gray. The complement is taken below.  This confusing
% approach was used so that the default when adding new flags is that they
% will gray out data unless specified otherwise. This basically assumes
% that by default flags will be added to screen data out, not merely to
% identify "interesting" cases
if isfield(varin,'no_mask')
    flag_gray = varin.no_mask; varin = rmfield(varin,'no_mask');
elseif isfield(varin,'goodnomask')
    flag_gray = varin.goodnomask; varin = rmfield(varin,'goodnomask');
end
gray_flags = uint32(zeros(size(t)));
gray_flags = bitcmp(gray_flags); % Take complement, 

if isstruct(flags)&exist('flag_gray','var')
    flag_names = fieldnames(flags);
    for f = 1:length(flag_names)
        if any(strcmp(flag_gray,flag_names{f}))
            gray_flags = bitset(gray_flags,f,false);
        end
    end
end
screened = bitand(screen, gray_flags);
if isfield(varin,'ylims')
    ylims = varin.ylims; varin = rmfield(varin,'ylims');
else
    ylims = [];
end
if isfield(varin,'figs')
    figs = varin.figs; varin = rmfield(varin,'figs');
else
    figs = [];
end
if isempty(figs)
    tau_fig = figure;zoom('on'); figs.tau_fig.h = tau_fig;cla
    leg_fig =figure;zoom('off'); figs.leg_fig.h = leg_fig;cla
    set(leg_fig,'name','flag legend','units','normalized');
    set(tau_fig,'name','colored flags','units','normalized');
    figs.tau_fig.pos = get(tau_fig,'position');
    figs.leg_fig.pos = get(leg_fig,'position');
    if nflags>1
        tau2_fig = figure;zoom('on'); figs.tau2_fig.h = tau2_fig;cla
        set(tau2_fig,'name','gray flags','units','normalized');
        figs.tau2_fig.pos = get(tau2_fig, 'position');
    end
else
    tau_fig = figs.tau_fig.h;   figure(tau_fig);zoom('on');cla
    leg_fig = figs.leg_fig.h; figure(leg_fig); zoom('on');cla
    set(figs.leg_fig.h,'name','flag legend','units','normalized','position',figs.leg_fig.pos);
    set(figs.tau_fig.h,'name','colored flags','units','normalized','position',figs.tau_fig.pos);
    if nflags>1
        tau2_fig = figs.tau2_fig.h; figure(tau2_fig);zoom('on');cla
        set(figs.tau2_fig.h,'name','gray flags','units','normalized','position',figs.tau2_fig.pos);
    end
end
subs = 0;
while isfield(varin,sprintf('panel_%d',subs+1))
    subs = subs +1;
    sub.(sprintf('panel_%d',subs)) = varin.(sprintf('panel_%d',subs));
    subfields = fieldnames(sub.(sprintf('panel_%d',subs)));
    for sb = length(subfields):-1:1
        if size(sub.(sprintf('panel_%d',subs)).(subfields{sb}),1)==1
            sub.(sprintf('panel_%d',subs)).(subfields{sb}) = sub.(sprintf('panel_%d',subs)).(subfields{sb})';
        end
    end
end
subpanes = [1,1,1];
if subs>0
    if isempty(figs)||~isfield(figs,'aux_fig')||isempty(figs.aux_fig.h)||isempty(figs.aux_fig.pos)
        aux_fig = figure;zoom('on');
        figs.aux_fig.h = aux_fig;
        set(figs.aux_fig.h,'name','auxiliary plots','unit','normalized');
    else
        aux_fig = figs.aux_fig.h; figure(aux_fig);
        set(figs.aux_fig.h,'name','auxiliary plots','unit','normalized','position',figs.aux_fig.pos);
    end
    if isfield(varin,'subplots')
        subpanes = [varin.subplots(1),varin.subplots(2),varin.subplots(1)*varin.subplots(2)];
    else
        subpanes = [subs,1,subs];
    end
    H = min([.1 + .25*subpanes(3),.95]);
    if exist('figs','var')&&isfield(figs,'aux_fig')&&isfield(figs.aux_fig,'pos')
        set(aux_fig,'position',figs.aux_fig.pos);
    else
        set(aux_fig,'position',[ 0.5885  (1-H)/2      0.3005    H]);
    end
    aux_N = 0;
    for sb = subpanes(3):-1:1
        if isfield(sub,(sprintf('panel_%d',sb)))
            aux_N = aux_N + length(fieldnames(sub.(sprintf('panel_%d',sb))));
        end
    end
    
    if aux_N==1
        aux_color(1,:)= [0,1,0];
        aux_color(2,:) =[1,0,0];
    else
        figure
        aux_color = get_colors([1:aux_N]);
        close(gcf)
    end
    tmp = aux_color;aux_color = [];
    for sb = 1:subpanes(3)
        aux_color = [aux_color;tmp(sb:3:end,:)];
    end
    figure(aux_fig);
    for sb = subpanes(3):-1:1
        ax(sb) = subplot(subpanes(1),subpanes(2),sb); cla;
        
        if isfield(sub,(sprintf('panel_%d',sb)))
            sub.(sprintf('leg_str%d',sb)) = [];
            flds = fieldnames(sub.(sprintf('panel_%d',sb)));
            hold('on');
            for fd = 1:length(flds)
                plot([t(screened==0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened==0);NaN]),syms(rem(fd,12)),'color',aux_color(fd,:));
                grid on
                sub.(sprintf('leg_str%d',sb)) = [sub.(sprintf('leg_str%d',sb)), {strrep(flds{fd},'_',' ')}];
            end
            lg = legend(sub.(sprintf('leg_str%d',sb))); set(lg,'interp','none');
            yl = ylim; % Capture these y-limits before plotting the values that failed screen
            for fd = 1:length(flds)
                plot([t(screened>0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened>0);NaN]),syms(rem(fd,12)),'color',grey);
                grid on
            end
            hold('off');
            xlabel(t_str);
            if isfield(ylims,sprintf('panel_%d',sb))
                yl = ylims.(sprintf('panel_%d',sb));
            end
            ylim(yl)
        end
        if time_choice ==1
            hax = handle(ax(sb));
            hProp = findprop (hax,'XTick');  % a schema.prop object
            hListener = handle.listener(hax, hProp, 'PropertyPostSet', @xticklabel_HHMMSS);
            setappdata(hax, 'XTickListener', hListener);
        end
    end
end
if ~exist('ax','var')
    ax = [];
end
% So the general idea is to plot the data in multiple subplots with x-axes
% locked, and zoom "on".  The user zooms in to whatever features they want
% with whatever axis they want and then selects one of the buttons to
% characterize all times within the x-limits.  If only one flag has been
% provided then the button acts to toggle the state of the points in view.
% If more than one flag was supplied, then after selecting the button to
% indicate the flag-type, another will let the user clear or mark all times
% in the window.
%%
figure(leg_fig)
hold('off');
plot([t(1)], [0*NaN], 'k.');
leg_ax = gca;
hold('on');
% for bit = 1:nflags
%     disp(['bit ',num2str(bit)])
%     test = logical(bitget(screen,bit));
%     plot([t(1)],[-1*bit*NaN],syms(rem(bit,12)),'color',color(bit,:));
% end
for bit = 1:nflags
%     bit_c=bit;
%     if bit>=12
%         bit = bit - 11 * round(bit/10);
%     end
    test = logical(bitget(screen,bit));
    plot([t(1)],[-1*bit*NaN],syms(rem(bit,12)+1),'color',color(bit,:));
end
set(gca,'xtick',[],'ytick',[]);
set(leg_fig,'unit','normalized');
if exist('figs','var')&&isfield(figs,'leg_fig')
    set(leg_fig,'position',figs.leg_fig.pos);
else
    set(leg_fig,'position',[0.1130    0.5917    0.1703    0.3528]);
end
pos = get(leg_ax,'position');pos(1) = 0;pos(3) = pos(3)./10;
set(leg_ax,'position',abs(pos));
lg = legend({'good',flag_names{:}},'location','EastOutside');
set(lg,'interp','none');

set(leg_fig,'name','flag legend','menu','none','handlevisibility','on','hittest','off','toolbar','none');
set(leg_ax,'visible','off');
% set(lg, 'Position', get(lg, 'OuterPosition') - ...
%     get(lg, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
hold('off')
%%
figure(tau_fig);
plot([t(~screen);t(end)], real([tau(~screen);NaN]), 'k.'); yl = ylim; hold('on');
ax(end+1) = gca;
for bit = 1:nflags
    test = logical(bitget(screen,bit));
    plot([t(test);t(end)],real([tau(test);NaN]),syms(rem(bit,12)+1),'color',color(bit,:));
end
if isfield(ylims,'tau_fig')
    ylim(ylims.tau_fig);
end
grid on %added by jml
ylabel('tau')
xlabel(t_str)

title(['Optical Depth: good(',num2str(sum(screen==0)),' screened(',num2str(sum(screen~=0)),'0']);
if exist('figs','var')&&isfield(figs,'tau_fig')
    set(tau_fig,'unit','normalized','position',figs.tau_fig.pos);
else
    set(tau_fig,'units','normalized','position',[ 0.2901    0.4250    0.2917    0.5019]);
end
if time_choice ==1
    hax = handle(ax(end));
    hProp = findprop(hax,'XTick');  % a schema.prop object
    hListener = handle.listener(hax, hProp, 'PropertyPostSet', @xticklabel_HHMMSS);
    setappdata(hax, 'XTickListener', hListener);
end

linkaxes(ax,'x');

ylim(ax(end),yl);
axes(ax(end));
nsubs = length(ax);

if nflags>1
figure(tau2_fig);
    plot([t(screened==0);t(end)], real([tau(screened==0);NaN]), 'g.','markersize',8); yl = ylim;
plot([t(screened>0);t(end)], real([tau(screened>0);NaN]), '.','color',grey,'markersize',8);
hold('on');
plot([t(screened==0);t(end)], real([tau(screened==0);NaN]), '.','color',[0,.75,0],'markersize',12);
    grid on %added by jml
legend('bad','good');
hold('off');
if isfield(ylims,'tau2_fig')
    yl=ylims.tau2_fig;
end
ylim(yl);
ax_2 = gca;
if time_choice ==1
    hax = handle(ax_2);
    hProp = findprop(hax,'XTick');  % a schema.prop object
    hListener = handle.listener(hax, hProp, 'PropertyPostSet', @xticklabel_HHMMSS);
    setappdata(hax, 'XTickListener', hListener);
end
% zoom('on');

title('Screened results only, no flags set');
xlabel(t_str);
if exist('figs','var')&&isfield(figs,'tau2_fig')
    set(tau2_fig,'unit','normalized','position',figs.tau2_fig.pos);
else
    
    set(tau2_fig,'units','normalized','position',[  0.2885    0.0593    0.2917    0.2750]);
end
end
% zoom('on');

while button <= nflags+1
    
    button =menu('Condition: ',{flag_names{:},'CLEAR','DONE'});
    back_ax = gca;
    v_ = axis(back_ax);
    flag_ax = find(ax==back_ax);
    
    if button <= nflags
        if isempty(flag_ax) || flag_ax > subpanes(3) || ~exist('sub','var')
            t_ = t>= v_(1) & t<= v_(2)& tau>v_(3)& tau<v_(4);
        else
            flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
            t_ = false(size(t));
            for fld = 1:length(flds)
                t_ = t_ | t>= v_(1) & t<= v_(2) & ...
                    sub.(sprintf('panel_%d',flag_ax)).(flds{fld})>v_(3) & ...
                    sub.(sprintf('panel_%d',flag_ax)).(flds{fld})<v_(4);
            end
        end
        screen(t_) = bitset(screen(t_), button, ~bitget(screen(t_),button));
        screened = bitand(screen, gray_flags);
    elseif button == nflags+1
        if isempty(flag_ax) || flag_ax > subpanes(3) || ~exist('sub','var')
            t_ = t>= v_(1) & t<= v_(2)& tau>v_(3)&tau<v_(4);
        else
            flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
            t_ = false(size(t));
            for fld = 1:length(flds)
                t_ = t_ | t>= v_(1) & t<= v_(2) & ...
                    sub.(sprintf('panel_%d',flag_ax)).(flds{fld})>v_(3) & ...
                    sub.(sprintf('panel_%d',flag_ax)).(flds{fld})<v_(4);
            end
        end
        screen(t_) = 0;
        screened = bitand(screen, gray_flags);
    end
    figure(tau_fig);
    axes(ax(end));yl = ylim;
    hold('off');
    plot([t(~screen);t(end)], real([tau(~screen);NaN]), 'k.');
    
    hold('on');
    for bit = 1:nflags
        test = logical(bitget(screen,bit));
        plot([t(test);t(end)],real([tau(test);NaN]),syms(rem(bit,12)+1),'color',color(bit,:));
        
    end
    if isfield(ylims,'tau_fig')
        yl=ylims.tau_fig;
    end
    ylim(yl);
    
    if nflags > 1 & exist('tau2_fig','var')
        figure(tau2_fig);
        axes(ax_2); vv = axis;
        plot([t(screened>0);t(end)], real([tau(screened>0);NaN]), '.','color',grey,'markersize',8);
        hold('on');
        plot([t(screened==0);t(end)], real([tau(screened==0);NaN]), '.','color',[0,.75,0],'markersize',12);
        grid on
        legend('bad','good');
        hold('off');
        axis(vv);
        if isfield(ylims,'tau2_fig')
            vv(3:4)=ylims.tau2_fig;
        end
        title('Screened results only, no flags set');
        xlabel(t_str);
        axis(vv);
        % zoom('on');
    end
    if exist('aux_fig','var')
        figure(aux_fig);
        for sb = subpanes(3):-1:1
            
            ax(sb) = subplot(subpanes(1),subpanes(2),sb);
            yl = ylim;
            if isfield(sub,(sprintf('panel_%d',sb)))
                sub.(sprintf('leg_str%d',sb)) = [];
                flds = fieldnames(sub.(sprintf('panel_%d',sb)));
                hold('on');
                for fd = 1:length(flds)
                    plot([t(screened==0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened==0);NaN]),syms(rem(fd,12)),'color',aux_color(fd,:));
                    grid on %added by jml
                    sub.(sprintf('leg_str%d',sb)) = [sub.(sprintf('leg_str%d',sb)), {strrep(flds{fd},'_',' ')}];
                end
                lg = legend(sub.(sprintf('leg_str%d',sb))); set(lg,'interp','none');
                % capture these y-limits before plotting the screened values
                yl = ylim;
                for fd = 1:length(flds)
                    plot([t(screened>0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened>0);NaN]),syms(rem(fd,12)),'color',grey);
                    grid on
                end
                if sb == subpanes(3)
                    xlabel(t_str);
                end
                if isfield(ylim,sprintf('panel_%d',sb))
                    yl = ylim.(sprintf('panel_%d',sb));
                end
                ylim(yl);
            end
        end
    end
    axes(back_ax);
    axis(v_);
end
%%
for f = 1:length(flag_names)
    flags.(char(flag_names(f))) = logical(bitget(screen,f));
end
%%
good = screened==0;
if exist('tau_fig','var')
    figs.tau_fig.h = tau_fig;
    figs.tau_fig.pos = get(tau_fig,'position');
end

if nflags>1 & exist('tau2_fig','var')
    figs.tau2_fig.h = tau2_fig;
    figs.tau2_fig.pos = get(tau2_fig,'position');
end

if exist('aux_fig','var')
    figs.aux_fig.h = aux_fig;
    figs.aux_fig.pos = get(aux_fig,'position');
end

if exist('leg_fig','var')
    figs.leg_fig.h = leg_fig;
    figs.leg_fig.pos = get(leg_fig,'position');
end
flags.time.t = time';
return