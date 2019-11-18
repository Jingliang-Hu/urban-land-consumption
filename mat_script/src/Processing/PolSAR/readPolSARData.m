function [ polsar,refmat ] = readPolSARData( path )
%This function read binary PolSAR data of different forms and dimensions. 
% C:covariance matrices     T:coherence matrices    S:sinclair matrices
% K:kennaugh matrices       
% Number following the letters above depicts the dimension.
% C3: 3 dimensional covariance matrix  C4: 4 dimensional covariance matrix
%   Input
%       - path          -- the directory of data
%
%   Output
%       - polsar        -- polsar data in polsarpro data format
%       - ref_mat       -- georeference data of the polsar data



% determine the formation of data and assigning type code to tp.

fm = strsplit(path,'\');
switch char(fm(end))
    case 'C3'
        num = 9;
        name = {'\C11.bin','\C22.bin','\C33.bin',...
                '\C12_real.bin','\C13_real.bin','\C23_real.bin',...
                '\C12_imag.bin','\C13_imag.bin','\C23_imag.bin'};
    case 'C2'
        num = 4;
        name = {'\C11.bin','\C22.bin','\C12_real.bin','\C12_imag.bin'};
        
    case 'T2'
        num = 4;
        name = {'\T11.bin','\T22.bin','\T12_real.bin','\T12_imag.bin'};

    case 'T3'
        num = 9;
        name = {'\T11.bin','\T22.bin','\T33.bin',...
                '\T12_real.bin','\T13_real.bin','\T23_real.bin',...
                '\T12_imag.bin','\T13_imag.bin','\T23_imag.bin'};
%     case 'C4'
%         tp = 2;
%     case 'T4'
%         tp = 4;
%     case 'S2'
%         tp = 5;
%     case 'K'
%         tp = 6;
end

% read info from config file

cpath = [path,'\config.txt'];
[ rw,cl ] = readConfig( cpath );

% initial output and read the binary data
polsar = zeros(cl,rw,num);
for k = 1:num
    fT = fopen([path,name{k}],'r');
    polsar(:,:,k) = fread(fT, [cl,rw], 'float32');
    fclose(fT);
end

% read the geo-reference data
p = [path '\geo.tif'];
try
    info = geotiffinfo(p);
    refmat = info.RefMatrix;
catch
    refmat =0;
end


end


function [ rw,cl,ty ] = readConfig( path )
%This function reads the row and column information from the config.txt
%   Input
%       - path          -- the path to the config.txt file
%   Output
%       - rw            -- the row number of data
%       - cl            -- the column number of data

fid = fopen(path);
temp = fread(fid,'char');
fclose(fid);
temp = strsplit(char(temp'));

if length(temp)~=12
    fprintf('fail reading config text');
end
rw = str2double(temp(2));
cl = str2double(temp(5));
ty = temp(11);

% fprintf('Num of row:',rw);

end

