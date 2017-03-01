function ch=colorbarlabeled(ystring)

% put a vertical colorbar;

ch=colorbar;
yl=get(ch,'ylabel');
set(ch,'linewidth',1,'fontsize',16);
set(yl,'linewidth',1,'fontsize',16);
if nargin>=1;
    set(yl,'string',ystring);
end;