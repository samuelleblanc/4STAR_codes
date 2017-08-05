function [flags,screened,good,figs] = visi_screen_v15(time, tau, varargin)
% [flags,screened,good,figs] = visi_screen(time, tau, varargin)
% 'time' should be in Matlab serial date
% 'tau' is a placeholder for whatever you'd like to see the screen applied to
% Many optional arguments:
% 'field_name' provides an optional label in place of 'tau'
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
% SL, v1.1, 2015/05/04, added special function button for rerunning some automated screening
% CJ, v1.2, 2017/08/04, streamlined logic associated with auto and manual
%                       flagging with support for disaster recovery using a
%                       temporary file ~starflag.mat.

%Things to modify/add:
% Button for flagging mode: ON, CLEAR, Toggle
% Button for selection region: inside, outside, before (within), after, after (within), above, above (during), below, below (during),
%
% Button for RESET (to initial flags)
% Button for UNDO
% Button for REDO
% Button to read in flags from other file


version_set('1.2');
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
CircleSize = 4;

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
        %         t = serial2hs(time);
        t = time;
        t_str = '';
        %         dynamicDateTicks;
        %         t_str = 'time [HH:MM:SS]';
    case 2
        t = serial2hs(time);
        t_str = 'time [HH.hh]';
    otherwise
        t = serial2doys(time);
        t_str = 'time (day of year)';
end

if isfield(varin,'field_name')
    field_name = varin.field_name; varin = rmfield(varin,'field_name');
else
    field_name = 'Optical Depth';
end

if isfield(varin,'flags_matio')
    flags_matio = varin.flags_matio; varin = rmfield(varin,'flags_matio');
end
% if exist('temporary_flags_matio.mat','file')
%     get_mat = menu('Recover flags saved in "temporary_flags_matio.mat"?','Yes','No');
%     if get_mat~=1
%         delete('temporary_flags_matio.mat');
%     end
%     flags_matio = matfile('temporary_flags_matio.mat','writable',true);
% end

if isfield(varin,'flags')
    flags = varin.flags; varin = rmfield(varin,'flags');
else
    flags.bad = false(size(t));
    flags.suspect = false(size(t));
    flags.noted = false(size(t));
    flags.event = false(size(t));
end
% trying to get rid of non-boolean or non-empty flag fields
if isstruct(flags)
    flag_names = fieldnames(flags);
    for f = length(flag_names):-1:1
        if isstruct(flags.(char(flag_names(f))))
%             flags = rmfield(flags,char(flag_names(f)));
            flag_names(f) = [];
        elseif ischar(flags.(char(flag_names(f))))
%             flags = rmfield(flags,char(flag_names(f)));
            flag_names(f) = [];
        elseif length(flags.(char(flag_names(f)))) == length(t) && ~islogical(flags.(char(flag_names(f))))
%             flags = rmfield(flags,char(flag_names(f)));
            flag_names(f) = [];
        else
            if length(flags.(char(flag_names(f))))~=length(t)
                flags.(char(flag_names(f))) = false(size(t));
            end
            if size(flags.(char(flag_names(f))),1)==1
                flags.(char(flag_names(f))) = flags.(char(flag_names(f)))';
            end
            if strcmp(char(flag_names(f)),'aerosol_init_auto') %MK modified 20140402 this flag is redundant with others; we don't need it.
%                 flags = rmfield(flags,char(flag_names(f)));
                flag_names(f) = [];
            end
            
        end
    end
