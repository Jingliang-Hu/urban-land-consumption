% directory to data of a city
% cityPath '/<directory to data>/city'
% cityPath = '/data/hu/sdg/mat_script/data/BOM';
cityPath = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script/data/BOM';
% results will be saved in: cityPath/OUTPUT 
% e.g. '/data/hu/sdg/mat_script/data/MUC/OUTPUT'

% directory to folder of scripts
% enviPath = '/<directory to the git local repo>/mat_script'
% enviPath = '/data/hu/sdg/mat_script';
enviPath = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script';

addpath(genpath(enviPath));

tic;
[flag] = enMIMA_Workflow_One_City_1(cityPath,enviPath);
toc;

