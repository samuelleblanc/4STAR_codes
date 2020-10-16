function [outname,ss,ww] = run_AERONET_retr_wi_selected_input_files(skyinput);
%% Modification notes
% SL, 2020-03-30, Added tracking of file daystr and merging of ppt files at the end.
%% CF, 2020-04-20, Replace existence tests with isavar, isadir, and isafile
%% Codes
% run_4STAR_AERONET_retrieval(skytag, line_num,)
% No customization, just pick files and run retrieval for all selected
% if ~exist('skyinput','var')
%    skyinput = getfullname(['*.input'],'4STAR_retr','Select one or more input files.');
%    if ischar(skyinput)&&~iscell(skyinput)&&exist(skyinput,'file')
%       skyinput ={skyinput};
%    end
% else
%    [pname, fname,ext] = fileparts(skyinput); [~, fname,~] = fileparts(fname)
%    skyinput = getfullname([pname,filesep,fname,'*.input'],'4STAR_retr','Select one or more input files.');
%    if ischar(skyinput)&&~iscell(skyinput)&&exist(skyinput,'file')
%       skyinput ={skyinput};
%    end
% end
if ~isavar('skyinput')||~isafile(skyinput)
   skyinput = getfullname(['*.input'],'4STAR_retr','Select one or more input files.');
end
if ischar(skyinput)&&~iscell(skyinput)&&isafile(skyinput)
   skyinput ={skyinput};
end
jf = 1;
for F = length(skyinput):-1:1
   infile = skyinput{F};
   disp(['Running ',num2str(F)])
   if isafile(infile)
      [pname_tagged, fname_tagged, ~] = fileparts(infile);pname_tagged = [pname_tagged, filesep];

      %         skip_dir = [pname_tagged, 'skip',filesep];
      %         if ~isadir(skip_dir)
      %             mkdir(skip_dir);
      %         end
      
      % build a list of good daystr and instrumentname for merging the ppts
      [daystr, filen, datatype,instrumentname]=starfilenames2daystr({infile}, 1);
      days{jf} = daystr;
      instnames{jf} = instrumentname;
      jf = jf+1;
      
      bad_dir = [pname_tagged, 'bad',filesep];
      if ~isadir(bad_dir)
         mkdir(bad_dir);
      end
      done_dir = [pname_tagged, 'done',filesep];
      %         done_dir = setnamedpath('staraip_out',[], 'Select the output directory for star aip results');
      if ~isadir(done_dir)
         mkdir(done_dir);
      end
      
      
      [~,fstem] = fileparts(fname_tagged); [~,fstem] = fileparts(fstem);
      imgdir = getnamedpath('starimg');
      if ~isadir([imgdir,fstem]);
         mkdir(imgdir, fstem);
      end
      
      
      if false %exist([skip_dir,fname_tagged,'.input'],'file')
         disp(['Skipping file ',fname_tagged,'.input'])
      else
         copyfile(['C:\z_4STAR\work_2aaa__\saved_dats\*.dat'], ['C:\z_4STAR\work_2aaa__\']);
         copyfile(['C:\z_4STAR\work_2aaa__\saved_dats\fort.*'], ['C:\z_4STAR\work_2aaa__\']);
         
         %             copyfile(infile, [skip_dir, fname_tagged, '.input']);
         in_test = fopen(infile, 'r');
         first_line = fgetl(in_test);
         fclose(in_test);
%          if contains(first_line,'ANET inp level:') %old-style ANET input level
%              enil = fliplr(first_line);
%              vel = strtok(enil,':');
%              lev = fliplr(vel);
%              in_lev = sscanf(lev, '%f');
%          elseif contains(first_line,'_test=') % Contains tests for sky or tau or both...
%              if contains(first_line,'sky_test=')
%                  ii = findstr(first_line,'sky_test=')+9;
%                  sky_test = sscanf(first_line(ii:end),'%f');
%              else
%                  sky_test = 1;
%              end
%              if contains(first_line,'tau_test')
%                  ii = findstr(first_line,'tau_test=')+9;
%                  tau_test = sscanf(first_line(ii:end),'%f');
%              else
%                  tau_test = 1;
%              end             
%          end
         % Haven't got around to re-tagging with post-processing data level
         
         [SUCCESS,MESSAGE,MESSAGEID] = copyfile(infile,'C:\z_4STAR\work_2aaa__\4STAR_.input');
         if isafile('C:\z_4STAR\work_2aaa__\4STAR_.output')
            delete('C:\z_4STAR\work_2aaa__\4STAR_.output')
         end
         disp(['Running retrieval for ',fname_tagged]);
         [ss,ww, toc_] = run_4STAR_AERONET_retrieval;
         disp(['Completed in ',sprintf('%2.1f ',toc_), 'seconds'])
         if isafile('C:\z_4STAR\work_2aaa__\4STAR_retr.log')
            outname = [pname_tagged,fname_tagged,'.4STAR_retr.log'];
            [SUCCESS,MESSAGE,MESSAGEID] = ...
               movefile('C:\z_4STAR\work_2aaa__\4STAR_retr.log',outname);
         end
         
         if isafile('C:\z_4STAR\work_2aaa__\4STAR_.output')
            outname = [pname_tagged,fname_tagged,'.output'];
            [SUCCESS,MESSAGE,MESSAGEID] = ...
               movefile('C:\z_4STAR\work_2aaa__\4STAR_.output',outname);
            %         fid3 = fopen(outname, 'r');
            %         outfile = char(fread(fid3,'uchar'))';
            %         fclose(fid3);
            
            try
               anetaip = parse_anet_aip_output(outname);
            
               [anetaip.lv_out, anetaip.tests] = anet_postproc_dl(anetaip);
               
               plot_anet_aip(anetaip);               
               lv_out = min([anetaip.lv_out.ssa,anetaip.lv_out.psd, anetaip.lv_out.pct_sphericity]);
               lv_ii = findstr(fname_tagged,'_lv');fname_tagged(lv_ii+1:end) = [];
               fname_tagged = [fname_tagged,num2str(10.*lv_out)];
%                [xls_fname] = print_anetretr_details_to_xls(s,xls_fname);
               save([done_dir,'..',filesep, fname_tagged, '.mat'],'-struct','anetaip')
               movefile([done_dir,'..',filesep, fname_tagged, '.*'], done_dir );
            catch ME
               disp(['Trouble displaying output from ',fname_tagged])
               copyfile(infile, bad_dir);
               [~, skyscan] = fileparts(fname_tagged);[~, skyscan] = fileparts(skyscan);
               figure; plot(0:1,0:1,'o'); title(['Crashed during ',skyscan], 'interp','none');
               text(0.1,0.8,ME.identifier,'color','red');
               text(0.1,0.6,ME.message,'color','red','fontsize',8);
               imgdir = getnamedpath('starimg');
               skyimgdir = [imgdir,skyscan,filesep];
               saveas(gcf,[skyimgdir,skyscan, '.bad.png']);
               ppt_add_slide([imgdir,skyscan,'.ppt'], [skyimgdir,skyscan, '.bad']);
               movefile([imgdir,skyscan,'.ppt'],[imgdir,'bad.',skyscan,'.ppt']);
               warning(['Crashed during ', fname_tagged]);
            end
            
         end
      end
   end
   pause(3); %close('all');
end
%%
if length(skyinput)==0
   outname = [];
end

%Merge the resulting ppts into a single per day
udays = unique(days)
for i=1:length(udays)
    ppt_out = merge_ppts_for_day(getnamedpath('starppt'),udays{i},instrumentname,'_allSKY');
end
return
