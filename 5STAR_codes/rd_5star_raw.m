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
