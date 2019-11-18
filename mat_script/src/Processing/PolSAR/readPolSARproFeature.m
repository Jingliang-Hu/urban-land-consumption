function [ feature ] = readPolSARproFeature( path )
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


    

% read info from config file
str = strsplit(path,'\');
cpath = str{1};
for i = 2:length(str)-1
    cpath = [cpath,'\',str{i}];
end

cpath = [cpath,'\config.txt'];
[ rw,cl ] = readConfig( cpath );

% initial output and read the binary data

fT = fopen([path],'r');
feature = fread(fT, [cl,rw], 'float32')';
fclose(fT);

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

