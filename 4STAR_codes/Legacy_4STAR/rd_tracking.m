function track = rd_tracking_F4_v2(infile);
if ~exist('infile','var')||~exist(infile,'file')
    infile = getfullname('*_TRACK.dat','SPICE2','Select tracking file');
end
% Read first two lines
% First line is original filename
% Second is header row definition but it includes spaces within some column
% headings.
% header row: 24 fields
% N       Time            Azim Angle      Azim Error      Elev Angle
% Elev Error      Azim pos        Elev Pos        VB_T            VL_R            VTOT            Tsetbox         Tmonbox         Tbox            Tvnir           Tnir      P1        P2        P3        P4        T1        T2        T3        T4
%Third row is first real row of data
[pname, fname, ext] = fileparts(infile);
track.pname = [pname,filesep];
track.fname = [fname, ext];


% N       Time            Azim Angle      Azim Error      Elev Angle      Elev Error      Azim pos        Elev Pos        VB_T            VL_R            VTOT            Tsetbox         Tmonbox         Tbox            Tvnir           Tnir      P1        P2        P3        P4        T1        T2        T3        T4
% 0	10:50:28.375 PM	92.360000	-1.480000	44.006400	-0.540000	4618.000000	-6112.000000	1.133447	3.738916	3.786768	0.000000	0.000000	0.000000	0.000000	0.000000	0.264967	2.287147	0.662522	0.662522	0.300112	0.034923	-0.004158	-0.004872
%%
% N       Time            Azim Angle      Azim Error      Elev Angle      Elev Error      Azim pos        Elev Pos        VB_T            VL_R            VTOT            Tsetbox         Tmonbox         Tbox            Tvnir           Tnir      P1        P2        P3        P4        T1        T2        T3        T4	
% 0	22:04:14.062	106.260000	-1.480000	51.357600	-0.532800	5313.000000	-7133.000000	1.131934	3.759473	3.804541	0.000000	0.000000	0.000000	0.000000	0.000000	0.262046	1.732191	0.084200	0.085498	0.257850	-0.011656	-0.050996	0.000743

fid = fopen(infile,'r');
inline = fgetl(fid);
track.row_labels = fgetl(fid);
start = ftell(fid);
first_row = fgetl(fid);
fseek(fid, start,-1);
PM = ~isempty(strfind(first_row,'PM'))||~isempty(strfind(first_row,'AM'));
if PM
    [C] = textscan(fid, '%d %s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]', 'bufsize',20000);
else
    [C] = textscan(fid, '%d %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %*[^\n]', 'bufsize',20000);
end
fclose(fid);

%%
row_labels_str = ['N Time Azim_Angle Azim_Error Elev_Angle Elev_Error Azim_pos Elev_Pos VB_T VL_R VTOT Tsetbox Tmonbox Tbox Tvnir Tnir P1 P2 P3 P4 T1 T2 T3 T4'];
labels = textscan(row_labels_str,'%s');
labels = labels{1};
if PM
    for l = length(labels):-1:3
        track.(labels{l}) = C{l+1};
    end
    track.(labels{1}) = double(C{1});
    in_date = strtok(fname,'_');
    in_times = C{2};
    PMs = C{3};
    %%
    for t = length(in_times):-1:1
        len(t) =  length([in_date, ' ',in_times{t}, ' ',PMs{t}]);
    end
    %%
    in_time = zeros(length(in_times),max(len));
    %%
    for t = length(in_times):-1:1
        tmp = [in_date, ' ',in_times{t}, ' ',PMs{t}];
        in_time(t,1:len(t)) = tmp(:);
    end
    track.time = datenum(char(in_time),'yyyymmdd HH:MM:SS.FFF PM');
    %%
    
else
    for l = length(labels):-1:3
        track.(labels{l}) = C{l};
    end
    track.(labels{1}) = double(C{1});
    in_date = strtok(fname,'_');
    in_times = C{2};
    for t = length(in_times):-1:1
        len(t) =  length([in_date, ' ',in_times{t}]);
    end
    in_time = zeros(length(in_times),max(len));
    for t = length(in_times):-1:1
        tmp = [in_date, ' ',in_times{t}];
        in_time(t,:) = tmp(:);
    end
    track.time = datenum(char(in_time),'yyyymmdd HH:MM:SS.FFF');
    
end
track.time(track.time<track.time(1))= track.time(track.time<track.time(1))+1;
[~, run_id] = strtok(fname, '_');
[run_id] = sscanf(strtok(run_id, '_'),'%d');
track.run_id = ones(size(track.time)).*run_id;

track = cleanup_raw_flds(track);
track.T_box = track.T_box*100-273.15;
track.T1 = track.T1*1000 - 273.15;
track.T2 = track.T2*1000 - 273.15;
track.T3 = track.T3*1000 - 273.15;
track.T4 = track.T4*1000 - 273.15;

% save([pname, filesep,fname, '.mat'],'track');
%%
% figure;
% sub = (3:length(track.time));
% for l = 3:length(labels)
%    plot(serial2Hh(track.time(sub)), track.(labels{l})(sub),'-o');
%    title(labels{l},'interp','none');
%    pause
% end
return

function trk = cleanup_raw_flds(raw);