end
% nflags = length(fieldnames(flags));
nflags = length(flag_names);
% zoom('on');
extra_buttons = {'FLAGGING MODE','SELECTION MODE','semilog ON/OFF','IMPORT FLAGS','UNDO','REDO','CLEAR','RESET','DONE','ABORT'};
if isfield(varin,'special_fn_name')
    extra_buttons = {varin.special_fn_name,extra_buttons{:}};
    varin = rmfield(varin,'special_fn_name');
    spc_fn = true;
    n_spc_fn = 1; % set to ony one special button for now
    % 'special_fn_name','Change sd_aero_crit','special_fn_flag_name','unspecified_clouds','special_fn_flag_str',flags_str.unspecified_clouds,'special_fn_flag_var','sd_aero_crit'
    
    % import the variables from the caller written into the special fn
    spfn_var_list = strsplit(varin.special_fn_flag_str,{' ','>','|','<','&','(',')'});
    for n_sp=1:length(spfn_var_list)
        try;
            eval([spfn_var_list{n_sp} '=' 'evalin(''caller'',' '''' spfn_var_list{n_sp} '''' ');']);
        catch me;
            %disp(me)
            %disp(['problem with variable or item:' spfn_var_list{n_sp}])
            continue;
        end;
    end
else
    spc_fn = false;
    n_spc_fn = 0;
end

screen = zeros(size(t),'uint32');
for bit = 1:nflags
    screen = bitset(screen, bit, flags.(char(flag_names(bit)))>0);
end

% Save the initial flag state to permit "RESET" and "ABORT"

INITIAL_SCREEN = screen;
INITIAL_FLAGS = flags;
% FLAG_MODES = {'SET','UNSET','TOGGLE'};
FLAG_MODE = 1;
% SELECTION_MODES = {'INSIDE','OUTSIDE','ABOVE','BELOW','BEFORE','AFTER'};
SELECTION_MODE = 1;
FLAG_TYPES = {'BAD','SUSPECT','NOTED','EVENT'};
FI = 1; % flag index to be used for undo, redo
N_FI = 1; % length index to keep track of how many changes have been selected
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

% Don't be confused.  The field flag_gray actually contains fields which
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
manual_flags.nomask_list = flag_gray;
gray_flags = uint32(zeros(size(t)));
gray_flags = bitcmp(gray_flags); % Take complement,

if isstruct(flags)&exist('flag_gray','var')
%     flag_names = fieldnames(flags);
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
                h.(flds{fd}) = plot([t(screened==0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened==0);NaN]),syms(rem(fd,12)),'color',aux_color(fd,:));
                sub.(sprintf('leg_str%d',sb)) = [sub.(sprintf('leg_str%d',sb)), {strrep(flds{fd},'_',' ')}];
            end
            lg = legend(sub.(sprintf('leg_str%d',sb))); set(lg,'interp','none');
            yl = ylim; % Capture these y-limits before plotting the values that failed screen
            for fd = 1:length(flds)
                plot([t(screened>0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened>0);NaN]),syms(rem(fd,12)),'color',grey);
                uistack(h.(flds{fd}),'top')
            end
            grid('on')
            hold('off');
            xlabel(t_str);
            if isfield(ylims,sprintf('panel_%d',sb))
                yl = ylims.(sprintf('panel_%d',sb));
            end
            ylim(yl)
        end
        if time_choice ==1
            hax = handle(ax(sb)); dynamicDateTicks(hax);
        end
    end
    title(['Auxiliary plots for ',datestr(time(1),'yyyy-mm-dd')]);
    
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
for bit = 1:nflags
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
h.col = plot([t(~screen);t(end)], real([tau(~screen);NaN]),'ko','MarkerFaceColor','k','MarkerSize',CircleSize); yl = ylim; hold('on');
ax(end+1) = gca; lg=legend(field_name); set(lg,'interp','none');
for bit = 1:nflags
    test = logical(bitget(screen,bit));
    plot([t(test);t(end)],real([tau(test);NaN]),syms(rem(bit,12)+1),'color',color(bit,:));
end
uistack(h.col,'top')
if isfield(ylims,'tau_fig')
    ylim(ylims.tau_fig);
end
grid('on') %added by jml
ylabel('tau')
xlabel(t_str)

tl = title(['Detailed flags for ',field_name,' for ',datestr(time(1),'yyyy-mm-dd')]);
set(tl,'interp','none')
if exist('figs','var')&&isfield(figs,'tau_fig')
    set(tau_fig,'unit','normalized','position',figs.tau_fig.pos);
