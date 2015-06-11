function spc = rd_spc_raw_tcap_v2(infile);
version_set('2.0');
% spc = rd_spc_raw_F4(infile);
% Reads a raw 4STAR-A spectral file 
% This version fixes an accidental sign error in AZ_deg by computing AZ_deg
% directly from AZstep
if ~exist('infile','var')||~exist(infile,'file')
   infile = getfullname_('*NIR*;*VIS*','4STAR_F4','Select spectrometer file (NIR or VIS)');
end
% %Mission: 
% %Operator: 
% %Detector Type: NIR
% %Detector SN: 0
% %Collection Code: 0
% %File Format Version: 0.000000
% %Observer Note: 
% %20110713_002_NIR_FOVP.dat
% YYYY MM DD HH mm ss msec Str Md Zn       Lat       Lon       Alt  Headng   pitch    roll       Tst      Pst        RH AZstep Elstep    AZ_deg    El_deg   QdVlr   QdVtb  QdVtot AZcorr ELcorr   Tbox      Tint AVG  Pix0 Pix1 Pix2 Pix3 Pix4 Pix5 Pix6 Pix7 Pix8 Pix9 Pix10 Pix11 Pix12 Pix13 Pix14 Pix15 Pix16 Pix17 Pix18 Pix19 Pix20 Pix21 Pix22 Pix23 Pix24 Pix25 Pix26 Pix27 Pix28 Pix29 Pix30 Pix31 Pix32 Pix33 Pix34 Pix35 Pix36 Pix37 Pix38 Pix39 Pix40 Pix41 Pix42 Pix43 Pix44 Pix45 Pix46 Pix47 Pix48 Pix49 Pix50 Pix51 Pix52 Pix53 Pix54 Pix55 Pix56 Pix57 Pix58 Pix59 Pix60 Pix61 Pix62 Pix63 Pix64 Pix65 Pix66 Pix67 Pix68 Pix69 Pix70 Pix71 Pix72 Pix73 Pix74 Pix75 Pix76 Pix77 Pix78 Pix79 Pix80 Pix81 Pix82 Pix83 Pix84 Pix85 Pix86 Pix87 Pix88 Pix89 Pix90 Pix91 Pix92 Pix93 Pix94 Pix95 Pix96 Pix97 Pix98 Pix99 Pix100 Pix101 Pix102 Pix103 Pix104 Pix105 Pix106 Pix107 Pix108 Pix109 Pix110 Pix111 Pix112 Pix113 Pix114 Pix115 Pix116 Pix117 Pix118 Pix119 Pix120 Pix121 Pix122 Pix123 Pix124 Pix125 Pix126 Pix127 Pix128 Pix129 Pix130 Pix131 Pix132 Pix133 Pix134 Pix135 Pix136 Pix137 Pix138 Pix139 Pix140 Pix141 Pix142 Pix143 Pix144 Pix145 Pix146 Pix147 Pix148 Pix149 Pix150 Pix151 Pix152 Pix153 Pix154 Pix155 Pix156 Pix157 Pix158 Pix159 Pix160 Pix161 Pix162 Pix163 Pix164 Pix165 Pix166 Pix167 Pix168 Pix169 Pix170 Pix171 Pix172 Pix173 Pix174 Pix175 Pix176 Pix177 Pix178 Pix179 Pix180 Pix181 Pix182 Pix183 Pix184 Pix185 Pix186 Pix187 Pix188 Pix189 Pix190 Pix191 Pix192 Pix193 Pix194 Pix195 Pix196 Pix197 Pix198 Pix199 Pix200 Pix201 Pix202 Pix203 Pix204 Pix205 Pix206 Pix207 Pix208 Pix209 Pix210 Pix211 Pix212 Pix213 Pix214 Pix215 Pix216 Pix217 Pix218 Pix219 Pix220 Pix221 Pix222 Pix223 Pix224 Pix225 Pix226 Pix227 Pix228 Pix229 Pix230 Pix231 Pix232 Pix233 Pix234 Pix235 Pix236 Pix237 Pix238 Pix239 Pix240 Pix241 Pix242 Pix243 Pix244 Pix245 Pix246 Pix247 Pix248 Pix249 Pix250 Pix251 Pix252 Pix253 Pix254 Pix255 Pix256 Pix257 Pix258 Pix259 Pix260 Pix261 Pix262 Pix263 Pix264 Pix265 Pix266 Pix267 Pix268 Pix269 Pix270 Pix271 Pix272 Pix273 Pix274 Pix275 Pix276 Pix277 Pix278 Pix279 Pix280 Pix281 Pix282 Pix283 Pix284 Pix285 Pix286 Pix287 Pix288 Pix289 Pix290 Pix291 Pix292 Pix293 Pix294 Pix295 Pix296 Pix297 Pix298 Pix299 Pix300 Pix301 Pix302 Pix303 Pix304 Pix305 Pix306 Pix307 Pix308 Pix309 Pix310 Pix311 Pix312 Pix313 Pix314 Pix315 Pix316 Pix317 Pix318 Pix319 Pix320 Pix321 Pix322 Pix323 Pix324 Pix325 Pix326 Pix327 Pix328 Pix329 Pix330 Pix331 Pix332 Pix333 Pix334 Pix335 Pix336 Pix337 Pix338 Pix339 Pix340 Pix341 Pix342 Pix343 Pix344 Pix345 Pix346 Pix347 Pix348 Pix349 Pix350 Pix351 Pix352 Pix353 Pix354 Pix355 Pix356 Pix357 Pix358 Pix359 Pix360 Pix361 Pix362 Pix363 Pix364 Pix365 Pix366 Pix367 Pix368 Pix369 Pix370 Pix371 Pix372 Pix373 Pix374 Pix375 Pix376 Pix377 Pix378 Pix379 Pix380 Pix381 Pix382 Pix383 Pix384 Pix385 Pix386 Pix387 Pix388 Pix389 Pix390 Pix391 Pix392 Pix393 Pix394 Pix395 Pix396 Pix397 Pix398 Pix399 Pix400 Pix401 Pix402 Pix403 Pix404 Pix405 Pix406 Pix407 Pix408 Pix409 Pix410 Pix411 Pix412 Pix413 Pix414 Pix415 Pix416 Pix417 Pix418 Pix419 Pix420 Pix421 Pix422 Pix423 Pix424 Pix425 Pix426 Pix427 Pix428 Pix429 Pix430 Pix431 Pix432 Pix433 Pix434 Pix435 Pix436 Pix437 Pix438 Pix439 Pix440 Pix441 Pix442 Pix443 Pix444 Pix445 Pix446 Pix447 Pix448 Pix449 Pix450 Pix451 Pix452 Pix453 Pix454 Pix455 Pix456 Pix457 Pix458 Pix459 Pix460 Pix461 Pix462 Pix463 Pix464 Pix465 Pix466 Pix467 Pix468 Pix469 Pix470 Pix471 Pix472 Pix473 Pix474 Pix475 Pix476 Pix477 Pix478 Pix479 Pix480 Pix481 Pix482 Pix483 Pix484 Pix485 Pix486 Pix487 Pix488 Pix489 Pix490 Pix491 Pix492 Pix493 Pix494 Pix495 Pix496 Pix497 Pix498 Pix499 Pix500 Pix501 Pix502 Pix503 Pix504 Pix505 Pix506 Pix507 Pix508 Pix509 Pix510 Pix511 
% 2011 07 13 00 02 44  93  1  1  0    0.0000    0.0000      0.00    0.00    0.00    0.00    0.0000    0.0000    0.0000   6775  -5399   135.500    38.873 -0.0059 -0.0176  4.0604      0      0 0.0000    100.00   1  -726.5   528.5   505.5   514.5   588.0   483.0   418.5   504.5   468.0   576.5   510.5   564.5   518.5   548.5   548.0   522.0   530.5   518.0   527.0   555.0   464.0   546.0   535.5   500.5   542.0   552.0   570.0   584.5   481.5   577.0   535.5   594.5   525.5   580.5   566.0   568.5   527.0   618.5   582.0   580.0   567.5   572.5   557.5   611.0   566.0   625.5   529.5   656.0   601.0   649.0   590.5   683.0   535.0   643.5   576.5   629.5   634.0   558.0   571.0   635.5   577.5   618.0   577.0   616.5   601.5   664.0   621.5   639.5   581.0   652.0   570.5   607.5   657.0   646.0   621.0   638.0   570.0   602.5   577.5   669.0   552.5   618.5   569.0   655.0   599.5   674.5   566.0   686.0   609.0   612.0   591.5   577.5   609.5   633.0   639.5   660.5   586.0   690.5   658.0   612.0   606.0   621.0   606.0   675.5   505.0   646.5   557.5   677.0   537.0   643.5   676.0   693.0   663.5   672.0   648.0   665.0   623.0   703.0   678.0   703.5   639.5   736.0   673.0   635.5   710.0   738.5   673.5   660.5   696.5   739.0   594.5   716.5   582.5   715.0   614.5   653.5   607.5   676.0   606.0   672.0   654.0   686.5   618.0   611.5   604.5   629.0   654.0   677.0   665.0   669.0   614.5   625.0   581.0   603.0   602.0   595.0   611.5   618.5   569.5   652.0   561.5   590.5   608.0   616.0   657.5   606.0   541.5   602.5   534.0   561.5   591.5   501.5   510.0   592.5   557.5   528.5   534.5   510.0   527.0   535.5   523.5   524.5   477.5   538.0   479.5   599.0   543.5   558.0   519.5   475.0   519.0   562.0   515.5   572.0   540.5   584.0   518.5   577.0   503.0   492.5   529.0   489.5   487.5   531.0   485.5   514.0   518.0   541.5   528.5   557.0   512.5   551.0   516.0   529.5   473.5   575.5   537.5   544.5   539.0   567.0   545.5   587.0   521.5   542.5   416.0   542.0   506.0   535.0   480.5   516.5   492.0   547.0   536.0   528.5   431.0   594.5   533.0   559.5   457.0   550.5   527.5   539.5   525.5   574.5   542.0   518.5   455.0   545.5   462.5   510.5   523.0   510.0   448.5   530.0   504.5   510.5   438.5   528.5   533.0   509.5   492.0   506.5   492.5   613.5   472.0   523.0   493.0   551.0   554.0   602.5   494.5   557.5   545.0   543.5   533.0   665.0   652.5   647.5   572.0   576.5   536.5   595.5   632.5   667.5   661.5   635.0   587.0   688.0   660.5   698.0   655.0   686.0   713.5   618.0   754.0   743.0   673.5   779.0   693.5   704.0   789.5   757.5   756.5   743.5   720.0   802.5   778.5   802.0   772.0   809.5   736.0   803.0   814.5   754.0   744.5   799.0   745.5   812.0   788.5   784.0   731.0   780.5   781.5   741.5   787.0   731.0   742.0   785.5   795.5   807.5   717.0   845.5   834.0   843.0   774.5   829.0   771.0   800.0   861.0   799.5   816.5   843.0   766.0   791.0   757.0   811.5   804.0   875.5   832.5   802.5   796.0   795.5   708.0   798.0   806.0   797.0   779.0   795.0   710.5   740.0   749.0   820.0   797.0   740.5   696.5   813.5   715.0   724.5   707.0   720.5   778.0   818.5   680.0   701.5   726.5   697.0   757.0   770.0   725.0   742.5   732.0   703.0   821.0   737.0   760.5   741.0   719.0   778.5   691.5   752.5   683.5   736.5   653.5   645.0   494.5   639.5   574.0   618.0   591.5   579.0   508.0   554.5   565.5   623.0   599.5   608.5   577.5   577.5   597.5   559.5   522.0   558.5   505.5   615.0   525.5   597.5   566.0   603.0   604.5   679.0   615.0   706.5   670.0   650.0   722.5   717.5   714.0   720.5   672.0   766.5   773.0   754.5   793.0   825.5   713.0   840.5   746.5   795.0   749.0   745.5   826.5   778.0   782.0   734.5   811.5   829.5   818.0   799.0   772.5   840.5   818.0   847.0   727.0   880.0   782.5   823.0   840.0   790.5   769.0   789.5   761.5   854.5   817.5   817.0   800.5   849.0   745.0   854.5   823.5   787.0   801.0   778.5   756.0   860.5   831.5   784.0   849.0   826.5   737.5   859.5   828.0   863.5   811.0   786.0   769.5   815.5   832.0   800.0   763.5   813.5   792.0   815.5   754.0   825.0   701.0   694.0   734.5   780.5   705.5   697.0   679.5   698.5   604.5   679.0   701.0   662.0   537.0   599.0   596.0   566.0   477.5  -642.0

