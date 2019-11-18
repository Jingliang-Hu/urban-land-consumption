function [ polsar_simulated_gt,polsar_simulated_n ] = polsar_simulator( structure,groundtruthS )
%This function simulates PolSAR data based on given structure (spatial
%structure) and ground truth signal. Ground truth signal is achieved by
%averaging homogenerous real polsar data.
%
%       input
%       - structure              -- 2d structure of the simulated data
%       - groundtruthS           -- polsar ground truth scattering matrix [1,#ofGroundTruthSample,polNbCh]
%        
%       output 
%       - polsar_simulated_gt    -- simulated ground truth
%       - polsar_simulated_n     -- simulated noisy data


[r,c,~] = size(structure);
[~,nc,n] = size(groundtruthS);
polsar_simulated_gt = zeros(r,c,n);
polsar_simulated_n = zeros(r,c,n);


codeStructure = unique(structure(:,:,1));
lengthStructure = length(codeStructure);


if lengthStructure>nc 
    disp('... # of ground truth signal is not enough ...');
    return;
end


for i = 1:lengthStructure
    polsar_simulated_gt = polsar_simulated_gt + repmat(groundtruthS(1,i,:),r,c,1).*repmat((structure(:,:,1)==codeStructure(i)),1,1,n);
end


% real and imagenary parts follow gaussian distribution respectively
noiseR = 0.7071*randn(size(polsar_simulated_gt));
noiseI = 0.7071*randn(size(polsar_simulated_gt));
polsar_simulated_n = real(polsar_simulated_gt).*noiseR + 1i*imag(polsar_simulated_gt).*noiseI;


end

