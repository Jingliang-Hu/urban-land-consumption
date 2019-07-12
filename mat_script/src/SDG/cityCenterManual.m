%% check the lcz map of the city
envPath = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script';
files = dir([envPath,'/data/',cityExtent22km(idx).cityCode,'/OUTPUT/claMap_cLCZ.tif']);
[lab,r] = geotiffread([files(1).folder,'/',files(1).name]);
col = label2color(lab,'lcz');
figure,imshow(col);

%% clip to a 22 km by 22 km extent
a = col(cityExtent22km(idx).imCenter.row-cityExtent22km(idx).imExtent.row:cityExtent22km(idx).imCenter.row+cityExtent22km(idx).imExtent.row, ...
        cityExtent22km(idx).imCenter.col-cityExtent22km(idx).imExtent.col:cityExtent22km(idx).imCenter.col+cityExtent22km(idx).imExtent.col, ...
        :);
figure,imshow(a)

%%
extentRadius = 1100;

idx = 32;
cityExtent22km(idx).city = 'Lisbon';
cityExtent22km(idx).cityCode = 'LCZ42_22167_Lisbon';
cityExtent22km(idx).imCenter.row = 2600;
cityExtent22km(idx).imCenter.col = 4100;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 31;
cityExtent22km(idx).city = 'Paris';
cityExtent22km(idx).cityCode = 'LCZ42_20985_Paris';
cityExtent22km(idx).imCenter.row = 4680;
cityExtent22km(idx).imCenter.col = 5510;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 30;
cityExtent22km(idx).city = 'Shenzhen';
cityExtent22km(idx).cityCode = 'LCZ42_20667_Shenzhen';
cityExtent22km(idx).imCenter.row = 1300;
cityExtent22km(idx).imCenter.col = 2200;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 29;
cityExtent22km(idx).city = 'WashingtonDC';
cityExtent22km(idx).cityCode = 'LCZ42_23174_WashingtonDC';
cityExtent22km(idx).imCenter.row = 2300;
cityExtent22km(idx).imCenter.col = 2720;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 28;
cityExtent22km(idx).city = 'Dongying';
cityExtent22km(idx).cityCode = 'LCZ42_23610_Dongying';
cityExtent22km(idx).imCenter.row = 4200;
cityExtent22km(idx).imCenter.col = 2000;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 27;
cityExtent22km(idx).city = 'Cairo';
cityExtent22km(idx).cityCode = 'LCZ42_22812_Cairo';
cityExtent22km(idx).imCenter.row = 4000;
cityExtent22km(idx).imCenter.col = 2100;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 26;
cityExtent22km(idx).city = 'Islamabad';
cityExtent22km(idx).cityCode = 'LCZ42_22042_Islamabad';
cityExtent22km(idx).imCenter.row = 3900;
cityExtent22km(idx).imCenter.col = 4660;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 25;
cityExtent22km(idx).city = 'Beijing';
cityExtent22km(idx).cityCode = 'LCZ42_20464_Beijing';
cityExtent22km(idx).imCenter.row = 7370;
cityExtent22km(idx).imCenter.col = 5740;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;