% Read until first character is not "%"
[pname, fname, ext] = fileparts(infile);
spc.pname = [pname,filesep];
spc.fname = [fname, ext];
%%
fid = fopen(infile,'r');
tmp = fgetl(fid);
i = 1;
while strcmp(tmp(1),'%')
   spc.header{i} = tmp;
   if ~isempty(strfind(tmp,'%Detector Type'))
      spc.is_vis = isempty(strfind(tmp,'NIR'));
   end
   i = i+1;
   tmp = fgetl(fid);
end
spc.row_labels = tmp;
spc.row_labels = textscan(spc.row_labels,'%s');
spc.row_labels = spc.row_labels{:};
data_i = ftell(fid);
labels = spc.row_labels;

vals = textscan(fgetl(fid),'%f');
vals = vals{:};
scan_str = [repmat('%f ',[1, length(vals)]),'%*[^\n]'];
fseek(fid,data_i,-1);
[C] = textscan(fid, scan_str, 'bufsize',20000);
fclose(fid);
%%
cols = length(C);
rows = length(C{1});
last_pix = labels{end};
pixels = sscanf(last_pix(4:end),'%d')+1;
% pixels = cols - length(spc.row_labels) +1;
spc.spectra = [];
for pix = pixels:-1:1
   spc.spectra(:,pix) = C{end};
   C(end) = [];
