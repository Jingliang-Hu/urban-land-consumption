% environment path
enviPath = '.';
addpath(genpath(enviPath));

% path to data of target city 
cityPath = './data/LCZ42_22691_Istanbul'

% run the algorithm
enMIMA_Workflow_One_City_lowMem(cityPath,enviPath);





