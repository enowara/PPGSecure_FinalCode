% function runFinalSVMResults(SVMdata, saveResults)
% mkdir(saveResults)
MatList = dir([SVMdata '*.mat']);  % MatList = dir('*.mat');

% Liu - ../Liu_Implementation/LiuSVMHandTogether/ 
%       ../Liu_Implementation/LiuSVMFixedTogether/
for mMat = 1:length(MatList)
    load([SVMdata MatList(mMat).name], 'labelsSVMcell', 'orderTscell', ...
        'predictionAllRDF', 'predictionAllRDFFake', 'predictionAllRDFLive', 'predictionAllSVM', ...
        'predictionAllSVMFake', 'predictionAllSVMLive', 'predictionAverageRDF', 'predictionAverageRDFLive', ...
        'predictionAverageRDFFake', 'predictionAverageSVM', 'predictionAverageSVMFake', 'predictionAverageSVMLive', ...
        'predictionRDF', 'predictionRDFFake', 'predictionRDFLive', 'predictionSVM', 'predictionSVMFake', ...
            'predictionSVMLive', 'predtestscell', 'scores_SVMcell', 'scores_RDFcell', 'scores_SVM_postcell', 'Ytsscell')
       
   %% results - SVM
   [SVMdata MatList(mMat).name]
   
   YtsStack = [];
   SVMlabelStack = [];
       
   for p = 1:length(Ytsscell)
       Yts = Ytsscell{p};
       YtsStack = [YtsStack; Yts];
       SVMlabel = labelsSVMcell{p};
       SVMlabelStack = [SVMlabelStack; SVMlabel];
   end
   
   liveIDX = find(YtsStack==1);  % live observations index
   fakeIDX = find(YtsStack==0);

   % Define which misclassification is a false positive or a false negative
   % the main goal is to detect a fake as a fake
   % false pos is fine - live clas. as fake BUT false neg is bad - fake
   % clas. as live
   FPsvm = length(find(SVMlabelStack(fakeIDX) == 1)) / length(fakeIDX); % fake as live - very bad
   FNsvm = length(find(SVMlabelStack(liveIDX) == 0)) / length(liveIDX); % live as fake 
   TPsvm = length(find(SVMlabelStack(fakeIDX) == 0)) / length(fakeIDX);  % correct fake
   TNsvm = length(find(SVMlabelStack(liveIDX) == 1)) / length(liveIDX);
%    
   % hence FP are worse than FN here
  
 
   % numbers to get:    
   specificity_svm = TNsvm/(TNsvm+FPsvm)  % true neg rate
   sensitivity_svm = TPsvm/(TPsvm+FNsvm)  % = recall? = TP/(TP+FN) = true pos rate
   precision_svm = TPsvm / (TPsvm + FPsvm) % true pos rate
%    trueNegRate_svm = TNsvm/(TNsvm+FPsvm);
%    negativePredictiveRate_svm = TNsvm/(TNsvm+FNsvm);
   falsePosRate_svm = FPsvm/(FPsvm+TPsvm)
   accuracy_svm = (TPsvm+TNsvm)/(TPsvm+TNsvm+FPsvm+FNsvm)   % SHOULD equal total number correctly classified / total observations?
%    
%    Csvm = confusionmat(YtsStack, SVMlabelStack) %(group, grouphat)
   
   %% results - RDF
   RDFpredStacked = [];
   for p = 1:length(Ytsscell)
       RDFpred  = predtestscell{p};
       RDFpredStacked = [RDFpredStacked; RDFpred];
   end
   FPrdf = length(find(RDFpredStacked(fakeIDX) == 1)) / length(fakeIDX); % fake as live - very bad
   FNrdf = length(find(RDFpredStacked(liveIDX) == 0)) / length(liveIDX); % live as fake 
   TPrdf = length(find(RDFpredStacked(fakeIDX) == 0)) / length(fakeIDX); % correct fake
   TNrdf = length(find(RDFpredStacked(liveIDX) == 1)) / length(liveIDX);

   specificity_rdf = TNrdf/(TNrdf+FPrdf) % true neg rate
   sensitivity_rdf = TPrdf/(TPrdf+FNrdf)  % = recall? = TP/(TP+FN) = true pos rate
   precision_rdf = TPrdf / (TPrdf + FPrdf) % true pos rate
%    trueNegRate_svm = TNsvm/(TNsvm+FPsvm);
%    negativePredictiveRate_svm = TNsvm/(TNsvm+FNsvm);
   falsePosRate_rdf = FPrdf/(FPrdf+TPrdf)
   accuracy_rdf = (TPrdf+TNrdf)/(TPrdf+TNrdf+FPrdf+FNrdf) % SHOULD equal total number correctly classified / total observations?
   
%    Crdf = confusionmat(YtsStack, RDFpredStacked)
   
end
% end