else
    set(tau_fig,'units','normalized','position',[ 0.2901    0.4250    0.2917    0.5019]);
end
if time_choice ==1
    hax = handle(ax(end));
    dynamicDateTicks(hax);
end
linkaxes(ax,'x');

ylim(ax(end),yl);
axes(ax(end));
nsubs = length(ax);

if nflags>1
    figure(tau2_fig);
    hold('off')
    plot([t(screened==0);t(end)], real([tau(screened==0);NaN]), 'o',...
        'color',[0,.75,0],'markersize',CircleSize, 'MarkerFaceColor',[0,.8,0]);
    yl = ylim;
    hold('on');
    bbb=plot([t(screened>0);t(end)], real([tau(screened>0);NaN]), 'o','color',grey,'MarkerFaceColor',grey,'markersize',CircleSize-1);
 %     hold('on');
%     plot([t(screened==0);t(end)], real([tau(screened==0);NaN]), '.','color',[0,.75,0]);
    grid('on') %added by jml
    legend('good','bad');
    uistack(bbb,'bottom');
    hold('off');
    if isfield(ylims,'tau2_fig')
        yl=ylims.tau2_fig;
    end
    ylim(yl);
    ax_2 = gca;
    if time_choice ==1
        hax = handle(ax_2);
        dynamicDateTicks(hax);
    end
    zoom('on');
    title({['Quality plot for ',field_name, ' on ',datestr(time(1),'yyyy-mm-dd')]; ...
        ['Good(',num2str(sum(screen==0)),') BAD(',num2str(sum(screen~=0)),',  "BAD"==(screen=0)']});
    xlabel(t_str);
    if exist('figs','var')&&isfield(figs,'tau2_fig')
        set(tau2_fig,'unit','normalized','position',figs.tau2_fig.pos);
    else
        
        set(tau2_fig,'units','normalized','position',[  0.2885    0.0593    0.2917    0.2750]);
    end
