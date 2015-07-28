% program to convert regular star.mat files to files to be used easily with
% plot_star_head_temp_test_all.m
%
% Used for taking flight data and relating it to lab data
% outputs .mat file with vis_sun and nir_sun renamed to vis_park and
% nir_park, with the T4 temperature saved to RH subfields

function convert_star_to_temptesting(daystr,varargin)

if nargin<2
    dostaraatscompare = false;
    disp('Running the converter for star.mat')
    dir = 'C:\Users\sleblan2\Research\4STAR\SEAC4RS\';
    fp_in = [dir daystr 'star.mat'];
    fp_out = [dir daystr 'star_for_temp_test.mat'];
else
    dostaraatscompare = varargin{1};
    disp('Ruuning the converter for star aats comparison')
    dir = 'C:\Users\sleblan2\Research\4STAR\roof\';
    fp_in = [dir daystr filesep daystr 'startoaats.mat'];
    fp_out = [dir daystr filesep daystr 'star_for_temp_test.mat'];
end

%% load the data
disp(['Loading: ' fp_in])
load(fp_in);
vis_park = vis_sun;
nir_park = nir_sun;
if dostaraatscompare; nir_park.t = vis_park.t; end;

%% interpolate the temp data to fit
nir_park.RH = interp1(track.t,smoothn(track.T4),nir_park.t,'linear','extrap');
vis_park.RH = interp1(track.t,smoothn(track.T4),vis_park.t,'linear','extrap');

%% special analysis for star aats compare
if dostaraatscompare
    disp('special treatment for star-aats compare')
    %split vis and nir
    vis_park.raw = vis_park.raw(:,1:1044);
    nir_park.raw = vis_park.rate(:,1045:end);
    % interpolate the aats channel intercomparison to all star wavelengths
    for i=1:length(vis_park.t)
       vis_park.raw(i,:) = interp1(aats.w,vis_park.raterelativeratiotoaats(i,:),vis_park.w(1:1044),'linear','extrap'); 
       nir_park.raw(i,:) = interp1(aats.w,vis_park.raterelativeratiotoaats(i,:),vis_park.w(1045:end),'linear','extrap'); 
    end
    vis_park.raw(1,:)=0.0;
    nir_park.raw(1,:)=0.0;
    nir_park.Tst = interp1(track.t,smoothn(track.T1),nir_park.t,'linear','extrap');
    vis_park.Tst = interp1(track.t,smoothn(track.T1),vis_park.t,'linear','extrap');
end

disp(['Saving to: ' fp_out])
save(fp_out,'nir_park','vis_park','-mat','-v7.3');
end