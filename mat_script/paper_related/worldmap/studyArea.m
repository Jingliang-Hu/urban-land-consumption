
%% plot global coastline
worldmap world
load coastlines

plotm(coastlat, coastlon)

%%
figure(1),hold on;
for idx = 1:length(cityLoc)
    plotm(cityLoc(idx).loc,'ko','MarkerFaceColor','k');
end

%% add cities

idx = 42;
cityLoc(idx).city = 'Melbourne';
cityLoc(idx).cityCode = 'LCZ42_206168_Melbourne';
cityLoc(idx).loc = [-37.97,144.77];


idx = 41;
cityLoc(idx).city = 'LosAngeles';
cityLoc(idx).cityCode = 'LCZ42_23052_LosAngeles-LongBeach-SantaAna';
cityLoc(idx).loc = [34.02,-118.55];

idx = 40;
cityLoc(idx).city = 'Moscow';
cityLoc(idx).cityCode = 'LCZ42_22299_Moscow';
cityLoc(idx).loc = [55.58,37.11];

idx = 39;
cityLoc(idx).city = 'London';
cityLoc(idx).cityCode = 'LCZ42_20382_London';
cityLoc(idx).loc = [51.53,-0.24];

idx = 38;
cityLoc(idx).city = 'Istanbul';
cityLoc(idx).cityCode = 'LCZ42_22691_Istanbul';
cityLoc(idx).loc = [41,28.87];


idx = 37;
cityLoc(idx).city = 'Vancouver';
cityLoc(idx).cityCode = 'LCZ42_20404_Vancouver';
cityLoc(idx).loc = [49.26,-123.16];

idx = 36;
cityLoc(idx).city = 'Cape Town';
cityLoc(idx).cityCode = 'LCZ42_22481_CapeTown';
cityLoc(idx).loc = [-33.92,18.42];


idx = 35;
cityLoc(idx).city = 'Madrid';
cityLoc(idx).cityCode = 'LCZ42_22549_Madrid';
cityLoc(idx).loc = [40.44,-3.75];

idx = 34;
cityLoc(idx).city = 'Kyoto';
cityLoc(idx).cityCode = 'LCZ42_206459_Kyoto';
cityLoc(idx).loc = [35.10,135.58];

idx = 33;
cityLoc(idx).city = 'Wuhan';
cityLoc(idx).cityCode = 'LCZ42_20712_Wuhan';
cityLoc(idx).loc = [30.57,114.16];

idx = 32;
cityLoc(idx).city = 'Lisbon';
cityLoc(idx).cityCode = 'LCZ42_22167_Lisbon';
cityLoc(idx).loc = [38.74,-9.19];


idx = 31;
cityLoc(idx).city = 'Paris';
cityLoc(idx).cityCode = 'LCZ42_20985_Paris';
cityLoc(idx).loc = [48.86,2.31];


idx = 30;
cityLoc(idx).city = 'Shenzhen';
cityLoc(idx).cityCode = 'LCZ42_20667_Shenzhen';
cityLoc(idx).loc = [22.56,113.91];


idx = 29;
cityLoc(idx).city = 'WashingtonDC';
cityLoc(idx).cityCode = 'LCZ42_23174_WashingtonDC';
cityLoc(idx).loc = [38.89,-77.08];


idx = 28;
cityLoc(idx).city = 'Dongying';
cityLoc(idx).cityCode = 'LCZ42_23610_Dongying';
cityLoc(idx).loc = [37.43,118.56];


idx = 27;
cityLoc(idx).city = 'Cairo';
cityLoc(idx).cityCode = 'LCZ42_22812_Cairo';
cityLoc(idx).loc = [30.06,31.22];


idx = 26;
cityLoc(idx).city = 'Islamabad';
cityLoc(idx).cityCode = 'LCZ42_22042_Islamabad';
cityLoc(idx).loc = [33.62,73.02];


idx = 25;
cityLoc(idx).city = 'Beijing';
cityLoc(idx).cityCode = 'LCZ42_20464_Beijing';
cityLoc(idx).loc = [39.94,116.26];


idx = 24;
cityLoc(idx).city = 'Amsterdam';
cityLoc(idx).cityCode = 'LCZ42_21930_Amsterdam';
cityLoc(idx).loc = [52.35,4.83];

idx = 23;
cityLoc(idx).city = 'Qingdao';
cityLoc(idx).cityCode = 'LCZ42_20641_Qingdao';
cityLoc(idx).loc = [36.13,120.22];