end
% {'FLAGGING MODE','SELECTION MODE','Log-y ON/OFF','IMPORT FLAGS','UNDO','REDO','CLEAR','RESET','DONE','ABORT'};
done = false; abort = false;
% while button <= nflags+1+n_spc_fn
while ~done
    menu_len = length({flag_names{:},'',extra_buttons{:}});
    extra_buttons{1} = ['FLAGGING MODE <',num2str(FLAG_MODE),'>'];
    extra_buttons{2} = ['SELECTION MODE <',num2str(SELECTION_MODE),'>'];
    buttons = {flag_names{:},'',extra_buttons{:}};
    button =menu('Condition: ',{flag_names{:},'',extra_buttons{:}});
    back_ax = gca;
    v_ = axis(back_ax);
    flag_ax = find(ax==back_ax);
    %% Identify region/points to flag
    if ~exist('sub','var');
        t_ = flag_these_points(t, tau, flag_ax, v_, subpanes, [],SELECTION_MODE);
    else
        t_ = flag_these_points(t, tau, flag_ax, v_, subpanes, sub,SELECTION_MODE);
    end
    if button == menu_len-9 % 'Set FLAGGING MODE'
        %         FLAG_MODES = {'SET','UNSET','TOGGLE'};
        FLAG_MODE = menu('Set FLAGGING MODE','Set TRUE','Set FALSE','Toggle state');
    elseif button == menu_len-8 % Set SELECTION MODE
        %         SELECTION_MODES = {'INSIDE','OUTSIDE','ABOVE','BELOW','BEFORE','AFTER'};
        SELECTION_MODE = menu({'Set SELECTION MODE for flagging:';'Set flags for points in what region? '},...
            'INSIDE axes limits','OUTSIDE axes limits','ABOVE max y-limit','BELOW min y-limit','BEFORE min x-limit','AFTER max x-limit');
    elseif button==menu_len-7 % toggle semilogy
        if strcmp(get((back_ax),'yscale'),'linear')
            logy(back_ax);
        else
            liny(back_ax);
        end
    elseif button==menu_len-6 % import flags
        screen(:,FI+1) = screen(:,FI);
        N_FI = size(screen,2); FI = FI + 1;
        in_flags = load(getfullname([datestr(time(1),'yyyymmdd'),'*_starflag_*.mat']));
        % figure out how to import flags...
        screen(t_,:) = imported_screen(t_);
    elseif button== menu_len-5 % UNDO
        if FI==1
            menu('No UNDOs left');
        else
            FI = max(1,FI-1);
        end
    elseif button== menu_len-4 % REDO
        if FI==N_FI
            menu('No REDOs left');
        else
            FI = min(N_FI,FI+1);
        end
    end
    if button== menu_len-3 % CLEAR
        screen(:,FI+1) = screen(:,FI);
        N_FI = size(screen,2); FI = FI + 1;
        screen(t_,FI) = false;
        
        % Figure out how to clear the selected region
    elseif button== menu_len-2 % RESET
        % Figure out how to RESET the selected region back to
        % initial values
        screen(:,FI+1) = screen(:,FI);
        N_FI = size(screen,2); FI = FI + 1;
        screen(t_,FI) = INITIAL_SCREEN(t_);
    elseif button== menu_len-1 % DONE
        % Be done.
        done = true;
    elseif button== menu_len % ABORT
        really = menu('Really abort?  Abandon all changes and exit screening utility? <NO>','Yes, really', 'Um... No.'); % Be done.
        if really==1
            done = true;
            abort = true;
            screen = INITIAL_SCREEN;
            flags = INITIAL_FLAGS;
            N_FI = size(screen,2); FI = 1;
        end
    elseif spc_fn && button == nflags+n_spc_fn
        
        %% do the special button part
        % 'special_fn_name','Change sd_aero_crit','special_fn_flag_name','unspecified_clouds','special_fn_flag_str',flags_str.unspecified_clouds,'special_fn_flag_var','sd_aero_crit'
        val = inputdlg(['Enter new value of ' varin.special_fn_flag_var],'Change auto screening values',[1 50]);
        eval([varin.special_fn_flag_var '=' val{:} ';']);
        all_or_flt=menu('Reset auto flag','For all points','For selection only');
        if all_or_flt==1
            t_ = eval(varin.special_fn_flag_str);
        elseif all_or_flt==2
            new_auto = eval([varin.special_fn_flag_str ';']);
            if isempty(flag_ax) || flag_ax > subpanes(3) || ~exist('sub','var')
                t_0 = t>= v_(1) & t<= v_(2)& tau>v_(3)& tau<v_(4);
            else
                flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
                t_0 = false(size(t));
                for fld = 1:length(flds)
                    t_0 = t_0 | t>= v_(1) & t<= v_(2) & ...
                        sub.(sprintf('panel_%d',flag_ax)).(flds{fld})>v_(3) & ...
                        sub.(sprintf('panel_%d',flag_ax)).(flds{fld})<v_(4);
                end
            end
            t_ = new_auto & t_0;
        end
        ib = strfind(flag_names,varin.special_fn_flag_name);
        i_b = find(not(cellfun('isempty',ib)));
        screen(t_,FI+1) = bitset(screen(t_,FI), i_b, ~bitget(screen(t_,FI),i_b));
        screen(t_,FI+1) = bitset(screen(t_,FI), button, ~bitget(screen(t_,FI),button));
        N_FI = size(screen,2); FI = FI + 1;
        
    elseif button <= nflags
        screen(:,FI+1) =screen(:,FI);
        if FLAG_MODE == 3
            screen(t_,FI+1) = bitset(screen(t_,FI), button, ~bitget(screen(t_,FI),button));
        else
            screen(t_,FI+1) = bitset(screen(t_,FI), button, FLAG_MODE==1);
        end
        N_FI = size(screen,2); FI = FI + 1;
    end
    % The field "gray_flags" is just a bit-map of "1" for all fields that  denote "bad" and will thus gray-out the data value
    screened = bitand(screen(:,FI), gray_flags);
    
    figure(tau_fig);
    axes(ax(end));yl = ylim;
    hold('off');
    h.col = plot([t(~screen(:,FI));t(end)], real([tau(~screen(:,FI));NaN]),'ko','MarkerFaceColor','k','MarkerSize',CircleSize);
    lg=legend(field_name); set(lg,'interp','none');
    tl = title(['Detailed flags for ',field_name,' for ',datestr(time(1),'yyyy-mm-dd')]);
    set(tl,'interp','none')
    hold('on');
    for bit = 1:nflags
        test = logical(bitget(screen(:,FI),bit));
        plot([t(test);t(end)],real([tau(test);NaN]),syms(rem(bit,12)+1),'color',color(bit,:));
    end
    uistack(h.col,'top');
    if isfield(ylims,'tau_fig')
        yl=ylims.tau_fig;
    end
    ylim(yl);
    if time_choice == 1
        dynamicDateTicks(ax(end));
    end
    
    if nflags > 1 & exist('tau2_fig','var')
        figure(tau2_fig);hold('off')
        axes(ax_2); vv = axis;
        tau2_good = plot([t(screened==0);t(end)], real([tau(screened==0);NaN]), ...
            'o','color',[0,.75,0],'MarkerFaceColor',[0,.75,0],'markersize',CircleSize);
        hold('on');
        plot([t(screened>0);t(end)], real([tau(screened>0);NaN]), 'o',...
            'color',grey,'MarkerFaceColor',grey,'markersize',CircleSize-1);
        grid('on');        
        legend('good','bad');
        uistack(tau2_good,'top');                
        axis(vv);
        if isfield(ylims,'tau2_fig')
            vv(3:4)=ylims.tau2_fig;
        end
        title({['Quality plot for ',field_name, ' on ',datestr(time(1),'yyyy-mm-dd')]; ...
            ['Good(',num2str(sum(~screened)),') BAD(',num2str(sum(screened)),'),  "BAD" when screened==true']});
        xlabel(t_str);
        if time_choice ==1
            dynamicDateTicks(gca);
        end
        axis(vv);
        % zoom('on');
    end
    if exist('aux_fig','var')
        figure(aux_fig);
        for sb = subpanes(3):-1:1
            ax(sb) = subplot(subpanes(1),subpanes(2),sb);
            semi_type = get(ax(sb),'yscale');
            yl = ylim;
            if isfield(sub,(sprintf('panel_%d',sb)))
                sub.(sprintf('leg_str%d',sb)) = [];
                flds = fieldnames(sub.(sprintf('panel_%d',sb)));
                hold('off');
                plot([t(screened==0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{1})(screened==0);NaN]),syms(rem(1,12)),'color',aux_color(1,:));
                sub.(sprintf('leg_str%d',sb)) = [sub.(sprintf('leg_str%d',sb)), {strrep(flds{1},'_',' ')}];
                hold('on')
                for fd = 2:length(flds)
                    plot([t(screened==0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened==0);NaN]),syms(rem(fd,12)),'color',aux_color(fd,:));
                    sub.(sprintf('leg_str%d',sb)) = [sub.(sprintf('leg_str%d',sb)), {strrep(flds{fd},'_',' ')}];
                end
                lg = legend(sub.(sprintf('leg_str%d',sb))); set(lg,'interp','none');
                % capture these y-limits before plotting the screened values
                yl = ylim;
                for fd = 1:length(flds)
                    bbb =  plot([t(screened>0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened>0);NaN]),syms(rem(fd,12)),'color',grey);
                    uistack(bbb,'bottom');
                    %                     plot([t(screened==0);t(end)],real([sub.(sprintf('panel_%d',sb)).(flds{fd})(screened==0);NaN]),syms(rem(fd,12)),'color',aux_color(fd,:))
                end
                if sb == subpanes(3)
                    xlabel(t_str);
                end
                if isfield(ylim,sprintf('panel_%d',sb))
                    yl = ylim.(sprintf('panel_%d',sb));
                end
                ylim(yl);
            end
            if time_choice==1
                dynamicDateTicks(gca);
            end
            set(ax(sb),'yscale',semi_type);
        end
        title(['Auxiliary plots for ',datestr(time(1),'yyyy-mm-dd')]);
    end
    axes(back_ax);
    axis(v_);
    flags_matio.screen = screen(:,FI);
    flags_matio.screened = screened;
    for f = 1:length(flag_names)
       flags_matio.(flag_names{f}) = logical(bitget(screen(:,FI),f));
    end
