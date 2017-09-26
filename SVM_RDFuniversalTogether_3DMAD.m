%     function SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)
saveFolder = 'Sep26_3DMAD_SVM_RDF/';
folderList = {'Sep26_3DMAD_PPG/'};
% replay_mask 
liveFolders = 1:2;
fakeFolders = 3; 
FolderBackgroundList = [];
background = 0;
modemode = 'filt';
attack = '';
LL = 300;
addpath('/home/ewa/Dropbox (Rice Scalable Health)/DocumentsUbuntu/BPADCameraVitals2016')

mkdir(saveFolder)
% debug / run


 % initialize 
    predictionAllSVM = [];
    predictionAllSVMLive = [];
    predictionAllSVMFake = [];
    predictionAllRDF = [];
    predictionAllRDFLive = [];
    predictionAllRDFFake = [];
    testPeople = [];
    labelsSVM = [];
    predtests = [];
    orderTrAll = [];
    orderTsAll = []; 

    startTestPerson1 = [1:5:85];
    endTestPerson1 = [1:5:85] + 4;

    startTestPerson2 = [];
    startTestPerson3 = [];
    endTestPerson2 = [];
    endTestPerson3 = [];

    allPeople = startTestPerson1(1):endTestPerson1(end); 
    pEnd = 17;

%     startTestPerson1 = (1:4:(60));
%     startTestPerson2 = (1:4:(60))+60;
%     startTestPerson3 = (1:2:(60))+120 ;
%     
%     endTestPerson1 =   ((1:4:(60)) + 3 );
%     endTestPerson2 =     (((1:4:(60))+60) +3);
%     endTestPerson3 =     (((1:2:(60))+120) +1); 
    
