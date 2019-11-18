%% read Coherence matrix Raw data

%%
clc;
clear all;
j = sqrt(-1);
path = '..\..\data\Convair_Ottawa_Data\';

col = 222;
row = 342;

fT11 = fopen([path, 'T11.bin'], 'r');
fT22 = fopen([path, 'T22.bin'], 'r');
fT33 = fopen([path, 'T33.bin'], 'r');
fT12_real = fopen([path, 'T12_real.bin'], 'r');
fT12_imag = fopen([path, 'T12_imag.bin'], 'r');
fT13_real = fopen([path, 'T13_real.bin'], 'r');
fT13_imag = fopen([path, 'T13_imag.bin'], 'r');
fT23_real = fopen([path, 'T23_real.bin'], 'r');
fT23_imag = fopen([path, 'T23_imag.bin'], 'r');

dataT = zeros(row, col, 9);
dataT(:, :, 1) = fread(fT11, [row, col], 'float32');
dataT(:, :, 2) = fread(fT22, [row, col], 'float32');
dataT(:, :, 3) = fread(fT33, [row, col], 'float32');
dataT(:, :, 4) = fread(fT12_real, [row, col], 'float32');
dataT(:, :, 5) = fread(fT13_real, [row, col], 'float32');
dataT(:, :, 6) = fread(fT23_real, [row, col], 'float32');
dataT(:, :, 7) = fread(fT12_imag, [row, col], 'float32');
dataT(:, :, 8) = fread(fT13_imag, [row, col], 'float32');
dataT(:, :, 9) = fread(fT23_imag, [row, col], 'float32');

fPauliImShow(dataT);
save preDataT dataT;

fclose(fT11);
fclose(fT22);
fclose(fT33);
fclose(fT12_real);
fclose(fT12_imag);
fclose(fT13_real);
fclose(fT13_imag);
fclose(fT23_real);
fclose(fT23_imag);

filteredData = NLmeanFilterForPolarSarData(dataT,10, 7, 1, 20);
% look number : 10;
% searching window : 15 * 15;
% patch size : 3 * 3
% K = 20;
fPauliImShow(filteredData);
