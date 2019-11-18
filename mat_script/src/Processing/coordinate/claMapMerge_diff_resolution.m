function [ output_A,out_ref_A,output_B,out_ref_B ] = claMapMerge_diff_resolution( dataA,refmatA,dataB,refmatB )
%This function upsample dataA and dataB in order to fit them into the same
%size grid. It solves data belong to different resolution.
%  
%   Input:
%       - refmatA                - reference matrix of data A
%       - refmatB                - reference matrix of data B
%       - dataA                  - data A with resolution A
%       - dataB                  - data B with resolution B
%
%   Output:
%       - output_A               - upsampled data A
%       - output_B               - upsampled data B
%       - out_ref_A              - reference matrix of upsampled data A
%       - out_ref_B              - reference matrix of upsampled data B



%**************************************************************************
%
% need to check whether input data starts from northwest corner
%
%**************************************************************************


% find out the overlapped area of data a and b
[ dataA_ol,refmatA_ol,dataB_ol,refmatB_ol ] = overlappedDataExtraction( dataA,refmatA,dataB,refmatB );

% ground sample distance for x and y axis are the same
if refmatA_ol(1,2)~=0
    gsd_A = abs(refmatA_ol(1,2));
end
if refmatB_ol(1,2)~=0
    gsd_B = abs(refmatB_ol(1,2));
end

power = 0;
if gsd_A<gsd_B
    while floor(gsd_A)~=gsd_A
        power = power + 1;
        gsd_A = gsd_A*10;
    end
    resolution = gcd(gsd_A,gsd_B*10^power);
else
    while floor(gsd_B)~=gsd_B
        power = power + 1;
        gsd_B = gsd_B*10;
    end
    resolution = gcd(gsd_A*10^power,gsd_B);
end
resolution = resolution/(10^power);

[ start_coord_A,end_coord_A,start_coord_B,end_coord_B ] = dataExtent( dataA_ol,refmatA_ol,dataB_ol,refmatB_ol );


% geo reference matrix of DATA A and DATA B
rowCol_A = fliplr(round((abs(end_coord_A-start_coord_A)+abs(refmatA(2,1)))./resolution));
rowCol_B = fliplr(round((abs(end_coord_B-start_coord_B)+abs(refmatB(2,1)))./resolution));

output_A = zeros(rowCol_A(1),rowCol_A(2));
output_B = zeros(rowCol_B(1),rowCol_B(2));

out_ref_A = refmatA;
out_ref_A(3,1) = out_ref_A(3,1) - out_ref_A(2,1) + resolution/2;
out_ref_A(3,2) = out_ref_A(3,2) - out_ref_A(1,2) - resolution/2;
out_ref_A(1,2) = - resolution;
out_ref_A(2,1) = resolution;

out_ref_B = refmatA;
out_ref_B(3,1) = out_ref_B(3,1) - out_ref_B(2,1) + resolution/2;
out_ref_B(3,2) = out_ref_B(3,2) - out_ref_B(1,2) - resolution/2;
out_ref_B(1,2) = - resolution;
out_ref_B(2,1) = resolution;

if sum(rowCol_A==rowCol_B)~=2
    disp('newly created grids do not match');
    return;
end

% upsample data A and data B into the same size grid (same resolution)
output_A = imresize(dataA_ol, abs(refmatA(2,1))/resolution, 'nearest');
output_B = imresize(dataB_ol, abs(refmatB(2,1))/resolution, 'nearest');




end