%     allPeople = startTestPerson1(1):endTestPerson3(end);
%     LL = 229; % some videos in Replay vary in length so keep the shortest common length
%     pEnd = 15;
   for p = 1:pEnd;  
     
    testPerson1 = startTestPerson1(p):endTestPerson1(p);
    if isempty(startTestPerson2) ~= 1
        testPerson2 = startTestPerson2(p):endTestPerson2(p);
    else
        testPerson2 = [];
    end
     if isempty(startTestPerson2) ~= 1
        testPerson3 = startTestPerson3(p):endTestPerson3(p);
     else
         testPerson3 = [];
     end
    testPersonInit = [testPerson1 testPerson2 testPerson3];
    
    % get training live %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     PdataLtrCell
    for ii = 1%:3
               Folder = [folderList{ii}];
               PdataLtr = [];
          for f = liveFolders
              testPersonLiv = testPersonInit;%(1:4);
              trainPeople = setdiff(allPeople, testPersonLiv);
              Pi = [];
            for ff = 1:length(trainPeople)
            m = trainPeople(ff);
            
            try
            if strcmp(modemode,'raw')
                
               load([Folder num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
               if background == 1
                    FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGrawL, PPGrawR, PPGrawF, PPGA, PPGB);
                    Pi = [PF' PL' PR' PA' PB'];
               else
               [PL, PR, PF] = fftFunction(LL, PPGrawL, PPGrawR, PPGrawF);
               Pi = [PF' PL' PR'];
               end
            elseif strcmp(modemode,'filt')
               load([Folder num2str(f)  '-'    num2str(m) '-PPGfilt.mat']);
               if background == 1
                    FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGfilt.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGLfilt, PPGRfilt, PPGFfilt, PPGAfilt, PPGBfilt);
                    Pi = [PF' PL' PR' PA' PB'];
               else
               [PL, PR, PF] = fftFunction(LL, PPGLfilt, PPGRfilt, PPGFfilt);
               Pi = [PF' PL' PR'];
               end
            else
               disp('ERROR')
              break
            end
            if sum(sum(isnan(Pi)))
                continue
            end
                PdataLtr = [PdataLtr; Pi];  
            catch
                continue
            end
        end
     end
            PdataLtrCell{ii} = PdataLtr;
  end
          
          % get testing live %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii = 1%:3
      Folder = [folderList{ii}];
    PdataLts = [];
          for f = liveFolders
              testPersonLiv = testPersonInit;%(1:4);
%               trainPeople = setdiff(allPeople, testPersonLiv);
            for ff = 1:length(testPersonLiv)
            m = testPersonLiv(ff);
            Pi = [];
            try
            if strcmp(modemode,'raw')
               load([Folder num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
               if background == 1
                    FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGrawL, PPGrawR, PPGrawF, PPGA, PPGB);
                    Pi = [PF' PL' PR' PA' PB'];
               else
               [PL, PR, PF] = fftFunction(LL, PPGrawL, PPGrawR, PPGrawF);
               Pi = [PF' PL' PR'];
               end
            elseif strcmp(modemode,'filt')
               load([Folder num2str(f)  '-'    num2str(m) '-PPGfilt.mat']);
               if background == 1
                    FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGfilt.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGLfilt, PPGRfilt, PPGFfilt, PPGAfilt, PPGBfilt);
                    Pi = [PF' PL' PR' PA' PB'];
               else
               [PL, PR, PF] = fftFunction(LL, PPGLfilt, PPGRfilt, PPGFfilt);
               Pi = [PF' PL' PR'];
               end
            else
               disp('ERROR')
              break
            end
            if sum(sum(isnan(Pi)))
                continue
                end
                PdataLts = [PdataLts; Pi];  
              catch
            continue
            end
            end
          end
          PdataLtsCell{ii} = PdataLts;
          end
          
              % get training fake %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii = 1%:3
        Folder = [folderList{ii}];
     PdataFtr = [];
          for f = fakeFolders
%                  if strcmp(attack,'photo')
                    testPersonAt = testPersonInit;%([1,2,5,6,9,10]);
                    trainPeople = setdiff(allPeople, testPersonInit);
%                 elseif strcmp(attack,'video')
%                     testPersonAt = testPersonInit%([3,4,7,8]);
%                     trainPeople = setdiff(allPeople, testPersonInit);
%                  end
            for ff = 1:length(trainPeople)
            m = trainPeople(ff);
            Pi = [];
            try
            if strcmp(modemode,'raw')
               load([Folder num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
               if background == 1
                    FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGrawL, PPGrawR, PPGrawF, PPGA, PPGB);
                    Pi = [PF' PL' PR' PA' PB'];
               else

               [PL, PR, PF] = fftFunction(LL, PPGrawL, PPGrawR, PPGrawF);
               Pi = [PF' PL' PR'];
               end
               
            elseif strcmp(modemode,'filt')
               load([Folder num2str(f)  '-'    num2str(m) '-PPGfilt.mat']);
               if background == 1
                    FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGfilt.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGLfilt, PPGRfilt, PPGFfilt, PPGAfilt, PPGBfilt);
                    Pi = [PF' PL' PR' PA' PB'];
               else
               [PL, PR, PF] = fftFunction(LL, PPGLfilt, PPGRfilt, PPGFfilt);
               Pi = [PF' PL' PR'];
               end
            else
               disp('ERROR')
              break
            end
            if sum(sum(isnan(Pi)))
                continue
            end
                PdataFtr = [PdataFtr; Pi];  
              catch
            continue
            end
            end
          end
         PdataFtrCell{ii} = PdataFtr;
    end
          
          % get testing fake %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for ii = 1%:3
   Folder = [folderList{ii}];
    PdataFts = [];
          for f = fakeFolders
%                if strcmp(attack,'photo')
                    testPersonAt = testPersonInit;%([1,2,5,6,9,10]);
%                     trainPeople = setdiff(allPeople, testPersonAt);
%                 elseif strcmp(attack,'video')
%                     testPersonAt = testPersonInit([3,4,7,8]);
% %                     trainPeople = setdiff(allPeople, testPersonAt);
%                  end
            for ff = 1:length(testPersonAt)
                m = testPersonAt(ff);
                Pi = [];
            try
            if strcmp(modemode,'raw')
               load([Folder num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
               if background == 1
                   FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGraw.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGrawL, PPGrawR, PPGrawF, PPGA, PPGB);
                    Pi = [PF' PL' PR' PA' PB'];
               else
               [PL, PR, PF] = fftFunction(LL, PPGrawL, PPGrawR, PPGrawF);
               Pi = [PF' PL' PR'];
               end
            elseif strcmp(modemode,'filt')
               load([Folder num2str(f)  '-'    num2str(m) '-PPGfilt.mat']);
               if background == 1
                   FolderBackground = [FolderBackgroundList{ii}];
                   load([FolderBackground num2str(f)  '-'   num2str(m) '-PPGfilt.mat']);
                   [PL, PR, PF, PA, PB] = fftFnctionBackground(LL, PPGLfilt, PPGRfilt, PPGFfilt, PPGAfilt, PPGBfilt);
                    Pi = [PF' PL' PR' PA' PB'];
               else
               [PL, PR, PF] = fftFunction(LL, PPGLfilt, PPGRfilt, PPGFfilt);
               Pi = [PF' PL' PR'];
               end
            else
               disp('ERROR')
              break
            end
            if sum(sum(isnan(Pi)))
                continue
                end
                PdataFts = [PdataFts; Pi];  
              catch
            continue
            end
            end
          PdataFtsCell{ii} = PdataFts;
          end
   end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  if not empty

%% set labels
    PdataLtrTotalTemp = [PdataLtrCell{1}];
    PdataFtrTotalTemp = [PdataFtrCell{1}];
%     PdataLtsTotalTemp = [PdataLtsCell{1} ; PdataLtsCell{2} ; PdataLtsCell{3}];
%     PdataFtsTotalTemp = [PdataFtsCell{1} ; PdataFtsCell{2} ; PdataFtsCell{3}];

%         if isempty(PdataLtrTotalTemp) || isempty(PdataFtrTotalTemp) || isempty(PdataLtsTotalTemp) || isempty(PdataFtsTotalTemp)
%             break % skip if there is data missing! otherwise - overfits
%         end
        
        scores_SVM_postI = [];
        scores_SVMI = [];
        scores_RDFI = [];
        YtssI = [];
        YtrsI = [];
        labelsSVMI = [];
        predtestsI = [];
        orderTsI = [];
        for ii = 1%:3
            
            if ii == 1
                PdataLtrTotal = [PdataLtrTotalTemp];%; PdataLtsCell{2}; PdataLtsCell{3}];
                PdataFtrTotal = [PdataFtrTotalTemp];%; PdataFtsCell{2}; PdataFtsCell{3}];
                PdataLtsTotal = [PdataLtsCell{1}];
                PdataFtsTotal = [PdataFtsCell{1}];
                
            elseif ii == 2                
                PdataLtrTotal = [PdataLtrTotalTemp; PdataLtsCell{1}; PdataLtsCell{3}];
                PdataFtrTotal = [PdataFtrTotalTemp; PdataFtsCell{1}; PdataFtsCell{3}];
                PdataLtsTotal = [PdataLtsCell{2}];
                PdataFtsTotal = [PdataFtsCell{2}];
            elseif ii == 3      
                PdataLtrTotal = [PdataLtrTotalTemp; PdataLtsCell{1}; PdataLtsCell{2}];
                PdataFtrTotal = [PdataFtrTotalTemp; PdataFtsCell{1}; PdataFtsCell{2}];
                PdataLtsTotal = [PdataLtsCell{3}];
                PdataFtsTotal = [PdataFtsCell{3}];
            end
                
                
        YtrL = ones(size(PdataLtrTotal,1), 1);
        YtrF = zeros(size(PdataFtrTotal,1), 1);
        YtsL = ones(size(PdataLtsTotal,1), 1);
        YtsF = zeros(size(PdataFtsTotal,1), 1);
        
        XtrTemp = [PdataLtrTotal; PdataFtrTotal];
        XtsTemp = [PdataLtsTotal; PdataFtsTotal];

        YtrTemp = [YtrL; YtrF];
        YtsTemp = [YtsL; YtsF];
        
        % combine. No shuffling if LOOV?
        Xtr = XtrTemp;
        Xts = XtsTemp;
        Ytr = YtrTemp;
        Yts = YtsTemp;
        
%         XYtrTemp = [XtrTemp YtrTemp];
%         s = RandStream('mt19937ar','Seed',sum(100*clock));
%         orderTri = randperm(s, size(XYtrTemp,1));
%         XYtr = XYtrTemp(orderTri,:);
% 
%         Xtr = XYtr(:,1:(end-1));
%         Ytr = XYtr(:,end);
% 
%         XYtsTemp = [XtsTemp YtsTemp];
%         s = RandStream('mt19937ar','Seed',sum(100*clock));
%         orderTsi = randperm(s, size(XYtsTemp,1));
%         XYts = XYtsTemp(orderTsi,:);
% 
%         Xtr = XYtr(:,1:(end-1));
%         Ytr = XYtr(:,end);
% 
%         Xts = XYts(:,1:(end-1));
%         Yts = XYts(:,end);
        
        %% SVM
        SVMModel = fitcsvm(Xtr,Ytr,'KernelFunction','linear','Standardize',true);
        [labelSVM,score] = predict(SVMModel,Xts);
        predictionSVM = (length(find(labelSVM==Yts))/length(Yts))*100;
        predictionAllSVM = [predictionAllSVM; predictionSVM];    

        % prediction for live and fake separately 
        LiveIdx = find(Yts == 1);
        FakeIdx = find(Yts == 0);
        labelLive = labelSVM(LiveIdx); %label(1:end/2);
        labelFake = labelSVM(FakeIdx); %label((end/2+1):end);
        YtsLive = Yts(LiveIdx); %Yts(1:end/2);
        YtsFake = Yts(FakeIdx); %Yts((end/2+1):end);
        
        SVMModel2 = fitPosterior(SVMModel);
        [~,score_posterior] = resubPredict(SVMModel2);
        if length(YtsLive) == 0 || length(YtsFake) ==0
%             continue 
        break
        end

        predictionSVMLive = (length(find(labelLive==YtsLive))/length(YtsLive))*100;
        predictionAllSVMLive = [predictionAllSVMLive; predictionSVMLive]; 
        predictionSVMFake = (length(find(labelFake==YtsFake))/length(YtsFake))*100;
        predictionAllSVMFake = [predictionAllSVMFake; predictionSVMFake]; 
        %% RDF
        bag = fitensemble(Xtr,Ytr,'Bag',400,'Tree',...
            'type','classification');
        [predtest scores] = bag.predict(Xts);
        predictionRDF = (length(find(predtest==Yts))/length(Yts))*100;
        predictionAllRDF = [predictionAllRDF; predictionRDF]; 

        predtestLive = predtest(LiveIdx); %predtest(1:end/2);
        predtestFake = predtest(FakeIdx); %predtest((end/2+1):end);

        predictionRDFLive = (length(find(predtestLive==YtsLive))/length(YtsLive))*100;
        predictionAllRDFLive = [predictionAllRDFLive; predictionRDFLive]; 

        predictionRDFFake = (length(find(predtestFake==YtsFake))/length(YtsFake))*100;
        predictionAllRDFFake = [predictionAllRDFFake; predictionRDFFake];
        
        scores_SVM_postI = [scores_SVM_postI; score_posterior];
        scores_SVMI = [scores_SVMI; score];
        scores_RDFI = [scores_RDFI; scores];
        YtssI = [YtssI; Yts];
        YtrsI = [YtrsI; Ytr];
%         testPeopleI = [testPeople; testPersonInit];
        labelsSVMI = [labelsSVMI; labelSVM];
        predtestsI = [predtestsI; predtest];
%         orderTsI = [orderTsI; orderTsi'];
        
  end
        scores_SVM_postcell{p} = scores_SVM_postI;
        scores_SVMcell{p} = num2cell(scores_SVMI);
        scores_RDFcell{p} = scores_RDFI;
        Ytsscell{p} = YtssI;
        Ytrscell{p} = YtrsI;
        testPeople = [testPeople; testPersonInit];
        labelsSVMcell{p} = labelsSVMI;
        predtestscell{p} = predtestsI;
%         orderTscell{p} = orderTsI;
   end
    
        % sum up accuracy over all test people    
        predictionAverageSVM = sum(predictionAllSVM)/length(predictionAllSVM);
        disp([num2str(predictionAverageSVM) '% Average SVM accuracy']);

        predictionAverageSVMLive = sum(predictionAllSVMLive)/length(predictionAllSVMLive);
        disp([num2str(predictionAverageSVMLive) '% Average Live SVM accuracy']);
        predictionAverageSVMFake = sum(predictionAllSVMFake)/length(predictionAllSVMFake);
        disp([num2str(predictionAverageSVMFake) '% Average Fake SVM accuracy']);

        predictionAverageRDF  = sum(predictionAllRDF)/length(predictionAllRDF);
        disp([num2str(predictionAverageRDF) '% Average RDF accuracy']);

        predictionAverageRDFLive  = sum(predictionAllRDFLive)/length(predictionAllRDFLive);
        disp([num2str(predictionAverageRDFLive) '% Average Live RDF accuracy']);
        predictionAverageRDFFake  = sum(predictionAllRDFFake)/length(predictionAllRDFFake);
        disp([num2str(predictionAverageRDFFake) '% Average Fake RDF accuracy']);
%         disp([saveFolder '/' folderList{ii} '_' modemode 'Live-' num2str(liveFolders)...
%             'vs. Fake-' num2str(fakeFolders)  '.mat'])
%      if background == 1
%          if fakeFolders == 2
%             save([saveFolder modemode attack 'Fixed_withBackground'   '.mat']) 
%          elseif fakeFolders == 3
%             save([saveFolder modemode attack 'Hand_withBackground'   '.mat'])
%          end
%      else 
%         if fakeFolders == 2
%         save([saveFolder modemode attack 'Fixed'   '.mat'])  
%         elseif fakeFolders == 3
%         save([saveFolder modemode attack 'Hand'   '.mat'])    
%         end
%     end
save([saveFolder modemode attack 'Sep26_3DMAD_SVM_RDF'  '.mat'])    
%     end
    
  