end
spc.time = datenum([C{1},C{2},C{3},C{4},C{5},C{6}+ C{7}./1000]);
C(7)=[];C(6)=[];C(5)=[];C(4)=[];C(3)=[];C(2)=[];C(1)=[];
% labels(end) = [];
labels(7) = [];labels(6) = [];labels(5) = [];labels(4) = [];
labels(3) = [];labels(2) = [];labels(1) = [];
for lab = (length(labels)-pixels):-1:1
   spc.(labels{lab}) = C{lab}; C(lab) = [];
end

if spc.is_vis
 spc.nm = Lambda_MCS_sn081100_tec5([1:pixels]);   
else
   spc.nm = fliplr(lambda_swir([1:pixels]));
   spc.spectra = fliplr(spc.spectra);
end
[~, run_id] = strtok(fname, '_');
[run_id] = sscanf(strtok(run_id, '_'),'%d');
spc.run_id = ones(size(spc.time)).*run_id;
spc.Az_deg = -1.*spc.AZstep./50;

spc.Tbox = spc.Tbox*100-273.15;
%%

% Convert T1-T4 into Temperatures
% Convert P1-P4 into Pressure
% Convert Tvnir into Temp
% Convert Tnir into Temp: 
% A = 1.2891e-3; B= 2.356e-4; C= 9.4272e-8;
% R = spc.Tvnir./10e-5; logR = log(R);
% T_K = 1./(A + B.*logR + C.*(logR).^3);
% spc.Tvnir = T_K;
  
return