function runFinalSVMResults(SVMdata, saveResults)
mkdir(saveResults)
MatList = dir([SVMdata '*.mat']);  % MatList = dir('*.mat');

for mMat = 1:length(MatList)
    load([SVMdata MatList(mMat).name], 'labelsSVMcell', 'orderTscell', ...
        'predictionAllRDF', 'predictionAllRDFFake', 'predictionAllRDFLive', 'predictionAllSVM', ...
        'predictionAllSVMFake', 'predictionAllSVMLive', 'predictionAverageRDF', 'predictionAverageRDFLive', ...
        'predictionAverageRDFFake', 'predictionAverageSVM', 'predictionAverageSVMFake', 'predictionAverageSVMLive', ...
        'predictionRDF', 'predictionRDFFake', 'predictionRDFLive', 'predictionSVM', 'predictionSVMFake', ...
            'predictionSVMLive', 'predtestscell', 'scores_SVMcell', 'scores_RDFcell', 'scores_SVM_postcell', 'Ytsscell')
       
   %% results - SVM
   YtsStack = [];
   scores_SVMStacked = [];
   SVMlabelStack = [];
       
   for p = 1:length(Ytsscell)
       Yts = Ytsscell{p};
       SVMlabel = labelsSVMcell{p};
       YtsStack = [YtsStack; Yts];
       scores_SVM = scores_SVMcell{p};
       scores_SVM = cell2mat(scores_SVM);
       scores_SVMStacked = [scores_SVMStacked; scores_SVM(:,2)];  
       SVMlabelStack = [SVMlabelStack; SVMlabel];
   end
   
   [Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(YtsStack,scores_SVMStacked, 1);      
%    figure, plot(Xsvm,Ysvm)
%    title('ROC')
   FFR_svm = (1-Ysvm);
   FLR_svm = Xsvm;
   figure, plot(FFR_svm,FLR_svm)
   title('Liu Hand FFR vs. FLR') % want to be in lower left corner
   AUCsvm
   
   liveIDX = find(YtsStack==1);  % live observations index
   fakeIDX = find(YtsStack==0);
  
   TF = length(find(SVMlabelStack(fakeIDX) == 0)) / length(fakeIDX); % live clas. as live
   FF = length(find(SVMlabelStack(liveIDX) == 0)) / length(liveIDX); % live misclasisfied as fake
   TL = length(find(SVMlabelStack(liveIDX) == 1)) / length(liveIDX); % fake clas. as fake
   FL = length(find(SVMlabelStack(fakeIDX) == 1)) / length(fakeIDX); % fake misclass as live!
   
   FFRbest_svm = FF/(FF+TF);   %FP/(FP + TP);  % false fake rate - when a real is classified as fake
   FLRbest_svm = FL/(FL+TL);% when a fake is mistaken for a live authentic user,  this one is the most problematic and ideally should be avoided at all cost
   
   EERidx_svm = find(FFRbest_svm == FLRbest_svm);  % equal error rate
   EER_svm = FFRbest_svm(EERidx_svm);
   HTER_svm = (FFRbest_svm+FLRbest_svm)/2; 
   
%    %% results - RDF
%    scores_RDFStacked = [];
%    RDFpredStacked = [];
%    for p = 1:length(Ytsscell)
%        scores_RDF = scores_RDFcell{p};
%        scores_RDFStacked = [scores_RDFStacked; scores_RDF(:,2)];  
%        RDFpred  = predtestscell{p};
%        RDFpredStacked = [RDFpredStacked; RDFpred];
%    end
%    
%    [X_rdf,Y_rdf,T_rdf,AUC_rdf] = perfcurve(YtsStack,scores_RDFStacked, 1);      
% %    figure, plot(X_rdf,Y_rdf)
% %    title('ROC')
%    FFR_rdf = (1-Y_rdf);
%    FLR_rdf = X_rdf;
% %    figure, plot(FFR_rdf,FLR_rdf)
% %    title('FFR vs. FLR') % want to be in lower left corner
%    AUC_rdf
%   
%    TF = length(find(RDFpredStacked(fakeIDX) == 0)) / length(fakeIDX); % live clas. as live
%    FF = length(find(RDFpredStacked(liveIDX) == 0)) / length(fakeIDX); % live misclasisfied as fake
%    TL = length(find(RDFpredStacked(liveIDX) == 1)) / length(fakeIDX); % fake clas. as fake
%    FL = length(find(RDFpredStacked(fakeIDX) == 1)) / length(fakeIDX); % fake misclass as live!
%    
%    FFRbest_rdf = FF/(FF+TF);   %FP/(FP + TP);  % false fake rate - when a real is classified as fake
%    FLRbest_rdf = FL/(FL+TL);% when a fake is mistaken for a live authentic user,  this one is the most problematic and ideally should be avoided at all cost
%    
%    EERidx_rdf = find(FFRbest_rdf == FLRbest_rdf);  % equal error rate
%    EER_rdf = FFRbest_rdf(EERidx_rdf);
%    HTER_rdf = (FFRbest_rdf+FLRbest_rdf)/2; 
    
%    save([saveResults MatList(mMat).name '-Result.mat'], 'FFRbest_svm', 'FLRbest_svm', 'EERidx_svm', 'EER_svm', 'HTER_svm', ...
%        'AUCsvm', 'FFR_svm', 'FLR_svm', 'FFRbest_rdf', 'FLRbest_rdf', 'EERidx_rdf', 'EER_rdf', 'HTER_rdf', ...
%        'AUC_rdf', 'FFR_rdf', 'FLR_rdf')

   save([saveResults MatList(mMat).name '-Result.mat'], 'FFRbest_svm', 'FLRbest_svm', 'EERidx_svm', 'EER_svm', 'HTER_svm', ...
       'AUCsvm', 'FFR_svm', 'FLR_svm')
%    pause(3)
%    close all

% save('LiuTrainResultPhoto.mat', 'FFRbest_svm', 'FLRbest_svm', 'EERidx_svm', 'EER_svm', 'HTER_svm', ...
%        'AUCsvm', 'FFR_svm', 'FLR_svm')
end
end