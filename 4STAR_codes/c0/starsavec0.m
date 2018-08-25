function starsavec0(filename, source, additionalnotes, w, c0, c0unc)

% Saves a 4STAR C0 file. 
% 
% Example
% % get c0new and w first, for example by running Langley.m. 
% filename=fullfile(starpaths, '20120722_NIR_C0_refined_Langley_on_G1_second_flight_screened_2x_test.dat');
% additionalnotes='Data outside 2x the STD of 501 nm Langley residuals were screened out before the averaging.';
% starsavec0(filename, '20120722Langleystarsun.mat', additionalnotes, w(1045:end), c0new(1045:end), NaN(1,512));
% 
% To read the content of an existing c0 file, use starc0.m or importdata.m.
% See also starLangley.m and Langley.m.
% 
% Yohei, 2012/10/19

% prohibit overwriting, because keeping records of c0 files is important
if isavar(filename);
    error([filename ' exists.']);
end;

% determine the data type
if ~isempty(findstr(upper(filename), 'VIS'));
    datatype='VIS';
elseif ~isempty(findstr(upper(filename), 'NIR'));
    datatype='NIR';
else
    error('Specify data type in the file name, or modify starsavec0.m.');
end;

% generate pix numbers
qq=numel(w);
pix=(0:(qq-1));
if isequal(upper(datatype(1:3)), 'NIR');
    pix=fliplr(pix);
end;

% regulate wavelength
if max(w)<10; % um
    factor=1000;
else
    factor=1;
end;

% regulate c0 values
c0(isfinite(c0)==0)=-1; % Roy likes -1 better than NaN.
c0unc(isfinite(c0unc)==0)=-1; % Roy likes -1 better than NaN.

% save headers lines
initialnote=['% C0 (TOA Count Rate, /ms) for 4STAR ' datatype ' spectrometer (' num2str(qq) ' channels) derived from ' source ' and recorded on ' datestr(now,31) '.'];
fid=fopen(filename, 'w');
fprintf(fid,'%s\n',initialnote);
if ~isempty(additionalnotes);
    if isstr(additionalnotes);
        fprintf(fid,'%s\n', ['% ' additionalnotes]);
    elseif iscell(additionalnotes);
        for i=1:numel(additionalnotes);
            fprintf(fid,'%s\n', ['% ' additionalnotes{i}]);
        end;
    else
        error('Give additionalnotes in either string or cell.');
    end;
end;
if size(c0unc,1)==1;
    fprintf(fid,'%s\n', 'Pix Wavelength C0 C0err');
    fmt='%u %6.2f %9.8e %9.8e \n';
elseif size(c0unc,1)==2;
    fprintf(fid,'%s\n', 'Pix Wavelength C0 C0errlo C0errhi');
    fmt='%u %6.2f %9.8e %9.8e %9.8e \n';
end;

% save numbers
fprintf(fid, fmt,[pix; w(:)'*factor; c0; c0unc]);
fclose(fid);        
           