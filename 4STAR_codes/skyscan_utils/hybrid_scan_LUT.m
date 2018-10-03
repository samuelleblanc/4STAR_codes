function hybrid_scan_LUT
% hybrid_scan_LUT
% Produce a look-up table for every 1-degree of SZA with (dAz, dEl) pairs
% Saves results as ASCII files *.asc  in named path 'hyscan_LUTs'
% Files are named as: "hyscan_SZA_N_LUT.asc wehre N is the supplied SZA
% LUTs contain six columns: SA , El, dEl, dAz, ddEl, ddAz 
% dEl and dAz are moves relative to solar position. 
% dEl and dAz are incremental moves from current 4STAR position. 
% The supplied scan is for the CCW leg  For CW, multiply dAz and ddAz by -1 

% Connor, v1.0, 2018/09/25
version_set('1.0');

SA_set = [-10, -7, -5, -3.5, 3, 3.5, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 25, 30, 35, ...
   40, 45, 50, 60, 70, 80, 90, 100, 120, 140, 160, 180];
SEL_ = [0.1 0.5:0.5:89.5, 89.9];
SZA_ = 90-SEL_;  

for za_i = 1:length(SZA_)
   mark.EL = SEL_(za_i); mark.ZA = 90-mark.EL;
   mark.AZ = 20; mark.SA = 0;
   SA_i = 0;   
   scan= hyscan(SEL_(za_i), SA_set);
%    scan.CW = hyscan(SEL_(za_i),-SA_set);
   figure_(86);
   plot3(scan.x, scan.y, scan.z,'k-',...
      scan.x, -scan.y, scan.z,'r-');hold('on')
   title(['Hybrid scan for SZA=',num2str(SZA_(za_i))]);
   xlabel('x'); ylabel('y'); zlabel('z')
   xl = xlim; yl = ylim; zl = zlim;
   ll(1) = min([xl,yl,zl]); ll(2) = max([xl,yl,zl]);
   axis('square');
   xlim(ll); ylim(ll); zlim(ll);
%    pause(.01)
   write_hyscan(scan);      
end
return

function write_hyscan(scan)
hyscan_out = getnamedpath('hyscan_LUTs');
LUT_name = ['hyscan_SZA_',strrep(num2str(scan.SZA),'.','p'),'_LUT.asc'];
title = ['% ',LUT_name];
comment_1 = ['% dEl and dAz are moves relative to solar position.'];
comment_2 = ['% dEl and dAz are incremental moves from current 4STAR position.'];
comment_3 = ['% This is for CCW leg.  For CW, multiply dAz and ddAz by -1'];
header = ['SA , El, dEl, dAz, ddEl, ddAz'];
txt = [scan.SA; scan.El; scan.dEl; scan.dAz; scan.ddEl; scan.ddAz];
fid = fopen([hyscan_out, LUT_name],'w');
fprintf(fid, '%s \n',title);
fprintf(fid, '%s \n',comment_1);
fprintf(fid, '%s \n',comment_2);
fprintf(fid, '%s \n',comment_3);
fprintf(fid, '%s \n',header);
fprintf(fid, '%2.1f, %2.1f, %2.1f, %2.1f, %2.1f, %2.1f \n', txt);
fclose(fid);

return


function plots
figure;
plot3(target.CCW.x(1,:), target.CCW.y(1,:), target.CCW.z(1,:),'ok-');
hold('on');
scatter3(target.CCW.x(1,:), target.CCW.y(1,:), target.CCW.z(1,:),...
32,target.CCW.SA(1,:));
xlabel('x'); ylabel('y'); zlabel('z')
xl = xlim; yl = ylim; zl = zlim;
ll(1) = min([xl,yl,zl]); ll(2) = max([xl,yl,zl]);
axis('square');
xlim(ll); ylim(ll); zlim(ll);


figure_(86);
plot3(target.CCW.x(aa,:), target.CCW.y(aa,:), target.CCW.z(aa,:),'ok-',...
   target.CW.x(aa,:), target.CW.y(aa,:), target.CW.z(aa,:),'or-');
hold('on');
xlabel('x'); ylabel('y'); zlabel('z')
xl = xlim; yl = ylim; zl = zlim;
ll(1) = min([xl,yl,zl]); ll(2) = max([xl,yl,zl]);
axis('square');
xlim(ll); ylim(ll); zlim(ll);

return