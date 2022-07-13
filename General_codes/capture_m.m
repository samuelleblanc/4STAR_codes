function m_out = capture_m(mfile)
% Captures the text inside an m-file skipping the function definitition and
%  stripping all leading commnents.
warning('off','MATLAB:deblank:NonStringInput')
if ~exist('mfile','var')||~exist(mfile,'file')
    mfile = getfullname('*.m','mfile','Select an m-file to capture');
end

if exist(mfile,'file')
    m_out = {};done = false;
    fid = fopen(mfile,'r'); 
    inline = deblank(fgetl(fid));
    while ~feof(fid)
        while isempty(inline)||strcmp(inline(1),'%')||strncmp('function',inline,8)||strncmp('return',inline,6)
            inline = deblank(fgetl(fid));
        end
        if ~isempty(inline)&&ischar(inline)
            m_out(end+1,1) = {inline};
        end
        inline = deblank(fgetl(fid));
    end
    fclose(fid);
else
    m_out  =[];
end
warning('on','MATLAB:deblank:NonStringInput')
return