% load data
datatypes={'vis_sun', 'nir_sun'};
starload(daystr, datatypes{:});

% count the number of rows for each raw file
for k=datatypes;
    records=[];
    eval(['s=' char(k) ';']);
    ufn=unique(s.filen);
    for i=ufn';
        records=[records; i numel(find(s.filen==i))];
    end;
    eval(['records' char(k) '=records;']);
end;

% show results
sdvis_sun=setdiff(recordsvis_sun,recordsnir_sun, 'rows');
sdnir_sun=setdiff(recordsnir_sun,recordsvis_sun, 'rows');
if ~isempty(sdvis_sun);
    for i=1:numel(sdvis_sun,1)
        disp(['Exclude file #' num2str(sdvis_sun(i,1)) ' (both VIS_SUN and NIR_SUN).']);
    end;
end;
if ~isempty(sdnir_sun);
    for i=1:numel(sdnir_sun,1)
        disp(['Exclude file #' num2str(sdvis_sun(i,1)) ' (both VIS_SUN and NIR_SUN).']);
    end;
end;
if isempty(sdvis_sun) && isempty(sdnir_sun);
    disp('There is a perfect 1-row-to-1-row match between vis_sun and nir_sun.');
end;
