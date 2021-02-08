function Test_files_code_versions()
%% Details of the function:
% NAME:
%   Test_files_code_versions
% 
% PURPOSE:
%   To check the output files against a tester and see differences after a
%   code update
%
% CALLING SEQUENCE:
%  Test_files_code_versions()
%
% INPUT:
% 
% OUTPUT:
%  - None
%
% DEPENDENCIES:
%  - None
%
% NEEDED FILES:
%  - tester file (star.mat / starsun.mat, etc.)
%  - Testee file (star.mat / starsun.mat, etc.)
%
% EXAMPLE:
%  ...
%
% MODIFICATION HISTORY:
% Written: (v1.0) Samuel LeBlanc, Santa Cruz, CA, during COVID-19 pandemic, 2020-05-04
% -------------------------------------------------------------------------
version_set('v1.0');


%% load files
%tester is the file of metric to test against
fp_tr = getfullname('*.mat','Tester_File','Select the mat file to be tester, metric to test against');
tr = load(fp_tr);

%testee is the file being interrogated if it matches the metric
fp_te = getfullname('*.mat','Testee_File','Select the mat file to be tested');
te = load(fp_te);

count = 0;
%% Print out program version info
is_pv = true;
if isfield(tr,'program_version')
    disp('.. TESTER program versions ..')
    disp(tr.program_version)
else
    fprintf(2,'*** NO TESTER program version !!!!\n')
    count = count + 1;
    is_pv = false;
end
    
if isfield(te,'program_version')
    disp('== TESTEE program versions ==')
    disp(te.program_version)
else
    fprintf(2,'+++ NO TESTEE program version !!!!\n')
    count = count + 1;
    is_pv = false;
end

if is_pv
    [pr_comm,pr_count] = test_cell_array(fields(tr.program_version),fields(te.program_version),'Program_version');
    count = count + pr_count;
    for ic=1:length(pr_comm)
        [nul,pr_cc] = test_cell_array(tr.program_version.(pr_comm{ic}),te.program_version.(pr_comm{ic}),pr_comm{ic});
        count = count + pr_cc;
    end
end

%% Build the variables to test and fields
tr_fl = fields(tr);
te_fl = fields(te);
[fl,countc] = test_cell_array(tr_fl,te_fl,'Main Variables');
count = count + countc;

for i=1:length(fl)
    % test main fields
    if isstruct(tr.(fl{i})) & length(tr.(fl{i}))>1
        if length(tr.(fl{i}))~=length(te.(fl{i}))
            fprintf(2,['Length of structures ' fl{i} ' not equivalent\n'])
            count = count + abs(length(tr.(fl{i}))-length(te.(fl{i})));
        else
            for j=1:length(tr.(fl{i}))
                counts = test_recursive_struct(tr.(fl{i})(j),te.(fl{i})(j),fl{i});
                count = count + counts;
            end
        end
    else
        counts = test_recursive_struct(tr.(fl{i}),te.(fl{i}),fl{i});
        count = count + counts;        
    end
end

disp(['File: ' fp_te ' has :']);
if count >0
    fprintf(2,'*** %s ***',num2str(count))
else
    fprintf('%i',count)
end
disp([' differences with file ' fp_tr])
return


function [cell_common,count] = test_cell_array(cell_r,cell_e,namestr)
%% Function to test differences in cell arrays of strings
if isempty(namestr), namestr = ''; end
count = 0;
%% check differences
if (length(setdiff(cell_r,cell_e))~=0) 
    % there is a difference, no go through and check what is the difference
    fprintf(2,['.. Tester ' namestr ' has more than Testee ..\n'])     
    disp(setdiff(cell_r,cell_e))    
    count = length(setdiff(cell_r,cell_e));
elseif (length(setdiff(cell_e,cell_r))~=0)
    fprintf(2,['== Testee ' namestr ' has more than Tester ==\n']) 
    disp(setdiff(cell_e,cell_r))
    count = length(setdiff(cell_e,cell_r));