% Copy raw fields into cleaned up names
fld = {  'pname'	   ,   'pname'
    'fname'	   ,   'fname'
    'time'	   ,   'time'
    'N'		   ,   'N'
    'Tnir'	   ,   'T_spec_nir'
    'Tvnir'	   ,   'T_spec_uvis'
    'Tbox'	   ,   'T_box'
    'Tmonbox'	   ,   'T_box_mon'
    'Tsetbox'	   ,   'T_box_set'
    'Elev_Angle'   ,   'El_deg'
    'Elev_Pos'	   ,   'El_step'
    'Elev_Error'   ,   'El_corr'
    'Azim_Angle'   ,   'Az_deg'
    'Azim_pos'	   ,   'Az_step'
    'Azim_Error'   ,   'Az_corr'
    'VTOT'	   ,   'QdV_tot'
    'VL_R'	   ,   'QdV_LR'
    'VB_T'	   ,   'QdV_TB'
    'T1'	   ,   'T1'
    'T2'	   ,   'T2'
    'T3'	   ,   'T3'
    'T4'	   ,   'T4'
    'P1'	   ,   'P1'
    'P2'	   ,   'P2'
    'P3'	   ,   'P3'
    'P4'	   ,   'P4'
    'run_id'   ,   'run_id'
    'T_spec_nir'   ,   'T_spec_nir'
    'T_spec_uvis'   ,   'T_spec_uvis'
    'T_box'	   ,   'T_box'
    'T_box_mon',   'T_box_mon'
    'T_box_set',   'T_box_set'
    'El_deg'   ,   'El_deg'
    'El_step'  ,   'El_step'
    'El_corr'  ,   'El_corr'
    'Az_deg'   ,   'Az_deg'
    'Az_step'  ,   'Az_step'
    'Az_corr'  ,   'Az_corr'
    'QdV_tot'  ,   'QdV_tot'
    'QdV_LR'   ,   'QdV_LR'
    'QdV_TB'   ,   'QdV_TB'  };

for f = 1:length(fld)
    if isfield(raw, fld{f,1})
    trk.(fld{f,2}) = raw.(fld{f,1});
    raw = rmfield(raw, fld{f,1});
    end
end

% Strip out a few unwanted fields
if isfield(raw,'row_labels')
    raw = rmfield(raw,'row_labels');
end

% Catch remainder in case we have some adhoc additions
fld = fieldnames(raw);
for f = 1:length(fld)
    trk.(fld{f,2}) = raw.(fld{f,1});
    raw = rmfield(raw, fld{f,1});
end
%%

% Convert T1-T4 into Temperatures
% Convert P1-P4 into Pressure
% Convert Tvnir into Temp
% Convert Tnir into Temp:
% Convert T1-T4 into Temperatures
% Convert P1-P4 into Pressure
% Convert Tvnir into Temp
% Convert Tnir into Temp: 
% A = 1.2891e-3; B= 2.356e-4; C= 9.4272e-8;
% R = spc.Tvnir./10e-5; logR = log(R);
% T_K = 1./(A + B.*logR + C.*(logR).^3);
% spc.Tvnir = T_K;

% For UV/VIS spectrometer with Hamamatsu S7031
% R = R2*exp(B*(1/T-1/T2))
% log(R/R2) =  B*(1/T-1/T2)
% (B*log(R/R2) + 1/T2) = 1/T 
% T =  1./(B*log(R/R2) + 1/T2) 
% B = 3450; R2(298K) = 10K
% Resistancs are in K Ohm.
%R =   10.*exp(3450*(1/T - 1/298))
% log(R/10) =  3450 * (1/T - 1/298)
% log(R/10)/3450 = (1/T - 1/298)
% 1/298 + log(R/10)/3450 = 1/T
% R = V/I
R_ccd = trk.T_spec_uvis./1e-5;
R_ccd = R_ccd/1000;
%% NIR spectrometer
trk.T_spec_uvis = 1./(1/298 + log(R_ccd/10)/3450);
% I = 10 microA = 1e-5;
A = 1.2891e-3; B= 2.3561e-4; C= 9.4272e-8;
R = trk.T_spec_nir./1e-5; 
logR = log(R);
T_K = 1./(A + B.*logR + C.*(logR).^3);
trk.T_spec_nir = T_K;
 
% AD590 yield 1 uA per K, V=IR, R = 1 kOhm, so V = 1mV per K
trk.El_temp_K = 1000.*trk.T1;
trk.NearWindow_temp_K = 1000.*trk.T2;
trk.Az_temp_K = 1000.*trk.T4;

trk.Can_P_mB = 1000.*trk.P1./.23;
% P1 is pressure transducer  MS5401-AMS5401-A 23 mV per barr
% P3 is RH sensor is a Honeywell HIH-4000-001
%  VOUT=(VSUPPLY)(0.0062(sensor RH) + 0.16), typical at 25 º
% Sensor_RH = (V_out/V_in -0.16)/0.0062
% True RH = (Sensor RH)/(1.0546 – 0.00216T), T in ºC
trk.Can_RH = (trk.P2./5-0.16)/0.0062; % There is a sign error in the offset.  Need confirmation from Roy.
%%
% 
% figure; plot(serial2doy(trk.time), [smooth(trk.T1, 600),smooth(trk.T2, 600),smooth(trk.T3, 600),smooth(trk.T4, 600)], '.');
% legend('T1: El Motor Temp','T2: near window Temp','T3: NC','T4: broken');
% 
% %%
% figure; plot(serial2doy(trk.time), [smooth(trk.P2, 600)-1.63,smooth(trk.P3, 600),smooth(trk.P4, 600)], '.')
% legend('P2: RH','P3: ','P4: ');
%%

return