idx = 22;
cityLoc(idx).city = 'Munich';
cityLoc(idx).cityCode = 'MUC';
cityLoc(idx).loc = [48.15,11.47];

idx = 21;
cityLoc(idx).city = 'Mumbai';
cityLoc(idx).cityCode = 'BOM';
cityLoc(idx).loc = [19.08,72.81];

idx = 20;
cityLoc(idx).city = 'New York';
cityLoc(idx).cityCode = 'NYC';
cityLoc(idx).loc = [40.70,-74.12];

idx = 19;
cityLoc(idx).city = 'SaoPaulo';
cityLoc(idx).cityCode = 'LCZ42_20287_SaoPaulo';
cityLoc(idx).loc = [-23.68,-46.74];

idx = 18;
cityLoc(idx).city = 'SanFrancisco';
cityLoc(idx).cityCode = 'LCZ42_23130_SanFrancisco-Oakland';
cityLoc(idx).loc = [37.76,-122.47];

idx = 17;
cityLoc(idx).city = 'Zurich';
cityLoc(idx).cityCode = 'LCZ42_22606_Zurich';
cityLoc(idx).loc = [47.38,8.5];

idx = 16;
cityLoc(idx).city = 'Nairobi';
cityLoc(idx).cityCode = 'LCZ42_21711_Nairobi';
cityLoc(idx).loc = [-1.30,36.78];

idx = 15;
cityLoc(idx).city = 'Rome';
cityLoc(idx).cityCode = 'LCZ42_21588_Rome';
cityLoc(idx).loc = [41.91,12.47];

idx = 14;
cityLoc(idx).city = 'Milan';
cityLoc(idx).cityCode = 'LCZ42_21571_Milan';
cityLoc(idx).loc = [45.46,9.14];

idx = 13;
cityLoc(idx).city = 'Tehran';
cityLoc(idx).cityCode = 'LCZ42_21523_Tehran';
cityLoc(idx).loc = [35.70,51.28];

idx = 12;
cityLoc(idx).city = 'Jakarta';
cityLoc(idx).cityCode = 'LCZ42_21454_Jakarta';
cityLoc(idx).loc = [-6.23,106.76];

idx = 11;
cityLoc(idx).city = 'HongKong';
cityLoc(idx).cityCode = 'LCZ42_21137_HongKong';
cityLoc(idx).loc = [22.35,113.99];

idx = 10;
cityLoc(idx).city = 'Shanghai';
cityLoc(idx).cityCode = 'LCZ42_20656_Shanghai';
cityLoc(idx).loc = [31.22,121.19];

idx = 9;
cityLoc(idx).city = 'Nanjing';
cityLoc(idx).cityCode = 'LCZ42_20625_Nanjing';
cityLoc(idx).loc = [32.10,118.60];

idx = 8;
cityLoc(idx).city = 'Sydney';
cityLoc(idx).cityCode = 'LCZ42_206167_Sydney';
cityLoc(idx).loc = [-33.87,151.21];

idx = 7;
cityLoc(idx).city = 'Guangzhou';
cityLoc(idx).cityCode = 'LCZ42_20517_Guangzhou';
cityLoc(idx).loc = [23.13,113.26];

idx = 6;
cityLoc(idx).city = 'Changsha';
cityLoc(idx).cityCode = 'LCZ42_20474_Changsha';
cityLoc(idx).loc = [28.21,112.99];

idx = 5;
cityLoc(idx).city = 'SantiagoDeChile';
cityLoc(idx).cityCode = 'LCZ42_20439_SantiagoDeChile';
cityLoc(idx).loc = [-33.46, -70.66];

idx = 4;
cityLoc(idx).city = 'Cologne';
cityLoc(idx).cityCode = 'LCZ42_204358_Cologne';
cityLoc(idx).loc = [50.94,6.96];

idx = 3;
cityLoc(idx).city = 'Berlin';
cityLoc(idx).cityCode = 'LCZ42_204296_Berlin';
cityLoc(idx).loc = [52.52,13.41];

idx = 2;
cityLoc(idx).city = 'RioDeJaneiro';
cityLoc(idx).cityCode = 'LCZ42_20272_RioDeJaneiro';
cityLoc(idx).loc = [-22.91,-43.17];

idx = 1;
cityLoc(idx).city = 'Tokyo';
cityLoc(idx).cityCode = 'LCZ42_21671_Tokyo';
cityLoc(idx).loc = [35.67,139.65];