else
    disp([ pad(namestr,25) 'Tester and Testee : have same number of cell array OK!']) 
end

%% return common
cell_common = intersect(cell_r,cell_e);

return

function count = test_recursive_struct(struct_r,struct_e,namestr)
%% Function to check recursive struct until we are at the smallest unit
count = 0;
if isempty(namestr), namestr = ''; end
if isstruct(struct_r)
    [cell_common,countc] = test_cell_array(fields(struct_r),fields(struct_e),namestr);
    count = count + countc;
    for ic=1:length(cell_common)
        if isstruct(struct_r.(cell_common{ic})) & length(struct_r.(cell_common{ic}))>1
            if length(struct_r.(cell_common{ic}))~=length(struct_e.(cell_common{ic}))
               fprintf(2,['*** Length of structures: ' namestr '.' cell_common{ic} ' not equivalent ***\n']) 
               count = count + abs(length(struct_r.(cell_common{ic})) - length(struct_e.(cell_common{ic})));
            else
                for j=1:length(struct_r.(cell_common{ic}))
                    count2 = test_recursive_struct(struct_r.(cell_common{ic})(j),struct_e.(cell_common{ic})(j),[namestr '.' cell_common{ic}]);
                    count = count + count2;
                end
            end
        else    
            count2 = test_recursive_struct(struct_r.(cell_common{ic}),struct_e.(cell_common{ic}),[namestr '.' cell_common{ic}]);
            count = count + count2;
        end
    end
elseif isfloat(struct_r)
    count2 = test_float(struct_r,struct_e,namestr);
    count = count + count2;
elseif isstring(struct_r)
    if ~strcmp(struct_r,struct_e)
        fprintf(2,['*** Differences in for ' namestr ' strings, Tester: ' struct_r ', Testee:' struct_e '***\n'])
        count = count + 1
    end
end
return

function count = test_float(float_r,float_e,namestr)
%% Function to check the differences in float for size, sum, mean, max, min, etc.
if isempty(namestr), namestr = ''; end
count = 0;
fprintf([pad(namestr,25) ':'])
fprintf(' sum=')
if nansum(float_r)~=nansum(float_e)
    fprintf(2,[' BAD! Tester: %s, Testee:%s'], num2str(nansum(float_r)), num2str(nansum(float_e)))
    count = count + 1;
else
    fprintf('OK!')
end

fprintf(', mean=')
if nanmean(float_r)~=nanmean(float_e)
    fprintf(2,[' BAD! Tester: %s, Testee:%s'], num2str(nanmean(float_r)), num2str(nanmean(float_e)))
    count = count + 1;
else
    fprintf('OK!')
end

fprintf(', min=')
if nanmin(float_r)~=nanmin(float_e)
    fprintf(2,[' BAD! Tester: %s, Testee:%s'], num2str(nanmin(float_r)), num2str(nanmin(float_e)))
    count = count + 1;
else
    fprintf('OK!')
end

fprintf(', max=')
if nanmax(float_r)~=nanmax(float_e)
    fprintf(2,[' BAD! Tester: %s, Testee:%s'], num2str(nanmax(float_r)), num2str(nanmax(float_e)))
    count = count + 1;
else
    fprintf('OK!')
end

fprintf(', size=')
if size(float_r)~=size(float_e)
    fprintf(2,[' BAD! Tester:' mat2str(size(float_r)) ', Testee:' mat2str(size(float_e))])
    count = count + 1;
else
    fprintf(['OK! (' mat2str(size(float_r)) ')'])
end

fprintf('\n')

if count > 0 & ~isempty(float_r) & any(any(isfinite(float_r)))
    figure;
    plot(float_r,'.g');
    hold on;
    plot(float_e,'.r');
    title(['Bad for: ' namestr])
    legend('Tester','Testee')
    hold off;
end
return



