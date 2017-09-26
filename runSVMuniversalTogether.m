function   runSVMuniversal(saveFolder, folderList, FolderBackgroundGiven, attack)
% run SVM on devel and test

%%%%%%%%%%%%%%%%%%%%%%%%%% replay
warning off
mkdir(saveFolder);

modemode = 'filt';
liveFolders = 1;
fakeFolders = 2; 
replay_mask = 0;
FolderBackgroundList = {};
background=0;
disp('Replay Live 1 vs. Fake Fixed, filtered')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)

warning off
modemode = 'filt';
liveFolders = 1;
fakeFolders = 3; 
FolderBackgroundList = {};
background=0;
disp('Replay Live vs. Fake Hand, filtered')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)

warning off
modemode = 'raw';
liveFolders = 1;
fakeFolders = 2; 
FolderBackgroundList = {};
background=0;
disp('Replay Live vs. Fake Fixed, unfiltered')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)

warning off
modemode = 'raw';
liveFolders = 1;
fakeFolders = 3; 
FolderBackgroundList = {};
background=0;
disp('Replay Live vs. Fake Hand, unfiltered')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)

%%%%%%%%%%%%%%%%%%%%% replay with background
warning off
modemode = 'filt';
liveFolders = 1;
fakeFolders = 2; 
FolderBackgroundList = FolderBackgroundGiven;
background=1;
disp('Replay Live 2 vs. Fake Fixed, filtered, background')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)

warning off
modemode = 'filt';
liveFolders = 1;
fakeFolders = 3; 
FolderBackgroundList = FolderBackgroundGiven;
background=1;
disp('Replay Live 2 vs. Fake Hand, filtered, background')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)

warning off
modemode = 'raw';
liveFolders = 1;
fakeFolders = 2; 
FolderBackgroundList = FolderBackgroundGiven;
background=1;
disp('Replay Live 2 vs. Fake Fixed, filtered, background')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)

warning off
modemode = 'raw';
liveFolders = 1;
fakeFolders = 3; 
FolderBackgroundList = FolderBackgroundGiven;
background=1;
disp('Replay Live 2 vs. Fake Hand, unfiltered, background')
SVM_RDFuniversalTogether(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackgroundList, background, attack)
end


%% 
% % masks
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% mkdir(saveFolder);
% 
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'filt';
% liveFolders = 2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = [];
% background=0;
% disp('Masks Live 2 vs. Fake, filtered')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)
% 
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'filt';
% liveFolders = 1:2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = [];
% background=0;
% disp('Masks Live 1:2 vs. Fake, filtered')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)
% 
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'raw';
% liveFolders = 2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = [];
% background=0;
% disp('Masks Live 2 vs. Fake, unfiltered')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)
% 
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'raw';
% liveFolders = 1:2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = [];
% background=0;
% disp('Masks Live 1:2 vs. Fake, unfiltered')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)
% 
% %%%%%%%%%%%%%%%%%%%%% masks with background
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'filt';
% liveFolders = 2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = 'Nov29_3DMADbackgr/';
% background=1;
% disp('Masks Live 2 vs. Fake, filtered, background')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)
% 
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'filt';
% liveFolders = 1:2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = 'Nov29_3DMADbackgr/';
% background=1;
% disp('Masks Live 1:2 vs. Fake, filtered, background')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)
% 
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'raw';
% liveFolders = 2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = 'Nov29_3DMADbackgr/';
% background=1;
% disp('Masks Live 2 vs. Fake, unfiltered, background')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)
% 
% warning off
% saveFolder = 'Dec5SVM_MasksShuffled';
% folderList = {'Nov29NotNorm3DMAD'};
% modemode = 'raw';
% liveFolders = 1:2;
% fakeFolders = 3; 
% replay_mask = 1;
% FolderBackground = 'Nov29_3DMADbackgr/';
% background=1;
% disp('Masks Live 1:2 vs. Fake, unfiltered, background')
% SVM_RDFuniversal(saveFolder, folderList, modemode, replay_mask, liveFolders, fakeFolders, FolderBackground, background)

