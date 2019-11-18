function [ polsar,refmat ] = readPolSARSinclair( path )
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



num = 4;
name = {'\s11.bin','\s12.bin','\s21.bin','\s22.bin'};
       

% read info from config file

cpath = [path,'\config.txt'];
[ rw,cl ] = readConfig( cpath );

% initial output and read the binary data
temp = zeros(rw,2*cl,num);
for k = 1:num
    fT = fopen([path,name{k}],'r');
    temp(:,:,k) = fread(fT, [2*cl,rw], 'float32')';
    fclose(fT);
end
ind = 1:cl;
polsar = temp(:,2*ind-1,:)+1i*temp(:,2*ind,:);


% fT = fopen([path,name{k}],'r');
% a=fread(fT, [2*cl,rw], 'float');
% fclose(fT);
% b = a(2*i-1,:)+1i*a(2*i,:);
% figure,imshow(abs(b)')



% read the geo-reference data
p = [path '\TSX.tif'];
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

