function [z,a,it,ord,s,fct] = backcorgui(n,y)

% BACKCORGUI   Graphical User Interface for background estimation.

% Initialization
z = [];
a = [];
it = [];
ord = [];
s = [];
fct = [];

order = 4;
threshold = 0.01;
costfunction = 'atq';

% Main window
hwin = figure('Visible','off','Position',[0 0 750 400],'NumberTitle','off','Name','Background Correction',...
    'MenuBar','none','Toolbar','figure','Resize','on','ResizeFcn',{@WinResizeFcn});
bgclr = get(hwin,'Color');

% Axes
haxes = axes('Units','pixels');

% Buttons OK & Cancel
hok = uicontrol('Style','pushbutton','String','OK','Position',[600,40,80,25],'Callback',{@OKFcn},'BackgroundColor',bgclr); 
hcancel = uicontrol('Style','pushbutton','String','Cancel','Position',[510,40,80,25],'Callback',{@CancelFcn},'BackgroundColor',bgclr); 

% Cost functions menu
hfctlbl = uicontrol('Style','text','String','Cost function:','HorizontalAlignment','left','BackgroundColor',bgclr);
hfct = uicontrol('Style','popupmenu','Value',4,'BackgroundColor','white','Callback',{@CostFunctionFcn},...
    'String',{'Symmetric Huber function','Asymmetric Huber function','Symmetric truncated quadratic','Asymmetric truncated quadratic'});

% Threshold text
hthresholdlbl = uicontrol('Style','text','String','Threshold:','HorizontalAlignment','left','BackgroundColor',bgclr);
hthreshold = uicontrol('Style','edit','String',num2str(threshold),'BackgroundColor','white','Callback',{@ThresholdFcn});

% Order slider
horderlbl = uicontrol('Style','text','String','Polynomial order:','HorizontalAlignment','left','BackgroundColor',bgclr);
horder = uicontrol('Style','slider','SliderStep',[0.5 0.5],'Min',0,'Max',10,'Value',order,'SliderStep',[0.1 0.1],'Callback',{@OrderFcn});
horderval = uicontrol('Style','text','String',num2str(order),'BackgroundColor',bgclr);

% Move the GUI to the center of the screen
movegui(hwin,'center');

% Plot a first estimation
[ztmp,atmp,ittmp,order,threshold,costfunction] = compute(n,y,order,threshold,costfunction);

% Make the GUI visible
set(hwin,'Visible','on');

% Callback functions

    function CancelFcn(source,eventdata)
        % Just close the window
        uiresume(gcbf);
        close(hwin);
    end
  
    function OKFcn(source,eventdata)
        % Return the current estimation and close the window
        z = ztmp;
        a = atmp;
        it = ittmp;
        ord = order;
        s = threshold;
        fct = costfunction;
        uiresume(gcbf);
        close(hwin);
    end

    function CostFunctionFcn(source,eventdata)
        % Change cost function
        cf = get(hfct,'Value');
        if cf == 1,
            costfunction = 'sh';
        elseif cf == 2,
            costfunction = 'ah';
        elseif cf == 3,
            costfunction = 'stq';
        elseif cf == 4,
            costfunction = 'atq';
        end
        [ztmp,atmp,ittmp,ord,s,fct] = compute(n,y,order,threshold,costfunction);
    end

    function OrderFcn(source,eventdata)
        % Change order
        order = get(horder,'Value');
        set(horderval,'String',num2str(order));
        [ztmp,atmp,ittmp,ord,s,fct] = compute(n,y,order,threshold,costfunction);
    end

    function ThresholdFcn(source,eventdata)
        % Change threshold
        threshold = get(hthreshold,'String');
        threshold = str2double(threshold);
        [ztmp,atmp,ittmp,ord,s,fct] = compute(n,y,order,threshold,costfunction);
    end
  
    function [ztmp,atmp,ittmp,order,threshold,costfunction] = compute(n,y,order,threshold,costfunction)
        % Compute and plot an estimation
        [ztmp,atmp,ittmp,order,threshold,costfunction] = backcor(n,y,order,threshold,costfunction);
        plot(n,y,'b-',n,ztmp,'r-');
    end

    function WinResizeFcn(source,eventdata)
        % Resize the window
        pos = get(hwin,'Position');
        w = pos(3);
        h = pos(4);
        if w>400 && h>100,
            set(haxes,'Position',[40,40,w-320,h-70]);
        end;
        set(hok,'Position',[w-90,30,80,25]);
        set(hcancel,'Position',[w-180,30,80,25]);
        set(hfctlbl,'Position',[w-240,h-30,220,20]);
        set(hfct,'Position',[w-240,h-50,220,25]);
        set(hthresholdlbl,'Position',[w-240,h-80,220,20]);
        set(hthreshold,'Position',[w-240,h-100,220,20]);
        set(horderlbl,'Position',[w-240,h-130,220,20]);
        set(horder,'Position',[w-210,h-150,190,20]);
        set(horderval,'Position',[w-240,h-150,20,20]);
    end

uiwait(gcf);

end