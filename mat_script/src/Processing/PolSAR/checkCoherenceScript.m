
%% dual polsar data
% set the path to polsar data
path = 'D:\Original_test_data\TSX_standard\T2';
% read pol sar data
TSX = readPolSARData( path );
% averaging using 3x3 sliding window
TSX = meanfilt2(TSX,1);
% calculate coherence ref:COHERENCE ESTIMATION FOR SAR IMAGERY. R.Touzi
coh = sqrt(TSX(:,:,3).^2+TSX(:,:,4).^2)./sqrt(TSX(:,:,1).*TSX(:,:,2));

% show the histogram of coherence values
% coherence values should range from 0 to 1
figure,hist(coh(:),1000);

% if coh > 1; modify the data 
% TSX(:,:,3:4) = TSX(:,:,3:4) / 2;

%% quad polsar data
% set the path to polsar data
% path = '..\..\original_data\TSX_standard\T2';
% read pol sar data
% TSX = readPolSARData( path );



TSX = meanfilt2(convert_S4_C3(polsar_simulated_n),1);
% averaging using 3x3 sliding window
% TSX = meanfilt2(TSX,1);



% TSX = cat(3,TSX(:,:,1),TSX(:,:,3),TSX(:,:,5),TSX(:,:,8)); % HH VV
% TSX = cat(3,TSX(:,:,1),TSX(:,:,2),TSX(:,:,4),TSX(:,:,7)); % HH HV
TSX = cat(3,TSX(:,:,2),TSX(:,:,3),TSX(:,:,6),TSX(:,:,9)); % HV VV



% calculate coherence ref:COHERENCE ESTIMATION FOR SAR IMAGERY. R.Touzi
coh = sqrt(TSX(:,:,3).^2+TSX(:,:,4).^2)./sqrt(TSX(:,:,1).*TSX(:,:,2));

% show the histogram of coherence values
% coherence values should range from 0 to 1
figure,hist(coh(:),1000);

