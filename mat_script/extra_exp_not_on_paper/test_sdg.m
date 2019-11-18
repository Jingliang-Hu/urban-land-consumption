enviPath = '/naslx/projects/pr84ya/ga39lev3/SDG/mat_script';
popFiles = dir([enviPath,'/data/*/POP/*POP_22km.tif']);


for i = 1:length(popFiles)
    cityPath = [];
    ttmp = strsplit(popFiles(i).folder,'/');
    for j = 1:length(ttmp)-1
        cityPath = strcat(cityPath,ttmp{j},'/');
    end
    cityPath = cityPath(1:end-1);
    tic;
    [flag] = SDG_Output(cityPath,enviPath);
    toc;
end