end
%%
for f = 1:length(flag_names)
    flags.(flag_names{f}) = logical(bitget(screen(:,FI),f));;
end
% flags.time.t = time';


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
return

function t_ = flag_these_points(t, tau, flag_ax, v_,subpanes, sub,SELECTION_MODE);
% SELECTION_MODES = {'INSIDE','OUTSIDE','ABOVE','BELOW','BEFORE','AFTER'}
%  'INSIDE axes limits','OUTSIDE axes limits','ABOVE max y-limit','BELOW min y-limit','BEFORE min x-limit','AFTER max x-limit');
if ~exist('SELECTION_MODE','var')||isempty(SELECTION_MODE)||SELECTION_MODE<=1||SELECTION_MODE>6
    
    if isempty(flag_ax) || flag_ax > subpanes(3) || isempty(sub)
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
elseif SELECTION_MODE==2 % outside
    if isempty(flag_ax) || flag_ax > subpanes(3) || isempty(sub)
        t_ = t< v_(1) | t> v_(2)| tau<v_(3)| tau>v_(4);
    else
        flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
        t_ = (t< v_(1) | t> v_(2));
        for fld = 1:length(flds)
            t_ = t_ & ~(sub.(sprintf('panel_%d',flag_ax)).(flds{fld})>v_(3) & ...
                sub.(sprintf('panel_%d',flag_ax)).(flds{fld})<v_(4));
        end
    end
