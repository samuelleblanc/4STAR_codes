function star5 = rd_5star_raw(infile);

if ~isavar('infile')||~isafile(infile)
   infile = getfullname('5STAR*.txt','5STAR_raw','Select 5STAR raw data');
end


% cccc-yy-mmThh:mm:ss.uu,	
%2:10  340si_10x,	  440si_1x,	  675si_1x,	  870si_1x,	  1020si_1x,	1020ings_1x,	1240ings_1x,	1640ings_1x,	2200ings_1x,	
%11:19 340si_1000x, 440si_100x, 675si_100x, 870si_100x, 1020si_100x, 1020ings_100x,	1240ings_100x,	1640ings_100x,	2200ings_100x,	
%20:28 340si_100kx, 440si_10kx, 675si_10kx, 870si_10kx, 1020si_10kx,	1020ings_10kx,	1240ings_10kx,	1640ings_10kx,	2200ings_10kx,	
% ai_sense,	ai_gnd,		precision_5v,	12v_pos,	12v_ret,	quad_tot,	quad_x/tot,	quad_y/tot
% 2019-09-27T13:29:24.55,	
%3.310375,	5.014990,	5.019107,	5.019107,	4.998686,	5.082510,	5.073123,	5.009885,	5.069664,	1.435746,	
% 4.231212,	3.803669,	4.494973,	4.453535,	10.678641,	10.890116,	5.316845,	10.318837,	-3.067236,	-6.246494,	
% -6.247809,	-3.873643,	-0.420765,	10.890116,	10.890116,	5.456011,	10.890116,	3.348416,	0.000338,	5.602971,	
% 4.029280,	-4.019006,	-0.003233,	-0.288223,	0.234312

fid = fopen(infile);
A = textscan(fid, ['%s ',repmat('%f ',1,27) ,'%f %f %f %f %f %f %f %f',' %*[^\n]'],'delimiter',',','headerlines',1);
fclose(fid);
clear star5
star5.time = datenum(A{1},'yyyy-mm-ddTHH:MM:SS.fff');
n = 1;
star5.ch_340si = A{n+1};star5.ch_340si(:,2) = A{n+10}; star5.ch_340si(:,3) = A{n+19};
n = n+1; 
star5.ch_440si = A{n+1};star5.ch_440si(:,2) = A{n+10}; star5.ch_440si(:,3) = A{n+19};
n = n+1; 
star5.ch_675si = A{n+1};star5.ch_675si(:,2) = A{n+10}; star5.ch_675si(:,3) = A{n+19};
n = n+1; 
star5.ch_870si = A{n+1};star5.ch_870si(:,2) = A{n+10}; star5.ch_870si(:,3) = A{n+19};
n = n+1; 
star5.ch_1020si = A{n+1};star5.ch_1020si(:,2) = A{n+10}; star5.ch_1020si(:,3) = A{n+19};
n = n+1; 
star5.ch_1020in = A{n+1};star5.ch_1020in(:,2) = A{n+10}; star5.ch_1020in(:,3) = A{n+19};
n = n+1; 
star5.ch_1240in = A{n+1};star5.ch_1240in(:,2) = A{n+10}; star5.ch_1240in(:,3) = A{n+19};
n = n+1; 
star5.ch_1640in = A{n+1};star5.ch_1640in(:,2) = A{n+10}; star5.ch_1640in(:,3) = A{n+19};
n = n+1; 
star5.ch_2200in = A{n+1};star5.ch_2200in(:,2) = A{n+10}; star5.ch_2200in(:,3) = A{n+19};
star5.ai_sense = A{29}; star5.ai_gnd = A{30};  star5.prec_5V = A{31}
star5.V12_pos = A{32} ; star5.V12_ret = A{33}; 
star5.Qt = A{34}; star5.Qx= A{35}; star5.Qy = A{36};
% ai_sense,	ai_gnd,		precision_5v,	12v_pos,	12v_ret,	quad_tot,	quad_x/tot,	quad_y/tot

% figure; plot(star5.time, star5.ch_340si,'x'); title('340 nm');
% legend('10x','1e3x','1e5x');
% 
% figure; plot(star5.time, star5.ch_440si,'x'); title('440 nm');
% legend('1x','1e2x','1e4x');
% 
% figure; plot(star5.time, star5.ch_675si,'x'); title('675 nm');
% legend('1x','1e2x','1e4x');
% 
% figure; plot(star5.time, star5.ch_870si,'x'); title('870 nm');
% legend('1x','1e2x','1e4x');
% 
% figure; plot(star5.time, star5.ch_1020si,'x'); title('1020 Si nm');
% legend('1x','1e2x','1e4x');
% 
% figure; plot(star5.time, star5.ch_1020in,'x'); title('1020 In nm');
% legend('1x','1e2x','1e4x');
% 
% figure; plot(star5.time, star5.ch_1240in,'x'); title('1240 In nm');
% legend('1x','1e2x','1e4x');
% 
% figure; plot(star5.time, star5.ch_1640in,'x'); title('1640 In nm');
% legend('1x','1e2x','1e4x');
% 
% figure; plot(star5.time, star5.ch_2200in,'x'); title('2200 In nm');
% legend('1x','1e2x','1e4x');

