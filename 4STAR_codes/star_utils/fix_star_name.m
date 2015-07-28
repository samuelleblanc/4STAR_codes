function fix_star_name
% test_name: this function checks the contents of 4STAR files against the
% filename and renames the file to reflect the contents.  It is mostly for 
% correcting "sun" files and "park" files, and also "zen", and "cldp" and
% "park"

%
% 0=park
% 1=sun tracking with quad
% 2=fovp?
% 3=fova?
% 4=skyp
% 5=skya
% 6=can't remember, may be nothing
% 7=sun tracking without quad, either ephemeris toggle is set or can't get on sun
% 8=can't remember but I don't think it's zenith
% 9=zenith i thought but now not so sure, maybe it is 8
% 10=cloud scan



infile = getfullname('*.dat','4STAR','Select a 4STAR data file in the directory you want to examine');

[pname, fname, ext] = fileparts(infile);
pname = [pname, filesep];
if ~exist([pname, 'done'],'dir')
    mkdir(pname, 'done');
end
if ~exist([pname, 'bad'],'dir')
    mkdir(pname, 'bad');
end
if ~exist([pname, 'old_name'],'dir')
    mkdir(pname, 'old_name');
end
if ~exist([pname, 'new_name'],'dir')
    mkdir(pname, 'new_name');
end


files = dir([pname, '*NIR*.dat']);

for f = length(files):-1:1
    fname = files(f).name;
    clear star
    if exist([pname, 'done',filesep,fname],'file')
        disp(['Skipping ',fname])
    else
        disp(['Reading file:',num2str(f), ', ',files(f).name]);
        try
            star = rd_spc_F4_v2([pname, files(f).name]);
        catch
            try % second try...
                star = rd_spc_F4_v2([pname, files(f).name]);
            catch
                disp(['Could not open ',files(f).name]);
                fclose(fopen([pname, 'bad',filesep,files(f).name],'w'));
            end
        end
        
        if exist('star','var')&&isstruct(star)
            %%
%             figure(1); plot([1:length(star.time)], star.t.mode,'o', [1:length(star.time)], star.t.shutter,'x',...
%                 [1:length(star.time)], star.t.sky_zone,'-' ); legend('mode','shutter','sky zone');
%             tl = title(files(f).name); set(tl,'interp','none');
            
            %%
            
            emanf = fliplr(star.fname);
            [gat, eman] = strtok(emanf(5:end),'_');
            tag = fliplr(gat); name = fliplr(eman);
            new_name = star.fname;
            if sum((star.t.mode==0|star.t.mode==1|star.t.mode==7) & star.t.shutter==1 & star.t.sky_zone==0)>5
                % Probably a "sun" file.
                if isempty(strfind(star.fname,'SUN.'))
                    new_name = strrep(star.fname, tag, 'SUN');
                end
            end
            
            if sum(star.t.mode==8 & star.t.shutter==2)>5
                % Probably a "ZEN" file.
                if isempty(strfind(star.fname,'ZEN.'))
                    new_name = strrep(star.fname, tag, 'ZEN');
                end
            end
            
            if sum(star.t.mode==4|star.t.mode==5|star.t.mode==9|star.t.mode==10 & star.t.shutter==2 ...
                    & star.t.sky_zone~=0)>5
                % Probably a sky scan or cloud scan file" file.
                if isempty(findstr(tag,'SKY'))
                    new_name = strrep(star.fname, tag, 'CLDP');
                else
                    new_name = star.fname;
                end                
            end
            
                    % zen mode                              % park and sun
            if sum(star.t.mode==8 & star.t.shutter==2)>5 & sum((star.t.mode==0|star.t.mode==1|star.t.mode==7) & star.t.shutter==1 & star.t.sky_zone==0)>5
            disp('What?  Sun and zenith in same file?');
            pause(1);
                % Stop if a file has more than 5 "zenith" mode and more than 5
            % "sun" mode because these aren't expected to be bundled
            % together in the same file.
            end
            
            if ~strcmp(star.fname,new_name)

                %                 mn = menu('Name the output file ...',star.fname, new_name);
                %                 if mn==2
                beep;
                disp(['renaming ',star.pname, ' to ',new_name])
                copyfile([star.pname, star.fname], [star.pname, 'old_name',filesep,star.fname]);
                movefile([star.pname, star.fname], [star.pname, 'new_name',filesep,new_name]);
                
                star.fname = strrep(star.fname,'NIR','VIS');
                new_name = strrep(new_name, 'NIR','VIS');
                if exist([star.pname, star.fname],'file')
                    copyfile([star.pname, star.fname], [star.pname, 'old_name',filesep,star.fname]);
                    movefile([star.pname, star.fname], [star.pname, 'new_name',filesep,new_name]);
                end
                %                 end
            else
                
                fclose(fopen([star.pname, 'done',filesep,star.fname],'w'));
            end
        end
    end
end

% put rename scripts in here.




    %%
return