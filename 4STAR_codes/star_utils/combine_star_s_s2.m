function s = combine_star_s_s2(s,s2,toggle);
pp=numel(s.t);
qq=size(s.raw,2);
    % check whether the two structures share almost identical time arrays
    if pp~=length(s2.t);
        bad_t=find(diff(s.t)<=0);
        bad_t2=find(diff(s2.t)<=0);
        if length(bad_t2) > 0
            disp('bad_t2 larger than 0');
        end
        [ainb, bina] = nearest(s.t, s2.t);
        st_len = length(s.t);
        st2_len = length(s2.t);
        fld = fieldnames(s);
        for fd = 1:length(fld)
            [rr,col] = size(s.(fld{fd}));
            if rr == st_len && col==1
                s.(fld{fd}) = s.(fld{fd})(ainb);
                s2.(fld{fd}) = s2.(fld{fd})(bina);
            elseif rr==st_len && col == length(s.w)
                s.(fld{fd}) = s.(fld{fd})(ainb,:);
                s2.(fld{fd}) = s2.(fld{fd})(bina,:);
            end
        end
        
        %         error(['Different size of time arrays. starwrapper.m needs to be updated.']);
    end;
    pp=numel(s.t);
    qq=size(s.raw,2);
    ngap=numel(find(abs(s.t-s2.t)*86400>0.02));
    if ngap==0;
    elseif ngap<pp*0.2; % less than 20% of the data have time differences. warn and proceed.
        warning([num2str(ngap) ' rows have different time stamps between the two arrays by greater than 0.02s.']);
    else; % many differences. stop.
        error([num2str(ngap) ' rows have different time stamps between the two arrays by greater than 0.02s.']);
    end;
    % check whether the two structures come from separate spectrometers
    if isequal(lower(s.datatype(1:3)), lower(s2.datatype(1:3)))
        error('Two structures must be for separate spectrometers.');
    end;
    % discard the s2 variables for which s has duplicates
    if toggle.verbose, disp('discarding duplicate structures'), end;
    fn={'Str' 'Md' 'Zn' 'Lat' 'Lon' 'Alt' 'Headng' 'pitch' 'roll' 'Tst' 'Pst' 'RH' 'AZstep' 'Elstep' 'AZ_deg' 'El_deg' 'QdVlr' 'QdVtb' 'QdVtot' 'AZcorr' 'ELcorr'};...
        fn={fn{:} 'Tbox' 'Tprecon' 'RHprecon' 'Tplate' 'sat_time'};
    fnok=[]; % Yohei, 2012/11/27
    for ff=1:length(fn); % take the values from the s structure, and discard those in s2
        if isfield(s, fn{ff});
            fnok=[fnok; ff];
            if size(s.(fn{ff}),1)~=pp || size(s2.(fn{ff}),1)~=pp
                error(['Check ' fn{ff} '.']);
            end;
        end;
    end;
    drawnow;
    s2=rmfield(s2, fn(fnok));
    clear fnok; % Yohei, 2012/11/27
    % combine some of the remaining s2 variables into corresponding s variables
    fnc={'raw' 'rawcorr' 'w' 'c0' 'c0err' 'fwhm' 'rate' 'dark' 'darkstd' 'sat_ij' 'skyresp', 'skyresperr'};
    qq2=size(s2.raw,2);
    s.([lower(s.datatype(1:3)) 'cols'])=1:qq;
    s.([lower(s2.datatype(1:3)) 'cols'])=(1:qq2)+qq;
    for ff=length(fnc):-1:1;
        if size(s.(fnc{ff}),2)~=qq || size(s2.(fnc{ff}),2)~=qq2
            error(['Check ' fnc{ff} '.']);
        else
            s.(fnc{ff})=[s.(fnc{ff}) s2.(fnc{ff})];
        end;
    end;
    s.aerosolcols=[s.aerosolcols(:)' s2.aerosolcols(:)'];
    %     s.aeronetcols = [s.aeronetcols(:)' s2.aeronetcols(:)'];
    note_x = {[upper(s.datatype(1:3)) ' and ' upper(s2.datatype(1:3)) ' data were combined with starwrapper.m. ']};
    note_x(end+1,1) = {[upper(s2.datatype(1:3)) ' notes: ']};
    for L = 1:length(s.note)
        note_x(end+1,1) = {s.note{L}};
    end
    note_x(end+1,1) = {[upper(s.datatype(1:3)) ' notes: ']};
    for L = 1:length(s2.note)
        note_x(end+1,1) = {s2.note{L}};
    end
    s.note = note_x;
    %     s.note={[upper(datatype(1:3)) ' and ' upper(datatype2(1:3)) ' data were combined with starwrapper.m. ']; [upper(datatype(1:3)) ' notes: ']; s.note{:} ;...
    %         [upper(datatype2(1:3)) ' notes: ']; s2.note{:}};
    s.filename=[s.filename; s2.filename];
    s2=rmfield(s2, [fnc(:); 'aerosolcols';'aeronetcols'; 'note'; 'filename']);
    % store the remaining s2 variables separately in s
    fn=fieldnames(s2);
    for ff=1:length(fn);
        s.([lower(s.datatype(1:3)) fn{ff}])=s.(fn{ff});
        s.([lower(s2.datatype(1:3)) fn{ff}])=s2.(fn{ff});
    end;
    s=rmfield(s, setdiff(fn,'t'));
    qq=qq+qq2;
    clear qq2 s2;
    [daystr, filen, s.datatype]=starfilenames2daystr(s.filename, 1);
% end


return