figure; plot(star5.time, [star5.ch_440si(:,1), star5.ch_675si(:,1), star5.ch_870si(:,1), star5.ch_1020si(:,1)],'o')
menu('Zoom into region with only darks.  Hit OK when done','OK');
xl = xlim; dark_= star5.time>=xl(1) & star5.time<=xl(2) & star5.ch_440si(:,1)>4.99 & ...
    star5.ch_675si(:,1)>4.99 & star5.ch_870si(:,1)>4.99;

star5.dark_340 = mean(star5.ch_340si(dark_,:)); 
star5.dark_440 = mean(star5.ch_440si(dark_,:));
star5.dark_675 = mean(star5.ch_675si(dark_,:)); 
star5.dark_870 = mean(star5.ch_870si(dark_,:));
star5.dark_1020 = mean(star5.ch_1020si(dark_,:)); 
star5.dark_1020in = mean(star5.ch_1020in(dark_,:));
star5.dark_1240 = mean(star5.ch_1240in(dark_,:));  
star5.dark_1640 = mean(star5.ch_1640in(dark_,:));
star5.dark_2200 = mean(star5.ch_2200in(dark_,:));

star5.sig_340 = star5.ch_340si(:,1) - star5.dark_340(1); 
star5.sig_440 = star5.ch_440si(:,1) - star5.dark_440(1);
star5.sig_675 = star5.ch_675si(:,1) - star5.dark_675(1); 
star5.sig_870 = star5.ch_870si(:,1) - star5.dark_870(1);
star5.sig_1020 = star5.ch_1020si(:,1) - star5.dark_1020(1); 
star5.sig_1020_in = star5.ch_1020in(:,1) - star5.dark_1020in(1); 
star5.sig_1240 = star5.ch_1240in(:,1) - star5.dark_1240(1); 
star5.sig_1640 = star5.ch_1640in(:,1) - star5.dark_1640(1); 
star5.sig_2200 = star5.ch_2200in(:,1) - star5.dark_2200(1); 

star5.sig_340 = -star5.sig_340; star5.sig_440 = -star5.sig_440; 
star5.sig_675 = -star5.sig_675; star5.sig_870 = -star5.sig_870; 
star5.sig_1020 = -star5.sig_1020; star5.sig_1020_in = -star5.sig_1020_in; 
star5.sig_1240 = -star5.sig_1240; star5.sig_1640 = -star5.sig_1640; 
star5.sig_2200 = -star5.sig_2200;

figure;plot(star5.time, [star5.sig_440,star5.sig_675,star5.sig_870,star5.sig_1020, star5.sig_1020_in], '.') 
legend('440','675','870','1020' , '1020 in');
figure;plot(star5.time, [star5.sig_1020_in,star5.sig_1240,star5.sig_1640,star5.sig_2200], '.') 
legend('1020 in','1240','1640','2200');


%From looking at the plots, infer polarity and limit
% I see several "limits"
% 340 nm: ~3.32 (10x), 5.01 (1e5x), 10.89 (1e3x)
% 440 nm, ~3.42 (1x) 4.94 (1e2x), 10.89 (1e4x) darks at 1e4x wander
% 675 nm, ~3.12 (1x), 5.29 (1e2s), 10.89 (1e4x), darks at 1e2x wander
% 870 nm, ~3.12 (1x), 4.94 (1e2x), 10.89 (1e4x), darsk ast 1e4x -6.299
%1020 Si, 3. (1x), 5.099 (1x dark), 5.278 (1e2x dark) , 10.89
%1020 In, 3.5977 (1x), -5.851 (1e2x), -6.21 (1e4x), 5.07 (1x dark), 7.903 (1e2x dark), 10.89 (1e4x dark)
%1240 nm, 4.5975 (1x), -5.8361 (1e2x), 5.013 (1e4x), 5.03 (1x dark 10.89 (1e2x and 1e4x dark)
%1640 nm, 4.99 (1x), 3.18 (1e2x), -5.336 (1e4), 5.015 (dark 1x), 5.18(1e2x dark), 5.456 (1e4x dark)
%2200 nm, 3.6147(1x), -5.8558 (1e2x), 4.9978(1e4x), 5.0349(1ex dark),7.8301 (1e2x dark), 10.89 (1e4x dark)

return