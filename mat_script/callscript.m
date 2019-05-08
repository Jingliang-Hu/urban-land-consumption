% directory to data of a city
% cityPath '/<directory to data>/city'
cityPath = '/data/hu/sdg/mat_script/data/MUC';

% results will be saved in: cityPath/OUTPUT 
% e.g. '/data/hu/sdg/mat_script/data/MUC/OUTPUT'

% directory to folder of scripts
% enviPath = '/<directory to the git local repo>/mat_script'
enviPath = '/data/hu/sdg/mat_script';

tic;
[flag] = enMIMA_Workflow_One_City(cityPath,enviPath);
toc;