idx = 24;
cityExtent22km(idx).city = 'Amsterdam';
cityExtent22km(idx).cityCode = 'LCZ42_21930_Amsterdam';
cityExtent22km(idx).imCenter.row = 6000;
cityExtent22km(idx).imCenter.col = 4100;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 23;
cityExtent22km(idx).city = 'Qingdao';
cityExtent22km(idx).cityCode = 'LCZ42_20641_Qingdao';
cityExtent22km(idx).imCenter.row = 3800;
cityExtent22km(idx).imCenter.col = 3400;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 22;
cityExtent22km(idx).city = 'Munich';
cityExtent22km(idx).cityCode = 'MUC';
cityExtent22km(idx).imCenter.row = 3800;
cityExtent22km(idx).imCenter.col = 3400;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 21;
cityExtent22km(idx).city = 'Mumbai';
cityExtent22km(idx).cityCode = 'BOM';
cityExtent22km(idx).imCenter.row = 5600;
cityExtent22km(idx).imCenter.col = 3000;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 20;
cityExtent22km(idx).city = 'New York';
cityExtent22km(idx).cityCode = 'NYC';
cityExtent22km(idx).imCenter.row = 3800;
cityExtent22km(idx).imCenter.col = 5300;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 19;
cityExtent22km(idx).city = 'SaoPaulo';
cityExtent22km(idx).cityCode = 'LCZ42_20287_SaoPaulo';
cityExtent22km(idx).imCenter.row = 2300;
cityExtent22km(idx).imCenter.col = 3700;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 18;
cityExtent22km(idx).city = 'SanFrancisco';
cityExtent22km(idx).cityCode = 'LCZ42_23130_SanFrancisco-Oakland';
cityExtent22km(idx).imCenter.row = 1730;
cityExtent22km(idx).imCenter.col = 2670;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 17;
cityExtent22km(idx).city = 'Zurich';
cityExtent22km(idx).cityCode = 'LCZ42_22606_Zurich';
cityExtent22km(idx).imCenter.row = 1600;
cityExtent22km(idx).imCenter.col = 2100;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 16;
cityExtent22km(idx).city = 'Nairobi';
cityExtent22km(idx).cityCode = 'LCZ42_21711_Nairobi';
cityExtent22km(idx).imCenter.row = 1150;
cityExtent22km(idx).imCenter.col = 1600;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 15;
cityExtent22km(idx).city = 'Rome';
cityExtent22km(idx).cityCode = 'LCZ42_21588_Rome';
cityExtent22km(idx).imCenter.row = 2500;
cityExtent22km(idx).imCenter.col = 1800;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 14;
cityExtent22km(idx).city = 'Milan';
cityExtent22km(idx).cityCode = 'LCZ42_21571_Milan';
cityExtent22km(idx).imCenter.row = 3900;
cityExtent22km(idx).imCenter.col = 3900;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 13;
cityExtent22km(idx).city = 'Tehran';
cityExtent22km(idx).cityCode = 'LCZ42_21523_Tehran';
cityExtent22km(idx).imCenter.row = 1800;
cityExtent22km(idx).imCenter.col = 3200;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 12;
cityExtent22km(idx).city = 'Jakarta';
cityExtent22km(idx).cityCode = 'LCZ42_21454_Jakarta';
cityExtent22km(idx).imCenter.row = 2600;
cityExtent22km(idx).imCenter.col = 3300;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 11;
cityExtent22km(idx).city = 'HongKong';
cityExtent22km(idx).cityCode = 'LCZ42_21137_HongKong';
cityExtent22km(idx).imCenter.row = 2900;
cityExtent22km(idx).imCenter.col = 2800;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 10;
cityExtent22km(idx).city = 'Shanghai';
cityExtent22km(idx).cityCode = 'LCZ42_20656_Shanghai';
cityExtent22km(idx).imCenter.row = 3200;
cityExtent22km(idx).imCenter.col = 3850;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 9;
cityExtent22km(idx).city = 'Nanjing';
cityExtent22km(idx).cityCode = 'LCZ42_20625_Nanjing';
cityExtent22km(idx).imCenter.row = 4300;
cityExtent22km(idx).imCenter.col = 3100;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 8;
cityExtent22km(idx).city = 'Sydney';
cityExtent22km(idx).cityCode = 'LCZ42_206167_Sydney';
cityExtent22km(idx).imCenter.row = 2900;
cityExtent22km(idx).imCenter.col = 5900;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 7;
cityExtent22km(idx).city = 'Guangzhou';
cityExtent22km(idx).cityCode = 'LCZ42_20517_Guangzhou';
cityExtent22km(idx).imCenter.row = 2900;
cityExtent22km(idx).imCenter.col = 3300;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 6;
cityExtent22km(idx).city = 'Changsha';
cityExtent22km(idx).cityCode = 'LCZ42_20474_Changsha';
cityExtent22km(idx).imCenter.row = 2200;
cityExtent22km(idx).imCenter.col = 3000;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 5;
cityExtent22km(idx).city = 'SantiagoDeChile';
cityExtent22km(idx).cityCode = 'LCZ42_20439_SantiagoDeChile';
cityExtent22km(idx).imCenter.row = 2600;
cityExtent22km(idx).imCenter.col = 3010;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 4;
cityExtent22km(idx).city = 'Cologne';
cityExtent22km(idx).cityCode = 'LCZ42_204358_Cologne';
cityExtent22km(idx).imCenter.row = 3700;
cityExtent22km(idx).imCenter.col = 2900;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 3;
cityExtent22km(idx).city = 'Berlin';
cityExtent22km(idx).cityCode = 'LCZ42_204296_Berlin';
cityExtent22km(idx).imCenter.row = 3500;
cityExtent22km(idx).imCenter.col = 3100;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 2;
cityExtent22km(idx).city = 'RioDeJaneiro';
cityExtent22km(idx).cityCode = 'LCZ42_20272_RioDeJaneiro';
cityExtent22km(idx).imCenter.row = 2300;
cityExtent22km(idx).imCenter.col = 6000;
cityExtent22km(idx).imExtent.row = extentRadius;
cityExtent22km(idx).imExtent.col = extentRadius;

idx = 1;
cityExtent22km(idx).city = 'Tokyo';
cityExtent22km(idx).cityCode = 'LCZ42_21671_Tokyo';
cityExtent22km(idx).imCenter.row = 1136;
cityExtent22km(idx).imCenter.col = 1096;
cityExtent22km(idx).imExtent.row = 1135;
cityExtent22km(idx).imExtent.col = 1095;


