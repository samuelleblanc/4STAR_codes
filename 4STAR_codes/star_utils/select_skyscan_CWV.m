function  star = select_skyscan_CWV(star);

man = menu('Obtain CWV from file or supply manually?','From file...','Manually...');

if man==2   
   star.PWV = input('Enter PWV amount:');   
elseif man==1
   sunfile = (getfullname(['4STAR_',datestr(star.t(1),'yyyymmdd'),'starsun*.mat;',datestr(star.t(1),'yyyymmdd'),'_gas_summary.mat'],'starsun_gas','Select a starsun file with gasses or gas summary file'));
   if ~isempty(sunfile)
      sun = matfile(sunfile); props = properties(sun);
      if any(strcmp('tUTC',props)) %Then it is a gas summary file
         [~,fname] = fileparts(sunfile);
         suntime = datenum(fname(1:8),'yyyymmdd')+sun.tUTC./24;
         CWV = sun.cwv;
         Alt = sun.alt;
         
      else
         suntime = sun.t;
         Alt = sun.Alt;
         if any(strcmp('cwv',props))
            
            CWV = sun.cwv;
            if isstruct(CWV)
               CWV= CWV.cwv940m1;
            end
         end
      end
      fig2 = figure_(2);
      figure_(2);
      plot(suntime, Alt, 'o-', mean(star.t), mean(star.Alt),'rx'); legend('Alt', 'location','EastOutside');
      ylabel('Altitude');
      dynamicDateTicks;  

      ax2(1) = gca; 
      zoom('on')
      if any(strcmp('cwv',props))
         fig3 = figure_(3);
         figure_(3);
         if ~isempty(CWV)
            plot(suntime, CWV, 'o'); yl2 = ylim;
            plot(suntime, CWV, 'o',[mean(star.t), mean(star.t)], yl2,'r--');
            ylim(yl2);  legend('CWV','Location','EastOutside');
         end
         ax3(1) = gca; dynamicDateTicks;
         zoom('on')
         linkaxes([ax2 ax3],'x');
         
         K = menu('Zoom and select action','Good','Questionable','BAD','SKIP');
         if K <4
            xl = xlim;
            good_cwv = suntime>=xl(1) & suntime<=xl(2);
            star.PWV = mean(CWV(good_cwv));
         end
      else
         disp('No CWV in this file')
      end 
   end   % if empty(sunfile)
end % if manual

return