elseif SELECTION_MODE==3 % above
    if isempty(flag_ax) || flag_ax > subpanes(3) || isempty(sub)
        t_ = t>= v_(1) & t<= v_(2)& tau>v_(4);
    else
        flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
        t_ = t>= v_(1) & t<= v_(2); t__ = false(size(t_));
        for fld = 1:length(flds)
            t__ = t__ |  sub.(sprintf('panel_%d',flag_ax)).(flds{fld})>v_(4);
        end
        t_ = t_&t__;
    end
elseif SELECTION_MODE==4 % below
    if isempty(flag_ax) || flag_ax > subpanes(3) || isempty(sub)
        t_ = t>= v_(1) & t<= v_(2)& tau<v_(3);
    else
        flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
        t_ = t>= v_(1) & t<= v_(2);t__ = false(size(t_));
        for fld = 1:length(flds)
            t__ = t__ |  sub.(sprintf('panel_%d',flag_ax)).(flds{fld})<v_(3);
        end
        t_ = t_&t__;
    end
    
elseif SELECTION_MODE==5 % before
    if isempty(flag_ax) || flag_ax > subpanes(3) || isempty(sub)
        t_ = t< v_(1) & tau>v_(3)& tau<v_(4);
    else
        flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
        t_ = t< v_(1);
        for fld = 1:length(flds)
            t_ = t_ &  sub.(sprintf('panel_%d',flag_ax)).(flds{fld})>v_(3) & ...
                sub.(sprintf('panel_%d',flag_ax)).(flds{fld})<v_(4) ;
        end
    end
    
elseif SELECTION_MODE==6 % after
    if isempty(flag_ax) || flag_ax > subpanes(3) || isempty(sub)
        t_ = t> v_(2) & tau>v_(3)& tau<v_(4);
    else
        flds = fieldnames(sub.(sprintf('panel_%d',flag_ax)));
        t_ = t> v_(2);
        for fld = 1:length(flds)
            t_ = t_ &  sub.(sprintf('panel_%d',flag_ax)).(flds{fld})>v_(3) & ...
                sub.(sprintf('panel_%d',flag_ax)).(flds{fld})<v_(4) ;
        end
    end
end

return