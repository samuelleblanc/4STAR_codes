function ch=colorbarlabeled(ystring)

% put a vertical colorbar;

ch=colorbar;
yl=get(ch,'ylabel');
set(ch,'linewidth',1,'fontsize',12);
set(yl,'linewidth',1,'fontsize',12);
if nargin>=1;
    set(yl,'string',ystring);
end;