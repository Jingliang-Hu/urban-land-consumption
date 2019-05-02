maxNumCompThreads(20)
%% solve the problem
Z = [se1Data',zeros(size(se1Data,2),size(se2Data,1));zeros(size(se2Data,2),size(se1Data,1)),se2Data'];
mu = [1,2];

oa = zeros(numel(T_ul),numel(T_br),length(mu));
ka = zeros(numel(T_ul),numel(T_br),length(mu));
map1 = cell(numel(T_ul),numel(T_br),length(mu));
map2 = cell(numel(T_ul),numel(T_br),length(mu));
Mdl_rf = cell(numel(T_ul),numel(T_br),length(mu));


for cv_mu = 1:length(mu)
for cv_ul = 1:numel(T_ul)
	T_ul_tmp = T_ul{cv_ul};
    parfor cv_br = 1:numel(T_br)
		T_br_tmp = T_br{cv_br};
		
		
		T = [T_ul_tmp,zeros(size(T_ul_tmp,1),size(T_br_tmp,2));zeros(size(T_ul_tmp,2),size(T_br_tmp,1)),T_br_tmp];
		T = T.*(~(S+D));
		T(eye(size(T))==1) = 0;

		%for cv_mu = 1:length(mu)
			[ map1{cv_ul,cv_br,cv_mu},map2{cv_ul,cv_br,cv_mu} ] = mani_version_2( S,D,T,Z,mu(cv_mu),size(se1Data,2),size(se2Data,2) );
			%% classification with random forest
			se1DataProj = se1Data * map1{cv_ul,cv_br,cv_mu};
			se2DataProj = se2Data * map2{cv_ul,cv_br,cv_mu};

			disp('')
			disp('---------------------')

			feat = cat(2,se1DataProj,se2DataProj);
			

			trainFeat = feat(1:size(trainSE1,1),:);
			testFeat = feat(size(trainSE1,1)+1:end,:);


			% training
			rng(1); % For reproducibility
			NumTrees = 40;
			Mdl_rf{cv_ul,cv_br,cv_mu} = TreeBagger(NumTrees,trainFeat,trLab,'OOBPredictorImportance','on');

			% testing
			predLab = predict(Mdl_rf{cv_ul,cv_br,cv_mu},testFeat);
			predLab = cellfun(@str2double,predLab);
			[ M,oa(cv_ul,cv_br,cv_mu),pa,ua,ka(cv_ul,cv_br,cv_mu) ] = confusionMatrix(double(teLab),predLab);
		end
                oa(cv_ul,:,cv_mu)
                ka(cv_ul,:,cv_mu)

	end
end


