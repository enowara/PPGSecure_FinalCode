%% SVM
figure
hold on
title('Photo Attack Fixed SVM')
ylabel('FFR')
xlabel('FLR')
% photo fixed
load('../Liu_Implementation/TrainLiuSVMFixed/LiuTrainResultPhoto.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainPhoto/filtphotoFixed.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'o')
load('TrainPhoto/filtphotoFixed_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, '+')

load('TrainPhoto/rawphotoFixed.mat-Result.mat')
plot(FFR_svm,FLR_svm, '*')

load('TrainPhoto/rawphotoFixed_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
title('Video Attack Fixed SVM')
ylabel('FFR')
xlabel('FLR')
% video fixed
load('../Liu_Implementation/TrainLiuSVMFixed/LiuTrainResultVideo.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainVideo/filtvideoFixed.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'o')
load('TrainVideo/filtvideoFixed_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, '+')

load('TrainVideo/rawvideoFixed.mat-Result.mat')
plot(FFR_svm,FLR_svm, '*')

load('TrainVideo/rawvideoFixed_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
title('Photo Attack Hand SVM')
ylabel('FFR')
xlabel('FLR')
% photo hand
load('../Liu_Implementation/TrainLiuSVMHand/LiuTrainResultPhoto.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainPhoto/filtphotoHand.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'o')
load('TrainPhoto/filtphotoHand_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, '+')

load('TrainPhoto/rawphotoHand.mat-Result.mat')
plot(FFR_svm,FLR_svm, '*')

load('TrainPhoto/rawphotoHand_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
title('Video Attack Hand SVM')
ylabel('FFR')
xlabel('FLR')
% video hand
load('../Liu_Implementation/TrainLiuSVMHand/LiuTrainResultVideo.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainVideo/filtvideoHand.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'o')
load('TrainVideo/filtvideoHand_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, '+')

load('TrainVideo/rawvideoHand.mat-Result.mat')
plot(FFR_svm,FLR_svm, '*')

load('TrainVideo/rawvideoHand_withBackground.mat-Result.mat')
plot(FFR_svm,FLR_svm, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')

%% RDF
figure
hold on
title('Photo Attack Fixed RDF')
ylabel('FFR')
xlabel('FLR')
% photo fixed
load('../Liu_Implementation/TrainLiuSVMFixed/LiuTrainResultPhoto.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainPhoto/filtphotoFixed.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'o')
load('TrainPhoto/filtphotoFixed_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '+')

load('TrainPhoto/rawphotoFixed.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '*')

load('TrainPhoto/rawphotoFixed_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
hold on
title('Video Attack Fixed RDF')
ylabel('FFR')
xlabel('FLR')
% video fixed
load('../Liu_Implementation/TrainLiuSVMFixed/LiuTrainResultVideo.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainVideo/filtvideoFixed.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'o')
load('TrainVideo/filtvideoFixed_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '+')

load('TrainVideo/rawvideoFixed.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '*')

load('TrainVideo/rawvideoFixed_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
title('Photo Attack Hand RDF')
ylabel('FFR')
xlabel('FLR')
% photo hand
load('../Liu_Implementation/TrainLiuSVMHand/LiuTrainResultPhoto.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainPhoto/filtphotoHand.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'o')
load('TrainPhoto/filtphotoHand_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '+')

load('TrainPhoto/rawphotoHand.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '*')

load('TrainPhoto/rawphotoHand_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on
title('Video Attack Hand RDF')
ylabel('FFR')
xlabel('FLR')
% video hand
load('../Liu_Implementation/TrainLiuSVMHand/LiuTrainResultVideo.mat')
plot(FFR_svm,FLR_svm, '--')

load('TrainVideo/filtvideoHand.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'o')
load('TrainVideo/filtvideoHand_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '+')

load('TrainVideo/rawvideoHand.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, '*')

load('TrainVideo/rawvideoHand_withBackground.mat-Result.mat')
plot(FFR_rdf,FLR_rdf, 'r')

legend('Liu et al.', 'CameraVitalsFiltered',  'CameraVitalsFiltered with Background', ...
    'CameraVitals', 'CameraVitals with Background')