function star5 = rd_5star_raw(infile);

if ~isavar('infile')||~isafile(infile)
   infile = getfullname('5STAR*.txt','5STAR_raw','Select 5STAR raw data');
end

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
