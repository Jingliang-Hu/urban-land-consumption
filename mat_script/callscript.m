% directory to data of a city
cityPath = '/data/hu/sdg/mat_script/data/MUC';
% directory to fold of scripts
enviPath = '/data/hu/sdg/mat_script';

tic;
[flag] = enMIMA_Workflow_One_City(cityPath,enviPath);
toc;

