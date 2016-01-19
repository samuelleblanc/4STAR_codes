function get_good_looking_axes

ax0=gca;
ax=findobj(gcf,'type','axes');
for i=1:length(ax);
    axes(ax(i));
    axis0=axis;
    pos=get(gca, 'position');
    if pos==[0.1300    0.1100    0.7750    0.8150]
        set(gca, 'position', [0.1500    0.1500    0.7550    0.7750]);
    end;
    set(gca, 'fontsize', 16, 'linewidth', 1); % cjf: 2016-01-12
%     set(gca, 'fontsize', 16, 'linewidth', 1, 'color', 'none');
    ti=get(gca,'title');
    xl=get(gca,'xlabel');
    yl=get(gca,'ylabel');
    zl=get(gca,'zlabel');
    set([ti xl yl zl], 'fontsize',16);
    axis(axis0);
end;
axes(ax0);

% aa=findobj(gcf,'type','axes');
% for i=1:length(aa);
%     pos=get(aa(i), 'position');
%     newpos=pos;
%     if pos(1)==0.13;
%         newpos(1)=0.15;
%         newpos(3)=pos(3)-0.02;
%     end;
%     if pos(2)==0.11;
%         newpos(2)=0.15;
%         newpos(4)=pos(4)-0.04;
%     end;
%     if newpos~=pos;
%         set(aa(i), 'position', newpos);
%     end;
%     set(aa(i), 'fontsize', 16, 'linewidth', 1);
% end;