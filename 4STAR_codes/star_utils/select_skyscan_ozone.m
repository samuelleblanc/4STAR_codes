function  star = select_skyscan_ozone(star);

man = menu('Obtain Ozone from file or supply manually?','From file...','Manually...');

if man==2
   star.O3col = input('Enter Ozone column amount (DU):');
elseif man==1
   sunfile = (getfullname(['4STAR_',datestr(star.t(1),'yyyymmdd'),'starsun*.mat;',datestr(star.t(1),'yyyymmdd'),'_gas_summary.mat'],'starsun_gas','Select a starsun file with gasses or gas summary file'));
   if ~isempty(sunfile)
      sun = matfile(sunfile); props = properties(sun);
      if any(strcmp('tUTC',props)) %Then it is a gas summary file
         [~,fname] = fileparts(sunfile);
         suntime = datenum(fname(1:8),'yyyymmdd')+sun.tUTC./24;
         Alt = sun.alt;
         O3 = sun.o3DU;
      else
         suntime = sun.t;
         Alt = sun.Alt;
         if any(strcmp('gas',props))
            O3 = sun.gas.o3;
         elseif any(strcmp('O3col',props))
            O3 = sun.O3col.*ones(size(Alt));
         end
      end
      
      fig2 = figure_(2);
      figure_(2);
      plot(suntime, Alt, 'o-', mean(suntime), mean(Alt),'rx'); legend('Alt', 'location','EastOutside');
      ylabel('Altitude')
      ax2(1) = gca;        dynamicDateTicks(ax2);
      zoom('on')
      if exist('O3','var')
         figure_(3);
         plot(suntime, O3, 'o'); yl2 = ylim;
         plot(suntime, O3, 'o',[mean(star.t), mean(star.t)], yl2,'r--');
         ylim(yl2);  legend('O3 [DU]','Location','EastOutside');
         %                 dynamicDateTicks;
      end
      ax3(1) = gca;
      zoom('on')
      linkaxes([ax2 ax3],'x');
      dynamicDateTicks(ax3,'linked');
      K = menu('Zoom and select action','Good','Questionable','BAD','SKIP');
      if K <4
         xl = xlim;
         good_gas = suntime>=xl(1) & suntime<=xl(2) & O3>100 & O3<1000;
         star.O3col = mean(O3(good_gas));
      end
   else
      disp('No gas / Ozone in this file')
   end
end % if manual

return